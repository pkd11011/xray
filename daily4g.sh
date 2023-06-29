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

bash <(curl -ls https://raw.githubusercontent.com/AZZ-vopp/XrayR-bk/master/install.sh)
cd /etc/XrayR
EOF
  cat >key.pem <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDyafSEcXUddVyH
Bs9n9k6qQ9H4qwD4lwLX9PrLtExvWJNwQHpZmNI7wWkiKVUEECixRWv7GMJcAZbA
Wo6nKjwwEHRGo6TwMwPCHK18xVtyJOc5mtpcZh8PpWmtiQQ3sMWGgEuGOu92yt2+
PY5zbn/3EVTj0Pad84hWcEbOmnrW4/HDlzp/fb549kpPZFiazh3ZK7FOOaf/32LG
VXenjULvXbtU82mugwTSdNY0Per1IX4X6+V8NDOomApvenZn0L24RBLItaT+bFLk
EviCxJFSpkb9ZNz1rpQXXXbJbaJtuDMK+y9q3AjYm4zp3Yt5gps495PuFIZkjUoE
vxz0NFqpAgMBAAECggEABZEbVWNJnjiQvGUSpD+KxOwzyTMcHZlSLmVo0P699pyh
HiXM6XvR8B9b67XpRuOcG54NgcGqzPQYYyhxODOHGE94bBrb8cwqHO4NqdzaYb+p
M7BzrUWHFxPkXmDUIPdFQfZ2RYna7+5usyy0tb/m3mSef3DQCQaLrfh8F8iCY6bi
+BGhrqCkuWbnjfdRz9sYkdtKNPDUM6jp8bA5N4Etyx8JPYKMPBBdUxrG+ZxLzi/5
XPf1YrPZHACSgMJ60TrYgftp3DgslJW0+JYOfOIMHjyOCIAh/pGngeYN/t4bTYum
za6RxLpfB62CEsuXNRoejbEoW/szBXK51/NZIUhFgQKBgQD8yDWZB6pGuCuB6KKa
naNQqposz/cZV5uEYfhCKcY4mztO5oGyA9PqfSyQKea+/OZZvc3/04a6Z5yqk9NN
M1Zp0bsiOebWAtOf7/q4OfDVwfKlnF2dQFpUeVN8/ZfbGYljavH1JxGLMGZpt5nu
pZK8bv6FotkilKznaVsuMCWYmQKBgQD1f/T6ufB+uC4g4A8s3TRBMqy5A8g7Oa4/
liy/JfBS6QAsCnYu+P9+cSlNSeli/+xKzeZiZkyMgCSfazhT8wv6SYvbsrFqUyYg
njCQEk3dMlocsR31QWGA12/iKmSiItyX8iF5qVEUsn37gvLQlyfkQ6Ste8kVHaex
P4EBiifMkQKBgApv8daZvGwjGpjIlD4yGBYylR8Yjylatq8mpGuG8gpQToiZd+1z
vwJFnNtu/3oPUyuNbL4Na9iygoOAiw76+axw3nsxTNi1USufawjES69nzK8N38eo
apJmWA4nImgHi+aw+cCXll/a5b+jtxVlfMOPCa9W5ARLg0Ai14L2tfaxAoGAMRRp
t45gxBSyNCRXJFL81WP6H+rfpud7LH8rZvOAvjKStDtLMUzaVz7sUOVL4VzksnfD
bTyiZRxhNfXLhwz6AgmeCkgJLAZ/gtndP5BJPMWKOl42bQerJITtezuabselbkMb
6iStbwPYJ+YgAQ+XDA1x6LTsmGobUlYtxk8GceECgYA9tg27BL0B8CjS/7fm6cc+
l9rpKlDk6Ij3sjDlZgztPpA0G0G9ReBQS+8aqKnI08laY0dCW7i3R/5ZdC8fLLv2
/mkwTmPN9fhplkiDac5hs6p2AsDzu8/eRrUbYdqH3eHu/8ekX+n4XNu3tNFojCf4
6rDZ63mPtdlEkG1OT7gRxA==
-----END PRIVATE KEY-----
EOF
  cat >crt.pem <<EOF
-----BEGIN CERTIFICATE-----
MIIEFTCCAv2gAwIBAgIUCbN76RfkReWo0XDaaJqZ0iwVGfcwDQYJKoZIhvcNAQEL
BQAwgagxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH
Ew1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBDbG91ZGZsYXJlLCBJbmMuMRswGQYD
VQQLExJ3d3cuY2xvdWRmbGFyZS5jb20xNDAyBgNVBAMTK01hbmFnZWQgQ0EgYWMy
ZmI5MWYxMjdiMWI2NDE1ZDZkZjdmZjZiMTQ3MDEwHhcNMjMwMzA1MDIxODAwWhcN
MjQwMzA0MDIxODAwWjAiMQswCQYDVQQGEwJVUzETMBEGA1UEAxMKQ2xvdWRmbGFy
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPJp9IRxdR11XIcGz2f2
TqpD0firAPiXAtf0+su0TG9Yk3BAelmY0jvBaSIpVQQQKLFFa/sYwlwBlsBajqcq
PDAQdEajpPAzA8IcrXzFW3Ik5zma2lxmHw+laa2JBDewxYaAS4Y673bK3b49jnNu
f/cRVOPQ9p3ziFZwRs6aetbj8cOXOn99vnj2Sk9kWJrOHdkrsU45p//fYsZVd6eN
Qu9du1Tzaa6DBNJ01jQ96vUhfhfr5Xw0M6iYCm96dmfQvbhEEsi1pP5sUuQS+ILE
kVKmRv1k3PWulBdddsltom24Mwr7L2rcCNibjOndi3mCmzj3k+4UhmSNSgS/HPQ0
WqkCAwEAAaOBuzCBuDATBgNVHSUEDDAKBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAA
MB0GA1UdDgQWBBSQlcoA4PXkT89A3cSiWbNOxV0jQzAfBgNVHSMEGDAWgBSMb+yS
ROOOzacivWqDMm5fg6pM7TBTBgNVHR8ETDBKMEigRqBEhkJodHRwOi8vY3JsLmNs
b3VkZmxhcmUuY29tLzU1NGZkNTMwLWVjMzktNDk5Ni04NTg4LTlhYTNlMDUxMGEz
ZS5jcmwwDQYJKoZIhvcNAQELBQADggEBADRkVsz6Ve3U2lBkzln197IobovbLP9U
2cyRdg6QRS7YRLROuvwKFMZvAkQPiE/HQbZaaR+ggqlBeeiJLSd6Pg/+WtkEbn0Y
6oqMLCiAmeE8wJGWiYPKNf2J27fY07OdMFtbAv51Kc6qSflS4xpBFWHLU2kwbskI
QmxE3wNrfVa4G8MXTds6+COZoOjPHv5uyOyboZuC8w8Dh0+uOWuSeJGkKnWTQxYb
swnWV8jL50mxQWvc+HTA3HSuu1RCfoVf5VI0ZeuvHvHSNFhTF/Chjtf8aSVXXbK6
aF6ob4O0Qp82jTtbcGkYbVkmrSYOGw/XMoSYJZ+xZIso3NsBePqo0DM=
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
      ApiHost: "https://daily4g.com"
      ApiKey: "daily4gsieure.site"
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
      ApiHost: "https://daily4g.com"
      ApiKey: "daily4gsieure.site"
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
