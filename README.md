# Disable/Enable Windows Defender Permanently
Simple yet effective PowerShell script to enable or disable windows defender permanently on later versions of windows 11.<br>
The idea of this script got to me after i was looking for a way to disable windows defender permanently and i found this [video](https://www.youtube.com/watch?v=ZwIoOR6Psk4) on YouTube by [Pureinfotech](https://www.youtube.com/@Pureinfotech) and i wanted to make it easier for other do it, so here we are.
## Disclaimer
I'm not expert at writing script in PowerShell but i tested it on my machine and it worked just fine, so it should work on all windows 11 machines without a problem.
## How to use
Before running the scripts you to need to prepare two things in order to work well, first disabling Tamper protection in the windows defender settings is mandatory or else all the registery edits won't apply and then we need.
### Preparations
* First press on `Windows-Key + S` and search for `Windows Defender` or `Windows Security` then open it, then click on `Virus & Threat protection` then under the `Virus & Threat protection settings` click on `Manage settings` then scroll down until you find `Tamper Protection` and turn it off.
* Enable script execution for PowerShell using this command
  ```PowerShell
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted
  ```
### Scripts
* To disable windows defender just right click on `Disable Defender.ps1` script file and then it will ask for admin privilge just to be able to write to the registery
* To enable windows defender just right click on `Enable Defender.ps1` script file and then it will ask for admin privilge just to be able to revert back all the changes in the registery
