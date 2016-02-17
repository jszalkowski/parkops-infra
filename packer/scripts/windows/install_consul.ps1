# Disable negative DNS response caching
write-output "Disable negative DNS response caching"
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters -Name MaxNegativeCacheTtl -Value 0 -Type DWord

# Allow Consul Serf traffic through the firewall
write-output "Set firewall"
netsh advfirewall firewall add rule name="Consul Serf LAN TCP" dir=in action=allow protocol=TCP localport=8301
netsh advfirewall firewall add rule name="Consul Serf LAN UDP" dir=in action=allow protocol=UDP localport=8301
