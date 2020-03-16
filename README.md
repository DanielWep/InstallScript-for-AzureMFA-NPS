# Install Script for Microsoft Network Policy Server (NPS) with AzureMFA Integration

The Install Script run this setup steps automatically: 

1. Installing the WindowsFeature Network Policy Server (NPS)
2. A Radius Client will be added, e.g. NetScaler Subnet IP
3. NPS domain registration
4. Downloading and Installing the AzureMFA NPS Extension
5. Running the initial AzureMFA config Script
6. [Optional] Adding an Windows Firewall Rule for incoming UDP Radius traffic, only for Windows Server 2019.

## Getting Started

The Install Script should be run on the destination NPS Server.

[More information here.](https://docs.microsoft.com/de-de/azure/active-directory/authentication/howto-mfa-nps-extension)

### Prerequisites

- Licenses for Azure Multi-Factor Authentication (included with Azure AD Premium, EMS, or an MFA stand-alone license)
- Windows Server 2008 R2 SP1 or above.
- Network connectivity to the following destinations with port 80/443 (Webproxy also possible or direct):
	https://adnotifications.windowsazure.com
	https://login.microsoftonline.com
	https://login.microsoftonline.com
	https://provisioningapi.microsoftonline.com
	https://aadcdn.msauth.net
- Active Directory domain-joined server
- Azure AD Tenant ID

## Running the scripts

### 

```
InstallScript-for-AzureMFA-NPS -RadiusClientName [YourRadiusClientName] -RadiusClientIP [YourRadiusClientIP]
```

## PostActions

- NPS policies for connection and network requests must be created manually
- Check if your new NPS Server added to the ActiveDirectory RAS and IAS Server Group. Otherwise you can authorize the server via NPS console right-click on the server and choose "Register server in Active Directory"

#