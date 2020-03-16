param([Parameter(Mandatory=$true)][string]$RadiusClientName="", [Parameter(Mandatory=$true)][string]$RadiusClientIP="")

# Install Script for AzureMFA NPS
# (c) Daniel Weppeler 15.03.2020 v0.81
# Twitter: @_DanielWep
# freeware license.

Write-Host("Info: Set the ExecutionPolicy to unrestricted") -ForegroundColor Green 
Set-ExecutionPolicy Unrestricted -Force
Write-Host("Info: Install NPS Feature") -ForegroundColor Green 

$install = Install-WindowsFeature NPAS -IncludeManagementTools
$os=(Get-WMIObject win32_operatingsystem).name

If($install.Success -eq "true") {
    Write-Host("Info: Installation was successful with status code "+ $install.ExitCode +".") -ForegroundColor Green 
    $RadiusClientSecret = Read-Host -Prompt 'Please enter your Radius SharedSecret' -AsSecureString
    $RadiusClientSecret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($RadiusClientSecret))
        try {
        $client = New-NpsRadiusClient -Address $RadiusClientIP -Name $RadiusClientName -SharedSecret $RadiusClientSecret

        Write-Host("Info: New RadiusClient " + $RadiusClientName + "with IP-Address " + $RadiusClientIP + " was added successful.") -ForegroundColor Green 
        $domainregister = netsh nps add registeredserver
            If ($domainregister -eq "Ok.") {
                Write-Host("Info: Server " + $env:computername + " was successful registered to domain "+ (Get-WmiObject Win32_ComputerSystem).Domain + ".") -ForegroundColor Green 
                    try {
                        Write-Host("Info: Downloading Extension for Azure MFA") -ForegroundColor Green 
                        Invoke-WebRequest -Uri "https://download.microsoft.com/download/B/F/F/BFFB4F12-9C09-4DBC-A4AF-08E51875EEA9/NpsExtnForAzureMfaInstaller.exe" -OutFile ($env:USERPROFILE + "\Downloads\NpsExtnForAzureMfaInstaller.exe")
                        Start-Process -Wait -FilePath ($env:USERPROFILE + "\Downloads\NpsExtnForAzureMfaInstaller.exe") -ArgumentList "/S" -PassThru
                        Write-Host("Info: Extension for Azure MFA is installed.") -ForegroundColor Green
                        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                        Write-Host("Info: NuGet is installed.") -ForegroundColor Green
                        Set-PSRepository -InstallationPolicy Trusted -name PSGallery
                        & ($env:ProgramFiles+"\Microsoft\AzureMfa\Config\AzureMfaNpsExtnConfigSetup.ps1")
                            if ($os -match "2019") {
                                New-NetFirewallRule -DisplayName "Allow-Radius-UDP" -Direction Inbound -LocalPort 1812,1813 -Protocol UDP -Action Allow
                                Write-Host("Info: New Firewall Rule for Allow Radius traffic is installed.") -ForegroundColor Green
                            } 
                    } catch { Write-Host("Error: " + $_.Exception.Message) -ForegroundColor Red } 

            } else { Write-Host("Error: The specified domain either does not exist or could not be contacted.") -ForegroundColor Red }
            
        } catch { Write-Host("Error: " + $_.Exception.Message) -ForegroundColor Red }

} else { Write-Host("Error: Installation was aborted with status code "+ $install.ExitCode) -ForegroundColor Red }