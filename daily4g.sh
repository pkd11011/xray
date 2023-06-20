#!/bin/bash
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)

    read -p "Nhập Node ID port 80 :" node_80
    echo -e "node_80 là : ${node_80}"

    read -p "Nhập Node ID port 443 :" node_443
    echo -e "node_443 là : ${node_443}"

    read -p "Nhập dns trên cloudflare node 443:" CertDomain443
    echo -e "CertDomain443 = ${CertDomain443}"     

  
  
cd /etc/XrayR
cat >abc.crt <<EOF
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
cat >abc.key <<EOF
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
cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnetionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 864 # Connection idle time limit, Second
  UplinkOnly: 20 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 40 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://daily4g.com"
      ApiKey: "daily4gsieure.site"
      NodeID: $node_80
      NodeType: V2ray # Node type: V2ray, Trojan, Shadowsocks, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 3 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # ./rulelist Path to local rulelist file
    ControllerConfig:
      DisableSniffing: true
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableUploadTraffic: false # Disable Upload Traffic to the panel
      DisableGetRule: false # Disable Get Rule from the panel
      DisableIVCheck: false # Disable the anti-reply protection for Shadowsocks
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/fallback/ for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: none # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "node1.test.com" # Domain to cert
        CertFile: ./etc/XrayR/server.pem # Provided if the CertMode is file
        KeyFile: ./etc/XrayR/privkey.pem
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: abc
          CLOUDFLARE_API_KEY: abc
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://daily4g.com"
      ApiKey: "daily4gsieure.site"
      NodeID: $node_443
      NodeType: V2ray # Node type: V2ray, Trojan, Shadowsocks, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 3 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # ./rulelist Path to local rulelist file
    ControllerConfig:
      DisableSniffing: true    
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableUploadTraffic: false # Disable Upload Traffic to the panel
      DisableGetRule: false # Disable Get Rule from the panel
      DisableIVCheck: false # Disable the anti-reply protection for Shadowsocks
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/fallback/ for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$CertDomain443" # Domain to cert
        CertFile: /etc/XrayR/abc.crt # Provided if the CertMode is file
        KeyFile: /etc/XrayR/abc.key
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: aaa
          CLOUDFLARE_API_KEY: bbb
EOF
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80
sudo ufw allow 443
xrayr restart
