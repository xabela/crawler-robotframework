*** Settings ***
Library    Selenium2Library
Library    String

*** Variables ***
${delay}            0.3
${urlNonCaptcha}    https://lpse.jabarprov.go.id/
${urlCaptcha}       https://lpse.kemenkumham.go.id/
${browser}          Chrome
${username}         BIGIO
${password}         '#B1GDdRE@M!

*** Keywords ***
Begin Web Test
    [Arguments]                           ${url}
    ${chrome_options}=                    Evaluate             sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method                           ${chrome_options}    add_argument                                         test-type
    Call Method                           ${chrome_options}    add_argument                                         --no-sandbox
    Call Method                           ${chrome_options}    add_argument                                         --headless
    Call Method                           ${chrome_options}    add_argument                                         --disable-dev-shm-usage
    Call Method                           ${chrome_options}    add_argument                                         --disable-extensions
    Call Method                           ${chrome_options}    add_argument                                         --disable-gpu
    Call Method                           ${chrome_options}    add_argument                                         start-maximized
    Open Browser                          ${url}               ${browser}                                           options=${chrome_options}
    Register Keyword To Run On Failure    NONE
    Set Window Size                       ${1920}              ${1080}
    Set Selenium Speed                    ${delay}

End Web Test
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser

Login Based On Condition Captcha
    Check Click Login Button
    ${isCaptcha}                Run Keyword And Return Status    Page Should Contain Element                //*[@id="formLoginSelect"]/div/div[1]/button
    Run Keyword If              '${isCaptcha}'=='True'           Login With Captcha And Valid Credential
    ...                         ELSE                             Login With Valid Credential

Login With Valid Credential
    Click Navbar Login
    Input Username Login
    Input Password Login
    Select Provider Button
    Click Login Button

Login With Captcha And Valid Credential
    Click Navbar Login Captcha
    Select Provider Login
    Input Username Login Captcha
    Input Password Login
    Input Captcha Manually
    Click Login Button Captcha

Check Click Login Button
    Click Element    //*[@id="login"]

Click Navbar Login
    Wait Until Element Is Visible    //*[@id="loginForm"]
    Wait Until Element Is Visible    //input[@id="txtUserId"]

Input Username Login
    Input Text    //input[@id="txtUserId"]    ${username}

Input Password Login
    ${password_}    Get Substring                 ${password}     1
    Input Text      //input[@id="txtPassword"]    ${password_}

Select Provider Button
    Select Radio Button    isRekanan    true

Click Login Button
    Click Element                    //*[@id="formLogin"]/button
    Wait Until Element Is Visible    //*[@id="logout"]

Click Navbar Login Captcha
    Wait Until Element Is Visible    //*[@id="formLoginSelect"]/div/div[1]/button

Select Provider Login
    Click Element    //*[@id="formLoginSelect"]/div/div[1]/button

Input Username Login Captcha
    Input Text       //input[@id="txtUserId2"]             ${username}
    Click Element    //*[@id="formLogin"]/div[3]/button

Input Captcha Manually
    Sleep    10

Click Login Button Captcha
    Click Element                    //*[@id="formLogin"]/div[4]/button
    Wait Until Element Is Visible    //*[@id="logout"]

Navigate To Data Penyedia
    Click Element    //*[@id="menu"]/div[1]/div/ul[1]/li[2]/a

Navigate To Tenaga Ahli
    Click Element    //*[text()="Tenaga Ahli"]

Input Personal Data
    [Arguments]                  ${name}          ${tglLahir}    ${alamat}    ${pendidikan}    ${email}    ${keahlian}    ${gender}    ${kwn}    ${pengalaman}    ${status}    ${jabatan}    
    Click Add Experts
    Input Name Experts           ${name}
    Input Birthdate Experts      ${tglLahir}
    Input Address Experts        ${alamat}
    Input Education Experts      ${pendidikan}
    Input Email Experts          ${email}
    Input Skill Experts          ${keahlian}
    Select Gender                ${gender}
    Input Nationality Experts    ${kwn}
    Input Experience Experts     ${pengalaman}
    Select Employment Status     ${status}
    Input Role Experts           ${jabatan}


Click Add Experts
    Wait Until Element Is Visible    //*[contains(@class, "btn-tambah")]
    Click Element                    //*[contains(@class, "btn-tambah")]

Input Name Experts
    [Arguments]    ${name}
    Input Text     //input[@name="staf.sta_nama"]    ${name}

Input Birthdate Experts
    [Arguments]      ${tglLahir}
    Press Keys       //input[@name="staf.sta_tgllahir"]          CTRL+a+BACKSPACE
    Input Text       //input[@name="staf.sta_tgllahir"]          ${tglLahir}
    # Click Element    //*[@id="main"]/div[2]/form/div[1]/div[1]/div[3]/label
    Click Element    //input[@name="staf.sta_kewarganearaan"]    

Input Address Experts
    [Arguments]    ${alamat}
    Input Text     //input[@name="staf.sta_alamat"]    ${alamat}

Input Education Experts
    [Arguments]    ${pendidikan}
    Input Text     //input[@name="staf.sta_pendidikan"]    ${pendidikan}

Input Email Experts
    [Arguments]    ${email}
    Input Text     //input[@name="staf.sta_email"]    ${email}

Input Skill Experts
    [Arguments]    ${keahlian}
    Input Text     //textarea[@name="staf.sta_keahlian"]    ${keahlian}

Select Gender
    [Arguments]       ${gender}
    Run Keyword If    '${gender}'=='Pria'    Select Radio Button    staf.sta_jenis_kelamin    1
    ...               ELSE                   Select Radio Button    staf.sta_jenis_kelamin    0

Input Nationality Experts
    [Arguments]    ${kwn}
    Input Text     //input[@name="staf.sta_kewarganearaan"]    ${kwn}

Input Experience Experts
    [Arguments]    ${pengalaman}
    Input Text     //input[@name="staf.sta_pengalaman"]    ${pengalaman}

Select Employment Status
    [Arguments]       ${status}
    Run Keyword If    '${status}'=='Tetap'    Select Radio Button    staf.sta_status    0
    ...               ELSE                    Select Radio Button    staf.sta_status    1

Input Role Experts
    [Arguments]    ${jabatan}
    Input Text     //input[@name="staf.sta_jabatan"]    ${jabatan}

Input CV Detail
    [Arguments]             ${experienceTime}                    ${experienceDetail}
    @{experienceTimes}      Split String                         ${experienceTime}             |
    @{experienceDetails}    Split String                         ${experienceDetail}           |
    ${nExperience}          Get Length                           ${experienceTimes}
    FOR                     ${i}                                 IN RANGE                      ${nExperience}
    Input Text              //input[@name="cvWaktu[${i}]"]       ${experienceTimes}[${i}]
    Input Text              //textarea[@name="cvDetil[${i}]"]    ${experienceDetails}[${i}]
    Run Keyword If          ${nExperience}==1                    Log                           ${nExperience}
    ...                     ELSE IF                              ${i}==${${nExperience}-1}     Log                            ${nExperience}
    ...                     ELSE                                 Click Element                 //*[@id="tambahPengalaman"]
    END

Input Educational Background
    [Arguments]            ${educationTime}                      ${educationDetail}
    @{educationTimes}      Split String                          ${educationTime}             |
    @{educationDetails}    Split String                          ${educationDetail}           |
    ${nEducation}          Get Length                            ${educationTimes}
    FOR                    ${i}                                  IN RANGE                     ${nEducation}
    Input Text             //input[@name="cvWaktu2[${i}]"]       ${educationTimes}[${i}]
    Input Text             //textarea[@name="cvDetil2[${i}]"]    ${educationDetails}[${i}]
    Run Keyword If         ${nEducation}==1                      Log                          ${nEducation}
    ...                    ELSE IF                               ${i}==${${nEducation}-1}     Log                            ${nEducation}
    ...                    ELSE                                  Click Element                //*[@id="tambahPendidikan"]
    END

Input Certificate Detail
    [Arguments]              ${certificateTime}                    ${certificateDetail}
    @{certificateTimes}      Split String                          ${certificateTime}             |
    @{certificateDetails}    Split String                          ${certificateDetail}           |
    ${nCertificate}          Get Length                            ${certificateTimes}
    FOR                      ${i}                                  IN RANGE                       ${nCertificate}
    Input Text               //input[@name="cvWaktu3[${i}]"]       ${certificateTimes}[${i}]
    Input Text               //textarea[@name="cvDetil3[${i}]"]    ${certificateDetails}[${i}]
    Run Keyword If           ${nCertificate}==1                    Log                            ${nCertificate}
    ...                      ELSE IF                               ${i}==${${nCertificate}-1}     Log                            ${nCertificate}
    ...                      ELSE                                  Click Element                  //*[@id="tambahSertifikat"]
    END

Input Language
    [Arguments]           ${languageDetail}
    @{languageDetails}    Split String                          ${languageDetail}           |
    ${nLanguage}          Get Length                            ${languageDetails}
    FOR                   ${i}                                  IN RANGE                    ${nLanguage}
    Input Text            //textarea[@name="cvDetil4[${i}]"]    ${languageDetails}[${i}]
    Run Keyword If        ${nLanguage}==1                       Log                         ${nLanguage}
    ...                   ELSE IF                               ${i}==${${nLanguage}-1}     Log                        ${nLanguage}
    ...                   ELSE                                  Click Element               //*[@id="tambahUraian"]
    END

Click Save Button
    Click Element    //*[contains(@class, "btn-simpan")]

Verify Experts Added Successfully
    [Arguments]       ${name}               ${pendidikan}                      ${pengalaman}    ${keahlian} 
    ${totalRow}       Get Element Count     //*[@id="tblStafAhli"]/tbody/tr
    Run Keyword If    '${totalRow}'=='0'    Verify First Data                  ${name}          ${pendidikan}    ${pengalaman}    ${keahlian} 
    ...               ELSE                  Verify Next Data                   ${name}          ${pendidikan}    ${pengalaman}    ${keahlian}     ${totalRow}

Verify First Data
    [Arguments]               ${name}                                    ${pendidikan}    ${pengalaman}    ${keahlian} 
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr/td[2]/a    ${name}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr/td[4]      ${pendidikan}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr/td[5]      ${pengalaman}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr/td[6]      ${keahlian}

Verify Next Data
    [Arguments]               ${name}                                                 ${pendidikan}    ${pengalaman}    ${keahlian}    ${totalRow}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr[${totalRow}]/td[2]/a    ${name}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr[${totalRow}]/td[4]      ${pendidikan}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr[${totalRow}]/td[5]      ${pengalaman}
    Element Text Should Be    //*[@id="tblStafAhli"]/tbody/tr[${totalRow}]/td[6]      ${keahlian}