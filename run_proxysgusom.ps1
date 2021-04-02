$ScriptFromGithHub = Invoke-WebRequest https://raw.githubusercontent.com/systoked/ProxySG/master/proxysg_usom.ps1
Invoke-Expression $($ScriptFromGithHub.Content)
