*** Settings ***
Library                                    Browser
Library                                    date_provider.py

*** Variables ***
${TIMEOUT}                                 1 minute 30 seconds
${APOLLO_LOGIN_URL}                        https://asiaauth.mayohr.com/HRM/Account/Login
${APOLLO_MAIN_PAGE_URL}                    https://apollo.mayohr.com/tube

${COMPANY_CODE_INPUT_XPATH}                //input[@name="companyCode"]
${EMPLOYEE_NO_INPUT_XPATH}                 //input[@name="employeeNo"]
${PASSWORD_INPUT_XPATH}                    //input[@name="password"]
${LOGIN_BUTTON_XPATH}                      //button[@type="submit"]

${APPLY_WAIT}                              30 seconds

*** Keywords ***
Login
    Fill Secret    ${COMPANY_CODE_INPUT_XPATH}    $COMPANY
    Fill Secret    ${EMPLOYEE_NO_INPUT_XPATH}     $EMPLOYEE_NO
    Fill Secret    ${PASSWORD_INPUT_XPATH}        $PASSWORD
    Click          ${LOGIN_BUTTON_XPATH}

    Wait Until Network Is Idle