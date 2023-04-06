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
MIIEojCCA4qgAwIBAgIUUkBfRgZuUE/0fjXMt41th/VYBR0wDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTIzMDQwNjEzMjMwMFoXDTI0MDQwNTEzMjMwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtQtZgdNHKI1csAgA7DQjQ4Yd9dCZlVyoIhTA
L7kaG56dWrcLYlfntYIFdg/RJ4h6GlMSx765cbL9k9jwXxGDSjOqcRADaLm+Q9hq
iOwZs4vinLUhHfIfF0tNC+DUXCVmQDld2R1BbcqyTEuvQPTQusX90DUxZDlALr95
gCa5gVD0n33aKoDp7N8hn2wFUDlSVchNrdrFItM1QVBGuTOQcVcUlOSvzmNXIIKV
m487kEr2XVUrz6md3rslm3QqPrulB2uL0hnSQcu1R8VyQ8C+0Z9ZQuX5fq0S4VNU
ORY8nbMFh8LTJ3ybODPdauOrW5v+QZPzreP7y4+QsprARFG6UQIDAQABo4IBJDCC
ASAwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSGcQ/0W1hQivagY3QjB1/drY/jQTAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAlBgNVHREEHjAcgg0qLmRhaWx5NGcuY29tggtkYWlseTRnLmNvbTA4BgNVHR8E
MTAvMC2gK6AphidodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdpbl9jYS5j
cmwwDQYJKoZIhvcNAQELBQADggEBAFOWyMhq6AHsUcXzUwC9oLzYPHy6NxBJ6mQz
kXwj5Az8ifaecFTsm7ewXo5WKVnWZ8aZf6FSbiHGWbaCXBPUEN8mqxQAmNc/ysIB
CJD5MN7kTYLcY+kB+ASJryTHrvjS4etGJRq1ydm10iob78NCmI7rTGUgIHdWXQoV
wmnWV2tPDCjGtHsybGgLv7led1XsgPUlzqg9gOrPzgqLjTm0BgfQutkzJkY7Mrk2
VCSEsnNyazb8OEvxlCQpPFniyE9LiiP589RnYJ8pcWlCs9gyy5UmuHGJzDe/lHd+
J9YfZZ5VQMguN9IQezMGTmUxNlbf8h4WCLGRcCjMq0uAP0LYQWQ=
-----END CERTIFICATE-----
EOF
cat >abc.key <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1C1mB00cojVyw
CADsNCNDhh310JmVXKgiFMAvuRobnp1atwtiV+e1ggV2D9EniHoaUxLHvrlxsv2T
2PBfEYNKM6pxEANoub5D2GqI7Bmzi+KctSEd8h8XS00L4NRcJWZAOV3ZHUFtyrJM
S69A9NC6xf3QNTFkOUAuv3mAJrmBUPSffdoqgOns3yGfbAVQOVJVyE2t2sUi0zVB
UEa5M5BxVxSU5K/OY1cggpWbjzuQSvZdVSvPqZ3euyWbdCo+u6UHa4vSGdJBy7VH
xXJDwL7Rn1lC5fl+rRLhU1Q5FjydswWHwtMnfJs4M91q46tbm/5Bk/Ot4/vLj5Cy
msBEUbpRAgMBAAECggEAAoaNQdqi7j2kmp8N9j2W9VjwX47Aqb0AanNMKA5GvzZj
/xE5Iy7TQGy3K0m2svy8KVRZ2Xf/acbjszWOSuE5aeZVHR0qUwJuVU92UwEqLZ9I
ssNzGhIX3XETOtRw2fU6mzBBrybxk/jFKnvOztLre4OKEia/0ORckRpiNUe1BEkJ
EoyrvrgrS6CLlud17DyIj/RvsZOD+R7U5p+TL0zSMMzqU3jB31mjkQHAztC1XTv1
cBklASuRfFUNytquLDcC6XRIOg/gqgnSSU6En3yy4i7QOj059JxcS+ZSGfximqSl
dJTbbLZ8ZoiO66l/AZ3Lp/l93MkxOgCUGzqnu2YagQKBgQDb7BgB9qTi1WyKzLsf
j1ejQzMYej+UoZ/0YN5jITi0rfynS8aEUvtb74Gywnl4ZbFtOHimKXtQ+jn9cr79
LodM9no0onOdD1/DWl4cB9a84JrlPAWkRATYroZPFWfMIh/rBWOdiiCohKqb3R2/
0ozQou/j93+mwC/GnQ2EV5uiYQKBgQDSvoe2ocmuziEdhb502pW3nb+obC4KmFsU
OkPhh1FQfl7xD/jm61ZdJ4iaci0pvIj3hbjcpPhss6GsWZPG9WlwyWplBTLHqozl
OJJEqXLCV5YVgin9xXQ9xAYSbI7XzH9nun8hA6h/0kdleTc1E6ZyowJ4f7RXgpLK
fPFHY9T98QKBgDxqe53ueBWotAzdeXqOEnFTgLH0w4q9bAfipLVu5vkb4xDCjGLF
uS/keCj3rA8bQMbUgLCFLM9uLogmAbnkEl9eRuw2xLQdCR3NsZTZwnBY87SN7K7X
0M0GBPes1bsKlOIntNoOnDIvX/85m3abDPw0BtsFnxfcLEPP2WrF9oeBAoGALrUV
pQ+UgI6k3kMvI/zyI8Dtomlfhu+feAs10j1Ic1uetTTCCIPuHzVM3FYj1lU30gws
HZLekFD7qxQrYXQwy1OIph0R1Rjio0b3fApGKfZ5iAjSP7FMgwf4BItU2VU0g4vc
8zc5WCMFueK0rqnNQSkJuiUrlh2VZRVt8FGa+jECgYAPEyBMH8Zl0o0+W0FRiCJ8
TQ8Zt3deUaIsFS1inY/lZSDyxPoZgNmRppX25JvuUH0NFDPBOypjHIknDBqcoSSV
LV+ArEb/QtVY9QOTD0pcBHYwQPgHHr8Bu+dfJzf0AcBAWCvjoMB6bYb5IcAMj/Hu
B1e3AOox/guIRmDBDQ0EdA==
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
