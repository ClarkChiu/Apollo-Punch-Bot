*** Variables ***
${TIMEOUT}                                 30s
${APOLLO_LOGIN_URL}                        https://asiaauth.mayohr.com/HRM/Account/Login

${COMPANY_CODE_INPUT_XPATH}                //input[@name="companyCode"]
${EMPLOYEE_NO_INPUT_XPATH}                 //input[@name="employeeNo"]
${PASSWORD_INPUT_XPATH}                    //input[@name="password"]
${LOGIN_BUTTON_XPATH}                      //button[@type="submit"]

${APPLY_WAIT}                              30s

*** Keywords ***
Login
    Type Text    ${COMPANY_CODE_INPUT_XPATH}    TXOne
    Type Text    ${EMPLOYEE_NO_INPUT_XPATH}     ${EMPLOYEE_NO}
    Type Text    ${PASSWORD_INPUT_XPATH}        ${PASSWORD}
    Click        ${LOGIN_BUTTON_XPATH}