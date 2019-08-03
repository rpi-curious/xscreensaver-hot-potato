# XScreenSaver Hot Potato
[heading__title]:
  #xscreensaver-hot-potato
  "&#x2B06; Top of this page"


[`xscreensaver-hot-potato.sh`][xscreensaver_hot_potato__master__source_code], for passively cooled devices with limited resources. Logs CPU temperature and active screen-saver, and depending upon configurations and logs may toggle available screen savers.


> The following covers how to install this branch as a crontab job, and parameters that `xscreensaver-hot-potato.sh` currently responds to.


## [![Byte size of xscreensaver-hot-potato.sh][badge__master__xscreensaver_hot_potato__source_code]][xscreensaver_hot_potato__master__source_code] [![Open Issues][badge__issues__xscreensaver_hot_potato]][issues__xscreensaver_hot_potato] [![Open Pull Requests][badge__pull_requests__xscreensaver_hot_potato]][pull_requests__xscreensaver_hot_potato] [![Latest commits][badge__commits__xscreensaver_hot_potato__master]][commits__xscreensaver_hot_potato__master]



------


#### Table of Contents


- [&#x2B06; Top of ReadMe File][heading__title]

- [:zap: Quick Start][heading__quick_start]

- [:scroll: xscreensaver-hot-potato.sh Positional Arguments][heading__api]

- [&#x1F5D2; Notes][notes]

- [:card_index: Attribution][heading__attribution]

- [:copyright: License][heading__license]


------


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; ...well as quick as it may get with things like this"


**Git Commands**


1. Make a directory for Git sources

2. Change current directory to sub-directory path

3. Clone the source


```Bash
mkdir -vp "${HOME}/git/hub/rpi-curious"

cd "${HOME}/git/hub/rpi-curious"

git clone git@github.com:rpi-curious/xscreensaver-hot-potato.git
```


**Install Commands**


1. Link `xscreensaver-hot-potato.sh` to a `PATH` accessible location

2. Set ownership and executable permissions

3. Write a `crontab` entry


```Bash
sudo ln -s "${HOME}/git/hub/rpi-curious/xscreensaver-hot-potato/xscreensaver-hot-potato.sh" '/usr/local/sbin/'

sudo chown ${USER}:${GROPUS} '/usr/local/sbin/xscreensaver-hot-potato.sh'
chmod u+x "${HOME}/git/hub/rpi-curious/xscreensaver-hot-potato/xscreensaver-hot-potato.sh"

sudo crontab -e
```


**Example:** `crontab` entry


```crontab
*/2 * * * * su pi -c "/usr/local/sbin/xscreensaver-hot-potato.sh --max-temp-c 75 --log-path /tmp/xscreensaver-hot-potato.log --config-path /home/pi/.xscreensaver"
```


**Example:** disable `xscreensaver` hacks that overheat device


```Bash
xscreensaver-hot-potato.sh\
 --log-path /tmp/xscreensaver-hot-potato.log\
 --config-path ~/.xscreensaver\
 --offence-limit 3
```

___


## XScreenSaver Hot Potato API
[heading__api]:
  #xscreensaver-hot-potato-api
  "&#x1F4DC; The incantations that xscreensaver-hot-potato.sh script understands"


| Arguments | Type | Description |
|---|---|---|
| `-h   --help   help`                        | boolean | Prints possibly helpful message and exits |
| `-l   --license   license`                  | boolean | Prints license and exits |
| `--max-temp-c   max-temp-c`                 | number  | Max temperature in Celsius before logging of `xscreensaver` hack name is triggered |
| `--max-temp-f   max-temp-f`                 | number  | Max temperature in Fahrenheit before logging of `xscreensaver` hack name is triggered |
| `--log-path   --log`                        | path    | File path that temperature and `xscreensaver` hack names are logged to |
| `--config-path   --config   config-path`    | path    | File path that `xscreensaver` configurations are read from |
| `--offence-limit   --limit   offence-limit` | number  | Max number any individual `xscreensaver` hack name may be logged, after which |



**Throws** `Parameter_Error: no configuration file found`, when `--config-path` is not defined


___


## Notes
[notes]:
  #notes
  "&#x1F5D2; Additional notes and links that may be worth clicking in the future"


Tested on Raspberry Pi revisions 2 and 3, and may operate on other Linux based system on a chip devices.


The `--help` option may be used in combination with other options to check that things are assigned as expected.


Setting `--max-temp-f` instead of `--max-temp-c` will _cost_ a bit more in computation, because conversions are required.


Until run with `--offence-limit` the `xscreensaver-hot-potato.sh` script will **not** disable any `xscreensaver` hacks.


Timing for `crontab` should capture 2 to 3 samples at minimum per default cycle, and `xscreensaver` should be configured to cycle through available hacks.


___


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


Resources that where helpful in building this project so far.


- Stack Overflow

  - [How to get first character of variable](https://stackoverflow.com/questions/17723790/)
  - [How to sort uniq and display line that appear more than x times](https://stackoverflow.com/questions/20147878/)
  - [Numbering lines matching the pattern using sed](https://stackoverflow.com/questions/10577256/)

- Unix Stack Exchange

  - [How to show lines after each grep match until other specific match](https://unix.stackexchange.com/questions/21076/)


___


## License
[heading__license]:
  #license
  "&#x00A9; Legal bits of Open Source software"


```
XScreenSaver Hot Potato submodule quick start documentation
Copyright (C) 2019  S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation; version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```



[badge__travis_ci__xscreensaver_hot_potato]:
  https://img.shields.io/travis/rpi-curious/xscreensaver-hot-potato/example.svg

[travis_ci__xscreensaver_hot_potato]:
  https://travis-ci.com/rpi-curious/xscreensaver-hot-potato
  "&#x1F6E0; Automated tests and build logs"


[badge__commits__xscreensaver_hot_potato__master]:
  https://img.shields.io/github/last-commit/rpi-curious/xscreensaver-hot-potato/master.svg

[commits__xscreensaver_hot_potato__master]:
  https://github.com/rpi-curious/xscreensaver-hot-potato/commits/master
  "&#x1F4DD; History of changes on this branch"


[xscreensaver_hot_potato__community]:
  https://github.com/rpi-curious/xscreensaver-hot-potato/community
  "&#x1F331; Dedicated to functioning code"


[xscreensaver_hot_potato__example_branch]:
  https://github.com/rpi-curious/xscreensaver-hot-potato/tree/example
  "If it lurches, it lives"


[badge__issues__xscreensaver_hot_potato]:
  https://img.shields.io/github/issues/rpi-curious/xscreensaver-hot-potato.svg

[issues__xscreensaver_hot_potato]:
  https://github.com/rpi-curious/xscreensaver-hot-potato/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."


[badge__pull_requests__xscreensaver_hot_potato]:
  https://img.shields.io/github/issues-pr/rpi-curious/xscreensaver-hot-potato.svg

[pull_requests__xscreensaver_hot_potato]:
  https://github.com/rpi-curious/xscreensaver-hot-potato/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"


[badge__master__xscreensaver_hot_potato__source_code]:
  https://img.shields.io/github/languages/code-size/rpi-curious/xscreensaver-hot-potato

[xscreensaver_hot_potato__master__source_code]:
  https://github.com/rpi-curious/xscreensaver-hot-potato/blob/master/xscreensaver-hot-potato.sh
  "&#x2328; Project source code!"
