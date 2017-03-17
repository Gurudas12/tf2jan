*** Settings ***
Suite Setup       SetupBrowsingEnv_Monitor  Mobile Demo  MobileDemo
Suite Teardown    DestroyBrowsingEnv
Resource          ../../../lib/web/WebLib.txt
Resource          ../../../lib/web/Ingestion/Ingestion_Config_UI.txt

*** Variables ***
${username}       aditya
${url}            http://aditya-ubuntu:9090/
${app_pkg_loc}    /home/aditya/Downloads/pi-demo-3.5.0.apa
${dt_version}      3.7.0
${apex_version}    3.6.0
${version_string}      3.6.0-dt20161215

*** Test Cases ***

#41
App Details - Logical Operator Details - Change operator properties 41
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    ${change_prop}=  convert to string   9
    ${property}=   convert to string   tuplesBlastIntervalMillis
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    click element  xpath=//a[contains(text(),"${operator_name}")]/../a
    wait until page contains   State  timeout=20s
    Input Text     xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div/table/thead/tr[2]/td[1]/input  ${property}
    Click element  xpath=//button[contains(text(),"change")]/../button
    Input text   xpath=/html/body/div[1]/div/div/div[2]/form/div/textarea   ${change_prop}    #text field
    click element   xpath=//button[contains(text(),"Save")]/../button   #save
    page should contain  ${change_prop}
    #page should not contain  error
    Capture Page Screenshot

#42
App Details - Logical Operator Details - Navigate to operator's Container 42
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    click element  xpath=//a[contains(text(),"${operator_name}")]/../a
    wait until page contains  ACTIVE  timeout=20s
    Click Element   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    wait till page contains  ${operator_name}   timeout=20s
    page should contain  ${operator_name}
    Capture Page Screenshot

#43
App Details - Logical Operator Details - Navigate to Physical operator 43
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    wait until page contains  ${operator_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${operator_name}")]/../a
    wait until page contains  ACTIVE  timeout=20s
    Click Element   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    page should contain  ${operator_name}
    Capture Page Screenshot

#44
App Details - Logical Operator Details - Record sample 44
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver      #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    click element  xpath=//a[contains(text(),"${operator_name}")]/../a
    wait until page contains  ACTIVE  timeout=20s
    select checkbox   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//t[contains(text(),"record a sample")]/../t
    wait until page contains  Sample Tuples   timeout=20s
    capture page screenshot
    click element   xpath=//button[contains(text(),"Close")]/../button
    capture page screenshot


#45
App Details - Streams details 45
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
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
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    ${get_stream_name1}  get text  xpath=//span[contains(text(),"${stream_name1}")]/../span
    ${stream_name1_str}  convert to string  ${get_stream_name1}
    ${get_stream_locality}  get text  xpath=//span[contains(text(),"${stream_locality}")]/../span
    ${stream_locality_str}  convert to string  ${get_stream_locality}
    log  ${stream_name1_str}
    log  ${stream_locality_str}

#46
App Details - Streams details - operator links 46
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${source}=  convert to string  LocationFinder
    ${sink}=  convert to string  LocationFinder
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]//a[contains(text(),"${source}")]/../a
    page should contain  ${source}
    capture page screenshot
    GO TO PAGEM   Monitor   Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[5]//a[contains(text(),"${sink}")]/../a
    page should contain  ${sink}
    capture page screenshot

#47
App Details - Streams details - Search & Sort 47
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${name_search}=  convert to string  Phone-Data
    ${locality_search}=  convert to string  AUTOMATIC
    ${source_search}=  convert to string  integer_data
    ${sinks_search}=  convert to string  data
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
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
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${time}=  convert to string  last 30 seconds
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    #click element   xpath=xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[6]/div/div[2]/div/div/select
    wait until page contains  last 5 minutes
    select from list  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[6]/div/div[2]/div/div/select   ${time}
    scroll page to location  0   2000
    page should contain  ${time}
    capture page screenshot


#49
App Details - Metric Chart details2 49
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${toggle}=  convert to string  tuplesEmittedPSMA
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    wait until page contains  ${toggle}  timeout=20s
    #click element  xpath=//t[contains(text(),"${toggle}")]/../t
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
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${toggle}=  convert to string  tuplesEmittedPSMA
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    ${num of operators}  get text   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[1]/div[1]
    ${num of operators_str}  convert to string  ${num of operators}
    ${num of operators}  get text   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[3]/div[1]/div[1]
    ${num of operators_str}  convert to string  ${num of operators}
    log  ${num of operators_str}



#52
App Details - Physical Operators - Logical Operator Name link 52
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div//a[contains(text(),"${operator_name}")]/../a
    capture page screenshot

#53
App Details - Physical Operators - Container link 53
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    capture page screenshot


#54
App Details - Physical Operators - Record a Sample (default) 54
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//t[contains(text(),"record a sample")]/../t
    wait until page contains  Sample Tuples   timeout=20s
    capture page screenshot
    click element   xpath=//button[contains(text(),"Close")]/../button
    sleep  2s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    capture page screenshot

*** comment ***
#55
App Details - Physical Operators - Record a Sample (1 window)
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${window_size}=  convert to string  record 1 window
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[1]/span[1]/span/button[2]
    wait until page contains  ${window_size}   timeout=10s
    click element  xpath=//a[contains(text(),"${window_size}")]/../a
    wait until page contains  Sample Tuples  timeout=20s
    capture page screenshot
    click element   xpath=//button[contains(text(),"Close")]/../button
    sleep  2s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    capture page screenshot


#56
App Details - Physical Operators - Record a Sample (1000 window)
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${window_size}=  convert to string  record 1000 window
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[1]/span[1]/span/button[2]
    wait until page contains  ${window_size}   timeout=10s
    click element  xpath=//a[contains(text(),"${window_size}")]/../a
    wait until page contains  Sample Tuples  timeout=20s
    capture page screenshot
    click element   xpath=//button[contains(text(),"Close")]/../button
    sleep  2s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    capture page screenshot


#57
App Details - Physical Operators - Record Sample modal details
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  LocationFinder     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//t[contains(text(),"record a sample")]/../t
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
    click element   xpath=//button[contains(text(),"Close")]/../button
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input


App Details - Physical Operators - Record Sample modal details -input operator
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//t[contains(text(),"record a sample")]/../t
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
    click element   xpath=//button[contains(text(),"Close")]/../button
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

App Details - Physical Operators - Record Sample modal details -output operator
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  LocationResult     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${operator_name}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//t[contains(text(),"record a sample")]/../t
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
    click element   xpath=//button[contains(text(),"Close")]/../button
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

*** Test Cases ***

#59
App Details - Physical Operator Details - Breadcrumb 59
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[2]/a
    wait until page contains  physical operators
    click element  xpath=//button[contains(text(),"physical operators")]/../button
    wait until page contains  ${operator_name}
    input text  xpath=//*[@id="breadcrumbs-top"]/li[4]/span/span/ul/li[2]/form/input  ${operator_name}
    click element  xpath=//a[contains(text(),"${operator_name}")]/../a
    capture page screenshot

#60
App Details - Physical Operator Details 60
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//a[contains(text(),"${operator_name}")]/../a
    page should contain  ${operator_name}
    page should contain  Logical Operator
    capture page screenshot

#62
App Details - Physical Operator Details - Navigate to container details 62
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    ${state}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[4]/span/span
    ${state_str}=  convert to string  ${state}
    ${status}=  convert to string  ACTIVE
    Run keyword unless  '${state_str}'=='${status}'  click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${current_url}  get location
    click element  xpath=//t[contains(text(),"logs")]/../t
    click element  xpath=//a[contains(text(),"dt.log")]/../a
    page should contain  dt.log
    go to  ${current_url}
    click element  xpath=//t[contains(text(),"logs")]/../t
    click element  xpath=//a[contains(text(),"stderr")]/../a
    page should contain  stderr
    go to  ${current_url}
    click element  xpath=//t[contains(text(),"logs")]/../t
    click element  xpath=//a[contains(text(),"stdout")]/../a
    page should contain  stdout
    capture page screenshot

#64
App Details - Physical Operator Details - Port details 64
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    click element  xpath=//a[contains(text(),"${port_name}")]/../a
    wait until page contains  ${port_name}   timeout=10s
    capture page screenshot
    go to  ${current_url}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"inspect")]/../span
    wait until page contains  ${port_name}   timeout=10s
    capture page screenshot


#65
App Details - Physical Operator Details - Container History - ID 65
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"   #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    #Run keyword unless  '${state_str}'=='${status}'  click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[4]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${cont_id}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset[1]/div[1]/div[1]/a
    ${cont_id_str}=  convert to string  ${cont_id}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div//a[contains(text(),"01_")]/../a
    ${status}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/fieldset/div[1]/div[1]/span/span
    ${status_str}=  convert to string  ${status}
    run keyword if  '${status_str}'=='ACTIVE'  page should contain  ${cont_id_str}
    capture page screenshot


#66
App Details - Physical Operator Details - Container History - logs 66
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[2]/a
    wait until page contains  Ports  timeout=10s
    ${current_url}  get location
    ${y}  get vertical position  xpath=//t[contains(text(),"logs")]/../t
    ${y_str}=  convert to string  ${y}
    scroll page to location  0   ${y_str}
    capture page screenshot
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]//t[contains(text(),"logs")]/../t
    wait until page contains  dt.log
    click element  xpath=/html/body/ul/li[1]/a
    page should contain  dt.log
    go to  ${current_url}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]//t[contains(text(),"logs")]/../t
    wait until page contains  stderr
    click element  xpath=/html/body/ul/li[2]/a
    page should contain  stderr
    go to  ${current_url}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]//t[contains(text(),"logs")]/../t
    wait until page contains  stdout
    click element  xpath=/html/body/ul/li[3]/a
    page should contain  stdout
    capture page screenshot


#67
App Details - Physical Operator Details - Search operator properties 67
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${input}=  convert to string  class
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  0001
    page should contain  ACTIVE
    page should contain  AppMaster
    capture page screenshot
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input


#71
App Details - Containers - operators link 71
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]//a[contains(text(),"${operator_name}")]/../a
    page should contain  ${operator_name}
    page should contain  Physical
    capture page screenshot

#72
App Details - Containers - Single Container options 72
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//t[contains(text(),"retrieve killed")]/../t
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  act
    click element  xpath=//t[contains(text(),"select active")]/../t
    checkbox should be selected   xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[1]/td[1]/input
    capture page screen shot
    click element  xpath=//t[contains(text(),"deselect all")]/../t
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input

#75
App Details - Containers - select all active but app master 75
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//t[contains(text(),"select all active but app master")]/../t
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  act
    checkbox should be selected  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[1]/input
    capture page screenshot
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  0001
    checkbox should not be selected  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    capture page screenshot
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input
    click element  xpath=//t[contains(text(),"deselect all")]/../t


#76
App Details - Containers - retrieve killed 76
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//t[contains(text(),"retrieve killed")]/../t

#77
App Details - Containers - AppMaster logs 77
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    click element  xpath=//a[contains(text(),"0001")]/../a
    wait until page contains  ACTIVE
    ${current_url}  get location
    click element  xpath=//t[contains(text(),"logs")]/../t
    wait until page contains  dt.log
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[1]/a
    page should contain  AppMaster.stderr
    go to  ${current_url}
    click element  xpath=//t[contains(text(),"logs")]/../t
    wait until page contains  stderr
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[2]/a
    page should contain  AppMaster.stdout
    go to  ${current_url}
    click element  xpath=//t[contains(text(),"logs")]/../t
    wait until page contains  stdout
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[3]/a
    page should contain  dt.log
    capture page screenshot

#78
App Details - Containers - logs 78
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    wait until page contains  AppMaster
    ${operator_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a
    ${operator_id}=  convert to string   ${operator_id}
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]//a[contains(text(),"${operator_id}")]/../a
    ${current_url}  get location
    click element  xpath=//t[contains(text(),"logs")]/../t
    wait until page contains  dt.log
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[1]/a
    page should contain  dt.log
    go to  ${current_url}
    click element  xpath=//t[contains(text(),"logs")]/../t
    wait until page contains  stderr
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[2]/a
    page should contain  stderr
    go to  ${current_url}
    click element  xpath=//t[contains(text(),"logs")]/../t
    wait until page contains  stdout
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/div/h2/span/ul/li[3]/a
    page should contain  stdout
    capture page screenshot

#79
App Details - Containers - AppMaster stackTrace 79
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_id}=  convert to string  00001     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${operator_id}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"stackTrace")]/../span
    page should contain  Stack Trace
    page should contain  ${operator_id}
    capture page screenshot
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input

#80
App Details - Containers - stackTrace 80
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    wait until page contains  AppMaster
    ${operator_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a
    ${operator_id}=  convert to string   ${operator_id}
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${operator_id}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"stackTrace")]/../span
    page should contain  Stack Trace
    page should contain  ${operator_id}
    capture page screenshot
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input


#58
App Details - Physical Operators - inspect 58
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    wait until page contains  AppMaster
    ${operator_id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[2]/td[2]/a
    ${operator_id}=  convert to string  ${operator_id}     #Make sure only two spaces after "string"
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input  ${operator_id}
    select checkbox  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr/td[1]/input
    click element  xpath=//span[contains(text(),"inspect")]/../span
    page should contain  ${operator_id}
    capture page screenshot
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
    wait until page contains  ACTIVE  timeout=20s
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input
    capture page screenshot

#70
App Details - Containers - Search & Sort 70
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  QueryLocation     #Make sure only two spaces after "string"
    ${id-1}  convert to string  2
    ${status}  convert to string  ACT
    #${process_id}  convert to string  1
    ${last heart beat}  convert to string  1
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[2]//a[contains(text(),"${id-1}")]/../a
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${process_id}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[3]//span[contains(text(),"${process_id}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input  ${host}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[4]//span[contains(text(),"${host}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input  ${alloc_mem}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[6]//span[contains(text(),"${alloc_mem}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input  ${free_mem}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[7]//span[contains(text(),"${free_mem}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[8]/input  ${operator_name}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[8]//a[contains(text(),"${operator_name}")]/../a
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[8]/input

    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input  ${status}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[9]//span[contains(text(),"${status}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[3]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[9]/input


#51
App Details - Physical Operators - Search & Sort 51
    ${app_name}=  convert to string  MobileDemo         #Make sure only two spaces after "string"
    ${id-1}  convert to string  2
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//span[contains(text(),"physical")]/../span
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
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//a[contains(text(),"${id-1}")]/../a
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[2]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input  ${name}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[3]//a[contains(text(),"${name}")]/../a
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[3]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input  ${status}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[4]//span[contains(text(),"${status}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[4]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[5]/input  ${processed/s}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[5]//span[contains(text(),"${processed/s}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[5]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input  ${emitted/s}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[6]//span[contains(text(),"${emitted/s}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[6]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input  ${cpu%}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[7]//span[contains(text(),"${cpu%}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[7]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[10]/input  ${failure}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[10]//span[contains(text(),"${failure}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[10]/input
    #input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[11]/input  ${last heart beat}
    #${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[11]//span[contains(text(),"${last heart beat}")]/../span
    #clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[11]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[12]/input  ${host}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[12]//span[contains(text(),"${host}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[12]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[14]/input  ${latency}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[14]//span[contains(text(),"${latency}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[14]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[15]/input  ${total processed}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[15]//span[contains(text(),"${total processed}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[15]/input
    input text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[16]/input  ${total emitted}
    ${x}  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/div/table/tbody[3]//tr[contains(text(),*)]/td[16]//span[contains(text(),"${total emitted}")]/../span
    clear element text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[2]/td[16]/input
    capture page screenshot

#36
App Details - Logical Operators - Search & Sort
    ${app_name}=  convert to string  MobileDemo        #Make sure only two spaces after "string"
    ${operator_name}=  convert to string  Receiver     #Make sure only two spaces after "string"
    GO TO PAGEM  Monitor  Cluster Overview
    wait until page contains   ${app_name}  timeout=20s
    click element  xpath=//a[contains(text(),"${app_name}")]/../a
    wait until page contains   ${app_name}  timeout=20s
    wait until page contains  RUNNING  timeout=20s
    click element  xpath=//span[contains(text(),"logical")]/../span
    wait until page contains   ${operator_name}  timeout=20s
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

    #latency
     #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[2]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[3]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[9]/span[1]
    sleep  1s
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted} =  create list
    ${ids_sorted} =  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[9]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[9]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #status
    LOG  status
    #click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[2]/span[1]
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[10]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[10]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list  ${ids}
    sort list  ${ids_sorted}
    LOG  SORTED
    Lists Should Be Equal  ${ids_sorted}  ${ids}
    ${ids_reverse}=  create list
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[10]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[10]
    \    ${id_str}=  convert to string  ${id}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}

    #processed
    log  processed
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[11]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[11]
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[11]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[11]
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[12]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[12]
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[12]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[12]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[13]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[13]
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[13]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[13]
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[14]/span[1]
    sleep  1s
    ${ids}=  create list
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[14]
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
    click element  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/table/thead/tr[1]/th[14]/span[1]
    sleep  1s
    reverse list  ${ids_sorted}
    : FOR    ${INDEX}    IN RANGE    1    ${count_str}+1
    \    Log    ${INDEX}
    \    ${id}=  get text  xpath=/html/body/div[2]/div/div/div/div[2]/div/div[2]/div[4]/div/div[2]/div/div/div[2]/div/table/tbody[3]/tr[${INDEX}]/td[14]
    \    ${id_str}=  convert to string  ${id}
    \    ${id_str}  remove string  ${id_str}  ,
    \    ${id_str}=  evaluate  ${id_str}
    \    append to list  ${ids_reverse}  ${id_str}
    ${ids_sorted}=  create list
    ${ids_sorted}=  copy list   ${ids_reverse}
    sort list  ${ids_sorted}
    reverse list  ${ids_sorted}
    Lists Should Be Equal  ${ids_sorted}  ${ids_reverse}