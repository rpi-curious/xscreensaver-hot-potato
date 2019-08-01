#!/usr/bin/env bash

## Enable sourcing via absolute path
__SOURCE__="${BASH_SOURCE[0]}"
while [[ -h "${__SOURCE__}" ]]; do
    __SOURCE__="$(find "${__SOURCE__}" -type l -ls | sed -n 's@^.* -> \(.*\)@\1@p')"
done
__DIR__="$(cd -P "$(dirname "${__SOURCE__}")" && pwd)"
__NAME__="${__SOURCE__##*/}"

__AUTHOR__='S0AndS0'
__DESCRIPTION__="Logs CPU temperature and active screen-saver, and may disable available screen savers."


source "${__DIR__}/modules/trap-failure/failure.sh"
trap 'failure "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR

source "${__DIR__}/modules/argument-parser/argument-parser.sh"


#
#    Script functions
#
usage(){
    local -n _parsed_argument_list="${1}"
    cat <<EOF
${__DESCRIPTION__}


#
#   Usage Options
#

  -h | --help | help
Prints possibly helpful message and exits

  -l | --license | license
Prints license and exits

  --max-temp-c | max-temp-c ${_max_temp_c:-<number>}
Max temperature in Celsius before logging of `xscreensaver` hack name is triggered

  --max-temp-f | max-temp-f ${_max_temp_f:-<number>}
Max temperature in Fahrenheit before logging of `xscreensaver` hack name is triggered

  --log-path | --log ${_log_path:-<path>}
File path that temperature and `xscreensaver` hack names are logged to

  --config-path | --config | config-path ${_config_path:-<path>}
File path that `xscreensaver` configurations are read from

  --offence-limit | --limit | offence-limit ${_offence_limit:-<number>}
Max number any individual `xscreensaver` hack name may be logged, after which
EOF
    if (("${#_parsed_argument_list[@]}")); then
        printf '\n\n#\n#    Parsed Options\n#\n\n\n'
        printf '    %s\n' "${_parsed_argument_list[@]}"
    fi
}


__license__(){
    _description="${1}"
    _author="${2:-S0AndS0}"
    cat <<EOF
${_description}
Copyright (C) 2019 ${_author}

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
EOF
}


xscreensaver__log_and_cycle(){
    _xscreensaver_time="${1:-$(xscreensaver-command -time)}"
    ## Parse current screensaver number from _xscreensaver_time
    _hack_number="$(awk -F'hack #' 'gsub("\)", ""); {print $2}' <<<"${_xscreensaver_time}" | tail -n1)"

    ## Calculate screensaver hack line number
    _line_number="$(( ${_hack_number} + 1 + $(awk '/programs/{print NR}' "${_config_path}") ))"

    ## Parse name from spicified line number
    _hack_name="$(awk -v lN="${_line_number}" '(NR==lN) {gsub("GL:",""); gsub("-",""); print $1}' "${_config_path}")"
    _log_line="# $(date +'%Y-%m-%d %A %R:%S') - Screensaver ${_hack_number} ${_hack_name} - Temperature: ${CURRENT_TEMP}"

    ## Append to log and cycle screensaver
    tee -a "${_log_path}" <<<"${_log_line}"
    xscreensaver-command -cycle
}


xscreensaver__comment_line_number(){
    _line_number="${1:?No line number provided}"
    [[ "${_line_number}" -ge '0' ]] || return 1
    _line="$(sed "${_line_number}q;d" "${_config_path}")"

    ## Test if not already commented to avoid errors from double runs
    case "${_line}" in
        '-'*) echo "Line number ${_line_number} already commented" && return 1;;
    esac

    printf 'Commenting out %s line number %i within %s' "${_name}" "${_line_number}" "${_config_path}"
    sed -i "${_line_number} {s@^@-@}" "${_config_path}"
}


xscreensaver__comment_toasty_hacks(){
    _offence_limit="${1}"

    ## Logged lines should look similar to
    ##> # 2018-09-21 Friday 23:08:02 - Screensaver 38 penrose - Temperature: 59
    _logged_names="$(awk '/# /{print $8}' "${_log_path}")"

    ## Parse for screensaver hack names that where logged one to many times
    _repeat_offenders="$(awk -v _limit="${_offence_limit}" '{a[$0]++}END{for(i in a){if(a[i] >= _limit){print i}}}' <<<"${_logged_names}")"
    for _name in ${_repeat_offenders}; do
        _line="$(grep -- " ${_name} " "${_config_path}")"
        _line_number="$(sed -n "/ ${_name} /=" "${_config_path}")"

        ## Parse for end of screensaver hack block
        _untill_line="$(( ${_line_number} + $(awk -v _name="${_name}" '$0 ~ _name,/\\n/' "${HOME}/.xscreensaver" | tail -n+2 | wc -l) ))"
        if [ "${_untill_line}" -gt "${_line_number}" ]; then
            for (( i=${_line_number}; i<=${_untill_line}; i++ )); do
                xscreensaver__comment_line_number "${i}"
            done
        else
            xscreensaver__comment_line_number "${_line_number}"
        fi
    done
}


#
#    Parse arguments to variables
#
_args=("${@:?# No arguments provided try: ${__NAME__} help}")
_valid_args=('--help|-h|help:bool'
             '--license|-l|license:bool'
             '--max-temp-c|max-temp-c:alpha_numeric'
             '--max-temp-f|max-temp-f:alpha_numeric'
             '--log-path|--log|log-path:path'
             '--config-path|--config|config-path:path'
             '--offence-limit|--limit|offence-limit:alpha_numeric')
argument_parser '_args' '_valid_args'
_exit_status="$?"


#
# Do things maybe
#
_log_path="${_log_path:-/tmp/xscreensaver_hot_potato.log}"
_config_path="${_config_path:-${HOME}/.xscreensaver}"

if ((_help)) || ((_exit_status)); then
    usage '_assigned_args'
    exit ${_exit_status:-0}
elif ((_license)); then
    __license__ "${__DESCRIPTION__}" "${__AUTHOR__}"
    exit ${_exit_status:-0}
fi


if ! [ -f "${_config_path}" ]; then
    printf 'Parameter_Error: no configuration file found\n' >&2
    exit 1
fi


CPU_TEMP_C="$(( $(cat /sys/devices/virtual/thermal/thermal_zone0/temp) / 1000 ))"
if [ -n "${_max_temp_f}" ]; then
    MAX_TEMP="${_max_temp_f}"
    CURRENT_TEMP="$(( ( (${CPU_TEMP_C} / 5) * 9) + 32 ))"
else
    MAX_TEMP="${_max_temp_c}"
    CURRENT_TEMP="${CPU_TEMP_C}"
fi


if ((_offence_limit)); then
    xscreensaver__comment_toasty_hacks "${_offence_limit}"
    exit "${?}"
elif [ "${CURRENT_TEMP}" -gt "${MAX_TEMP}" ]; then
    ## Provides line similar to
    #> XScreenSaver 5.36: screen blanked since Wed Sep 19 14:53:23 2018 (hack #172)
    XSCREENSAVER_TIME="$(xscreensaver-command -time)"
    case "${XSCREENSAVER_TIME}" in
        *non-blanked*)
            exit 0
        ;;
        *locked*|*blanked*)
            xscreensaver__log_and_cycle "${XSCREENSAVER_TIME}"
            exit "${?}"
        ;;
    esac
fi
