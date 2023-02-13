*** Settings ***
Library                            Browser
Library                            String
Library                            OperatingSystem
Library                            ../src/date_provider.py

Resource                           ../src/common.resource

*** Variables ***

*** Test Cases ***
Check Login
    [Teardown]             Close Browser

    New Page               ${APOLLO_LOGIN_URL}
    Set Browser Timeout    ${TIMEOUT}
    Login

    Wait Until Network Is Idle

    Take Screenshot

Get The Official Holidays in 2023
    ${WORKING_DAY_LIST_FROM_LIB} =     Get Working Dates In Range    2023/01/01    2023/12/31

    ${WORKING_DAY_FROM_FILE} =         Get File                      test/data/2023_working_day.txt
    ${WORKING_DAY_LIST_FROM_FILE} =    Split String                  ${WORKING_DAY_FROM_FILE}

    Should Be Equal    ${WORKING_DAY_LIST_FROM_LIB}    ${WORKING_DAY_LIST_FROM_FILE}

Is Today a Holiday
    ${is_holiday} =    Is Today A Holiday

    IF    not ${is_holiday}
        Log To Console    Today is working day
    ELSE
        Log To Console    Today is holiday
    END