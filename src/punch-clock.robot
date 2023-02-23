*** Settings ***
Resource                           common.resource

*** Variables ***
${PUNCH_CLOCK_PAGE_URL}            https://apollo.mayohr.com/ta?id=webpunch
${PUNCH_CLOCK_IN_BUTTON_XPATH}     //*[text()="上班"]/ancestor::node()[1]
${PUNCH_CLOCK_OUT_BUTTON_XPATH}    //*[text()="下班"]/ancestor::node()[1]

*** Test Cases ***
Punch Clock
    [Teardown]    Close Browser

    ${is_holiday} =    Is Today A Holiday

    IF    not ${is_holiday}
        IF    "${CHECK_ACTION}" == "IN"
            ${CHECK_ACTION_BUTTON_XPATH} =    Set Variable    ${PUNCH_CLOCK_IN_BUTTON_XPATH}
        ELSE IF    "${CHECK_ACTION}" == "OUT"
            ${CHECK_ACTION_BUTTON_XPATH} =    Set Variable    ${PUNCH_CLOCK_OUT_BUTTON_XPATH}
        END

        New Page               ${APOLLO_LOGIN_URL}
        Set Browser Timeout    ${TIMEOUT}
        Login
        Go To                  ${PUNCH_CLOCK_PAGE_URL}
        Click                  ${CHECK_ACTION_BUTTON_XPATH}
        Sleep                  ${APPLY_WAIT}
        Take Screenshot
    END