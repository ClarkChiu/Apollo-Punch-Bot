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

    New Context            locale=zh-TW
    New Page               ${APOLLO_LOGIN_URL}
    Set Browser Timeout    ${TIMEOUT}
    Login
    Get Element            ${TARGET_ELEMENT_AFTER_LOGIN}

Login with 2FA State
    [Tags]         local
    [Teardown]     Close Browser

    New context    locale=zh-TW
    ...            storageState=${TARGET_STATE_FILEPATH}

    New Page       ${APOLLO_MAIN_PAGE_URL}

    Wait Until Network Is Idle

    Get Element    ${TARGET_ELEMENT_AFTER_LOGIN}

Is Today a Holiday?
    ${CURRENT_YEAR} =                  Get Current Date    result_format=%Y
    ${TODAY} =                         Get Current Date    result_format=%Y/%m/%d

    # Working day from Taiwan calendar
    ${WORKING_DAY_FROM_FILE} =         Get File            test/data/${CURRENT_YEAR}_working_day.txt
    ${WORKING_DAY_LIST_FROM_FILE} =    Split String        ${WORKING_DAY_FROM_FILE}

    # This func call is using another data source of Taiwan calendar
    ${IS_HOLIDAY} =    Is Today A Holiday

    IF    ${IS_HOLIDAY}
        Should Not Contain    ${WORKING_DAY_LIST_FROM_FILE}    ${TODAY}
    ELSE
        Should Contain        ${WORKING_DAY_LIST_FROM_FILE}    ${TODAY}
    END