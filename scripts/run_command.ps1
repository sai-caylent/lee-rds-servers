# Create Temp directory if it doesn't exist
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory -Force
}

# Set TLS 1.2 as the default security protocol
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download and install AWS CLI if not already installed
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile "C:\Temp\AWSCLIV2.msi"
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Temp\AWSCLIV2.msi /quiet" -Wait
    # Add AWS CLI to the PATH for the current session
    $env:Path += ";C:\Program Files\Amazon\AWSCLIV2"
}

# Verify AWS CLI installation
if (Get-Command aws -ErrorAction SilentlyContinue) {
    Write-Output "AWS CLI installed successfully."
} else {
    Write-Output "AWS CLI installation failed."
    exit 1
}

# Download the MSI file from S3
aws s3 cp s3://lee-fileshare/agentInstaller-x86_64.msi C:\Temp\agentInstaller-x86_64.msi

# Install the MSI file
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Temp\agentInstaller-x86_64.msi /l*v C:\Temp\insight_agent_install_log.log CUSTOMTOKEN=us:b88e223e-4e66-40f3-bcdc-3060d6f1e32e /quiet" -Wait

# Verify MSI installation using log file
$msiLogPath = "C:\Temp\insight_agent_install_log.log"
if (Test-Path $msiLogPath) {
    $logContent = Get-Content $msiLogPath
    if ($logContent -match "Installation completed successfully") {
        Write-Output "MSI installation completed successfully."
    } else {
        Write-Output "MSI installation failed. Check the log file for details."
        exit 1
    }
} else {
    Write-Output "MSI installation log file not found."
    exit 1
}

# Verify if the ir_agent service is running
$service = Get-Service -Name "ir_agent" -ErrorAction SilentlyContinue
if ($service -and $service.Status -eq 'Running') {
    Write-Output "ir_agent service is running."
} else {
    Write-Output "ir_agent service is not running or not installed."
    exit 1
}