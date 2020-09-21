# ## PDF Invite printer
# ### Part2: Work Item To PDF
#
# This example is explained in detail <a href="https://robocorp.com/docs/development-howtos/pdf/pdf-invites-printer">here</a>.
#
# > !! **To run this code locally, you need to complete additional setup steps. Check the README.md file or the <a href="https://robocorp.com/docs/development-howtos/pdf/pdf-invites-printer">example page</a> for details!**
#

*** Settings ***
Documentation     Invite printer robot. Creates PDF invitations to events based on data it receives
...               from the work item.
Library           OperatingSystem
Library           RPA.Archive
Library           RPA.PDF
Library           RPA.Robocloud.Items
Variables         variables.py

*** Keywords ***
Set up and validate
    File Should Exist    ${PDF_TEMPLATE_PATH}
    Create Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}

*** Keywords ***
Collect invitations from work item
    ${invitations}=    Get Work Item Variable    invitations
    [Return]    ${invitations}

*** Keywords ***
Create PDF file for invitation
    [Arguments]    ${invitation}
    Template Html To Pdf    ${PDF_TEMPLATE_PATH}    ${PDF_TEMP_OUTPUT_DIRECTORY}/${invitation["first_name"]}_${invitation["last_name"]}.pdf    ${invitation}

*** Keywords ***
Create ZIP package from PDF files
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIRECTORY}/PDFs.zip
    Archive Folder With Zip    ${PDF_TEMP_OUTPUT_DIRECTORY}    ${zip_file_name}

*** Keywords ***
Cleanup temporary PDF directory
    Remove Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}    True

*** Tasks ***
Create PDF invitations
    Set up and validate
    ${invitations}=    Collect invitations from work item
    FOR    ${invitation}    IN    @{invitations}
        Run Keyword And Continue On Failure    Create PDF file for invitation    ${invitation}
    END
    Create ZIP package from PDF files
    [Teardown]    Cleanup temporary PDF directory
