*** Settings ***
Test Setup       Begin Web Test                    ${urlNonCaptcha}
Test Teardown    End Web Test
Test Template    Logged in user can add experts
Library          DataDriver                        file=Test Data/Data.xlsx    sheet_name=Tenaga Ahli    encoding=UTF-8
Resource         ./Resource.robot

*** Test Cases ***
Logged in user can add experts
    [Tags]                            positive
    Logged in user can add experts

*** Keywords ***
Logged in user can add experts
    [Arguments]                          ${name}               ${tglLahir}             ${alamat}           ${pendidikan}         ${email}              ${keahlian}             ${gender}            ${kwn}    ${pengalaman}    ${status}    ${jabatan}
    ...                                  ${experienceTime}     ${experienceDetail}     ${educationTime}    ${educationDetail}    ${certificateTime}    ${certificateDetail}    ${languageDetail}
    Login Based On Condition Captcha
    Navigate To Data Penyedia
    Navigate To Tenaga Ahli
    Input Personal Data                  ${name}               ${tglLahir}             ${alamat}           ${pendidikan}         ${email}              ${keahlian}             ${gender}            ${kwn}    ${pengalaman}    ${status}    ${jabatan}    
    Input CV Detail                      ${experienceTime}     ${experienceDetail}
    Input Educational Background         ${educationTime}      ${educationDetail}
    Input Certificate Detail             ${certificateTime}    ${certificateDetail}
    Input Language                       ${languageDetail}
    Click Save Button
    Verify Experts Added Successfully    ${name}               ${pendidikan}           ${pengalaman}       ${keahlian}
    Close Browser