# Correct Check In/Out Tool for Apollo HR System

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

## Usage

```shell
EMPLOYEE_NO=5487
PASSWORD=5487

robot --variable EMPLOYEE_NO:${EMPLOYEE_NO} \
      --variable PASSWORD:${PASSWORD} \
      --variable DRY_RUN:True \
      --variable DATE_START:2022/07/05 \
      --variable DATE_END:2022/07/05 \
      --outputdir result \
      correct-punch-clock.robot
```

## ToDo

- Containerize
- DRY RUN mode still WIP (The tool cannot handle the Kendo UI popup windows now)

## Note

- The Apollo HR system will create the new ticket ID once you apply for the check in/out correction and the ID will not get recycled and be re-used, which means the ID will get bigger and bigger. Hence, please be careful about your application request and the DRY run mode (Please check the date range before you execute this tool!)