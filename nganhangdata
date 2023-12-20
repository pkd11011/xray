yum install nano -y
systemctl stop firewalld
systemctl disable firewalld
clear
read -p " NODE ID 1 443 grpc: " node_id1
  [ -z "${node_id1}" ] && node_id1=0
  
read -p " subdomain ID 1 443 grpc: " sub1
  [ -z "${sub1}" ] && sub1=0

read -p " NODE ID 2 vmess: " node_id2
  [ -z "${node_id2}" ] && node_id2=0

read -p " điền ip ID 2 vmess: " ip2
  [ -z "${ip2}" ] && ip2=0

bash <(curl -Ls https://raw.githubusercontent.com/longyi8/XrayR/master/install.sh)
cd /etc/XrayR
EOF
  cat >key.pem <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQChsZBqsIMHrTrf
esPD9rgLBHDjiegGmwdyD8jQy00D8rikDM2gwXVLdk0JttBiQ4f8xXx/g3z1dddU
KloYlUDLHzoe4FS6Rez14bIpLpXQDM2ICQ4nFb7thz3Bycs6VoYr4uS7NRjJNDcy
OOdBUWO2atbkLIDe7sX4MNbwh9jImiDMaL2hlO5CVH7ONBeFIFInABcuTXVYvkfG
OirTblrxLZl0XhhulkvlpeJcGG62yXdFZyidV/Luv8H+9XGIOSGjMnBaqgGqC6j+
GX3zO/Cs6NDxximArGOIcayE6t8jAYVwCG0hPXnhz0JfgIkaC8LWmhGeo1UPpH91
f4mviVbpAgMBAAECggEAMJWV+zjGZkwa4IOWxw8fBdBzyyro2PNELXWotXQg1Are
iAyAzMjUYbROOZkAzEXWWpFMc1Qi++5IoTWIlNJkAaSEZjqpur7AELGcQtuIkFcI
etOduQjDscNtPwlPU1wkPJOUftvZcruJykFm2y2FdI5tu2nT3yiHu6eRLfzjmoKa
qjUikKpsu9dyPzY0sZdtvLfLWN/bgALz/IP0a6MmYafAwU3aC1rkpPhtSCfwLdpP
+AtSCQj5LyR4/ZSyAaDT1IEtMkNBUbMja4VtX0f+AJbbNH23xnrfuSBLl8IX6Mvf
jUtNWVh5DzGjOqS/hCuCRtEExgHdtdI3MfUm5SMtcQKBgQDcM2Z24KrBWqMxOO+b
hm62dsH927Y+W6iiosImpihtSRO3CN5qUdtdU/Qwb19ZC4JgWrx8vHmhzOFUu6yT
k8x5CDf5jeMbF/jpevRC+0I8E3A0jiVzwmaPj8sf6FFTzW3f+frqI/yF+Gak53s7
P8AKZgXrN8pVMV+YJ923JNIjJwKBgQC7+yMUL3SiqE0fUd5bIg2AmBgjMa87+34d
XxAApWaPATPn0HNP+Z4SS6KV44DDbrdjOSUohQxBvRHamAYnxAbfwsxD5f3Rp2M7
FWmm3HMBtYpYiV5NKsOW3s5SDuAqa1DfbUeP7dZ50XQGFz9cZqidNo4SPPPjOEiV
FnRqJX6/bwKBgGfZZe2Sr3VZBbXlIDu8/uHWyE6tHBn0qGdrUx1fJ5nC6SVdbWe/
CzHMslFVdSZNo0NGB7bcPJDuSybnC9Dd14UNNzjejcjtWVrjvecJEIe8syJWF5us
hyoVqrp1mkVnkPYcsxVRu3qDWAVVlmyu+CbvTsNMIIRlMKxVwN7q4p/pAoGAd9x+
VZSczkp6Qoo1Oe7QpTpVybsYfSqzE49V6NOOPYkKy7lCjbAgdpH7rY9Ov06NaJs7
ckbDtfcUt0lQQ3Le3zaagIDaAyC0SSwyHc9bFa/n8uREWPf3lu+ipvgNP38GJjDL
/J4ur6Y6UNfp8sUSpovusvpimHN+9HFI8ZXO58kCgYAQ6KlS0XSikfpY6++gDU4G
S0JPaIw0dmnccwVyAl2e+8eizHRKRWR1nxLFCww3SkoSMgqLVdEp8Eo7Y9PF/Ull
Dbmw4zB/6dxPsl/vMPpePPrNAhSbL3VIaW1qGLZDB5m3Pi/RYYSUjjTCl2yKng8R
WxfKASlXrpZSDv6HDGBfRA==
-----END PRIVATE KEY-----
EOF
  cat >crt.pem <<EOF
-----BEGIN CERTIFICATE-----
MIIEojCCA4qgAwIBAgIUAMn6/Rq/rZUrX41UjJT09xuIrwQwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTIzMTIwNDE2MDMwMFoXDTI0MTIwMzE2MDMwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAobGQarCDB60633rDw/a4CwRw44noBpsHcg/I
0MtNA/K4pAzNoMF1S3ZNCbbQYkOH/MV8f4N89XXXVCpaGJVAyx86HuBUukXs9eGy
KS6V0AzNiAkOJxW+7Yc9wcnLOlaGK+LkuzUYyTQ3MjjnQVFjtmrW5CyA3u7F+DDW
8IfYyJogzGi9oZTuQlR+zjQXhSBSJwAXLk11WL5Hxjoq025a8S2ZdF4YbpZL5aXi
XBhutsl3RWconVfy7r/B/vVxiDkhozJwWqoBqguo/hl98zvwrOjQ8cYpgKxjiHGs
hOrfIwGFcAhtIT154c9CX4CJGgvC1poRnqNVD6R/dX+Jr4lW6QIDAQABo4IBJDCC
ASAwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSXRH3jT3WzTfH4GQbiuvgwtQwK5jAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAlBgNVHREEHjAcgg0qLmRhaWx5NGcuY29tggtkYWlseTRnLmNvbTA4BgNVHR8E
MTAvMC2gK6AphidodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdpbl9jYS5j
cmwwDQYJKoZIhvcNAQELBQADggEBAD9Va7VszCQW21RCTbkWrGn7PQKZqo+nlBZF
z8mL4f+r/6rQiYCj6EsDjONgA+NggRlW7F4gZlzNecrshjYicUvhgC1jXRBTy3Bm
nhiWPmjMHPpyHmcKaCy+AVMhoHwkR0yH/LVeDPVvA7Z5BCnkUdtJSYXmqi995kt7
15UI5ubkd1DzIs0V+IUIFmG5eFqWwnLgktdnxLeTJONFK3yfvakpOeUgi/TUsObH
DS1uPiG3LkCkYcnDNTZ7l35OiaSXh+TlgOvqLLnG0DFBUAVcqmY0akbDd85H6XEi
hMQn1sUP5OCBP6dugRlP5UwKFvQ3jBof2sx1HwRQUQpti0ErBtw=
-----END CERTIFICATE-----
EOF

cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
    ApiConfig:
      ApiHost: "https://go.nganhangdata.com"
      ApiKey: "gonganhangdata.com"
      NodeID: $node_id1
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 2 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
        WarnTimes: 0 # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
        LimitSpeed: 0 # The speedlimit of a limited user (unit: mbps)
        LimitDuration: 0 # How many minutes will the limiting last (unit: minute)
      GlobalDeviceLimitConfig:
        Enable: false # Enable the global device limit of a user
        RedisAddr: 127.0.0.1:6379 # The redis server address
        RedisPassword: YOUR PASSWORD # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, tls, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$sub1" # Domain to cert
        CertFile: /etc/XrayR/crt.pem
        KeyFile: /etc/XrayR/key.pem
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: 
          CLOUDFLARE_API_KEY: 
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
    ApiConfig:
      ApiHost: "https://go.nganhangdata.com"
      ApiKey: "gonganhangdata.com"
      NodeID: $node_id2
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 2 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
        WarnTimes: 0 # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
        LimitSpeed: 0 # The speedlimit of a limited user (unit: mbps)
        LimitDuration: 0 # How many minutes will the limiting last (unit: minute)
      GlobalDeviceLimitConfig:
        Enable: false # Enable the global device limit of a user
        RedisAddr: 127.0.0.1:6379 # The redis server address
        RedisPassword: YOUR PASSWORD # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, tls, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$ip2" # Domain to cert
        CertFile: /etc/XrayR/crt.pem
        KeyFile: /etc/XrayR/key.pem
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: 
          CLOUDFLARE_API_KEY: 
EOF

xrayr restart
