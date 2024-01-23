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
$DisableBehaviorMonitoringValue     = "DisableBehaviorMonitoring"
$DisableOnAccessProtectionValue     = "DisableOnAccessProtection"
$DisableRealtimeMonitoringValue     = "DisableRealtimeMonitoring"
$DisableScanOnRealtimeEnableValue   = "DisableScanOnRealtimeEnable"
$ForceUpdateFromMUValue             = "ForceUpdateFromMU"
$DisableBlockAtFirstSeenValue       = "DisableBlockAtFirstSeen"

$WindowsDefenderIsDisabledPermanently = "WindowsDefenderIsDisabledPermanently"

If(Test-Path -Path $DefenderPath) {
    Write-host -f Green "Key Exists!"
}
Else {
    Write-host -f Yellow "Key doesn't Exists!"
    exit
}

$IsAleadyDisabled = Get-ItemProperty -Path "$DefenderPath" -Name "$WindowsDefenderIsDisabledPermanently" -ErrorAction SilentlyContinue
If($IsAleadyDisabled)
{
    Write-Error "You have already disabled windows defender!"
    Pause
    exit
}

New-ItemProperty -Path "$DefenderPath" -Name "$WindowsDefenderIsDisabledPermanently" -Value "1" -PropertyType Dword

#New-Item -Path "$DefenderPath\$PolicyManagerKey"
New-Item -Path "$DefenderPath\$RealTimeProtectionKey"
New-Item -Path "$DefenderPath\$SignatureUpdatesKey"
New-Item -Path "$DefenderPath\$SpynetKey"

New-ItemProperty -Path "$DefenderPath" -Name "$AllowFastServiceStartupValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath" -Name "$DisableAntiSpywareValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath" -Name "$DisableAntiVirusValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath" -Name "$DisableRoutinelyTakingActionValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath" -Name "$DisableSpecialRunningModesValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath" -Name "$ServiceKeepAliveValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath" -Name "$DisableRealtimeMonitoringValue" -Value "1" -PropertyType Dword

New-ItemProperty -Path "$DefenderPath\$RealTimeProtectionKey" -Name "$DisableBehaviorMonitoringValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath\$RealTimeProtectionKey" -Name "$DisableOnAccessProtectionValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath\$RealTimeProtectionKey" -Name "$DisableRealtimeMonitoringValue" -Value "1" -PropertyType Dword
New-ItemProperty -Path "$DefenderPath\$RealTimeProtectionKey" -Name "$DisableScanOnRealtimeEnableValue" -Value "1" -PropertyType Dword

New-ItemProperty -Path "$DefenderPath\$SignatureUpdatesKey" -Name "$ForceUpdateFromMUValue" -Value "1" -PropertyType Dword

New-ItemProperty -Path "$DefenderPath\$SpynetKey" -Name "$DisableBlockAtFirstSeenValue" -Value "1" -PropertyType Dword

Pause