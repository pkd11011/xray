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
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCTKPIGpNHWsr8w
W5xa2G1yGNLRf7jfYjVR0QqlecYv/ThqMaUZEJRXOA0EZT+2wLi6WuNHasWlCxYE
2Y2W3ZhEbbBOhL6hp3HnCi0d1xW0ww9RS2J+TQ7sxzE7kIV/teWhitcbXVUrCgjU
k/yWAbkkIFsnplxi5dqJ+7wZeErjcek4efq/D8M9kPAmGXZWI3uLVOKJmSUT7PFC
pMVNMgt3Eem88hmc0+QcvZe4hnUL8HkU3heVRZgrNiDxl3Jx7SyTUcIg0MYZJzAY
A1v1rlvsye0Dbrh4Ve3iHwx5YOmTaZNMH9HjKgg+XirU2Z5peeTFFR3YqFUd5kt1
gNGENYRPAgMBAAECggEASJClu9H1aU3OCi36bS+Q1HTaLBUzl++JBFW0zsE8Ebjn
YzIky7XJuDJ69MJqhxcEYFxl+3byi/5p9q1CbPTLW17NVAKQMA1uFLQHaFIBsZeI
C5nFMSuVYvucUtdihQWwfJaGmMdOsoDpts1cfanO3joYSPZ3Uwst1uGrsNGI+BsZ
bAN2C5ryvDYvkKNYqvlJiAUefNCm/pn5QKtmIEVW5dHooRvlXUf+b91dK5yB7sHQ
mREEUBZyLVAvdXZony1863b+5d7aT2wPqk4Hty2GMzzlnnXDl7py4SDMArHQgKDd
MttxCym9jgFSJrV5crbUBkF6/BmQqdCmNskydt+haQKBgQDMeryG/FaYQANIqK/U
Gw21Q/qw7jx0c4I9lWNxj8ZPp7pR/T/U70dZ40893gqrksIDyknsaUzFYEEYIvNH
GhsOiIQ3bGtMumjJrXigt9Ht+qvbyTodhZ9uyTG1c3bNQoSflSe7T5dRVslU6Gsz
jqI5PD+gMHNDIL4haQsZLZbLxwKBgQC4PQGZBABwtin/aeb9zG+Q/snvvy7DALp9
aIupWhBWFTJhl6Hl/THCk3xnWiW+41BUDZLAajHJMJC3aDgoLXuOhKN3kSitj0jg
syVw6kUYYce/B40qORu48M532bmWxPGQjLzXy+rkgO8CsEX33NkxbfWvvbXRmkjI
CuNajaqzOQKBgQC1aOKfo3m0A36mVLoBpKrJuXDMzd+mtN/EgSfDlXmsK7NakCK0
aEDWF5uy2K6Av2gPcsWYz2cD6Tx3DHLnDtsYTrd2cGLVpL/YxWUyuUKvLmiQSnub
u3PSFv9Z6wFoY25EIlEolhk6WZOvF7AcApwbyT7tgG6SDJeCDq6A/Pg++wKBgHqx
Resc2x40ceuCHy5Ngs7QnrJmY0HBrm/tu3RgYhixrQeI72w2HXkyttotEo3423ne
QCibj+Qnz3gUk7FN+MaEVkg+BxTuIt5g70IvASynkVoKMVw5A9k5pIX0HL/nD+fv
kaM0TY02v/TOZwoVrR5Z2A/dCsQ3NtjhR176kP8hAoGACRX6WxT+4H7fdmqf+HyC
0ravydAvbqqEPiGeBOiGyZZVqz9kYBEhWKvjfCRsdJRMx5TYbl3Wj6ZNtNAAYO4Y
hKsxdltNvpg4MR+RMrO4n6aLWsMwL6jQg5DLHvX/9Cxd3yNYpk754qIocZ7Kh1rE
xDH4f/TekkyAGBpCRO8tJIA=
-----END PRIVATE KEY-----
EOF
  cat >crt.pem <<EOF
-----BEGIN CERTIFICATE-----
MIIEFTCCAv2gAwIBAgIUdaXAWdynPg1vlYYshzv/wrQxey4wDQYJKoZIhvcNAQEL
BQAwgagxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH
Ew1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBDbG91ZGZsYXJlLCBJbmMuMRswGQYD
VQQLExJ3d3cuY2xvdWRmbGFyZS5jb20xNDAyBgNVBAMTK01hbmFnZWQgQ0EgMmRh
YWU2ZDFmNjgxYmExNzRmODY4YjU0OTBmMDU2YmMwHhcNMjQwMzIzMTI0MzAwWhcN
MjcwMzIzMTI0MzAwWjAiMQswCQYDVQQGEwJVUzETMBEGA1UEAxMKQ2xvdWRmbGFy
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJMo8gak0dayvzBbnFrY
bXIY0tF/uN9iNVHRCqV5xi/9OGoxpRkQlFc4DQRlP7bAuLpa40dqxaULFgTZjZbd
mERtsE6EvqGncecKLR3XFbTDD1FLYn5NDuzHMTuQhX+15aGK1xtdVSsKCNST/JYB
uSQgWyemXGLl2on7vBl4SuNx6Th5+r8Pwz2Q8CYZdlYje4tU4omZJRPs8UKkxU0y
C3cR6bzyGZzT5By9l7iGdQvweRTeF5VFmCs2IPGXcnHtLJNRwiDQxhknMBgDW/Wu
W+zJ7QNuuHhV7eIfDHlg6ZNpk0wf0eMqCD5eKtTZnml55MUVHdioVR3mS3WA0YQ1
hE8CAwEAAaOBuzCBuDATBgNVHSUEDDAKBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAA
MB0GA1UdDgQWBBQ6diIdVGXBKQR7sPHcRW+TrqrhPTAfBgNVHSMEGDAWgBSgCh03
t+90Og6Y42oop5uuvvXhajBTBgNVHR8ETDBKMEigRqBEhkJodHRwOi8vY3JsLmNs
b3VkZmxhcmUuY29tL2JiMjE5YWZkLWQyNzgtNGJkNS1hZTE0LWI0ODc2YjA3ZTJi
Zi5jcmwwDQYJKoZIhvcNAQELBQADggEBAAZ4+3vTZm77zX7rf5UtIoRJ6Lc2QoGD
l7YaniwZ1QeA5KRC7+054IZqz1ByW3rUvk11sTbAFWuxeo5qcP2rZG+ql26Guw/f
QxshfEQY8GilnGhg1DynvhRQm22gntL9z/ZlhHCOEETw9F62Gt2uFWx575DReXUn
Q6Xq8WnLOgGaBHjY6yMQxblHQvH7lMnr4j/np4DKxgWKU+4C0H6IJuD7TWlEJTGQ
1Sy1LGnI/MC3QGrGunmY0rCx6URikj04NTmO7MSFRdIMmT5cfNxAXk64il2A+vd6
mG+L8+/p2fDNIv5TklGbuZMk4nFW655g5m21YcE1eKN9RGrqdZRFErs=
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
    PanelType: "NewV2board" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
    ApiConfig:
      ApiHost: "https://kho4g.com"
      ApiKey: "kho4ggiare123456
      NodeID: $node_id1
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
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
    PanelType: "NewV2board" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
    ApiConfig:
      ApiHost: "https://kho4g.com"
      ApiKey: "kho4ggiare123456"
      NodeID: $node_id2
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
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
