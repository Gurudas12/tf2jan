*** Settings ***
Suite Setup       SetupBrowsingEnv_DT_Configure
Suite Teardown    DestroyBrowsingEnv_DT_Configure
Resource          ../../../lib/web/WebLib.txt
Resource          ../../../lib/web/Ingestion/Ingestion_Config_UI.txt
Library           Selenium2Library


*** Variables ***
${url}            http://plaban-lenovo:9090/
${app_pkg_loc}    /home/plaban/tf2jan/apa/pi-demo-3.4.0.apa
${dt_version}     3.8.0
${apex_version}    3.6.0

#***Variables for Shubham Test Cases***
#${url}            http://192.168.2.165:9090/
#${app_pkg_loc}    /home/shubham/tf2jan/apa/Pi-demo-3.4.0.apa
#${dt_version}   3.8.0
#${apex_version}    3.6.0
#${username}    shubham
#${license_path}  /home/shubham/anon-20170120070341-nhbdmwda


*** Test Cases ***
##########################################################################
#                                                                        #
#\\\------------------------Assigned-Test-Cases-----------------------///#
#                                                                        #
##########################################################################
#----------------------#
##System_Configuration##
#______________________#
Configure_SMTP      #Test no. 0                            #PASSED      #Run only once
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']             #goto Configure -> System Configuration
    Wait Until Page Contains    Gateway Information
    ${Status}=      Run Keyword And Return Status   Page Should Contain Element     xpath=//TD[@colspan='2'][text()='Not configured']          #Check if SMTP is already configured
    Run Keyword If   '${Status'=='False'     Fail       SMTP has already been configured!           #Delibrate failure if SMTP already is configured
    Click Button    xpath=(//BUTTON[@class='btn btn-success'])[2]
    Wait Until Page Contains        Required fields
    Input Text      xpath=(//INPUT[@type='text'])[1]        localhost       #Server field
    Input Text      xpath=//INPUT[@type='number']           25              #Port field
    Input Text      xpath=(//INPUT[@type='text'])[4]        testings@datatorrent.com      #email field
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success ng-binding']             #Save Button
    Click Button    xpath=//BUTTON[@class='btn btn-success ng-binding']        #Save Button
    Wait Until Page Does Not Contain        Required fields
    [Teardown]  Close Browser


Navigate_to_System_Configuration        #Test no. 1                            #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']             #goto Configure -> System Configuration
    #Below Are list of expected text to be found on the page as per the test case
    Wait Until Page Contains    Gateway Information
    Page Should Contain     System Configuration
    Page Should Contain     Gateway Information
    Page Should Contain     Hadoop Information
    Page Should Contain     System Properties
    Page Should Contain     SMTP Configuration
    Page Should Contain     App Data Tracker
    Page Should Contain     Usage Reporting
    Capture Page Screenshot
    [Teardown]  Close Browser

Restart_Gateway                         #Test no. 2                             #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     Gateway Information
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='restart the gateway']          #Click button to restart gateway
    Wait Until Page Contains     Are you sure you want to restart the gateway?  #Verifies the Popup Window
    Click Element       xpath=//button[text()='Yes, restart the gateway']
    Page Should Contain     restarting the gateway...
    Wait Until Page Contains     Gateway successfully restarted!
    Capture Page Screenshot
    [Teardown]    Close Browser


Check_Gateway_Information               #Test no. 3                             #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     Gateway Information
    Read Table      xpath=(//TABLE[@class='simple table'])[1]                   #Reads the Gateway information table and displays the table in log
    Capture Page Screenshot
    [Teardown]    Close Browser

Check_Hadoop_Information                #Test no. 4                             #PASSED
   Connect_To_DT_Console    ${url}
   Go_To_Page      Configure       System Configuration                         #goto home -> Configure
   Click Element        xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
   Wait Until Page Contains     Hadoop Information
   Read Table       xpath=(//TABLE[@class='simple table'])[2]                   #Reads the Hadoop information table and displays the table in log

   [Teardown]    Close Browser

Check_System_Properties                 #Test no. 5                             #PASSED
   Connect_To_DT_Console    ${url}
   Go_To_Page      Configure       System Configuration                         #goto home -> Configure
   Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
   Wait Until Page Contains     System Properties
   Read Table Search Type         xpath=//DIV[@class='mlhr-rows-table-wrapper']/table       #Read table which can be searched and copy in log
   Capture Page Screenshot
   [Teardown]    Close Browser

Change_System_Property                  #Test no. 6                             #PASSED     #in suite setup make changes accordingly for 3.7.0 beforehand
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties                              #Confirmation of correct navigation
    ${Property_Name}        Set Variable        dt.version
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Property_Name}
    Wait Until Page Does Not Contain        dt.loggers.level
    Click Element       xpath=//SPAN[@class='btn btn-xs btn-danger ng-scope'][text()='change']
    Wait Until Page Contains        Change System Property
    Input Text      xpath=//TEXTAREA[@msd-elastic='']       3.8.0-SNAPSHOT
    Wait Until Element is Enabled       xpath=//BUTTON[@class='btn ng-binding btn-danger']
    Click Element       xpath=//BUTTON[@class='btn ng-binding btn-danger']
    Table Should Contain        xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     dt.version
    Table Should Contain        xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3.8.0      #search for updated version in table
    Capture page screenshot
    [Teardown]    Close Browser

Delete_System_Property                 #Test no. 7                              #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    ${Property_Name}        Set Variable        dt.version
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Property_Name}    #input of property name to be deleted
    Wait Until Page Does Not Contain        dt.loggers.level                    #check that will determine dt.loggers and any other item is not displayed after search
    Click Element       xpath=//SPAN[@class='btn btn-xs btn-danger ng-scope'][text()='delete']      #Click on delete button
    Wait Until Page Contains        Delete System Property                      #Delete Confirmation Page
    Click Element       xpath=//BUTTON[@class='btn btn-danger ng-binding ng-scope']         #Button to confirm Delete operation
    Wait Until Page Does Not Contain        Delete System Property                      #Delete Confirmation Page
    ${Status}       Run Keyword And Return Status       	Table Should Contain        xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     dt.version          #Search for property in Table
    Run Keyword If      ${Status}=='False'      Comment     Property Successfully Deleted        #Confirmation of Deletion of property - dt.version
    Capture Page Screenshot
    ${Status}       Run Keyword And Return Status       	Table Should Contain        xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3.8.0               #search for updated version in table
    Run Keyword If      ${Status}=='False'      Comment     Value Successfully Deleted        #Confiramtion of Deletion of value - 3.8.0
    Capture Page Screenshot
    Clear Element Text      xpath=(//INPUT[@type='text'])[1]
    [Teardown]    Close Browser

Add_System_Property                       #Test no. 8                           #PASSED  #Should run delete first
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    Click Button        xpath=//BUTTON[@class='btn btn-success']                #Click on 'Add System Property'
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. incomplete fields
    ${Property_Name}        Set Variable        dt.version                                      #Adding Property Name of dt.version
    Input Text      xpath=//INPUT[@id='propName']        ${Property_Name}
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    Input Text      xpath=//TEXTAREA[@msd-elastic='']        3.8.0                              #Adding Property Value
    Element Should Be Enabled         xpath=//BUTTON[@class='btn ng-binding btn-success']       #Check for Save Button which should be enabled in this situation i.e. both text fields are filled and valid
    Click Button        xpath=//BUTTON[@class='btn ng-binding btn-success']                     #Click the save Button if element is visible`
    Table Should Contain        xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     dt.version          #Search for property in Table
    Table Should Contain        xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3.8.0      #search for updated version in table
    Capture Page Screenshot
    [Teardown]      Close Browser

Add_System_Property_no_key_and_value        #Test no. 9                         #PASSED       #check for visibility seperate for no key and value in one test case
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    Click Button        xpath=//BUTTON[@class='btn btn-success']                #Click on 'Add System Property'

    #Check-1 Verifies that if both the text fields are empty then save button should be disabled
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    #Entering here should confirm the Check-1 is successfully completed

    #Check-2 For Single text box fill i.e. only Property Name
    Input Text      xpath=//*[@id="propName"]       dt.version
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    #Entering here should confirm the Check-2 is successfully completed

    Clear Element Text      xpath=//*[@id="propName"]                           #Removing of text from Property Name text box for next step of test

    #Check-3 For Single text box fill i.e. only Property Value
    Input Text      xpath=//TEXTAREA[@msd-elastic='']        3.8.0-SNAPSHOT     #Adding Property Value Only
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    #Entering here should confirm the Check-3 is successfully completed

    Sleep       2s
    Capture Page Screenshot
    [Teardown]      Close Browser


Add_Already_Existing_System_Property        #Test no. 10                        #PASSED     #Check for unique property name (Redundant Property name)
    
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    Click Button        xpath=//BUTTON[@class='btn btn-success']                #Click on 'Add System Property'
    Input Text      xpath=//*[@id="propName"]       dt.version                  #Redundant property name
    Page Should Contain      Property already exists with the same name.        #Check For Redundant Name
    Element Should Be Disabled      xpath=//BUTTON[@class='btn ng-binding btn-success']         #Check for Save Button which should be disabled in this situation i.e. an incomplete field or invalid name field
    Capture Page Screenshot
    [Teardown]      Close Browser


Check_Transient_System_Property_Info        #Test no. 11                        #PASSED
    
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties
    ${Property_Name}        Set Variable        dt.loggers.level
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Property_Name}    #Transient Property Search
    Wait Until Page Does Not Contain        dt.version                          #Check for only dt.loggers.level is present
    Mouse Over      xpath=//I[@ng-if='!row.canSet']                             #Hover over the transient property (i) symbol
    Sleep       1s                                                              #Sleep for 1 second so that popup appears
    Capture Page Screenshot
    ${Popup_Content}=    Get Element Attribute     css=.tooltip@content
    Log     ${Popup_Content}
    [Teardown]      Close Browser


Sort_The_Columns_property_and_value           #Test no. 12                      #PASSED
    
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                        #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']              #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties

    #Check-1: Sort_By_Property
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-1.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[1]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Properties: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-1.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[1]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}       msg=Properties: Descending Sort Working Unsuccessful
    Capture Page Screenshot

    #Check-2: Values
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-1.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}     msg=Values: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-1.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}    msg=Values: Descending Sort Working Unsuccessful
    Capture Page Screenshot

    [Teardown]      Close Browser


Search_The_Columns_property_and_value         #Test no. 13                       #PASSED
    
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     System Properties

    #Check-1: Property Search
    ${Test_Term}        Set Variable       dt.
    Input Text      xpath=(//INPUT[@type='text'])[1]        ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1           #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=False
    Should Be Equal As Integers     ${Check_Success}    ${Count}      #Log     Property: Search Test Successful

    Clear Element Text      xpath=(//INPUT[@type='text'])[1]                     #Clear text area for check for value

    #Check-2: Value Search
    ${Test_Term}        Set Variable       datatorrent
    Input Text      xpath=(//INPUT[@type='text'])[2]        ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2          #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=False
    Should Be Equal As Integers     ${Check_Success}    ${Count}     ${Check_Success}    ${Count}      #Log     Value: Search Test Successful

    Clear Element Text      xpath=(//INPUT[@type='text'])[1]                     #Clear text area for check for value

    Capture Page Screenshot
    [Teardown]      Close Browser


App_Data_Tracker_Enable                        #Test no. 14                      #PASSED        #App Data Tracker should be Disabled before hand Guide in Suite
    
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     App Data Tracker                                #Check if App data tracker is present
    Click Button        xpath=//BUTTON[@class='btn btn-info']                    #Click on 'Enable App Data Tracker' to enable it and a popup should be displayed for confirmation
    Page Should Contain     Enable App Data Tracker?                             #Check/Verify if  Popup is displayed or not
    Click Element       xpath=//BUTTON[@ng-click='$close()'][text()='Enable']    #Confirmation for enabling App Data Tracker
    Wait Until Page Contains        App Data Tracker is enabled now.             #Confirmaton that App Data Tracker is Enabled Now
    Reload Page                                                                  #Refreshes the page for checking if App Data Tracker is Enabled or Not
    Wait Until Page Contains        App Data Tracker      timeout=10s
    Page Should Contain     Disable App Data Tracker                             #Final confirmation that App Data Tracker is Enabled
    [Teardown]      Close Browser

App_Data_Tracker_Change_Queue                   #Test no. 16                     #PASSED   #App Data Tracker should be enacbled before hand #Some discrepency in test cases unable to find App Data Tracker Settings which belongs to Plaban       #drop down menu encountered #should be choose a queue before hand in drop down menu and App_Data_Tracker_Should_be_running_beforehand
    
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains        App Data Tracker

    #Check-1: Default
    Select From List By Label       xpath=//SELECT[@class='form-control ng-pristine ng-untouched ng-valid']      default       #root.default for node  #//SELECT[@class='form-control ng-pristine ng-untouched ng-valid']//SELECT[@class='form-control ng-valid ng-dirty ng-valid-parse ng-touched']
    Wait Until Page Contains        Restart App Data Tracker?       timeout=10s
    Click Element      xpath=//BUTTON[@ng-click='$close()'][text()='Okay']
    Sleep       1s
    Page Should Contain     Starting App Data Tracker....                        #alert should be present-gives no alerts found
    Sleep       2s
    Wait Until Page Contains        App Data Tracker has been restarted successfully.       timeout=20s
    Focus   xpath=//H2[@dt-text=''][text()='Usage Reporting']
    Capture Page Screenshot
    Reload Page

    #Check-2: Choose A Queue
    Select From List By Label       xpath=//SELECT[@class='form-control ng-pristine ng-untouched ng-valid']       choose a queue
    Wait Until Page Contains        Restart App Data Tracker?       timeout=10s
    Click Element      xpath=//BUTTON[@ng-click='$close()'][text()='Okay']
    Sleep       1s
    Page Should Contain     Starting App Data Tracker....                        #alert should be present-gives no alerts found
    Sleep       2s
    Wait Until Page Contains        App Data Tracker has been restarted successfully.       timeout=20s
    Focus   xpath=//H2[@dt-text=''][text()='Usage Reporting']
    Capture Page Screenshot

    [Teardown]      Close Browser

App_Data_Tracker_Disable                        #Test no. 15                     #PASSED         #App Data TArcker should be Enabled before hand
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     App Data Tracker                                #Check if App data tracker is present
    Click Element       xpath=//BUTTON[@class='btn btn-danger']                  #Click on 'Disable App Data Tracker' to enable it and a popup should be displayed for confirmation
    Page Should Contain     Disable App Data Tracker?                            #Check/Verify if  Popup is displayed or not
    Click Button        xpath=//BUTTON[@ng-click='$close()'][text()='Disable']   #Confirmation for disabling App Data Tracker
    #Wait Until Page Contains        App Data Tracker is disabled.     timeout=10s    #Confirmaton that App Data Tracker is Disabled Now
    Reload Page                                                                  #Refreshes the page for checking if App Data Tracker is Disabled or Not
    Wait Until Page Contains        App Data Tracker      timeout=10s
    Page Should Contain     Enable App Data Tracker                              #Final confirmation that App Data Tracker is Disabled
    [Teardown]      Close Browser

Usage_Reporting_Disable                         #Test no. 17                     #PASSED #Should be enabled before      #Confirm in guide
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     Usage Reporting
    Click Button       xpath=//BUTTON[@class='btn btn-danger ng-binding']        #Click on 'Disable App Data Tracker' Button
    Wait Until Page Contains        This action will restart the gateway. Are you sure you want to proceed?         #Display of Popup
    Click Button       xpath=//BUTTON[@class='btn btn-danger ng-binding'][text()='Disable']                         #Confirmation of Gateway restart
    Wait Until Page Contains        restarting the gateway...                    #Confirmation of above action
    Wait Until Page Contains        Gateway successfully restarted!              #Confirmation that Gateway restarted
    Sleep       5s
    Reload Page                                                                  #To view the Changed state
    Wait Until Page Contains        Usage Reporting    timeout=10s
    Page Should Contain     Enable Reporting                                     #Confirmation of Succesful Test Run
    [Teardown]      Close Browser


Usage_Reporting_Enable                          #Test no. 18                     #PASSED     #Should be disabled before
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Configuration                         #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Configuration']               #goto Configure -> System Configuration
    Wait Until Page Contains     Usage Reporting
    Click Button        xpath=//BUTTON[@class='btn btn-danger ng-binding']       #Click on 'Enable App Data Tracker' Button
    Wait Until Page Contains        This action will restart the gateway. Are you sure you want to proceed?     #Display of Popup
    Click Button        xpath=//BUTTON[@class='btn btn-danger ng-binding'][text()='Enable']                     #Confirmation of Gateway restart
    Wait Until Page Contains        restarting the gateway...                    #Confirmation of above action
    Wait Until Page Contains        Gateway restarted                            #Confirmation that Gateway restarted
    Sleep       5s                                                               #Sleep for allowing gateway to restart
    Reload Page                                                                  #Refreshes the page for Change in text of button
    Wait Until Page Contains        Usage Reporting       timeout=10s
    Page Should Contain     Disable Reporting                                    #Confirmation of Successful test run
    [Teardown]      Close Browser



#----------------------------#
#***Security Configuration***#
#____________________________#

Navigate_to_Security_Configuration                #Test no. 19                   #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='Security Configuration']        #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    Click Element     xpath=//I[@class='caret pull-right']                       #Click on drop down menu for display
    Sleep       2s                                                               #Wait for Drop down to appear
    Capture Page Screenshot
                                                        #Screenshot confirmation for Drop Down
    [Teardown]      Close Browser


Set_Authentication_to_Password                    #Test no. 20                   #PASSED        #Should be set to None Before Hand
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='Security Configuration']                        #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Click Element    xpath=//T[@class='ng-binding ng-scope']                      #Click On Drop Down Menu
    Click Element    xpath=(//A[@href='javascript:void(0)'])[2]
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success']      #Save Button
    Click Button        xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Contains     Save Authentication
    Click Button        xpath=//BUTTON[@class='btn btn-danger']
    Page Should Contain     Authentication setting saved. Restarting the gateway.
    Wait Until Page Contains        Login       timeout=20s
    Capture Page Screenshot

    [Teardown]          Close Browser


Set_Authentication_to_None                        #Test no. 21                   #PASSED         #Should be set to Password Before Hand
    Connect To DT Console After Setting Password        dtadmin     dtadmin                      #username    #password
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='Security Configuration']                        #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Click Element       xpath=//T[@class='ng-binding ng-scope']                      #Click On Drop Down Menu
    Click Element       xpath=(//A[@href='javascript:void(0)'])[1]
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success']
    Click Button        xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Contains     Save Authentication
    Click Button        xpath=//BUTTON[@class='btn btn-danger']
    Page Should Contain     Authentication setting saved. Restarting the gateway.
    Wait Until Page Contains        Security features disabled.      timeout=20s
    Capture Page Screenshot

    [Teardown]          Close All Browsers


Set_Authentication_to_Existing_Option             #Test no. 22          #PASSED
    Open Browser        ${url}      CHROME
    ${Status}=      Run Keyword And Return Status       Page Should Contain     Login
    Run Keyword If      '${Status}'=='True'     Connect To DT Console After Setting Password        dtadmin     dtadmin
    ...     ELSE    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='Security Configuration']          #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    ${Authentication_Type}      Get Text    xpath=//SPAN[@tabindex='-1']
    Click Element       xpath=//T[@class='ng-binding ng-scope']
    Run Keyword If      '${Authentication_Type}'=='None'    Click Element   xpath=(//A[@href='javascript:void(0)'])[1]
    Run Keyword If      '${Authentication_Type}'=='Password'    Click Element   xpath=(//A[@href='javascript:void(0)'])[2]
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot

    [Teardown]          Close All Browsers


Cancel_Security_Configuration                      #Test no. 23           #PASSED
    Open Browser        ${url}      CHROME
    ${Status}=      Run Keyword And Return Status       Page Should Contain     Login
    Run Keyword If      '${Status}'=='True'     Connect To DT Console After Setting Password        dtadmin     dtadmin
    ...     ELSE    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       Security Configuration                       #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='Security Configuration']        #Navigate to Security Configuration
    Wait Until Page Contains        Secure mode can be enabled by selecting an Authentication                   #Confirmation of successfull navigation
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    ${Authentication_Type}      Get Text    xpath=//SPAN[@tabindex='-1']
    Click Element       xpath=//T[@class='ng-binding ng-scope']
    Run Keyword If      '${Authentication_Type}'=='None'    Click Element   xpath=(//A[@href='javascript:void(0)'])[2]
    Run Keyword If      '${Authentication_Type}'=='Password'    Click Element   xpath=(//A[@href='javascript:void(0)'])[1]
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success']
    Click Button        xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Contains     Save Authentication
    Click Button        xpath=//BUTTON[@class='btn btn-default']
    Run Keyword If      '${Authentication_Type}'=='None'    Page Should Contain     DataTorrent RTS native authentication management solution.
    Run Keyword If      '${Authentication_Type}'=='Password'    Page Should Contain     No authentication.
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot

    [Teardown]          Close All Browsers


#-------------------------------------------#
#***Security Alerts Management and History***
#___________________________________________#

Navigate_to_System_Alerts_Management                #Test no. 24                  #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Capture Page Screenshot
    [Teardown]          Close Browser

Systems_Alert_Management_History_Link               #Test no. 25                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain     System Alerts History                                #Confirmation of successful navigation to System Alerts Page
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Click on System Alerts History Link
    Page Should Contain     configure system alerts on the management page.         #Confirmation of successful navigation to System Alerts History Page-New Version
    #Page Should Contain     Below are the occurrences of triggered alerts.       #Confirmation of successful navigation to System Alerts History Page-Old Version
    Capture Page Screenshot
    [Teardown]          Close Browser

Create_New_Alert                                    #Test no. 26                 #PASSED #if empty then no alerts found # Add in suite setup
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Button        xpath=//BUTTON[@ng-click='createAlert(users, roles)']    #Click on 'create new alert'
    Wait Until Page Contains        Required fields                              #Confirmation that 'New Alert' popup window is encountered
    Input Text      xpath=(//INPUT[@type='text'])[1]        Test_Case_6
    Input Text      xpath=(//INPUT[@type='text'])[2]        xyz@datatorrent.com
    Input Text      xpath=//INPUT[@type='number']           6000
    #Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       Test_Case_6        #Old-Version for Java Script

    #For Javascript tab option in new RTS #Error - User Ineditable error
    #Click Element       xpath=//A[@href=''][text()='Javascript Code']
    #Click Element       xpath=//PRE[@class=' CodeMirror-line ']
    #Input Text      xpath=//PRE[@class=' CodeMirror-line ']       Test_Case_6();

    #For Pre-Defined Conditions in new RTS
    Click Element       xpath=//A[@href=''][text()='Predefined Conditions']         #Click On Predefined Conditions
    Click Element       xpath=//SPAN[@tabindex='-1']                                #Click On Drop Dowm Menu
    Click Element       xpath=(//A[@href='javascript:void(0)'])[5]                  #For Active Containers Count
    Wait Until Page Contains        Alert when the total number of active containers in the cluster matches the specified criteria.
    Select From List By Label       xpath=//SELECT[@ng-if='param.values']           greater than
    Input Text      xpath=//INPUT[@ng-if='!param.values']       3


    Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.description']     Created_New_Alert_Test_Case_Running_Test_6
    Click Element       xpath=//LABEL[@for='statusEnabled'][text()='Enabled']      #For New Version
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot
    Click Element       xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot
    Wait Until Page Does Not Contain       Required fields
    Page Should Contain     Test_Case
    [Teardown]          Close Browser

Create_New_Alert_Negative                           #Test no. 27                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Button        xpath=//BUTTON[@ng-click='createAlert(users, roles)']    #Click on 'create new alert'
    Wait Until Page Contains        Required fields                              #Confirmation that 'New Alert' popup window is encountered
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']     #Confirmation that the 'Save' button is disabled

    #Check-1: Invalid Name (already existing name and empty field)
    ##Check-1.1:Already Existing Name
    Input Text      xpath=(//INPUT[@type='text'])[1]        Test_Case_1          #Check for Already Existing Name
    Page Should Contain     This alert name already exists.                      #Confirmation success of Check-1.1
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot
    ##Check-1.2:Empty Field Check
    Clear Element Text      xpath=(//INPUT[@type='text'])[1]                     #Check for Empty Field
    Page Should Contain     Please enter a name for this alert.                  #Confirmation success of Check-1.2
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot

    #Check-2: Invalid Email
    ##Check-2.1:Wrong Email text
    Input Text      xpath=(//INPUT[@type='text'])[2]            datatorrent      #Check for validity for e-mail
    Page Should Contain     Invalid email address.                               #Confirmation of success of Check-2.1
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot
    ##Check-2.2:Empty Field Check
    Clear Element Text      xpath=(//INPUT[@type='text'])[2]                     #Check for Empty Field
    Page Should Contain     Please enter an email for this alert.                #Confirmaton of Check-2.2
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot

    #Check-3: Invalid Threshold
    ##Check-3.1:Only Numeric Characters Check
    Input Text      xpath=//INPUT[@type='number']       abc                      #Enters alphabets to check for Numeric input(only numeric characters appear on on text field)
    ${Character_Check}      Get Text        xpath=//INPUT[@type='number']        #Gets the text from text box
    Should Not Be Equal     ${Character_Check}      abc                          #Confirms Check-3.1 if passed
    Capture Page Screenshot
    ##Check-3.2:Empty Field Check
    Clear Element Text      xpath=//INPUT[@type='number']                        #Check for empty field
    Page Should Contain     Please enter the threshold for this alert.           #Confirmation of Check-3.2
    Element Should Be Disabled       xpath=//BUTTON[@class='btn btn-success']    #Check if 'Create' is disabled
    Capture Page Screenshot

    #Check-4: Invalid condition     #Old RTS
    #Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       ABC
    #Clear Element Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']    #Check for empty field
    #Page Should Contain     Please enter a valid Javascript express for this alert.  #Confirmation for check-4
    #Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']         #Check if 'Create' is disabled
    #Capture Page Screenshot

    [Teardown]      Close Browser

Create_New_Alert_Condition_Link                     #Test no. 28                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Button        xpath=//BUTTON[@ng-click='createAlert(users, roles)']    #Click on 'create new alert'
    Wait Until Page Contains        Required fields                              #Confirmation that 'New Alert' popup window is encountered
    Sleep  2s
    Click Link      Click here                                                   #System Alerts Documentation
    #Check_for_new_browser_window_here
    Select Window   Title=dtGateway - DataTorrent Documentation                  #Switch Browser tab
    Page Should Contain     Rest API                                             #Confirmation of Successful Switch
    Capture Page Screenshot
    [Teardown]      Close All Browsers

Systems_Alerts_Management_Search                    #Test no. 29                 #Revise Suite Setup #PASS     #should make test_alerts_beforehand with varied fields Test_Case_1, Test_Case_2, Test_Case_3 etc created before in suite setup
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page

    #Check-1: Search_By_Name
    #page should not contain            Test_Case_2                              #other test cases names - Test_Case_1,Test_Case_2,Test_Case_3 etc.
    ${Test_Term}        Set Variable       Test_Case
    Input Text     xpath=(//INPUT[@type='text'])[2]       ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[2]


    #Check-2: Search_By_E-mail
    ${Test_Term}        Set Variable       abc
    Input Text     xpath=(//INPUT[@type='text'])[3]       ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[3]


    #Check-3: Search_By_Threshold
    ${Test_Term}        Set Variable       4000
    Input Text     xpath=(//INPUT[@type='text'])[5]       ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[5]

    #Check-4: Search_By_Condition
    ${Test_Term}        Set Variable       Alert when
    Input Text     xpath=(//INPUT[@type='text'])[6]       ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     6              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[6]


    #Check-5: Search_By_Message     (Owner for New RTS)
    ${Test_Term}        Set Variable       Running_Test
    Input Text     xpath=(//INPUT[@type='text'])[4]       ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}

    Clear Element Text      xpath=(//INPUT[@type='text'])[4]
    Capture Page Screenshot

    [Teardown]      Close Browser


System_Alerts_Management_Sort                       #Test no. 30                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
    Page Should Contain  System Alerts Management


    #Check-1: Sort_By_Name
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-1.1: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}    ${RHS_Click_Sort}       msg=Name: Descending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-1.2: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Name: Ascending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-2: Sort_By_Email
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-2.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[3]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=E-Mail: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-2.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[3]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}    ${RHS_Click_Sort}       msg=E-Mail: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-3: Sort_By_Threshold
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-3.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[5]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Threshold: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-3.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[5]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}    ${RHS_Click_Sort}       msg=Threshold: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-4: Sort_By_Condition     #Condition too long to be able to Sort instead sort for Owner
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     7    Sorted                 #7 for owner
    ${LHS_Function_Sort_Descending}     Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     7    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-4.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[7]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     7    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Condition: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-4.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[7]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     7    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}    ${RHS_Click_Sort}       msg=Condition: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-5: Sort_By_Message  #Owner For New RTS Version
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-5.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[4]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Owner: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-5.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[4]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}    ${RHS_Click_Sort}       msg=Owner: Descending Sort Working Unsuccessful
    Capture Page Screenshot

    [Teardown]      Close Browser


Change_Existing_Alert                       #Test No. 31                #PASSED            #check existing using search
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
    Page Should Contain  System Alerts Management

    #Check-1: Change Name
    ${Old_Test_Term}        Set Variable       Test_Case_6
    ${New_Test_Term}        Set Variable       Test_Case_7
    ${Count}        ${List}        Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2
    ${Count_Before}=       Get Match Count     ${List}     *${New_Test_Term}*
    Clear Element Text      xpath=(//INPUT[@type='text'])[2]
    Input Text     xpath=(//INPUT[@type='text'])[2]       ${Old_Test_Term}      #Search_by_test_case since name is unique therefore only one result
    Click Element          xpath=//SPAN[@class='btn btn-xs btn-info ng-scope'][text()='change']
    Wait Until Page Contains        Required fields
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Clear Element Text      xpath=(//INPUT[@type='text'])[1]
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Input Text      xpath=(//INPUT[@type='text'])[1]       ${New_Test_Term}
    Element Should Be Enabled      xpath=//BUTTON[@class='btn btn-success']
    Click Element       xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Does Not Contain        Required fields
    Input Text      xpath=(//INPUT[@type='text'])[2]            ${New_Test_Term}         #check for authenticity
    ${Count}    ${List}         Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2
    ${Count_After}=       Get Match Count     ${List}     *${New_Test_Term}*
    Should Be Equal As Integers     ${Count_After}        1                #Since unique
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[2]

    #Check-2: Change E-Mail
    ${Old_Test_Term}        Set Variable       abc@datatorrent.com
    ${New_Test_Term}        Set Variable       xyz@datatorrent.com
    ${Count}        ${List}        Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3
    ${Count_Before}=       Get Match Count     ${List}     *${New_Test_Term}*
    Input Text     xpath=(//INPUT[@type='text'])[3]       ${Old_Test_Term}      #Search_by_test_case since name is unique therefore only one result
    Click Element          xpath=//SPAN[@class='btn btn-xs btn-info ng-scope'][text()='change']
    Wait Until Page Contains        Required fields
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Clear Element Text      xpath=(//INPUT[@type='text'])[2]
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Sleep  1s
    Input Text      xpath=(//INPUT[@type='text'])[2]       ${New_Test_Term}
    Element Should Be Enabled      xpath=//BUTTON[@class='btn btn-success']
    Click Element       xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Does Not Contain        Required fields
    Input Text      xpath=(//INPUT[@type='text'])[3]            ${New_Test_Term}         #check for authenticity
    ${Count}    ${List}         Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3
    ${Count_After}=       Get Match Count     ${List}     *${New_Test_Term}*
    Should Be Equal As Integers     ${Count_Before}        ${${Count_After}-1}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[3]

    #Check-3: Change Threshold
    ${Old_Test_Term}        Set Variable       5000
    ${New_Test_Term}        Set Variable       4000
    ${Count}        ${List}        Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5
    ${Count_Before}=       Get Match Count     ${List}     *${New_Test_Term}*
    Input Text     xpath=(//INPUT[@type='text'])[5]       ${Old_Test_Term}      #Search_by_test_case since name is unique therefore only one result
    Click Element          xpath=//SPAN[@class='btn btn-xs btn-info ng-scope'][text()='change']
    Wait Until Page Contains        Required fields
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Clear Element Text      xpath=//INPUT[@type='number']
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Sleep  1s
    Input Text      xpath=//INPUT[@type='number']       ${New_Test_Term}
    Element Should Be Enabled      xpath=//BUTTON[@class='btn btn-success']
    Click Element       xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Does Not Contain        Required fields
    Input Text      xpath=(//INPUT[@type='text'])[5]            ${New_Test_Term}         #check for authenticity
    ${Count}    ${List}         Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5
    ${Count_After}=       Get Match Count     ${List}     *${New_Test_Term}*
    Should Be Equal As Integers     ${Count_Before}        ${${Count_After}-1}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[5]

    #Check-4: Condition
    ${Old_Test_Term}        Set Variable       Test_Case_6
    ${New_Test_Term}        Set Variable       Test_Case_7
    ${Count}        ${List}        Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     6
    ${Count_Before}=       Get Match Count     ${List}     *${New_Test_Term}*
    Input Text     xpath=(//INPUT[@type='text'])[2]       ${Old_Test_Term}      #Search_by_test_case since name is unique therefore only one result
    Click Element          xpath=//SPAN[@class='btn btn-xs btn-info ng-scope'][text()='change']
    Wait Until Page Contains        Required fields

    #For new version of RTS
    Click Element       xpath=//A[@href=''][text()='Predefined Conditions']         #Click On Predefined Conditions
    Click Element       xpath=//SPAN[@tabindex='-1']                                #Click On Drop Dowm Menu
    Click Element       xpath=(//A[@href='javascript:void(0)'])[6]                  #Click On Application Status
    Input Text          xpath=//INPUT[@ng-if='!param.values']       PiDemo                       #Input Name of Application
    Select From List By Label       xpath=//SELECT[@ng-if='param.values']       RUNNING     #Select status as RUNNING
    Sleep   1s
    Element Should Be Enabled       xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot
    Click Element       xpath=//BUTTON[@class='btn btn-success']
    Capture Page Screenshot
    Wait Until Page Does Not Contain       Required fields

    ##--for previous versions of RTS--##
    #Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    #Clear Element Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']
    #Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    #Sleep  1s
    #Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       ${New_Test_Term}
    #Wait Until Element is Enabled      xpath=//BUTTON[@class='btn btn-success']
    #Click Element       xpath=//BUTTON[@class='btn btn-success']
    #Wait Until Page Does Not Contain        Required fields

    Input Text      xpath=(//INPUT[@type='text'])[2]            ${New_Test_Term}        #check for authenticity
    ${Count}    ${List}         Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     6
    ${Count_After}=       Get Match Count     ${List}     *${New_Test_Term}*
    Should Be Equal As Integers     ${Count_Before}        ${${Count_After}-1}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[2]

    #Check-5: Message   #Owner for new RTS Version
    ${Old_Test_Term}        Set Variable       Created_New_Alert_Test_Case_Running_Test_6
    ${New_Test_Term}        Set Variable       Created_New_Alert_Test_Case_Running_Test_7
    ${Count}        ${List}        Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4
    ${Count_Before}=       Get Match Count     ${List}     *${New_Test_Term}*
    Input Text     xpath=(//INPUT[@type='text'])[4]       ${Old_Test_Term}      #Search_by_test_case since name is unique therefore only one result
    Click Element          xpath=//SPAN[@class='btn btn-xs btn-info ng-scope'][text()='change']
    Wait Until Page Contains        Required fields
    Element Should Be Disabled      xpath=//BUTTON[@class='btn btn-success']
    Clear Element Text      xpath=//TEXTAREA[@ng-model='theAlert.data.description']
    Sleep  1s
    Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.description']       ${New_Test_Term}
    Wait Until Element is Enabled      xpath=//BUTTON[@class='btn btn-success']
    Click Element       xpath=//BUTTON[@class='btn btn-success']
    Wait Until Page Does Not Contain        Required fields
    Input Text      xpath=(//INPUT[@type='text'])[4]            ${New_Test_Term}         #check for authenticity
    ${Count}         ${List}         Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4
    ${Count_After}=       Get Match Count     ${List}     *${New_Test_Term}*
    Should Be Equal As Integers     ${Count_Before}        ${${Count_After}-1}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[4]
    [Teardown]      Close Browser


Delete_Alert                     #Test no. 32                               #PASSED
    Connect_To_DT_Console    ${url}             #Open Chrome in new window
    Go_To_Page      Configure       System Alerts                           #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
    Page Should Contain  System Alerts Management

    ${Test_Term}        Set Variable       Test_Case_1
    ${Count}        ${List}        Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2
    ${Count_Before}=       Get Match Count     ${List}     ${Test_Term}
    Should Be Equal As Integers     ${Count_Before}        1                #Since unique
    Input Text     xpath=(//INPUT[@type='text'])[2]       ${Test_Term}      #Search_by_test_case since name is unique therefore only one result
    Select Checkbox     xpath=(//INPUT[@type='checkbox'])[2]
    Click Button    xpath=//BUTTON[@ng-click='removeAlerts()']
    Wait Until Page Contains        Delete selected alert?
    Click Button        xpath=//BUTTON[@ng-click='$close()'][text()='Okay']
    Wait Until Page Does Not Contain        Delete selected alert?
    Clear Element Text      xpath=(//INPUT[@type='text'])[2]
    Input Text      xpath=(//INPUT[@type='text'])[2]            ${Test_Term}         #check for authenticity
    ${Count}    ${List}         Read Table Get Column Count And List      xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2
    ${Count_After}=       Get Match Count     ${List}     ${Test_Term}
    Should Be Equal As Integers     ${Count_After}        0                #Since unique
    Clear Element Text      xpath=(//INPUT[@type='text'])[2]
    Capture Page Screenshot
    [Teardown]      Close Browser


Top_Navbar_Alert_Menu                   #Test no. 33                    #PASSED
    Connect_To_DT_Console    ${url}
    Sleep  2s
    Click Element   xpath=//*[@id="main-nav-collapse"]/alerts-icon[2]/ul/li/a/span
    Capture Page Screenshot
    Page Should Contain     Alerts History
    Page Should Contain     Alerts Management
    Click Element       xpath=(//A[@href='#/config/alerts-history'])[3]
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.
    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful
    Capture Page Screenshot
    Click Element       xpath=//*[@id="main-nav-collapse"]/alerts-icon[2]/ul/li/a/span
    Capture Page Screenshot
    ${Test_Variable}    Set Variable  Test_Case_3
    Run Keyword If      '${Result_2}'=='False'      Click Element   xpath=(//SPAN[@class='name ng-binding'][text()='${Test_Variable}'][text()='${Test_Variable}'])[3]       #if Result2 is True i.e. Alerts were not created before hand and vice versa
    Sleep   2s
    Capture Page Screenshot
    [Teardown]      Close Browser


#Top_Navbar_Alert_Menu_Alert_Message     #Test no. 34                    #Does not Work - giving problems after update
#    
#    Connect_To_DT_Console    ${url}
#    Sleep  2s

#    ${Alert_Count}=     Get Text        xpath=(//SPAN[@class='badge has-alerts ng-binding ng-scope'][text()='2'][text()='2'])[3]
#    Log     ${Alert_Count}

    #Positive Alerts
#    Click Element       xpath=(//SPAN[@class='badge has-alerts ng-binding ng-scope'][text()='2'][text()='2'])[3]

    #Positive Alerts
#    Go_To_Page      Configure       System Alerts               #goto home -> Configure
#    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
#    Page Should Contain  System Alerts Management
#    Click Button    xpath=//BUTTON[@ng-click='createAlert(users, roles)']
#    Wait Until Page Contains    Required fields     timeout=10s
#    Input Text      xpath=(//INPUT[@type='text'])[1]        Test_Case_6
#    Input Text      xpath=(//INPUT[@type='text'])[2]        xyz@datatorrent.com
#    Input Text      xpath=//INPUT[@type='number']           6000
#    Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']       Test_Case_6
#    Input Text      xpath=//TEXTAREA[@ng-model='theAlert.data.description']     Create_New_Alert_Test_Case_Running_Test_6
#    Capture Page Screenshot
#    click element   xpath=//BUTTON[@class='btn btn-success']
#    Capture Page Screenshot
#    Wait Until Page Does Not Contain    Required fields
#    page should contain   Test_Case
    #positive Green check marks
    #Negative

#    Go_To_Page      Configure       System Alerts               #goto home -> Configure
#    click element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
#    page should contain  System Alerts Management
#    click button    xpath=//BUTTON[@ng-click='createAlert(users, roles)']
#    wait until page contains    Required fields
#    element should be disabled       xpath=//BUTTON[@class='btn btn-success']

    #invalid name
#    clear element text      xpath=(//INPUT[@type='text'])[1]
#    page should contain     Please enter a name for this alert.
#    element should be disabled       xpath=//BUTTON[@class='btn btn-success']
    ##invalid email
#    Input Text      xpath=(//INPUT[@type='text'])[2]            datatorrent
#    page should contain     Invalid email address.
#    element should be disabled       xpath=//BUTTON[@class='btn btn-success']
    ##invalid threshold
#    clear element text       xpath=//INPUT[@type='number']
#    page should contain     Please enter the threshold for this alert.
#    element should be disabled       xpath=//BUTTON[@class='btn btn-success']
    ##Invalid condition
#    clear element text      xpath=//TEXTAREA[@ng-model='theAlert.data.condition']
#    page should contain     Please enter a valid Javascript express for this alert.
#    element should be disabled      xpath=//BUTTON[@class='btn btn-success']
    #negative  red circle
    #for combination    red circle number on circle should display active alerts
#    [Teardown]      Close Browser

Navigate_Management                                 #Test no. 35                 #PASSED        Maybe Same as Test no. 40
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Capture Page Screenshot
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Navigate to Sytem Alerts History
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.
    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful
    Capture Page Screenshot
    Click Button        xpath=//*[@id="breadcrumbs-top"]/li[2]/span/span/button     #Click on System Alerts on top left of RTS System alerts History page
    Wait Until Element Is Visible        xpath=//INPUT[@type='text']             #Wait for page to open a dialog box
    Click Element       xpath=//A[@href='/#/config/alerts-management'][text()='Management']     #Navigate to Systems Alerts Management
    Page Should Contain     Use this page to configure alerts to monitor running applications and Hadoop cluster.       #Confirm Navigation
    Capture Page Screenshot

    [Teardown]      Close Browser


Navigate_System_Alert_History                       #Test no. 36                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Capture Page Screenshot
    Click Element  xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']       #Navigate to System Alerts History
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.
    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful
    Capture Page Screenshot
    
    [Teardown]      Close Browser


System_Alerts_History_Search                        #Test no. 37                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
    Page Should Contain     System Alerts Management
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.
    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful

    Run Keyword If      '${Result_2}'=='True'  Fail        Alerts history table is Empty!           #Empty (maybe because no alerts were created beforehand)

    #Check-1: Search_By_Name
    ${Test_Term}        Set Variable       Test_Case_3
    Input Text     xpath=(//INPUT[@type='text'])[2]      ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[2]


    #Check-2: Search_By_In_Time
    ${Test_Term}        Set Variable       >today
    #Input Text     xpath=(//INPUT[@type='text'])[3]      ${Test_Term}
    ${Count_total}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2              #Read Column which can be searched and copy in log
    #${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Input Text     xpath=(//INPUT[@type='text'])[3]      ${Test_Term}
    ${Count_1}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2              #Read Column which can be searched and copy in log
    Clear Element Text      xpath=(//INPUT[@type='text'])[3]
    ${Test_Term}        Set Variable       <today
    Input Text     xpath=(//INPUT[@type='text'])[3]      ${Test_Term}
    ${Count_2}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2              #Read Column which can be searched and copy in log
    Should Be Equal As Integers     ${${Count_1}+${Count_2}}    ${Count_total}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[3]


    #Check-3: Search_By_Out_Time
    ${Count_total}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3              #Read Column which can be searched and copy in log
    ${Test_Term}        Set Variable       >today
        #Input Text     xpath=(//INPUT[@type='text'])[4]      ${Test_Term}

        #${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Input Text     xpath=(//INPUT[@type='text'])[4]      ${Test_Term}
    ${Count_1}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3              #Read Column which can be searched and copy in log
    Clear Element Text      xpath=(//INPUT[@type='text'])[4]
    ${Test_Term}        Set Variable       <today
    Input Text     xpath=(//INPUT[@type='text'])[4]      ${Test_Term}
    ${Count_2}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3              #Read Column which can be searched and copy in log
    Should Be Equal As Integers     ${${Count_1}+${Count_2}}    ${Count_total}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[4]

    #Check-4: Search_By_Active
    ${Count_total}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4              #Read Column which can be searched and copy in log
    ##Check-4.1: Search Term='yes'
    ${Test_Term}        Set Variable       yes
    Input Text     xpath=(//INPUT[@type='text'])[5]      ${Test_Term}
    ${Count_1}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4              #Read Column which can be searched and copy in log
    #${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Capture Page Screenshot

    Clear Element Text      xpath=(//INPUT[@type='text'])[5]

    ##Check-4.2: Search Term='!yes'
    ${Test_Term}        Set Variable       !yes
    Input Text     xpath=(//INPUT[@type='text'])[5]      ${Test_Term}
    ${Count_2}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4              #Read Column which can be searched and copy in log
    #${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Capture Page Screenshot
    Should Be Equal As Integers     ${${Count_1}+${Count_2}}    ${Count_total}

    Clear Element Text      xpath=(//INPUT[@type='text'])[5]

    #Check-5: Search_By_Message
    ${Test_Term}        Set Variable       yes
    Input Text     xpath=(//INPUT[@type='text'])[6]      ${Test_Term}
    ${Count}        ${List}        Read Table Get Column Count And List     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5              #Read Column which can be searched and copy in log
    ${Check_Success}=        Get Match Count     ${List}     *${Test_Term}*       case_insensitive=${True}        whitespace_insensitive=${False}
    Should Be Equal As Integers     ${Check_Success}    ${Count}
    Capture Page Screenshot

    [Teardown]      Close Browser

System_Alerts_History_Sort                          #Test no. 38                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts               #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']
    Page Should Contain     System Alerts Management
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.

    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful

    Run Keyword If      '${Result_2}'=='True'  Fail        Alerts history table is Empty!           #Empty (maybe because no alerts were created beforehand)

    #Check-1: Sort_By_Name
            ##logic for comparison get list and compare with your sorted list
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-1.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[1]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Properties: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-1.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[1]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     1    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}       msg=Properties: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-2: Sort_By_In_Time
            ##logic for comparison get list and compare with your sorted list
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-2.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Properties: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-2.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[2]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     2    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}       msg=Properties: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-3: Sort_By_Out_Time
            ##logic for comparison get list and compare with your sorted list
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-3.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[3]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Properties: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-3.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[3]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     3    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}       msg=Properties: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-4: Sort_By_Active
            ##logic for comparison get list and compare with your sorted list
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-4.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[4]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Properties: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-4.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[4]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     4    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}       msg=Properties: Descending Sort Working Unsuccessful
    Capture Page Screenshot


    #Check-5: Sort_By_Message
            ##logic for comparison get list and compare with your sorted list
    ${LHS_Function_Sort_Ascending}      Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Sorted
    ${LHS_Function_Sort_Descending}     Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Reverse Sorted
    Log List    ${LHS_Function_Sort_Ascending}
    Log List    ${LHS_Function_Sort_Descending}

    ##Check-5.1: Ascending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[5]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Ascending}    ${RHS_Click_Sort}       msg=Properties: Ascending Sort Working Unsuccessful
    Capture Page Screenshot

    ##Check-5.2: Descending
    Click Element       xpath=(//SPAN[@class='column-text ng-binding ui-sortable-handle'])[5]
    ${RHS_Click_Sort}         Read Table Column Sort     xpath=//DIV[@class='mlhr-rows-table-wrapper']/table     5    Unsorted
    Lists Should Be Equal     ${LHS_Function_Sort_Descending}   ${RHS_Click_Sort}       msg=Properties: Descending Sort Working Unsuccessful
    Capture Page Screenshot

    [Teardown]      Close Browser

System_Alerts_History_Details                       #Test no. 39                 #PASSED
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Navigate to System Alert History
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.
    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful

    Run Keyword If      '${Result_2}'=='True'  Fail        Alerts history table is Empty!           #Empty (maybe because no alerts were created beforehand)

    ${Alert_Name}       Set Variable        Test_Case_2                          #Alert Name
    Click Element       xpath=//A[@ng-click='options.parentScope.alertDetail(row)'][text()='${Alert_Name}']     #Click on Alert
    Wait Until Page Contains        Alert Details                                #Confirm Popup windows for Alert Details
    Sleep       1s                                                               #Required to make the Popupoptically visible to take screenshot
    Capture Page Screenshot

    [Teardown]      Close Browser


System_Alerts_History_Management_Link                #Test no. 40                #PASSED        #Maybe same as Test no. 35
    Connect_To_DT_Console    ${url}
    Go_To_Page      Configure       System Alerts                                #goto home -> Configure
    Click Element       xpath=//SPAN[@class='ng-scope'][text()='System Alerts']      #Click On System Alerts
    Page Should Contain        System Alerts Management                          #Confirmation of successful navigation to System Alerts Page
    Click Element       xpath=//A[@href='#/config/alerts-history'][text()='System Alerts History']      #Navigate to System Alert History
    ${Result_1}=    Run Keyword And Return Status       Page Should Contain     Below are the occurrences of triggered alerts.
    ${Result_2}=    Run Keyword And Return Status       Page Should Contain     No alerts history found.
    Run Keyword If      '${Result_1}'=='False' and '${Result_2}'=='False'     Fail       ERROR!! Navigation not as expected     #Deliberate failure if navigation is unsuccessful

    Click Link      Click here
    #Click Element       xpath=//A[@dt-page-href='AlertsManagement'][text()='Click here']      #Navigate to Systems Alerts Management
    Page Should Contain     Use this page to configure alerts to monitor running applications and Hadoop cluster.       #Confirm Navigation
    Capture Page Screenshot

    [Teardown]      Close Browser

#####End_Of_Assingned_Test_Cases#####

##Shubam_Test_Cases##

License_Inf_Verify    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    License Information
    Sleep    15s
    Capture Page Screenshot
    Click Element    //*[text()='License Information']/..
    Wait Until Page Contains    Current License
    Capture Page Screenshot

                                                                                                                                                                                 255,0-1       50%

Import_New_License    #passed
    Connect_To_DT_Console    ${url}
    Import_License_File    ${license_path}
    Capture Page Screenshot

License_Upgrade_link    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    License Information
    Capture Page Screenshot
    Click Element    //t[text()='License Information']/..
    Wait Until Page Contains    Current License
    Capture Page Screenshot
    ${Upgrade_Link}    Set Variable    /html/body/div[2]/div/div//a[contains(text(),"upgrade")]/../a
    Click Element    xpath=${Upgrade_link}
    wait until page contains    DataTorrent RTS    timeout=20s
    Capture Page Screenshot

User_Info    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    User Profile
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='User Profile']/..
    Wait Until Page Contains    Restore Defaults
    Capture Page Screenshot

Theme_Change_Test     #pass
    Connect_To_DT_Console    ${url}
    Sleep    15s
    Capture Page Screenshot
    Go_To_Page    Configure    User Profile
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='User Profile']/..
    Wait Until Page Contains    Restore Defaults
    Capture Page Screenshot
    Select From List By Label    xpath=/html/body/div[2]/div/form/div[2]/select    DataTorrent Classic
    Sleep    10s
    Capture Page Screenshot

New_Start_Page    #pass
    Connect_To_DT_Console    ${url}
    Sleep    15s
    Capture Page Screenshot
    Go_To_Page    Configure    User Profile
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='User Profile']/..
    Wait Until Page Contains    Restore Defaults
    Capture Page Screenshot
    Select From List By Label    xpath=/html/body/div[2]/div/form/div[1]/select    /ops
    Sleep    10s
    Capture Page Screenshot
    Go To    ${url}
    Capture Page Screenshot
                                                                                                                                                                                 313,1         64%
Restore_Default    #pass
    Connect_To_DT_Console    ${url}
    Go_To_Page    Configure    User Profile
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='User Profile']/..
    Wait Until Page Contains    Restore Defaults
    Capture Page Screenshot
    Click Element    xpath=//*[text()='restore defaults']
    Click Element    xpath=/html/body/div[1]/div/div/div[3]/button[1]    #click the okay button
    Go To    ${url}
    Capture Page Screenshot
    #-----------------------Installation Wizard-------------------------------

Complete_InstWiz_Test    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    Installation Wizard
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='Installation Wizard']/..
    Wait Until Page Contains    continue
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']
    Capture Page Screenshot
    Input Text    xpath=//INPUT[@name='hadoopLocation']   /usr/bin/hadoop    #/home/shubham/hadoop/bin/hadoop
    Input Text    xpath=//INPUT[@name='dfsLocation']    /user/dttbc/datatorrent-node36
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to third page on installation wizard
    Wait Until Page Contains    continue    timeout=100s
    Sleep    10s
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']
    Wait Until Page Contains    Summary    timeout=30s   #takes to fourth page on installation wizard
    Click Element    xpath=//*[text()='continue']     #/html/body/div[2]/div[1]/div/a    #need to make it generic    #//*[text()='continue']    #takes you out of the installation wizard
    Wait Until Page Contains    Summary    timeout=30s
    Capture Page Screenshot

InstWiz_BackButton_Test    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    Installation Wizard
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='Installation Wizard']/..
    Wait Until Page Contains    continue
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']
    Sleep    30s
    Capture Page Screenshot
    Click Element    xpath=//*[text()='back']
    Sleep    30s
    Capture Page Screenshot

                                                                                                                                                                                 368,0-1       78%
InstWiz_SysDiagon_Test    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    Installation Wizard
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='Installation Wizard']/..
    Wait Until Page Contains    continue
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to second page on installation wizard
    Wait Until Page Contains    Summary    timeout=30s
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to third page on installation wizard
    Wait Until Page Contains    Summary    timeout=800s
    Capture Page Screenshot    #/html/body/div[2]/div[1]/div/p[2]/a
    Click Element    xpath=//*[text()='continue']      #takes to fourth page on installation wizard
    Wait Until Page Contains    Summary    timeout=30s
    ${SysDiagons_Link}    Set Variable    /html/body/div[2]/div[1]/div/p[2]/a
    Click Element    xpath=${SysDiagons_link}
    Sleep    20s
    Capture Page Screenshot

InstWiz_ConfPage_Link_Test    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    Installation Wizard
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='Installation Wizard']/..
    Wait Until Page Contains    continue
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to second page on installtion wizard
    Wait Until Page Contains    Summary    timeout=30s
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to third page on installtion wizard
    Wait Until Page Contains    Summary    timeout=50s
    Capture Page Screenshot    #/html/body/div[2]/div[1]/div/p[2]/a
    Click Element    xpath=//*[text()='continue']      #takes to fourth page on installation wizard
    Wait Until Page Contains    Summary    timeout=30s
    ${ConfPage_Link}    Set Variable    /html/body/div[2]/div[1]/div/p[1]/a
    Click Element    xpath=${ConfPage_link}
    Sleep    12s
    Capture Page Screenshot

Installation_Summary    #pass
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    Installation Wizard
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='Installation Wizard']/..
    Wait Until Page Contains    continue
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to second page on installation wizard
    Wait Until Page Contains    Summary    timeout=800s
    Capture Page Screenshot    #/html/body/div[2]/div[1]/div/p[2]/a
    Read_Table_Hard_Coded    xpath=/html/body/div[2]/div[1]/div/table

Wrong_InstWiz_Test    #partial pass    #bug in gui, does not shows error when we give wrong path
    Connect_To_DT_Console    ${url}
    Capture Page Screenshot
    Go_To_Page    Configure    Installation Wizard
    Sleep    15s
    Capture Page Screenshot
    Click Element    //t[text()='Installation Wizard']/..
    Wait Until Page Contains    continue
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']
    Capture Page Screenshot
    Input Text    xpath=//INPUT[@name='hadoopLocation']    /home/shubham/hadoop/bin/hadoop
    Input Text    xpath=//INPUT[@name='dfsLocation']    /wrong
    Capture Page Screenshot
    Click Element    xpath=//*[text()='continue']    #takes to third page on installation wizard
    Sleep    12s
    Capture Page Screenshot
    #---------------------------THE - END-----------------------------
    #--------------------------------------------------------------------------------------------------------------------------------------------


Connect_To_SIT_Captive_Portal
    Open Browser    10.10.216.2:8090        CHROME
    Wait Until Page Contains        SYMBIOSIS HILL BASE CAMPUS
    Input Text      xpath=//INPUT[@type='text']         14070121140
    Input Password      xpath=//INPUT[@type='password']     coffeebee
    [Teardown]  Close Browser