*** Settings ***
Library                            Browser
Resource                           ../apollo-punch-bot/common.resource

*** Variables ***

*** Test Cases ***
Check Login
    [Teardown]             Close Browser

    New Page               ${APOLLO_LOGIN_URL}
    Set Browser Timeout    ${TIMEOUT}
    Login

    Wait Until Network Is Idle

    Take Screenshot