*** Settings ***
Library                                    Browser
Library                                    String

*** Variables ***
${DATE_START}                              2022/07/01
${DATE_END}                                2022/07/02

${TIMEOUT}                                 30s
${APOLLO_LOGIN_URL}                        https://asiaauth.mayohr.com/HRM/Account/Login

${COMPANY_CODE_INPUT_XPATH}                //input[@name="companyCode"]
${EMPLOYEE_NO_INPUT_XPATH}                 //input[@name="employeeNo"]
${PASSWORD_INPUT_XPATH}                    //input[@name="password"]
${LOGIN_BUTTON_XPATH}                      //button[@type="submit"]

${FORM_APPLICATION_LINK_XPATH}             //*[text()="表單申請"]/ancestor::node()[1]
${FORGET_PUNCH_LINK_XPATH}                 //a[contains(., '忘打卡申請單')]

${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE}     main
${BANNER_IFRAME_ID_ON_FORGET_PUNCH_PAGE}   banner

${CHECK_IN_STRING}                         上班
${CHECK_OUT_STRING}                        下班
${CHECK_ACTION_DROPDOWN_XPATH}             //*[@id="attendancetype_input"]
${CHECK_IN_BUTTON_XPATH}                   //ul[@id="fm_attendancetype_listbox" and @aria-live="polite"]/li[text()="${CHECK_IN_STRING}"]
${CHECK_OUT_BUTTON_XPATH}                  //ul[@id="fm_attendancetype_listbox" and @aria-live="polite"]/li[text()="${CHECK_OUT_STRING}"]

${DATE_TIME_INPUT_ID}                      fm_datetime
${DATE_TIME_INPUT_XPATH}                   //input[@id="${DATE_TIME_INPUT_ID}"]

${LOCATION_STRING}                         台北 Taipei
${LOCATION_DROPDOWN_XPATH}                 //*[@id="location_input"]
${LOCATION_BUTTON_XPATH}                   //ul[@id="fm_location_listbox" and @aria-live="polite"]/li[text()="${LOCATION_STRING}"]

${SUBMIT_BUTTON_XPATH}                     //div[text()="送簽"]/ancestor::node()[1]

${APPLY_WAIT}                              30s
${APPLY_INTERVAL}                          30s

${DELETE_BUTTON_XPATH}                     //div[text()="刪除"]/ancestor::node()[1]
${DELETE_CONFIRM_BUTTON_XPATH}             //button[contains(., "確定")]

*** Test Cases ***
Correct Clock
    # Generate Business Day List
    ${BUSINESS_DAY_LIST} =    Evaluate    pandas.bdate_range(start='${DATE_START}', end='${DATE_END}')    pandas

    FOR    ${IDX}    ${DATE}    IN ENUMERATE    @{BUSINESS_DAY_LIST}
        Run Keyword If              ${IDX} != 0           Sleep      ${APPLY_INTERVAL}
        ${DATE} =                   Convert To String     ${DATE}
        ${DATE} =                   Remove String         ${DATE}    00:00:00
        ${DATE} =                   Strip String          ${DATE}

        ${CHECK_IN_DATETIME} =      Catenate              ${DATE}    09:00
        ${CHECK_OUT_DATETIME} =     Catenate              ${DATE}    18:00

        ${CHECK_IN_DATETIME} =      Set Suite Variable    ${CHECK_IN_DATETIME}
        ${CHECK_OUT_DATETIME} =     Set Suite Variable    ${CHECK_OUT_DATETIME}

        Punch    IN
        Punch    OUT  
    END

*** Keywords ***
Login
    Type Text    ${COMPANY_CODE_INPUT_XPATH}    TXOne
    Type Text    ${EMPLOYEE_NO_INPUT_XPATH}     ${EMPLOYEE_NO}
    Type Text    ${PASSWORD_INPUT_XPATH}        ${PASSWORD}
    Click        ${LOGIN_BUTTON_XPATH}

Punch
    [Arguments]    ${CHECK_ACTION}
    [Teardown]     Close Browser

    IF    "${CHECK_ACTION}" == "IN"
        ${CHECK_ACTION_BUTTON_XPATH} =    Set Variable    ${CHECK_IN_BUTTON_XPATH}
        ${CHECK_DATETIME} =               Set Variable    ${CHECK_IN_DATETIME}
    ELSE IF    "${CHECK_ACTION}" == "OUT"
        ${CHECK_ACTION_BUTTON_XPATH} =    Set Variable    ${CHECK_OUT_BUTTON_XPATH}
        ${CHECK_DATETIME} =               Set Variable    ${CHECK_OUT_DATETIME}
    END

    New Page               ${APOLLO_LOGIN_URL}
    Set Browser Timeout    ${TIMEOUT}
    Login

    Click                  ${FORM_APPLICATION_LINK_XPATH}
    Click                  ${FORGET_PUNCH_LINK_XPATH}
    Switch Page            NEW
    Reload

    Click                  id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${CHECK_ACTION_DROPDOWN_XPATH}
    Click                  id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${CHECK_ACTION_BUTTON_XPATH}
    Evaluate JavaScript    id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${DATE_TIME_INPUT_XPATH}          document.querySelector("#${DATE_TIME_INPUT_ID}").removeAttribute("readonly");
    Type Text              id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${DATE_TIME_INPUT_XPATH}          ${CHECK_DATETIME}

    # Click arbitrary element in webpage. Just for re-fresh the page after date picker selection
    Click                  id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> //legend
    Wait Until Network Is Idle

    Click                  id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${LOCATION_DROPDOWN_XPATH}
    Click                  id=${MAIN_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${LOCATION_BUTTON_XPATH}

    IF    ${DRY_RUN}
        Take Screenshot
        Click              id=${BANNER_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${DELETE_BUTTON_XPATH}  
        Click              ${DELETE_CONFIRM_BUTTON_XPATH}
    ELSE
        Click              id=${BANNER_IFRAME_ID_ON_FORGET_PUNCH_PAGE} >>> ${SUBMIT_BUTTON_XPATH}
        Log To Console     \n${DATE} Checked ${CHECK_ACTION}
    END

    # The new tab will auto closed after submit. So we need to switch back to the main tab.
    Sleep                  ${APPLY_WAIT}