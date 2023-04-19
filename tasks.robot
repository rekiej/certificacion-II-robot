*** Settings ***
Documentation       Template robot main suite.
Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.HTTP
Library             RPA.Excel.Files
Library             RPA.RobotLogListener
Library             RPA.Desktop
Library             RPA.Tables
Library             RPA.PDF
Library             RPA.Archive  
Library             Dialogs

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    #Recorriendo el csv
    ${orders}=  Get orders
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the robot
        Submit the order
       ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
       ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
    END
    Create a ZIP file of the receipts

*** Keywords ***

Open the robot order website
  Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Get orders
  Set Local Variable  ${orders_file}    ${CURDIR}${/}orders.csv
  Download  https://robotsparebinindustries.com/orders.csv  ${orders_file}  overwrite=True
  @{order}=    Read table from CSV  ${orders_file}    
  [Return]  ${order}

Close the annoying modal
  Click Button    OK

Fill the form
  [Arguments]  ${row}
  Select From List By Index  id:head  ${row}[Head]
  Select Radio Button  body  ${row}[Body]
  Input Text  address  ${row}[Address]
  Set Local Variable      ${input_legs}       xpath://html/body/div/div/div[1]/div/div[1]/form/div[3]/input 
  Input Text  ${input_legs}  ${row}[Legs] 
  Click Button    Preview
  Set Local Variable  ${Order number}  ${row}[Order number]

Preview the robot
  Wait Until Keyword Succeeds    30x    1.0 sec    Click Button    Preview

Take a screenshot of the robot
  [Arguments]  ${Order_number}
  Wait Until Element Is Visible    id:robot-preview-image
  Set Local Variable  ${ruta_image}  ${OUTPUT_DIR}${/}order_${Order_number}.png
  Screenshot    id:robot-preview-image    ${ruta_image}
  [Return]  ${ruta_image}

Submit the order
    Wait Until Keyword Succeeds    30x    1.0 sec    Click Button    id:order
    Element is visible

Element is visible
    ${elemento}=    Is Element Visible    id:order-completion
    IF    ${elemento} == False
        Submit the order
    END
    

Store the receipt as a PDF file
  [Arguments]  ${Order_number}
  Wait Until Element Is Visible    id:receipt  20 sec 
  Set Local Variable  ${ruta_pdf}  ${OUTPUT_DIR}${/}order_${Order_number}.pdf
  ${pdf}=    Get Element Attribute    id:receipt    outerHTML
  Html To Pdf    ${pdf}    ${ruta_pdf}
  [Return]  ${ruta_pdf} 

Embed the robot screenshot to the receipt PDF file
  [Arguments]  ${screenshot}    ${pdf}
  Open Pdf    ${pdf}
  @{List_files}=  Create List  ${screenshot}    ${pdf}
  Add Files To Pdf  ${List_files}  ${pdf}
  
Go to order another robot
  Set Local Variable    ${id_headorder}  //*[@id="order-another"]
  Click Button  ${id_headorder}

Create a ZIP file of the receipts
  Set Local Variable    ${pdf_folder}  ${OUTPUT_DIR}
  Set Local Variable    ${zip_file}  ${OUTPUT_DIR}${/}pdf_archive.zip
  Archive Folder With ZIP     ${pdf_folder}  ${zip_file}   recursive=True  include=*.pdf
