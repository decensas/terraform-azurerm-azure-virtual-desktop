$ErrorActionPreference = "Stop"
$registrationToken = '${registration_token}'
$agentInstaller = Join-Path $env:TEMP "Microsoft.RDInfra.RDAgent.Installer-x64.msi"
$bootLoaderInstaller = Join-Path $env:TEMP "Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi"

try {
    Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2310011" -OutFile $agentInstaller -UseBasicParsing
    Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2311028" -OutFile $bootLoaderInstaller -UseBasicParsing
    Unblock-File -Path $agentInstaller
    Unblock-File -Path $bootLoaderInstaller

    $agentInstall = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$agentInstaller`" /quiet REGISTRATIONTOKEN=$registrationToken" -Wait -PassThru
    if ($agentInstall.ExitCode -notin @(0, 3010)) {
        throw "Azure Virtual Desktop Agent installation failed with exit code $($agentInstall.ExitCode)."
    }

    $bootLoaderInstall = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$bootLoaderInstaller`" /quiet" -Wait -PassThru
    if ($bootLoaderInstall.ExitCode -notin @(0, 3010)) {
        throw "Azure Virtual Desktop Agent Boot Loader installation failed with exit code $($bootLoaderInstall.ExitCode)."
    }
} catch {
    Write-Error $_
    exit 1
}

exit 0