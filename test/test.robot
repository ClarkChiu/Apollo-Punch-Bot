*** Settings ***
Library                          Browser
Library                          String
Library                          DateTime
Library                          OperatingSystem
Library                          ../src/date_provider.py

Resource                         ../src/common.resource

*** Variables ***
${TARGET_ELEMENT_AFTER_LOGIN}    //*[contains(text(),'我要打卡')]

*** Test Cases ***
Check Login
    [Tags]                 local
    [Teardown]             Close Browser

    New Page               ${APOLLO_LOGIN_URL}
    Set Browser Timeout    ${TIMEOUT}
    Login
    Get Element            ${TARGET_ELEMENT_AFTER_LOGIN}

Get The Official Holidays in 2023
    ${WORKING_DAY_LIST_FROM_LIB} =     Get Working Dates In Range    2023/01/01    2023/12/31

    ${WORKING_DAY_FROM_FILE} =         Get File                      test/data/2023_working_day.txt
    ${WORKING_DAY_LIST_FROM_FILE} =    Split String                  ${WORKING_DAY_FROM_FILE}

    Should Be Equal    ${WORKING_DAY_LIST_FROM_LIB}    ${WORKING_DAY_LIST_FROM_FILE}

Is Today a Holiday
    ${CURRENT_YEAR} =                  Get Current Date    result_format=%Y
    ${TODAY} =                         Get Current Date    result_format=%Y/%m/%d

    ${WORKING_DAY_FROM_FILE} =         Get File            test/data/${CURRENT_YEAR}_working_day.txt
    ${WORKING_DAY_LIST_FROM_FILE} =    Split String        ${WORKING_DAY_FROM_FILE}

    ${IS_HOLIDAY} =    Is Today A Holiday

    IF    ${IS_HOLIDAY}
        Should Not Contain    ${WORKING_DAY_LIST_FROM_FILE}    ${TODAY}
    ELSE
        Should Contain        ${WORKING_DAY_LIST_FROM_FILE}    ${TODAY}
    END