*** Settings ***
Library     OperatingSystem
Resource    common.resource

*** Variables ***
${microsoft_login_btn_xpath}              //*[@title="microsoft"]
${domain_input_xpath}                     //*[@placeholder="網域"]
${verification_btn_xpath}                 //span[text()="前往驗證"]/ancestor::button
${microsoft_login_email_input_xpath}      //input[@name="loginfmt"]
${microsoft_login_next_btn_xpath}         //input[@type="submit"]
${microsoft_login_pass_input_xpath}       //input[@name="passwd"]
${microsoft_verification_number_xpath}    //*[@id="idRichContext_DisplaySign"]

*** Test Cases ***
Get 2FA Login State
    [Tags]        Utility
    [Teardown]    Close Browser

    New Context            locale=zh-TW
    New Page               ${APOLLO_LOGIN_URL}
    Set Browser Timeout    ${TIMEOUT}

    Click                  ${microsoft_login_btn_xpath}
    Wait Until Network Is Idle

    Fill Secret            ${domain_input_xpath}                   $2FA_DOMAIN
    Click                  ${verification_btn_xpath}
    Wait Until Network Is Idle

    Fill Secret            ${microsoft_login_email_input_xpath}    $2FA_USERNAME
    Click                  ${microsoft_login_next_btn_xpath}
    Wait Until Network Is Idle

    Fill Secret            ${microsoft_login_pass_input_xpath}     $2FA_PASSWORD
    Click                  ${microsoft_login_next_btn_xpath}
    Wait Until Network Is Idle

    ${verification_number} =    Get Text    ${microsoft_verification_number_xpath}
    Log To Console    ${\n}Microsoft Authenticator Number: ${verification_number}

    Sleep    10s
    Wait Until Network Is Idle

    Click          ${microsoft_login_next_btn_xpath}
    Wait Until Network Is Idle

    Take Screenshot

    ${saved_state_filepath} =    Save Storage State
    Move File    ${saved_state_filepath}    ${TARGET_STATE_FILEPATH}

Keep 2FA State Alive
    New context    locale=zh-TW
    ...            storageState=${TARGET_STATE_FILEPATH}

    New Page       ${APOLLO_MAIN_PAGE_URL}

    Wait Until Network Is Idle
    Take Screenshot

    ${saved_state_filepath} =    Save Storage State
    Move File    ${saved_state_filepath}    ${TARGET_STATE_FILEPATH}