<powershell>
$Hostname = "${hostname}"
# Ensure EC2 doesn't reset password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableAutomaticRestartSignOn" -Value 1
# Wait for system services to fully initialize
Start-Sleep -Seconds 30
Set-TimeZone -Id "Central Standard Time"
$Password = "ChangeMe%2025"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
Set-LocalUser -Name "Administrator" -Password $SecurePassword
Rename-Computer -Restart -NewName $Hostname -Force
</powershell>