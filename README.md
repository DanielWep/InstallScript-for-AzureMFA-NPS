# Install Script for Microsoft Network Policy Server (NPS) with AzureMFA Integration

```
- Installing the WindowsFeature Network Policy Server (NPS)
- A Radius Client will be added, e.g. NetScaler Subnet IP
- Downloading and Installing the AzureMFA NPS Extension
- Execute the initial AzureMFA config Script
```

## Getting Started

The Install Scripte should be run on the destination NPS Server.

### Prerequisites

```
- Licenses for Azure Multi-Factor Authentication (included with Azure AD Premium, EMS, or an MFA stand-alone license)
- Windows Server 2008 R2 SP1 or above.
- Network connectivity to the following destination with port 80/443 (Webproxy also possible or direct):
	- https://adnotifications.windowsazure.com
	- https://login.microsoftonline.com
	- https://login.microsoftonline.com
	- https://provisioningapi.microsoftonline.com
	- https://aadcdn.msauth.net
- Active Directory domain-joined server
```

## Running the scripts

### 

```
InstallScript-for-AzureMFA-NPS -RadiusClientName [YourRadiusClientName] -RadiusClientIP [YourRadiusClientIP]
```

## PostActions

```
- Create NPS Policies manually for Connection and Network request
- Check if your new NPS Server added to the ActiveDirectory RAS and IAS Server Group. Otherwise you can authorize the server via NPS console right-click on the server and choose "Register server in Active Directory"
```

#