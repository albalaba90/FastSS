@echo off
set scriptPath='%1'
powershell -command ^
$ExclusionType;^
$ExclusionFile = %scriptpath%;^
if(Test-Path -path $ExclusionFile ){^
	$Exclusions = Get-Content $ExclusionFile;^
	foreach ($Item in $Exclusions ) {^
        $ItemTrimmed = $Item.trim();^
        if($Item.length -gt 0){^
            if($ItemTrimmed.StartsWith('-')) {^
                $ExclusionType = $ItemTrimmed;^
                Write-Host $ExclusionType;^
            }^
			elseif ( !($ItemTrimmed.StartsWith('#'))) {^
                if ($ExclusionType -eq '-Folder') {^
                    Add-MpPreference -ExclusionPath $ItemTrimmed;^
                    Write-Host "Adding "$ExclusionType" exclusion " $ItemTrimmed;^
                }^
                elseif ($ExclusionType -eq '-FileType') {^
                    Add-MpPreference -ExclusionExtension  $ItemTrimmed;^
                    Write-Host "Adding "$ExclusionType" exclusion " $ItemTrimmed;^
                }^
                elseif ($ExclusionType -eq '-Process') {^
                    Add-MpPreference -ExclusionProcess  $ItemTrimmed;^
                    Write-Host "Adding "$ExclusionType" exclusion " $ItemTrimmed;^
                }^
            }^
        }^
	}^
}^
else{^
	Write-Host "Did not find exclusion file " $ExclusionFile;^
    Return;^
}^