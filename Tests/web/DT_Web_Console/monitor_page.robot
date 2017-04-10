*** Settings ***
Suite Setup       SetupBrowsingEnv_Monitor  Mobile Demo  MobileDemo  Pi Demo  PiDemo
Suite Teardown    DestroyBrowsingEnv
Resource          ../../../lib/web/WebLib.txt
Resource          ../../../lib/web/Ingestion/Ingestion_Config_UI.txt
Library           ../../../etc/environments/server.py

*** Variables ***
${app_name}         MobileDemo
${Inspect_Button}       //span[contains(text(),"inspect")]
${Shutdown_Button}      //button[contains(@class,'btn btn-warning ng-binding')]
${Kill_Button}          //button[contains(@class,'btn btn-danger ng-binding')]
${Ended_Apps_Button}    //button[contains(@class,'btn btn-default ng-scope')]
${Pkg_Name}    Pi Demo
${App_Name}    PiDemo
${Alter_Pkg_Name}    Mobile Demo
${Alter_App_Name}    MobileDemo

*** Test Cases ***

Get_Monitor_Page_Stats_TC1
    Go_To_Page    Monitor    Cluster Overview
    ${cores}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[1]/div[1]/div[1]
    ${cores}    Convert To String    ${cores}
    ${memalloc}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[1]/div[2]/div[1]
    ${memalloc}    Convert To String    ${memalloc}
    ${peakalloc}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[1]/div[3]/div[1]
    ${peakalloc}    Convert To String    ${peakalloc}
    ${running}     Get Text    //*[contains(@class,'value status-running ng-binding')]
    ${running}    Convert To String    ${running}
    ${pending}     Get Text    //*[contains(@class,'value status-pending-deploy ng-binding')]
    ${pending}    Convert To String    ${pending}
    ${failed}     Get Text    //*[contains(@class,'value status-failed ng-binding')]
    ${failed}    Convert To String    ${failed}
    ${killed}     Get Text    //*[contains(@class,'value status-killed ng-binding')]
    ${killed}    Convert To String    ${killed}
    ${submitted}     Get Text    //*[contains(@class,'value status-submitted ng-binding')]
    ${submitted}    Convert To String    ${submitted}
    ${containers}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[3]/div[1]/div[1]
    ${containers}    Convert To String    ${containers}
    ${operators}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[3]/div[2]/div[1]
    ${operators}    Convert To String    ${operators}
    ${tuples}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[3]/div[3]/div[1]
    ${tuples}    Convert To String    ${tuples}
    ${emitted}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[3]/div[4]/div[1]
    ${emitted}    Convert To String    ${emitted}
    ${warnings}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[4]/div[1]/div[1]
    ${warnings}    Convert To String    ${warnings}
    ${errors}     Get Text    xpath=/html/body/div[2]/div[1]/div/div/fieldset[4]/div[2]/div[1]
    ${errors}    Convert To String    ${errors}
    Run Keyword Unless    '${cores}'!='0.00'    Fail    Core usage is ZERO
    Run Keyword Unless    '${memalloc}'!='0 B'    Fail    Memory Allocation is ZERO
    Run Keyword Unless    '${peakalloc}'!='0 B'    Fail    Peak Memory Allocation is ZERO
    Run Keyword Unless    '${running}'!='-'    Fail    No Apps are Running
    Run Keyword Unless    '${pending}'!='-'    Fail    Apps are in Accepted State
    Run Keyword Unless    '${failed}'!='-'    Fail    There are some Failed Apps
    Run Keyword Unless    '${submitted}'!='-'    Fail    There are no Submitted Apps
    Run Keyword Unless    '${containers}'!='0'    Fail    No Containers In Use
    Run Keyword Unless    '${operators}'!='0'    Fail    No Operators Deployed
    Run Keyword Unless    '${tuples}'!='0'    Fail    Tuples are not being processed
    Run Keyword Unless    '${emitted}'!='0'    Fail    Tuples are not being Emitted
    Run Keyword Unless    '${warnings}'=='0'    Fail    There are issues (Warnings) with the Installation
    Run Keyword Unless    '${errors}'=='0'    Fail    There are issues (errors) with the Installation

Ended_Apps_TC2
    Go To Page    Monitor    Cluster Overview
    Click Button    ${Ended_Apps_Button}
    Wait Until Page Contains  ended apps    timeout=30s
    Wait Until Element Is Enabled  ${Ended_Apps_Button}    timeout=30s
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]    #Sorting
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    ${state}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${temp}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${temp_str}=  convert to string  ${temp}
    \    append to list  ${state}  ${temp_str}
    List Should Contain Value   ${state}  KILLED (KILLED)
    Click Button    ${Ended_Apps_Button}
    Wait Until Element Is Enabled  ${Ended_Apps_Button}    timeout=30s
    Wait Until Page Contains  ended apps    timeout=30s
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    sleep    1s
    ${state}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${temp}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${temp_str}=  convert to string  ${temp}
    \    append to list  ${state}  ${temp_str}
    List Should Not Contain Value   ${state}  KILLED (KILLED)
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]


Get_System_Apps_TC3
    Go_To_Page    Monitor    Cluster Overview
    Click Element    //*[contains(text(),'AppDataTracker')]
    Wait Until Page Contains  AppDataTracker    timeout=30s
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    AppDataTracker is not running, current state is ${state}

Monitor_Page_Table_Search_TC4
    Go_To_Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    ${id}    Get Text    //*[contains(@dt-container-shorthand,'data.id')]
    ${id}    Convert To String     ${id}
    ${user}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h4/span[2]
    ${user}    Convert To String    ${user}
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    Go To Page    Monitor    Cluster Overview
    ${queue}=    Get Text    xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr/td[6]/span
    ${started}=    Set Variable    >5
    ${lifetime}=    Set Variable    today
    ${memory}=    Set Variable    >1

    # ID

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[2]/input  ${id}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[2]//a[contains(text(),"${id}")]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[2]/input

    # APP NAME

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  ${App_Name}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[3]//a[contains(text(),"${App_Name}")]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input

    # STATE

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input  ${state}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[4]/span//span[contains(text(),"${state}")]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input

    # USER

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[5]/input  ${user}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[5]//span[contains(text(),"${user}")]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[5]/input

    # QUEUE

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[6]/input  ${queue}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[6]//span[contains(text(),"${queue}")]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[6]/input

    # STARTED

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[7]/input  ${started}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[7]//span[contains(text(),*)]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[7]/input

    # LIFETIME

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[8]/input  ${lifetime}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[8]//span[contains(text(),*)]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[8]/input

    # MEMORY

    input text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[9]/input  ${memory}
    ${x}  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[contains(text(),*)]/td[9]//span[contains(text(),*)]
    clear element text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[9]/input

Monitor_Page_Table_Sort_TC5
    Go_To_Page    Monitor    Cluster Overview

    #ID

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[2]
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[2]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[2]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #NAME

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  NAME
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[3]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[3]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[3]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #STATE
    Clear Element Text     xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input    #'state' string search
    Input Text    xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input    running    #using search option
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  STATE
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[4]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}
    Clear Element Text     xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input    #'state' string search

    #USER

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  USER
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[5]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[5]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[5]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #QUEUE

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  QUEUE
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[6]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[6]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[6]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #STARTED

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  STARTED
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[7]
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[7]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_list}=  get regexp matches  ${id_str}  \\d+
    \    ${count}=  get length  ${id_list}
    \    ${id_str}=  Time_To_Seconds  ${id_list}   ${count}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[7]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_list}=  get regexp matches  ${id_str}  \\d+
    \    ${count}=  get length  ${id_list}
    \    ${id_str}=  Time_To_Seconds  ${id_list}   ${count}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #MEMORY

    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  MEMORY
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[9]
    #click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[9]
    sleep    1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  Remove String  ${id_str}   GB
    \    ${id_str}=  Remove String  ${id_str}   MB
    \    ${id_str}=  Remove String  ${id_str}   B
    \    ${id_str}=  Evaluate  ${id_str}
    \    ${id_str2}=  Evaluate  ${id_str}*1024
    \    ${id_str}=  Set Variable If  ${id_str}<100  ${id_str}  ${id_str2}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[1]/th[9]
    sleep    1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  Remove String  ${id_str}   GB
    \    ${id_str}=  Remove String  ${id_str}   MB
    \    ${id_str}=  Remove String  ${id_str}   B
    \    ${id_str}=  Evaluate  ${id_str}
    \    ${id_str2}=  Evaluate  ${id_str}*1024
    \    ${id_str}=  Set Variable If  ${id_str}<100  ${id_str}  ${id_str2}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

Shutdown_Multiple_Apps_TC6
    Go_To_Page    Monitor    Cluster Overview
    ${before}     Get Text    //*[contains(@class,'value status-finished ng-binding')]
    ${before}    Convert To String    ${before}
    Clear Element Text     xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input    #'state' string search
    Input Text    xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input    running    #using search option
    Input Text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  =${App_Name}
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input     #First Checkbox
    clear element text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input
    Input Text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  =${Alter_App_Name}
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input     #First Checkbox
    clear element text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input
    Page Should Not Contain Element  ${Inspect_Button}
    Click Button    ${Shutdown_Button}
    Click Element    //button[contains(@ng-click,'$close()')]
    sleep     60s               #Wait Until Page Contains    FINISHED    timeout=60s
    ${after}     Get Text    //*[contains(@class,'value status-finished ng-binding')]
    ${after}    Convert To String    ${after}
    Run Keyword Unless    '${before}'<'${after}'    Fail    Applications didn't Shutdown
    Launch_The_App    ${Pkg_Name}    ${App_Name}  #comment when running individual test case
    sleep    10s
    Launch_The_App    ${Alter_Pkg_Name}    ${Alter_App_Name}
    sleep    10s

Kill_Multiple_Apps_TC7
    Go_To_Page    Monitor    Cluster Overview
    ${before}     Get Text    //*[contains(@class,'value status-killed ng-binding')]
    ${before}    Convert To String    ${before}
    Clear Element Text     xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input
    Input Text    xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[4]/input    running    #using search option
    Input Text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  =${App_Name}
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input     #First Checkbox
    clear element text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input
    Input Text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  =${Alter_App_Name}
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input     #First Checkbox
    clear element text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input
    Page Should Not Contain Element  ${Inspect_Button}
    Click Button    ${Kill_Button}
    Click Element    //button[contains(@ng-click,'$close()')]
    Reload Page
    sleep    5s
    ${after}     Get Text    //*[contains(@class,'value status-killed ng-binding')]
    ${after}    Convert To String    ${after}
    Run Keyword Unless    '${before}'<'${after}'    Fail    Applications didn't got Killed
    Launch_The_App    ${Pkg_Name}    ${App_Name}  #comment when running individual test case
    sleep    10s
    Launch_The_App    ${Alter_Pkg_Name}    ${Alter_App_Name}
    sleep    10s

Open_App_Details_Page_TC8
    Go_To_Page    Monitor    Cluster Overview
    Input Text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  =${App_Name}
    Click Element    xpath=/html/body/div[2]/div[2]/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input     #First Checkbox
    clear element text   xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input
    Click Element  xpath=//span[contains(text(),"inspect")]    #${Inspect_Button}
    Wait Until Page Contains    ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    AppDataTracker is not running, current state is ${state}
    Go_To_page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}     #Clicking first App
    Wait Until Page Contains    ${App_Name}    timeout=30s
    ${state}   Get Text    //span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    ${App_Name} is not running, current state is ${state}
    ${appid1}    Get Text    //span[@dt-container-shorthand='data.id']
    ${appid1}    Convert To String    ${appid1}
    Go_To_page    Monitor    Cluster Overview
    Click Element    //*[contains(text(),'${appid1}')]   #Clicking from ID
    Wait Until Page Contains    ${appid1}
    Wait Until Page Contains Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2
    ${appid2}    Get Text    //span[@dt-container-shorthand='data.id']
    ${appid2}    Convert To String    ${appid2}
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    ${App_Name} is not running, current state is ${state}
    Run Keyword Unless    '${appid1}'=='${appid2}'    Fail    App ID's On Monitor Page and on Application Page is differnet


Search_And_Navigation_Apps_TC9
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page   ${Alter_App_Name}
    Wait Until Page Contains   ${Alter_App_Name}
    Click Element    //*[contains(text(),'logical')]
    Click Element     //button[contains(@class,'btn btn-link dropdown-toggle ng-binding')]
    Input Text    //*[contains(@ng-model,'search.term')]    ${App_Name}
    Click Element    xpath=//*[@id="breadcrumbs-top"]/li[2]/span/span/ul/li[3]/span/a
    Wait Until Page Contains    ${App_Name}    timeout=30s
    ${App_Name2}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2
    ${App_Name2}    Convert To String    ${App_Name2}
    ${App_Name2}=    Fetch From Left    ${App_Name2}    shutdown     #-> Not generic, as the app name contains a space, this wont work
    ${App_Name2}=    Remove String    ${App_Name2}      ' '
    ${App_Name}=    Remove String    ${App_Name}      ' '
    Run Keyword Unless    '${App_Name} '=='${App_Name2}'    Fail    Correct Application didn't Open


Default_Tabs_In_App_Details_TC10
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    ${logical}    Get Text    //span[contains(text(),'logical')]
    ${logical}    Convert To String    ${logical}
    ${physical}    Get Text    //span[contains(text(),'physical')]
    ${physical}    Convert To String    ${physical}
    ${physical-dag-view}    Get Text    //span[contains(text(),'physical-dag-view')]
    ${physical-dag-view}    Convert To String    ${physical-dag-view}
    ${metric-view}    Get Text    //span[contains(text(),'metric-view')]
    ${metric-view}    Convert To String    ${metric-view}
    ${attempts}    Get Text    //span[contains(text(),'attempts')]
    ${attempts}    Convert To String    ${attempts}
    Run Keyword Unless    '${logical}'=='logical'    Fail    Logical Tab Not Found
    Run Keyword Unless    '${physical}'=='physical'    Fail    Physical Tab Not Found
    Run Keyword Unless    '${physical-dag-view}'=='physical-dag-view'    Fail    Physical Dag View Tab Not Found
    Run Keyword Unless    '${metric-view}'=='metric-view'    Fail    Metric View Tab Not Found
    Run Keyword Unless    '${attempts}'=='attempts'    Fail    Attempts Tab Not Found


Add_Custom_Tab_View_TC11
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@ng-click,'createNewLayout()')]    #Adding New View
    Click Element    //*[contains(@uib-tooltip,'clear all widgets')]    #Removing Widgets
    Page Should Not Contain Element     //*[contains(@ng-repeat,'widget in widgets')]     Widgets Still Present
    Click Element    //button[contains(@uib-tooltip,'add a widget')]
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[1]/div/ul/li[1]/a    #Adding Application Overview Widget
    Page Should Contain Element     //*[contains(@ng-repeat,'widget in widgets')]    Widget Not Added
    Reload Page
    Wait Until Page Contains    ${App_Name}    timeout=30s
    Click Element    //*[contains(@ng-click,'resetWidgetsToDefault()')]
    Click Element    //*[contains(@ng-click,'removeLayout(layout)')]


Application_Overview_Details_TC12
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    ${state}   Get Text    xpath=//span[@dt-status='data.state']/span
    ${id}    Get Text    //*[contains(@dt-container-shorthand,'data.id')]
    ${id}    Convert To String     ${id}
    ${user}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h4/span[2]
    ${user}    Convert To String    ${user}
    ${version}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h4/span[3]/a
    ${version}     Convert To String    ${version}
    ${wid}    Get Text     //*[contains(@window-id,'data.currentWindowId')]/span
    ${wid}    Convert To String    ${wid}
    ${rec_wid}    Get Text    //*[contains(@window-id,'data.recoveryWindowId')]/span
    ${rec_wid}    Convert To String     ${rec_wid}
    ${latency}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[2]/div[1]/div[1]    #latency
    ${latency}    Convert To String     ${latency}
    ${processed}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[2]/div[2]/div[1]    #processed/s
    ${processed}    Convert To String     ${processed}
    ${emitted}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[2]/div[3]/div[1]    #emitted/s
    ${emitted}    Convert To String     ${emitted}
    ${tot_processed}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[2]/div[4]/div[1]    #total processed
    ${tot_processed}    Convert To String     ${tot_processed}
    ${tot_emitted}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[2]/div[5]/div[1]    #total emitted
    ${tot_emitted}    Convert To String     ${tot_emitted}
    ${operators}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[1]/div[1]    #operators
    ${operators}    Convert To String     ${operators}
    ${p/c_cont}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[2]/div[1]    #planned/allocated containers
    ${p/c_cont}    Convert To String     ${p/c_cont}
    ${alloc_mem}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[3]/div[1]    #allocated memory
    ${alloc_mem}    Convert To String     ${alloc_mem}
    Run Keyword Unless    '${state}'=='RUNNING'    Fail    ${App_Name} is not running, current state is ${state}
    Run Keyword Unless    '${id}'!='NULL'    Fail    ID is not shown
    Run Keyword Unless    '${user}'=='${username}'    Fail    Username is wrong or not shown
    Run Keyword Unless    '${version}'=='${version_string}'    Fail    Version string not same
    Run Keyword Unless    '${wid}'!='-'    Fail    Current Window ID not shown
    Run Keyword Unless    '${rec_wid}'!='-'    Fail    Recovert Windows ID not shown
    Run Keyword Unless    '${latency}'!='-'    Fail    Latency Not Shown
    Run Keyword Unless    '${processed}'!='-'    Fail    Processed/sec not shown
    Run Keyword Unless    '${emitted}'!='-'    Fail    Emitted/sec not shown
    Run Keyword Unless    '${tot_processed}'!='-'    Fail    Total Processed not shown
    Run Keyword Unless    '${tot_emitted}'!='-'    Fail    Total Emitted not shown
    Run Keyword Unless    '${operators}'!='-'    Fail    Number Of Operators not shown
    Run Keyword Unless    '${p/c_cont}'!='-'    Fail    Planned/Alloc is not shown
    Run Keyword Unless    '${alloc_mem}'!='-'    Fail    Allocated Memory is not shown

App_Details_Shutdown_TC13
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //span[text()='shutdown']/..    #Shutdown the launched app
    Wait Until Page Contains Element    //h3[text()="End this application?"]    #timeout=10s
    Click Element    //button[contains(@class,'btn-danger')]
    Wait Until Page Contains Element    //span[text()='FINISHED']/..    timeout=60s
    Launch_The_App    ${Pkg_Name}    ${App_Name}  #comment when running individual test case
    sleep    10s


App_Details_Kill_TC14
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //span[text()='kill']/..    #Shutdown the launched app
    Wait Until Page Contains Element    //h3[text()="End this application?"]    #timeout=10s
    Click Element    //button[contains(@class,'btn-danger')]
    Wait Until Page Contains Element    //span[text()='KILLED']/..     timeout=20s
    Launch_The_App    ${Pkg_Name}    ${App_Name}  #comment when running individual test case
    sleep    10s

Set_Logging_Levels_TC15
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Click Element    //button[contains(@ng-click,'addLogger()')]
    Click Element    //button[contains(@ng-click,'addLogger()')]
    Click Element    //button[contains(@ng-click,'setLoggers()')]
    Page Should Contain    Entries required
    Input Text    //*[@id="target_0"]    com.datatorrent.stram.util.ConfigUtils
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[1]/div[2]/div/select
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[1]/div[2]/div/select/option[8]
    Input Text    //*[@id="target_1"]    com.datatorrent.stram.engine.WindowGenerator
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[2]/div[2]/div/select
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[2]/div[2]/div/select/option[8]
    Click Element    //button[contains(@ng-click,'setLoggers()')]
    Page Should Contain      Entries required
    Input Text    //*[@id="target_2"]    com.datatorrent.lib.io.WebSocketOutputOperator
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[3]/div[2]/div/select
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[3]/div[2]/div/select/option[8]
    Capture Page Screenshot
    Click Element    //button[contains(@ng-click,'setLoggers()')]
    Wait Until Page Contains     ${App_Name}    timeout=30s


Load_Current_Log_Levels_TC16
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Click Element    //button[contains(@ng-click,'loadCurrentLogLevels()')]
    sleep    5s
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[4]/button    #Red Cross Button
    Click Element    //button[contains(@ng-click,'setLoggers()')]
    Wait Until Page Contains     ${App_Name}    timeout=30s


Delete_Log_Levels_TC17
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Click Element    //button[contains(@ng-click,'loadCurrentLogLevels()')]
    sleep   5s
    Click Element    //button[contains(@ng-click,'addLogger()')]
    Click Element    //button[contains(@ng-click,'addLogger()')]
    #Page Should Contain     Entry required
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[4]/button    #Red Cross Button
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[4]/button    #Red Cross Button
    Input Text    //*[@id="target_3"]    com.datatorrent.stram.util.ConfigUtils
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[4]/div[2]/div/select
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div[4]/div[2]/div/select/option[8]
    Click Element    //button[contains(@ng-click,'setLoggers()')]
    Wait Until Page Contains     ${App_Name}    timeout=30s


Set_Wrong_Log_Level_PackageName_TC18
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Input Text    //*[@id="target_0"]    a
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[2]/div/select    #Opening List
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[2]/div/select/option[8]     #Selecting Log Level
    Click Element    //*[contains(@ng-click,'setLoggers()')]
    Click Element    //*[contains(@ng-click,'setLoggers()')]
    Page Should Contain Element     //*[contains(@ng-if,'loggerForm.$error.invalidRegEx')]
    Click Element    //*[contains(@ng-click,'$dismiss()')]
    Wait Until Page Contains    ${App_Name}    timeout=30s

Set_Wrong_Log_Level_TC19
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Input Text    //*[@id="target_0"]    abcd
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[2]/div/select    #Not Selecting Log Level
    Click Element    //*[contains(@ng-click,'setLoggers()')]
    Click Element    //*[contains(@ng-click,'setLoggers()')]
    Page Should Contain Element     //*[contains(@ng-if,'loggerForm.$error.required.length === 1')]
    Click Element    //*[contains(@ng-click,'$dismiss()')]
    Wait Until Page Contains    ${App_Name}    timeout=30s

Search_Wrong_Log_Level_TC20
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Input Text    //*[@id="target_0"]    com
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[1]/div/button    #Search Button
    Page Should Contain Element    //*[contains(@class,'popover-content')]
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[1]/div/button    #Search Button
    Clear Element Text    //*[@id="target_0"]
    Click Element    //*[contains(@ng-click,'$dismiss()')]
    Wait Until Page Contains    ${App_Name}    timeout=30s

Search_Wrong_Log_Level_and_Set_Log_Level_TC21
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Input Text    //*[@id="target_0"]    com
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[1]/div/button    #Search Button
    Page Should Contain Element    //*[contains(@class,'popover-content')]
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[1]/div/button    #Search Button
    Clear Element Text    //*[@id="target_0"]
    Click Element    //*[contains(@ng-click,'$dismiss()')]
    Wait Until Page Contains    ${App_Name}    timeout=30s

Search_Same_Package_Log_Level_TC22
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Input Text    //*[@id="target_0"]    com.datatorrent.stram.util.ConfigUtils
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[2]/div/select    #Selecting Log Level Dropdown
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/form/div/div[2]/div/select/option[8]    #Selecting 'ALL' Option
    Click Element    //*[contains(@ng-click,'setLoggers()')]
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //button[contains(@ng-click,'appInstance.openLogLevelModal()')]
    Click Element    //button[contains(@ng-click,'loadCurrentLogLevels()')]
    Page Should Contain    com.datatorrent.stram.util.ConfigUtils
    Click Element    //*[contains(@ng-click,'$dismiss()')]
    Wait Until Page Contains    ${App_Name}    timeout=30s

New_Dashboard_Visualise_TC23
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@class,'btn btn-xs btn-primary dropdown-toggle')]
    Click Element    //*[contains(@uib-tooltip,'Create a new dashboard')]
    Page Should Contain     ${App_Name}


Existing_Dashboard_Visualise_TC24
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@class,'btn btn-xs btn-primary dropdown-toggle')]
    Click Element    //*[contains(@uib-tooltip,'View existing dashboard')]
    Page Should Contain     ${App_Name}


AM_Logs_Test_TC25
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@container-logs-message,'containerLogs')]
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span[3]/ul/li[1]/a    #Clicking AppMaster.stderr Link
    Page Should Contain    AppMaster.stderr
    Go Back
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@container-logs-message,'containerLogs')]
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span[3]/ul/li[2]/a    #Clicking AppMaster.stdout Link
    Page Should Contain    AppMaster.stdout
    Go Back
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@container-logs-message,'containerLogs')]
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span[3]/ul/li[3]/a    #Clicking dt.log Link
    Page Should Contain    dt.log


StramEvents_Details_TC26
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Page Should Contain Element    //*[contains(text(),'StramEvents')]
    Page Should Contain Element    //*[contains(text(),'StartContainer')]
    sleep    20s
    Reload Page
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Page Should Contain Element    //*[contains(@ng-if,'!event.data.logFileNameOnly')]
    Page Should Contain Element    //*[contains(text(),'StartOperator')]
    Page Should Contain Element    //*[contains(@dt-page-href,'PhysicalOperator')]
    Page Should Contain Element    //*[contains(@dt-page-href,'LogicalOperator')]


StramEvents_Following_TC27
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Page Should Contain Element    //*[contains(text(),'StramEvents')]
    Page Should Contain Element    //*[contains(text(),'StartContainer')]
    Click Element    //span[text()='physical']/..
    sleep    5s
    Click Element    //a[text()='1']/../../..//a[@dt-page-href="Container"]
    Page Should Contain Element    //h2[contains(text(),'container')]
    Click Element    //t[text()='kill']/..
    Reload Page
    sleep    5s    #Delay in response due to remote connection
    Page Should Contain Element    //span[@ng-if='dtStatus' and text()='KILLED']
    Go Back
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //span[text()='logical']/..
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Page Should Contain Element    //*[contains(text(),'StopContainer')]


StramEvents_Not_Following_TC28              #FAIL - NOT FOLLOWING STATE DOESN'T PERSIST
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Element    //*[contains(@ng-click,'toggleTailState()')]
    Page Should Contain Element    //*[contains(text(),'StramEvents')]
    Page Should Contain Element    //*[contains(text(),'StartContainer')]
    Click Element    //span[text()='physical']/..
    sleep    5s
    Click Element    //a[text()='1']/../../..//a[@dt-page-href="Container"]
    Page Should Contain Element    //h2[contains(text(),'container')]
    Click Element    //t[text()='kill']/..
    Reload Page
    sleep    5s    #Delay in response due to remote connection
    Page Should Contain Element    //span[@ng-if='dtStatus' and text()='KILLED']
    Go Back
    Click Element    //span[text()='logical']/..
    Page Should Not Contain Element    //*[contains(text(),'StopContainer')]


StramEvents_Range_TC29
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Click Button     //*[contains(@ng-click,'toggleMode()')]
    ${from}=  create list
    ${to}=  create list
    ${from}=    Get Time  year month day hour min sec  NOW - 1min
    ${to}=    Get Time  year month day hour min sec  NOW
    Input Text    //*[contains(@ng-model,'state.range.from')]  ${from[1]}/${from[2]}/${from[0]} ${from[3]}:${from[4]}:${from[5]}
    Input Text    //*[contains(@ng-model,'state.range.to')]    ${to[1]}/${to[2]}/${to[0]} ${to[3]}:${to[4]}:${to[5]}
    Click Element    //*[contains(@class,'btn btn-primary submit-event-range-btn')]
    Wait Until Page Does Not Contain  Fetching events...    timeout=30s
    ${stram_time}    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/stram-event-list/div[2]/div[1]/div/ol/li[1]/div/stram-event-detail      #Getting Timestamp of the first one from the List
    ${stram_time}=  get regexp matches  ${stram_time}  \\d+
    Capture Page Screenshot
    Log    ${stram_time}
    Run Keyword Unless  '${stram_time[0]}'=='${from[0]}'  Fail  Hour Not Present in Range
    Run Keyword Unless  '${stram_time[1]}'=='${from[1]}'  Fail  Minute Not Present in Range


Logical_DAG_Details_TC30
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains Element    //*[contains(@class,'svg-main')]    timeout=30s
    Page Should Contain Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/span[1]/select    #Top List
    Page Should Contain Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/span[2]/select    #Bottom List
    Page Should Contain Element    //*[contains(@ng-hide,'criticalPathLoading')]
    Page Should Contain Element    //*[contains(@ng-model,'showLocality')]
    Page Should Contain Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/div/a[2]    #Reset Position


Logical_DAG_Top_Bottom_Selection_TC31
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains Element    //*[contains(@class,'svg-main')]    timeout=30s
    ${processed}    Get Text    css=g.node:nth-child(1) > g:nth-child(3) > text:nth-child(1)
    ${processed}=  Replace String  ${processed}  ,  ${EMPTY}
    ${processed}=  evaluate  ${processed}
    ${emitted}     Get Text    css=g.node:nth-child(3) > g:nth-child(4) > text:nth-child(1)
    ${emitted}=  Replace String  ${emitted}  ,  ${EMPTY}
    ${emitted}=  evaluate  ${emitted}
    Page Should Contain Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/span[1]/select    #Top List
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/span[1]/select/option[11]    #Total Processed
    Page Should Contain Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/span[2]/select    #Bottom List
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/span[2]/select/option[12]    #Total Emitted
    sleep    5s
    ${tot_processed}    Get Text    css=g.node:nth-child(1) > g:nth-child(3) > text:nth-child(1)
    ${tot_processed}=  Replace String  ${tot_processed}  ,  ${EMPTY}
    ${tot_processed}=  evaluate  ${tot_processed}
    ${tot_emitted}    Get Text    css=g.node:nth-child(3) > g:nth-child(4) > text:nth-child(1)
    ${tot_emitted}=  Replace String  ${tot_emitted}  ,  ${EMPTY}
    ${tot_emitted}=  evaluate  ${tot_emitted}
    Run Keyword Unless    ${tot_processed}>${processed}    Fail    Total Processed Not Shown
    Run Keyword Unless    ${tot_emitted}>${emitted}    Fail    Total Emitted Not Shown


Operator_Details_From_DAG_TC32
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains Element    //*[contains(@class,'svg-main')]    timeout=30s
    sleep    5s
    ${name}    Get Text    css=g.node:nth-child(3) > g:nth-child(2) > text:nth-child(1)
    Click Element    css=g.node:nth-child(3) > g:nth-child(2) > text:nth-child(1)
    Wait Until Page Contains    ${name}
    Page Should Contain    ${name}


Critical_Path_Test_TC33
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains Element    //*[contains(@class,'svg-main')]    timeout=30s
    ${before}=    Get Element Attribute     css=g.node:nth-child(3) > rect:nth-child(1)@fill
    Click Element    //*[contains(@ng-model,'showCriticalPath')]
    sleep    2s
    ${after}=    Get Element Attribute     css=g.node:nth-child(3) > rect:nth-child(1)@fill
    Run Keyword Unless    '${before}'!='${after}'    Fail    Last Operator is not shown in Critical Path


Stream_Locality_Test_TC34
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains Element    //*[contains(@class,'svg-main')]    timeout=30s
    Page Should Not Contain Element    //*[@stroke-dasharray='5,2' and @style='opacity: 1;']
    Click Element    //*[contains(@ng-model,'showLocality')]
    sleep    2s
    Page Should Contain Element    //*[@stroke-dasharray='5,2' and @style='opacity: 1;']


Reset_DAG_TC35
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains Element    //*[contains(@class,'svg-main')]    timeout=30s
    ${before}     Get Element Attribute    css=.svg-main > g:nth-child(3) > g:nth-child(1)@transform
    Drag And Drop    css=.svg-main > g:nth-child(3) > g:nth-child(1)    //*[contains(@class,'minimap-interaction')]     #100    20    #Move 100px to right and 20px down
    ${after}     Get Element Attribute    css=.svg-main > g:nth-child(3) > g:nth-child(1)@transform
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div[1]/div/a[2]    #Reset Position
    ${after_reset}     Get Element Attribute    css=.svg-main > g:nth-child(3) > g:nth-child(1)@transform
    Run Keyword Unless    '${before}'!='${after}'    Fail    DAG didn't Moved
    Run Keyword Unless    '${before}'=='${after_reset}'    Fail    DAG Position Not Resetted

Logical_Operator_Details_TC36
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains  Logical Operators  timeout=30s
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  name
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  class
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  total cpu
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  current wID
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  recovery wID
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  failures
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  last heartbeat
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  latency (ms)
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  status
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  processed/s
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  emitted/s
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  total processed
    Table Should Contain  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table  total emitted

Logical_Operators_Search_And_Sort_TC37
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains  Logical Operators  timeout=30s

    #SEARCH
    ${name}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    ${class}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[3]/span
    ${total_cpu}=  Set Variable  >1
    ${failures}=  Set Variable  0
    ${last_heartbeat}=  Set Variable  today
    ${latency}=  Set Variable  >1
    ${status}=  Set Variable  1
    ${processed/s}=  Set Variable  >2
    ${emitted/s}=  Set Variable  >2
    ${tot_processed}=  Set Variable  >100
    ${tot_emitted}=  Set Variable  >100

    #name
    Input Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${name}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    Clear Element Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input

    #class
    Input Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${class}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    Clear Element Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

    #total cpu
    Input Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input  ${total_cpu}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    Clear Element Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input

    #failures
    Input Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input  ${failures}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    Clear Element Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input

    #last heartbeat
    Input Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[8]/input  ${last_heartbeat}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    Clear Element Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[8]/input

    #latency (ms)
    Input Text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  ${latency}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input

    #status
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[10]/input  ${status}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[10]/input

    #processed/s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[11]/input  ${processed/s}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[11]/input

    #emitted/s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[12]/input  ${emitted/s}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[12]/input

    #total processed
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[13]/input  ${tot_processed}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[13]/input

    #total emitted
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[14]/input  ${tot_emitted}
    Page Should Contain Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[14]/input


    #SORT
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}

    #name
    LOG  NAME
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #class
    LOG  class
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]/span[1]
    #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #cpu
    log  cpu
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  fetch from left  ${id_str}  .
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  fetch from left  ${id_str}  .
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #wid
    log  wid
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[5]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[5]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #recovery
    log  recovery
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[6]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[6]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #FAILURE
    log  failure
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[7]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[7]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #heartbeat
    log  heartbeat
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[8]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[8]/span[1]
    sleep  1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

Logical_Operators_Set_Loging_Level_TC38
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains  Logical Operators  timeout=30s
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[1]/span/input
    Click Element    //*[contains(@ng-disabled,'settingLogLevel')]
    Click Element    //*[contains(text(),'ALL')]    #Loggin Level = ALL
    Page Should Contain Element    //*[contains(@class,'alert ui-pnotify-container alert-success ui-pnotify-shadow')]

Logical_Operators_Link_TC39
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    Wait Until Page Contains  Logical Operators  timeout=30s
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count}=  convert to string  ${count}
    : FOR    ${INDEX}    IN RANGE    1    ${count}+1
    \    Log  ${INDEX}
    \    ${name}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]/a
    \    Click Element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]/a
    \    Wait Until Page Contains  ${name}  timeout=30s
    \    Page Should Contain  ${name}
    \    Go Back
    \    Wait Until Page Contains  Logical Operators  timeout=30s
    \    Select Checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[1]/input
    \    Click Element  //*[contains(text(),'inspect')]
    \    Wait Until Page Contains  ${name}  timeout=30s
    \    Page Should Contain  ${name}
    \    Go Back

Search_Logical_Operator_TC40
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    ${next_op_name}=    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a    #Absolute Path To Second Link
    ${next_op_name}    Convert To String    ${next_op_name}
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a    #Absolute Path to First Link
    Click Element    //*[contains(text(),'logical operators')]
    Input Text    xpath=//*[@id="breadcrumbs-top"]/li[4]/span/span/ul/li[2]/form/input     ${next_op_name}
    Click Element    //*[contains(text(),'${next_op_name}')]
    Wait Until Page Contains    ${next_op_name}


Logical_Operator_Details_TC41
    Go To Page    Monitor    Cluster Overview
    Select_App_Monitor_Page  ${App_Name}
    Wait Until Page Contains     ${App_Name}    timeout=30s
    Click Element    //*[contains(text(),'logical')]
    ${op_name}=    Get Text    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a    #Absolute Path To First Link
    ${op_name}    Convert To String    ${op_name}
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a    #Absolute Path to First Link
    Wait Until Page Contains    ${op_name}
    Page Should Contain Element    //*[contains(text(),'${op_name}')]
    Page Should Contain Element    //*[contains(text(),'Partitions')]
    Page Should Contain Element    //*[contains(text(),'Metrics Chart')]
    Page Should Contain Element    //*[contains(text(),'Operator Properties')]
    Page Should Contain Element    //*[contains(text(),'Logical Operator')]

*** Test Cases ***
#41 ${url}            http://aditya-ubuntu:9090/
App Details - Logical Operator Details - Change operator properties 41
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    ${change_prop}=  convert to string   9
    ${property}=   convert to string   tuplesBlastIntervalMillis
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    scroll page to location  0  500
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]//a[contains(text(),"${operator_name}")]
    wait until page contains   State  timeout=20s
    Input Text     xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div/table/thead/tr[2]/td[1]/input  ${property}
    Click element  xpath=//*[contains(text(),"change")]
    Input text   xpath=/html/body/div[1]/div/div/div[2]/form/div/textarea   ${change_prop}    #text field
    click element   xpath=//*[contains(text(),"Save")]/../button   #save
    page should contain  ${change_prop}
    #page should not contain  error
    Capture Page Screenshot

#42
App Details - Logical Operator Details - Navigate to operator's Container 42
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]//*[contains(text(),"${operator_name}")]
    wait until page contains  ACTIVE  timeout=20s
    Click Element   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    wait until page contains  ${operator_name}   timeout=20s
    page should contain  ${operator_name}
    Capture Page Screenshot

#43
App Details - Logical Operator Details - Navigate to Physical operator 43
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    wait until page contains  ${operator_name}  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]//a[contains(text(),"${operator_name}")]
    wait until page contains  ACTIVE  timeout=20s
    Click Element   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    page should contain  ${operator_name}
    Capture Page Screenshot

#44
App Details - Logical Operator Details - Record sample 44
          #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver      #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]//a[contains(text(),"${operator_name}")]
    wait until page contains  ACTIVE  timeout=20s
    select checkbox   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    #click element  xpath=//*[contains(text(),"record a sample")]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[1]/span[1]/span/button[1]
    wait until page contains  Sample Tuples   timeout=20s
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]
    capture page screenshot


#45
App Details - Streams details 45
          #Make sure only two spaces after "string"
    ${stream_name1}=  convert to string  Results
    ${stream_name2}=  convert to string  Phone-Data
    ${stream_name3}=  convert to string  Query
    ${stream_locality}=  convert to string  AUTOMATIC
    ${stream_source1}=  convert to string  integer_data
    ${stream_source1}=  convert to string  locationQueryResult
    ${stream_source3}=  convert to string  outputPort
    ${stream_sinks1}=  convert to string  data
    ${stream_sinks2}=  convert to string  input
    ${stream_sinks3}=  convert to string  phoneQuery
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    ${get_stream_name1}  get text  xpath=//span[contains(text(),"${stream_name1}")]
    ${stream_name1_str}  convert to string  ${get_stream_name1}
    ${get_stream_locality}  get text  xpath=//span[contains(text(),"${stream_locality}")]
    ${stream_locality_str}  convert to string  ${get_stream_locality}
    log  ${stream_name1_str}
    log  ${stream_locality_str}

#46
App Details - Streams details - operator links 46
          #Make sure only two spaces after "string"
    ${source}=  convert to string  LocationFinder
    ${sink}=  convert to string  LocationFinder
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]//*[contains(text(),"${source}")]
    page should contain  ${source}
    capture page screenshot
    GO TO PAGEM   Monitor   Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]//*[contains(text(),"${sink}")]
    page should contain  ${sink}
    capture page screenshot

#47
App Details - Streams details - Search & Sort 47
          #Make sure only two spaces after "string"
    ${name_search}=  convert to string  Phone-Data
    ${locality_search}=  convert to string  AUTOMATIC
    ${source_search}=  convert to string  integer_data
    ${sinks_search}=  convert to string  data
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    scroll page to location  0  700
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    sleep  2s
    capture page screenshot
    ${1}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/span
    ${1_str}=  convert to string  ${1}
    ${2}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/span
    ${2_str}=  convert to string  ${2}
    run keyword if  '${1_str}'<='${2_str}'   log  ${1_str}
    run keyword if  '${1_str}'>'${2_str}'    FAIL
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]/span[1]
    ${1}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[3]/span
    ${1_str}=  convert to string  ${1}
    ${2}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[3]/span
    ${2_str}=  convert to string  ${2}
    run keyword if  '${1_str}'>='${2_str}'   log  ${1_str}
    run keyword if  '${1_str}'<'${2_str}'    FAIL
    capture page screenshot
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${name_search}
    capture page screenshot
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${locality_search}
    capture page screenshot
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input  ${source_search}
    capture page screenshot
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[5]/input  ${sinks_search}
    capture page screenshot


#48
App Details - Metric Chart details 48
          #Make sure only two spaces after "string"
    ${time}=  convert to string  last 30 seconds
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    #click element   xpath=xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[6]/div/div[2]/div/div/select
    wait until page contains  last 5 minutes
    select from list  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[6]/div/div[2]/div/div/select   ${time}
    scroll page to location  0   2000
    page should contain  ${time}
    capture page screenshot


#49
App Details - Metric Chart details2 49
          #Make sure only two spaces after "string"
    ${toggle}=  convert to string  tuplesEmittedPSMA
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]
    wait until page contains  ${toggle}  timeout=20s
    #click element  xpath=//t[contains(text(),"${toggle}")]
    #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[6]/div/div[2]/div/nvd3-line-chart/svg/g/g/g[4]/g/g/g[1]/text
    ${Y}=  get vertical position  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]/div/div[1]
    ${Y_str}  convert to string  ${Y}
    log  ${Y_str}
    scroll page to location  0   ${Y_str}
    sleep  5s
    click element  xpath=//*[contains(text(),"tuplesEmittedPSMA")]
    capture page screenshot


#50
App Details - Physical Operators details 50
          #Make sure only two spaces after "string"
    ${toggle}=  convert to string  tuplesEmittedPSMA
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    ${num of operators}  get text   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[1]/div[1]
    ${num of operators_str}  convert to string  ${num of operators}
    ${num of operators}  get text   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[1]/div[1]
    ${num of operators_str}  convert to string  ${num of operators}
    log  ${num of operators_str}



#52
App Details - Physical Operators - Logical Operator Name link 52
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div//*[contains(text(),"${operator_name}")]
    capture page screenshot

#53
App Details - Physical Operators - Container link 53
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    capture page screenshot


#54
App Details - Physical Operators - Record a Sample (default) 54
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[1]/span[1]/span/button[1]
    wait until page contains  Sample Tuples   timeout=20s
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]
    sleep  2s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    capture page screenshot

*** comment ***
#55
App Details - Physical Operators - Record a Sample (1 window)
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${window_size}=  convert to string  record 1 window
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[1]/span[1]/span/button[2]
    wait until page contains  ${window_size}   timeout=10s
    click element  xpath=//*[contains(text(),"${window_size}")]
    wait until page contains  Sample Tuples  timeout=20s
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]/../button
    sleep  2s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    capture page screenshot


#56
App Details - Physical Operators - Record a Sample (1000 window)
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${window_size}=  convert to string  record 1000 window
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[1]/span[1]/span/button[2]
    wait until page contains  ${window_size}   timeout=10s
    click element  xpath=//*[contains(text(),"${window_size}")]
    wait until page contains  Sample Tuples  timeout=20s
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]
    sleep  2s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    capture page screenshot


#57
App Details - Physical Operators - Record Sample modal details
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  LocationFinder     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//*[contains(text(),"record a sample")]
    wait until page contains  Sample Tuples   timeout=20s
    ${total tuples}=  get text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[1]/fieldset/div/div[1]/span
    ${total tuples_str}=  convert to string  ${total tuples}
    ${loaded tuples}=  get text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[1]/fieldset/div/div[2]/span
    ${loaded tuples_str}  convert to string  ${loaded tuples}
    click element  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[2]/fieldset/div[1]/a
    click element  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[2]/fieldset/div[2]/a
    input text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[2]/div[2]/div/div/form/input  xyz
    log  ${loaded tuples_str}
    log  ${total tuples_str}
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input


App Details - Physical Operators - Record Sample modal details -input operator
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//*[contains(text(),"record a sample")]
    wait until page contains  Sample Tuples   timeout=20s
    ${total tuples}=  get text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[1]/fieldset/div/div[1]/span
    ${total tuples_str}=  convert to string  ${total tuples}
    ${loaded tuples}=  get text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[1]/fieldset/div/div[2]/span
    ${loaded tuples_str}  convert to string  ${loaded tuples}
    click element  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[2]/fieldset/div[2]/a
    input text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[2]/div[2]/div/div/form/input  xyz
    log  ${loaded tuples_str}
    log  ${total tuples_str}
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

App Details - Physical Operators - Record Sample modal details -output operator
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  LocationResult     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//*[contains(text(),"record a sample")]
    wait until page contains  Sample Tuples   timeout=20s
    ${total tuples}=  get text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[1]/fieldset/div/div[1]/span
    ${total tuples_str}=  convert to string  ${total tuples}
    ${loaded tuples}=  get text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[1]/fieldset/div/div[2]/span
    ${loaded tuples_str}  convert to string  ${loaded tuples}
    click element  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[1]/div[2]/fieldset/div[1]/a
    input text  xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div[2]/div[2]/div/div/form/input  xyz
    log  ${loaded tuples_str}
    log  ${total tuples_str}
    capture page screenshot
    click element   xpath=//*[contains(text(),"Close")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

*** Test Cases ***

#59
App Details - Physical Operator Details - Breadcrumb 59
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    wait until page contains  physical operators
    click element  xpath=//*[contains(text(),"physical operators")]
    wait until page contains  ${operator_name}
    input text  xpath=//*[@id="breadcrumbs-top"]/li[4]/span/span/ul/li[2]/form/input  ${operator_name}
    click element  xpath=//*[contains(text(),"${operator_name}")]
    capture page screenshot

#60
App Details - Physical Operator Details 60
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    wait until page contains  Operator Properties
    page should contain  Physical Operator
    page should contain  Ports
    page should contain  Container History
    page should contain  Operator Properties
    capture page screenshot

#61
App Details - Physical Operator Details - Navigate to Logical operator details 61
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//*[contains(text(),"${operator_name}")]
    page should contain  ${operator_name}
    page should contain  Logical Operator
    capture page screenshot

#62
App Details - Physical Operator Details - Navigate to container details 62
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    ${state}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span/span
    ${state_str}=  convert to string  ${state}
    ${status}=  convert to string  ACTIVE
    Run keyword unless  '${state_str}'=='${status}'  click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[1]/div[1]/div[1]/a
    page should contain  Container Overview
    sleep  5s
    capture page screenshot

#63
App Details - Physical Operator Details - Container logs 63
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    ${state}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span/span
    ${state_str}=  convert to string  ${state}
    ${status}=  convert to string  ACTIVE
    Run keyword unless  '${state_str}'=='${status}'  click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${current_url}  get location
    click element  xpath=//*[contains(text(),"logs")]
    click element  xpath=//*[contains(text(),"dt.log")]
    page should contain  dt.log
    go to  ${current_url}
    click element  xpath=//*[contains(text(),"logs")]
    click element  xpath=//*[contains(text(),"stderr")]
    page should contain  stderr
    go to  ${current_url}
    click element  xpath=//*[contains(text(),"logs")]
    click element  xpath=//*[contains(text(),"stdout")]
    page should contain  stdout
    capture page screenshot

#64
App Details - Physical Operator Details - Port details 64
         #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    ${state}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span/span
    ${state_str}=  convert to string  ${state}
    ${status}=  convert to string  ACTIVE
    Run keyword unless  '${state_str}'=='${status}'  click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${current_url}  get location
    ${port_name}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    ${port_name}=  convert to string  ${port_name}
    click element  xpath=//*[contains(text(),"${port_name}")]
    wait until page contains  ${port_name}   timeout=10s
    capture page screenshot
    go to  ${current_url}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"inspect")]
    wait until page contains  ${port_name}   timeout=10s
    capture page screenshot


#65
App Details - Physical Operator Details - Container History - ID 65
   #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    #Run keyword unless  '${state_str}'=='${status}'  click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${cont_id}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[1]/div[1]/div[1]/a
    ${cont_id_str}=  convert to string  ${cont_id}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div//*[contains(text(),"01_")]
    ${status}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset/div[1]/div[1]/span/span
    ${status_str}=  convert to string  ${status}
    run keyword if  '${status_str}'=='ACTIVE'  page should contain  ${cont_id_str}
    capture page screenshot


#66
App Details - Physical Operator Details - Container History - logs 66
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${current_url}  get location
    ${y}  get vertical position  xpath=//*[contains(text(),"logs")]
    ${y_str}=  convert to string  ${y}
    scroll page to location  0   ${y_str}
    capture page screenshot
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]//*[contains(text(),"logs")]
    wait until page contains  dt.log
    click element  xpath=/html/body/ul/li[1]/a
    page should contain  dt.log
    go to  ${current_url}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]//*[contains(text(),"logs")]
    wait until page contains  stderr
    click element  xpath=/html/body/ul/li[2]/a
    page should contain  stderr
    go to  ${current_url}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]//*[contains(text(),"logs")]
    wait until page contains  stdout
    click element  xpath=/html/body/ul/li[3]/a
    page should contain  stdout
    capture page screenshot


#67
App Details - Physical Operator Details - Search operator properties 67
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${input}=  convert to string  class
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div/table/thead/tr[2]/td[1]/input  ${input}
    page should contain  ${input}
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div/table/thead/tr[2]/td[1]/input  dfafjajl
    page should contain  no rows
    capture page screenshot
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div/table/thead/tr[2]/td[1]/input
    capture page screenshot


#68
App Details - Containers - Details 68
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  act
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    ${host}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span
    ${host_str}=  convert to string  ${host}
    log  ${count_str}
    log  ${host_str}
    : FOR    ${INDEX}    IN RANGE    2    ${count_str}
    \    Log    ${INDEX}
    \   ${operator_name}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]/ul[1]/li/a
    \    ${operator_name_str}=  convert to string  ${operator_name}
    \    Log  ${operator_name_str}
#69
App Details - Containers - AppMaster
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  0001
    page should contain  ACTIVE
    page should contain  AppMaster
    capture page screenshot
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input


#71
App Details - Containers - operators link 71
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]//*[contains(text(),"${operator_name}")]
    page should contain  ${operator_name}
    page should contain  Physical
    capture page screenshot

#72
App Details - Containers - Single Container options 72
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input
    page should contain  inspect
    page should contain  logs
    page should contain  stackTrace
    page should contain  deselect all
    page should contain  kill selected
    page should contain  retrieve killed
    unselect checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input
    sleep  2s
    capture page screenshot

#73
App Details - Containers - Multiple Container options 73
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[3]/td[1]/input
    page should not contain  inspect
    #page should not contain  logs
    page should not contain  stackTrace
    page should contain  deselect all
    page should contain  kill selected
    page should contain  retrieve killed
    unselect checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input
    unselect checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[3]/td[1]/input
    sleep  2s
    capture page screenshot

#74
App Details - Containers - select active 74
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//*[contains(text(),"retrieve killed")]
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  act
    click element  xpath=//*[contains(text(),"select active")]
    checkbox should be selected   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input
    capture page screen shot
    click element  xpath=//*[contains(text(),"deselect all")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input

#75
App Details - Containers - select all active but app master 75
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//*[contains(text(),"select all active but app master")]
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  act
    checkbox should be selected  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[1]/input
    capture page screenshot
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  0001
    checkbox should not be selected  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    capture page screenshot
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input
    click element  xpath=//*[contains(text(),"deselect all")]


#76
App Details - Containers - retrieve killed 76
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//*[contains(text(),"retrieve killed")]

#77
App Details - Containers - AppMaster logs 77
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//*[contains(text(),"0001")]
    wait until page contains  ACTIVE
    ${current_url}  get location
    click element  xpath=//*[contains(text(),"logs")]
    wait until page contains  dt.log
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[1]/a
    page should contain  AppMaster.stderr
    go to  ${current_url}
    click element  xpath=//*[contains(text(),"logs")]
    wait until page contains  stderr
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[2]/a
    page should contain  AppMaster.stdout
    go to  ${current_url}
    click element  xpath=//*[contains(text(),"logs")]
    wait until page contains  stdout
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[3]/a
    page should contain  dt.log
    capture page screenshot

#78
App Details - Containers - logs 78
         #Make sure only two spaces after "string"
    #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    wait until page contains  AppMaster
    ${operator_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a
    ${operator_id}=  convert to string   ${operator_id}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]//*[contains(text(),"${operator_id}")]
    ${current_url}  get location
    click element  xpath=//*[contains(text(),"logs")]
    wait until page contains  dt.log
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[1]/a
    page should contain  dt.log
    go to  ${current_url}
    click element  xpath=//*[contains(text(),"logs")]
    wait until page contains  stderr
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[2]/a
    page should contain  stderr
    go to  ${current_url}
    click element  xpath=//*[contains(text(),"logs")]
    wait until page contains  stdout
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[3]/a
    page should contain  stdout
    capture page screenshot

#79
App Details - Containers - AppMaster stackTrace 79
         #Make sure only two spaces after "string"
    ${operator_id}=  convert to string  00001     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${operator_id}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"stackTrace")]
    page should contain  Stack Trace
    page should contain  ${operator_id}
    capture page screenshot
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input

#80
App Details - Containers - stackTrace 80
         #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    wait until page contains  AppMaster
    ${operator_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a
    ${operator_id}=  convert to string   ${operator_id}
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${operator_id}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"stackTrace")]
    page should contain  Stack Trace
    page should contain  ${operator_id}
    capture page screenshot
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input


#58
App Details - Physical Operators - inspect 58
         #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    wait until page contains  AppMaster
    ${operator_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a
    ${operator_id}=  convert to string  ${operator_id}     #Make sure only two spaces after "string"
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${operator_id}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"inspect")]
    page should contain  ${operator_id}
    capture page screenshot
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input
    capture page screenshot

#70
App Details - Containers - Search & Sort 70
         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${id-1}  convert to string  2
    ${status}  convert to string  ACT
    #${process_id}  convert to string  1
    ${last heart beat}  convert to string  1
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    ${alloc_mem}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[6]/span
    ${alloc_mem}=  remove string  ${alloc_mem}  MB
    ${alloc_mem}=  remove string  ${alloc_mem}  GB
    ${alloc_mem}=  fetch from left  ${alloc_mem}  .0
    ${free_mem}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[7]/span
    ${free_mem}=  remove string  ${free_mem}  MB
    ${free_mem}=  remove string  ${free_mem}  GB
    ${free_mem}=  fetch from left  ${free_mem}  .0
    ${free_mem}=   get substring  ${free_mem}  0  1
    ${free_mem}=   convert to string  1
    ${process_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[3]/span
    ${process_id}=  convert to string  ${process_id}
    ${host}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span
    ${host_str}=  convert to string  ${host}
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}

    #id
    Log  id sort
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]/a
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]/a
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #process id
    log  sort processid
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]/span
    \    ${id_str}=  EVALUATE   ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]/span
    \    ${id_str}=  EVALUATE  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #host
    Log  sort host
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]/span
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]/span
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #heartbeat
    Log  sort heartbeat
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[5]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]/span
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[5]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]/span
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #memory
    log  sort memory
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[6]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]/span
    \    ${id_str}=  convert to string   ${id}
    \    ${id_str}=  remove string   ${id_str}  MB
    \    ${id_str}=  remove string   ${id_str}  GB
    \    ${id_str}=  EVALUATE  ${id_str}
    \    ${id_str2}=  EVALUATE  ${id_str}*1024
    \    run keyword if  ${id_str}<10  Set Test Variable  ${id_str}  ${id_str2}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[6]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]/span
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  remove string   ${id_str}  MB
    \    ${id_str}=  remove string   ${id_str}  GB
    \    ${id_str}=  EVALUATE  ${id_str}
    \    ${id_str2}=  EVALUATE  ${id_str}*1024
    \    run keyword if  ${id_str}<10  Set Test Variable  ${id_str}  ${id_str2}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    # free memory
    log  free memory
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[7]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]/span
    \    ${id_str}=  convert to string   ${id}
    \    ${id_str}=  remove string   ${id_str}  MB
    \    ${id_str}=  remove string   ${id_str}  GB
    \    ${id_str}=  EVALUATE  ${id_str}
    \    ${id_str2}=  EVALUATE  ${id_str}*1024
    \    run keyword if  ${id_str}<10  Set Test Variable  ${id_str}  ${id_str2}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[7]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]/span
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  remove string   ${id_str}  MB
    \    ${id_str}=  remove string   ${id_str}  GB
    \    ${id_str}=  EVALUATE  ${id_str}
    \    ${id_str2}=  EVALUATE  ${id_str}*1024
    \    run keyword if  ${id_str}<10  Set Test Variable  ${id_str}  ${id_str2}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #operator
    log  sort operator
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[8]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]/a
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[8]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]/a
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #status
    log  sort status
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[9]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]/div/span
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[9]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]/div/span
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #search

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${id-1}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[2]//*[contains(text(),"${id-1}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${process_id}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[3]//span[contains(text(),"${process_id}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input  ${host}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[4]//span[contains(text(),"${host}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input  ${alloc_mem}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[6]//span[contains(text(),"${alloc_mem}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input  ${free_mem}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[7]//span[contains(text(),"${free_mem}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[8]/input  ${operator_name}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[8]//*[contains(text(),"${operator_name}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[8]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  ${status}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[9]//span[contains(text(),"${status}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input


#51
App Details - Physical Operators - Search & Sort 51
          #Make sure only two spaces after "string"
    ${id-1}  convert to string  2
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//*[contains(text(),"${app_name}")]
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]
    wait until page contains  ACTIVE  timeout=20s
    ${name}  convert to string  Receiver
    ${status}  convert to string  ACT
    ${p}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[5]
    ${p}=  Evaluate    ${P} / 100
    ${processed/s}  convert to string  ${p}
    ${e}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[6]
    #${e}=  Evaluate  ${e} - (${e}/ 1000)
    ${emitted/s}  convert to string  0
    ${c}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[7]
    #${c}=  Evaluate  ${c}/100
    ${cpu%}  convert to string  0
    ${failure}  convert to string  0
    ${last heart beat}  convert to string  1
    ${containers}  convert to string  05
    ${latency}  convert to string  0
    ${total processed}  convert to string  0
    ${total emitted}  convert to string  0
    ${host}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span
    ${host_str}=  convert to string  ${host}


    #Sort
    ${count}=  get matching xpath count  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text()," ")]/../tr
    ${count_str}=  convert to string  ${count}
    LOG  ID
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]
    sleep  1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[2]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #name
    LOG  NAME
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[3]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #status
    log  status
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[4]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #processed
    log  processed
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[5]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[5]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[5]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}
    log  ${ids_sorted}
    log  ${ids_reverse}
    capture page screenshot

    #emitted
    log  emitted
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[6]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[6]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[6]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #cpu
    log  cpu
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[7]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[7]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[7]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #wid
    log  wid
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[8]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[8]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[8]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    #recovery
    log  recovery
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[9]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[9]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #FAILURE
    log  failure
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[10]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[10]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[10]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[10]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #heartbeat
    log  heartbeat
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[11]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[11]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[11]
    sleep  1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[11]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #host
    LOG  host
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[12]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[12]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[12]
    sleep  1s
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[12]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #container
    LOG   container
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[13]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[13]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[13]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[13]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}


    LOG   donetilllatency
    #latency
     #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[14]/span[1]
    sleep  1s
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[14]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[14]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[14]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #total processed
    log  total processed
    #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[15]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[15]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[15]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[15]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #total emitted
    log  total emitted
    #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[16]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[16]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[16]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[16]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #Search
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${id-1}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//*[contains(text(),"${id-1}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${name}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[3]//*[contains(text(),"${name}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input  ${status}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[4]//span[contains(text(),"${status}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[5]/input  ${processed/s}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[5]//span[contains(text(),"${processed/s}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[5]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input  ${emitted/s}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[6]//span[contains(text(),"${emitted/s}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input  ${cpu%}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[7]//span[contains(text(),"${cpu%}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[10]/input  ${failure}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[10]//span[contains(text(),"${failure}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[10]/input
    #input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[11]/input  ${last heart beat}
    #${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[11]//span[contains(text(),"${last heart beat}")]
    #clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[11]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[12]/input  ${host}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[12]//span[contains(text(),"${host}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[12]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[14]/input  ${latency}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[14]//span[contains(text(),"${latency}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[14]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[15]/input  ${total processed}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[15]//span[contains(text(),"${total processed}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[15]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[16]/input  ${total emitted}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[16]//span[contains(text(),"${total emitted}")]
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[16]/input
    capture page screenshot

*** Keywords ***

Time_To_Seconds
    [Arguments]    ${list}    ${count}
    reverse list    ${list}
    ${multiples}=  create list
    Append To List  ${multiples}  1  60  3600  86400
    ${value}=   Set Variable   0
    : FOR    ${i}    IN RANGE    0    ${count}
    \    ${value}=   evaluate  ${value}+(${list[${i}]}*${multiples[${i}]})
    \    Log   ${value}
    [Return]  ${value}

Select_App_Monitor_Page
    [Arguments]    ${appname}
    Input Text  xpath=/html/body/div[2]/div[2]/div/div[2]/table/thead/tr[2]/td[3]/input  =${appname}
    Wait Until Page Contains    ${appname}    timeout=30s
    Click Element    //*[contains(text(),'${appname}')]