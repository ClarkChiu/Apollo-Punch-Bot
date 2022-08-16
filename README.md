# Punch Clock Tool for Apollo HR System

## Prerequisite

- Python v3
- Poetry (Package management)
    1. Robot Framework
    2. [Robot Framework - Browser](https://github.com/MarketSquare/robotframework-browser)
- NodeJS/npm (required by robotframework-browser)

## Prepare your environment

```shell
poetry install --no-dev
rfbrowser init
```

## Usage Example for daily punch clock

```shell
EMPLOYEE_NO=5487
PASSWORD=5487

# You can use --argumentfile user.config to setting EMPLOYEE_NO and PASSWORD variable
robot --variable EMPLOYEE_NO:${EMPLOYEE_NO} \
      --variable PASSWORD:${PASSWORD} \
      --variable CHECK_ACTION:IN \
      --outputdir result/`date +"%Y%m%d-%H%M"` \
      punch-clock.robot
```

## Setup cronjob for working day

- Make sure your timezone is correct
- Prepare the environment or argumentfile to setting the EMPLOYEE_NO and PASSWORD
- Find the binary path of virtual environment

```shell
(apollo-punch-bot-YHbyUk43-py3.10) clark@PC:~/apollo-punch-bot$ poetry env info
Virtualenv
Python:         3.10.4
Implementation: CPython
Path:           /home/clark/.cache/pypoetry/virtualenvs/apollo-punch-bot-YHbyUk43-py3.10
Valid:          True
```

- Add cronjob (Using Perl for random sleep) [^1]

```shell
45 08 * * 1-5 perl -e 'sleep(rand(900))'; cd /home/clark/apollo-punch-bot && /home/clark/.cache/pypoetry/virtualenvs/apollo-punch-bot-YHbyUk43-py3.10/bin/robot --argumentfile user.config --variable CHECK_ACTION:IN --outputdir result/`date +"\%Y\%m\%d-\%H\%M"` punch-clock.robot

00 18 * * 1-5 perl -e 'sleep(rand(900))'; cd /home/clark/apollo-punch-bot && /home/clark/.cache/pypoetry/virtualenvs/apollo-punch-bot-YHbyUk43-py3.10/bin/robot --argumentfile user.config --variable CHECK_ACTION:OUT --outputdir result/`date +"\%Y\%m\%d-\%H\%M"` punch-clock.robot

```

## Usage Example for correct punch clock

```shell
robot --argumentfile user.config \
      --variable DRY_RUN:False \
      --variable DATE_START:2022/07/05 \
      --variable DATE_END:2022/07/05 \
      --outputdir result/`date +"%Y%m%d-%H%M"` \
      correct-punch-clock.robot
```

## ToDo

- Containerize
- DRY RUN mode still WIP (The tool cannot handle the Kendo UI popup windows now) [^2]

[^1]: If the working time is greater than 8.5 hours, the new selection box will pop out to ask what causes the check out to be delayed.

[^2]: The Apollo HR system will create the new ticket ID once you apply for the check in/out correction and the ID will not get recycled and be re-used, which means the ID will get bigger and bigger. Hence, please be careful about your application request and the DRY run mode (Please check the date range before you execute this tool!)
