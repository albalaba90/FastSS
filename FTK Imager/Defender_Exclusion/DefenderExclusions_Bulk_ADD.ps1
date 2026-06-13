<#
.NOTES
    AUTHOR:  Wayne Mitchell
    VERSION: 3
 
    RELEASE NOTES:
    Initial draft: 20210305
	Modified by Tom Angle to only add Exclusions
	20220711

    Requires -RunAsAdministrator


#>

# Variables
$scriptPath = split-path -parent $MyInvocation.MyCommand.Path
$ExclusionFile = $scriptpath + '\ExterroExclusions.txt'
$ExclusionType = ""

##################################
# Configure Scanning Preferences #
##################################

# Import exclusion file

If (Test-Path -path $ExclusionFile )
{   $Exclusions = Get-Content $ExclusionFile
    Foreach ($Item in $Exclusions ) {
        $ItemTrimmed = $Item.trim()
        If ($Item.length -gt 0) {
            If ($ItemTrimmed.StartsWith('#')) {
                # this is a comment, ignore
            }
            ElseIf ($ItemTrimmed.StartsWith('-')) {
                $ExclusionType = $ItemTrimmed
                Write-Host $ExclusionType
            }
            Else {
                If ($ExclusionType -eq '-Folder') {
                    Add-MpPreference -ExclusionPath $ItemTrimmed
                    Write-Host "Adding "$ExclusionType" exclusion " $ItemTrimmed
                }
                ElseIf ($ExclusionType -eq '-FileType') {
                    Add-MpPreference -ExclusionExtension  $ItemTrimmed
                    Write-Host "Adding "$ExclusionType" exclusion " $ItemTrimmed
                }
                ElseIf ($ExclusionType -eq '-Process') {
                    Add-MpPreference -ExclusionProcess  $ItemTrimmed
                    Write-Host "Adding "$ExclusionType" exclusion " $ItemTrimmed
                }
            }
        }
    }
}
else
{   Write-Host "Did not find exclusion file " $ExclusionFile
    Return
}

