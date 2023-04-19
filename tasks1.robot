*** Settings ***
Documentation       Robot to order robots from RobotSpareBin Industries.
Library    RPA.Browser.Selenium  auto_close=${FALSE}
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF

*** Tasks ***
Robot to order robots from RobotSpareBin Industries
    Open the orders website
    Download the csv file
    #get orders
    Fill the form using the data from the csv file

*** Keywords ***
Open the orders website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
    Click Button    //*[@id="root"]/div/div[2]/div/div/div/div/div/button[1]

Download the csv file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

get orders
    #Wait Until Page Contains Element    id:sales-form
    [Arguments]    ${order}
    Select From List By Value    head    ${order}[Head]
    Select Radio Button    body    ${order}[Body]
    Input Text    xpath://html/body/div/div/div[1]/div/div[1]/form/div[3]/input    ${order}[Legs]
    Input Text    address    ${order}[Address]
    Click Button    preview
    Click Button    order
    

Fill the form using the data from the csv file
    ${orders}=    Read table from CSV    orders.csv    dialect=excel    header=True    delimiters=,
    FOR    ${order}    IN    @{orders}
        get orders    ${order}
    END