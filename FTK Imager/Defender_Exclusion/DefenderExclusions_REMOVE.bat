@echo off
set scriptPath='%1'
powershell -command ^
$ExclusionType;^
$ExclusionFile = %scriptpath%;^
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine;^
$Logs=[System.IO.Path]::GetTempPath() + 'Clear-WindowsDefenderExcl.txt';^
Start-Transcript $Logs -Append -Force;^

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
                    Remove-MpPreference -ExclusionPath $ItemTrimmed;^
                    Write-Host "Removing "$ExclusionType" exclusion " $ItemTrimmed;^
                }^
                elseif ($ExclusionType -eq '-FileType') {^
                    Remove-MpPreference -ExclusionExtension  $ItemTrimmed;^
                    Write-Host "Removing "$ExclusionType" exclusion " $ItemTrimmed;^
                }^
                elseif ($ExclusionType -eq '-Process') {^
                    Remove-MpPreference -ExclusionProcess  $ItemTrimmed;^
                    Write-Host "Removing "$ExclusionType" exclusion " $ItemTrimmed;^
                }^
            }^
        }^
	}^
}^
else{^
	Write-Host "Did not find exclusion file " $ExclusionFile;^
    Return;^
}^

Write-Host "================================================";^
Write-Host "Done.";^
Stop-Transcript;^
