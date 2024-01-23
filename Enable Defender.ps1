# thanks to https://superuser.com/a/1648105
#### START ELEVATE TO ADMIN #####
Param([Parameter(Mandatory=$false)][switch]$shouldAssumeToBeElevated, [Parameter(Mandatory=$false)] [String]$workingDirOverride)

# If parameter is not set, we are propably in non-admin execution. We set it to the current working directory so that
#  the working directory of the elevated execution of this script is the current working directory
if(-not($PSBoundParameters.ContainsKey('workingDirOverride')))
{
    $workingDirOverride = (Get-Location).Path
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# If we are in a non-admin execution. Execute this script as admin
if ((Test-Admin) -eq $false)  {
    if ($shouldAssumeToBeElevated) {
        Write-Output "Elevating did not work :("
        exit
    } else {
        #                                                         vvvvv add `-noexit` here for better debugging vvvvv 
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -shouldAssumeToBeElevated -workingDirOverride "{1}"' -f ($myinvocation.MyCommand.Definition, "$workingDirOverride"))
    }
    exit
}

Set-Location "$workingDirOverride"
##### END ELEVATE TO ADMIN #####

Write-Output $workingDirOverride

$DefenderPath                       = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"

#$PolicyManagerKey                   = "Policy Manager"
$RealTimeProtectionKey              = "Real-Time Protection"
$SignatureUpdatesKey                = "Signature Updates"
$SpynetKey                          = "Spynet"

$AllowFastServiceStartupValue       = "AllowFastServiceStartup"
$DisableAntiSpywareValue            = "DisableAntiSpyware"
$DisableAntiVirusValue              = "DisableAntiVirus"
$DisableRoutinelyTakingActionValue  = "DisableRoutinelyTakingAction"
$DisableSpecialRunningModesValue    = "DisableSpecialRunningModes"
$ServiceKeepAliveValue              = "ServiceKeepAlive"
$DisableRealtimeMonitoringValue     = "DisableRealtimeMonitoring"

$WindowsDefenderIsDisabledPermanently = "WindowsDefenderIsDisabledPermanently"

If(Test-Path -Path $DefenderPath) {
    Write-host -f Green "Key Exists!"
}
Else {
    Write-host -f Yellow "Key doesn't Exists!"
    exit
}

$IsAleadyDisabled = Get-ItemProperty -Path "$DefenderPath" -Name "$WindowsDefenderIsDisabledPermanently" -ErrorAction SilentlyContinue
If(-Not $IsAleadyDisabled)
{
    Write-Error "You have already enabled windows defender!"
    Pause
    exit
}

Remove-ItemProperty -Path "$DefenderPath" -Name "$WindowsDefenderIsDisabledPermanently"

#Remove-Item -Path "$DefenderPath\$PolicyManagerKey" -Recurse
Remove-Item -Path "$DefenderPath\$RealTimeProtectionKey" -Recurse
Remove-Item -Path "$DefenderPath\$SignatureUpdatesKey" -Recurse
Remove-Item -Path "$DefenderPath\$SpynetKey" -Recurse

Remove-ItemProperty -Path "$DefenderPath" -Name "$AllowFastServiceStartupValue"
Remove-ItemProperty -Path "$DefenderPath" -Name "$DisableAntiSpywareValue"
Remove-ItemProperty -Path "$DefenderPath" -Name "$DisableAntiVirusValue"
Remove-ItemProperty -Path "$DefenderPath" -Name "$DisableRoutinelyTakingActionValue"
Remove-ItemProperty -Path "$DefenderPath" -Name "$DisableSpecialRunningModesValue"
Remove-ItemProperty -Path "$DefenderPath" -Name "$ServiceKeepAliveValue"
Remove-ItemProperty -Path "$DefenderPath" -Name "$DisableRealtimeMonitoringValue"

Pause