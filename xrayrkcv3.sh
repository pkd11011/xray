#!/bin/bash

# ==========================================
# KHAI BÁO MÀU SẮC
# ==========================================
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

clear
echo -e "${YELLOW}==> Đang Lấy Địa Chỉ IP Máy Chủ Của Bạn <==${NC}"
PUBLIC_IP=$(curl -s https://api.ipify.org)
[ -z "$PUBLIC_IP" ] && PUBLIC_IP=$(curl -s https://ipv4.icanhazip.com)
clear

# ==========================================
# HÀM XỬ LÝ LẤY API THEO CÁC WEB TỪ NEWV2BOARD
# ==========================================
set_api_info() {
    case $1 in
        1) 
            CUR_API_HOST="https://kingcloud.click"
            CUR_API_KEY="fdsf326s2vchrt66gb656467hgfjfyjyilmh4902du15iu" 
            ;;
        *) 
            # Mặc định an toàn
            CUR_API_HOST="https://kingcloud.click"
            CUR_API_KEY="fdsf326s2vchrt66gb656467hgfjfyjyilmh4902du15iu" 
            ;;
    esac
    
    # Dành cho Reality
    CUR_REALITY_KEY="LVfcz9sfL8Gr-UkAWQYsWpnsRCCgvE3NpntcwHNYDbo"
    CUR_SID="63856d5c"
}

vmess_nodes=()
trojan_nodes=()
ss_nodes=()
vless_nodes=()

show_web_menu() {
    echo -e "${WHITE}Chọn Web quản lý Node này:${NC}"
    echo -e "  ${PURPLE}1.${NC} kingcloud.click"
}

ask_vmess() {
    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node ${PURPLE}VMess${WHITE}? : ${CYAN}"
    read count
    for ((i=1; i<=count; i++)); do
        echo -e "${NC}--- Cấu hình VMess thứ $i ---"
        show_web_menu
        echo -e -n "${WHITE} ↳ Chọn số (1): ${CYAN}"; read w
        echo -e -n "${WHITE} ↳ Nhập Node ID: ${CYAN}"; read id
        if [ -n "$id" ]; then vmess_nodes+=("$w|$id"); fi
    done
    echo -e "${NC}--------------------------"
}

ask_trojan() {
    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node ${YELLOW}Trojan${WHITE}? : ${CYAN}"
    read count
    for ((i=1; i<=count; i++)); do
        echo -e "${NC}--- Cấu hình Trojan thứ $i ---"
        show_web_menu
        echo -e -n "${WHITE} ↳ Chọn số (1-8): ${CYAN}"; read w
        echo -e -n "${WHITE} ↳ Nhập Node ID: ${CYAN}"; read id
        if [ -n "$id" ]; then trojan_nodes+=("$w|$id"); fi
    done
    echo -e "${NC}--------------------------"
}

ask_ss() {
    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node ${GREEN}Shadowsocks${WHITE}? : ${CYAN}"
    read count
    for ((i=1; i<=count; i++)); do
        echo -e "${NC}--- Cấu hình Shadowsocks thứ $i ---"
        show_web_menu
        echo -e -n "${WHITE} ↳ Chọn số (1-8): ${CYAN}"; read w
        echo -e -n "${WHITE} ↳ Nhập Node ID: ${CYAN}"; read id
        if [ -n "$id" ]; then ss_nodes+=("$w|$id"); fi
    done
    echo -e "${NC}--------------------------"
}

ask_vless() {
    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node ${PURPLE}VLESS (Reality)${WHITE}? : ${CYAN}"
    read count
    for ((i=1; i<=count; i++)); do
        echo -e "${NC}--- Cấu hình VLESS thứ $i ---"
        show_web_menu
        echo -e -n "${WHITE} ↳ Chọn số (1-8): ${CYAN}"; read w
        echo -e -n "${WHITE} ↳ Nhập Node ID: ${CYAN}"; read id
        echo -e -n "${WHITE} ↳ Nhập SNI ${YELLOW}(Enter để mặc định learn.microsoft.com)${WHITE}: ${CYAN}"; read sni
        if [ -z "$sni" ]; then sni="learn.microsoft.com"; fi
        
        if [ -n "$id" ]; then vless_nodes+=("$w|$id|$sni"); fi
    done
    echo -e "${NC}--------------------------"
}

# ==========================================
# MENU LỰA CHỌN TỔNG
# ==========================================
while true; do
    vmess_nodes=()
    trojan_nodes=()
    ss_nodes=()
    vless_nodes=()
    
    echo -e "${WHITE}CHỌN COMBO GIAO THỨC CHO ${YELLOW}XrayR (NewV2board)${WHITE}:"
    echo -e "${PURPLE}IP Máy Chủ: ${CYAN}${PUBLIC_IP}${NC}"
    echo -e "${PURPLE}  1.${WHITE} Chỉ chạy ${YELLOW}Trojan"
    echo -e "${PURPLE}  2.${WHITE} Chỉ chạy ${PURPLE}VMess"
    echo -e "${PURPLE}  3.${WHITE} Chỉ chạy ${GREEN}Shadowsocks"
    echo -e "${PURPLE}  4.${WHITE} Chỉ chạy ${PURPLE}VLESS (Reality)"
    echo -e "${PURPLE}  5.${WHITE} ${PURPLE}VMess${WHITE} & ${YELLOW}Trojan"
    echo -e "${PURPLE}  6.${WHITE} ${PURPLE}VMess${WHITE} & ${YELLOW}Trojan${WHITE} & ${PURPLE}VLESS"
    echo -e "${PURPLE}  7.${WHITE} ${PURPLE}VMess${WHITE} & ${YELLOW}Trojan${WHITE} & ${PURPLE}VLESS${WHITE} & ${GREEN}Shadowsocks"
    echo -e "${PURPLE}  8.${WHITE} ${YELLOW}Trojan${WHITE} & ${PURPLE}VLESS${WHITE} & ${GREEN}Shadowsocks"
    echo -e "${PURPLE}  9.${WHITE} ${PURPLE}VMess${WHITE} & ${PURPLE}VLESS${WHITE} & ${GREEN}Shadowsocks"
    echo -e "${PURPLE} 10.${WHITE} ${PURPLE}VLESS${WHITE} & ${GREEN}Shadowsocks"
    echo -e "${PURPLE} 11.${WHITE} ${PURPLE}VMess${WHITE} & ${PURPLE}VLESS"
    echo -e "${PURPLE} 12.${WHITE} ${YELLOW}Trojan${WHITE} & ${PURPLE}VLESS"
    echo "--------------------------"
    echo -e -n "${WHITE}Nhập lựa chọn của bạn (1-12): ${CYAN}" 
    read choice
    echo -e "${NC}--------------------------"

    case $choice in
        1) ask_trojan ;;
        2) ask_vmess ;;
        3) ask_ss ;;
        4) ask_vless ;;
        5) ask_vmess; ask_trojan ;;
        6) ask_vmess; ask_trojan; ask_vless ;;
        7) ask_vmess; ask_trojan; ask_vless; ask_ss ;;
        8) ask_trojan; ask_vless; ask_ss ;;
        9) ask_vmess; ask_vless; ask_ss ;;
        10) ask_vless; ask_ss ;;
        11) ask_vmess; ask_vless ;;
        12) ask_trojan; ask_vless ;;
        *) echo -e "${RED}Lựa chọn không hợp lệ!${NC}"; continue ;;
    esac

    echo -e "${GREEN}Đã ghi nhận cấu hình! Bạn có muốn bắt đầu cài đặt? ${PURPLE}(Y/N)${WHITE}: ${CYAN}\c"
    read check
    check=$(echo $check | tr '[:upper:]' '[:lower:]')
    if [ "$check" == "y" ]; then
        break
    fi
    clear
done

# ==========================================
# CÀI ĐẶT CORE XRAYR VÀ CHỨNG CHỈ FAKE
# ==========================================
echo -e "${GREEN}==> Đang cài đặt XrayR Core...${NC}"
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)

echo -e "${GREEN}==> Đang tạo chứng chỉ SSL ảo (viefast.crt / viefast.key)...${NC}"
mkdir -p /etc/XrayR

cat > /etc/XrayR/viefast.crt << "EOF"
-----BEGIN CERTIFICATE-----
MIIEojCCA4qgAwIBAgIUb8N4v7Iph5HbnbTLEYW3EuVFfGcwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTI1MDcwMjAxMzkwMFoXDTQwMDYyODAxMzkwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsvcvl0hlsFqMTT0OXW2Gg4sXV2FRZd4wwTDq
cBDwILzzPjKC098MTRXnOQLq1U7kwQNaJ2LGAitRTvYpsAVaD4sQmb5WBupaM9bF
OSJMwFSDs/MD7i1UeFl8VOFu9DpfCCnXGaoxh3bqYDHrZY9qmxhEZBs3F4UsUDOa
EH2FglBQQR4bVil+5Zn4rpkf7G/G3SaFuPXFjTScfqi7E/XfIQCbWQOD/MXsmwsn
GX9dVjjTtb1ozdAWnHaR5g8o7qxnx4tZTTgEy/AY9sxbDaSHIVxQr1rUMBGz4PG0
nDxEWhpcYF4I8m+58wqxQgpncHNYwo8J/gF5Olf+9n6vp1ko5QIDAQABo4IBJDCC
ASAwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSB6QATvufn/mPZvz9LHAnZswRJ/jAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAlBgNVHREEHjAcgg0qLnZpZWZhc3QubmV0ggt2aWVmYXN0Lm5ldDA4BgNVHR8E
MTAvMC2gK6AphidodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdpbl9jYS5j
cmwwDQYJKoZIhvcNAQELBQADggEBACP/NoH9x5jhiAVqy79kRp7wAPTSJ1fzuP2+
/qd94iK4hFzHcWPn9YIGjmDSERoWZUIYp8yxHX3BzeHF42JVSNhsZKLqZlmrivYR
AZoyZ7dLEXKmViE8LuguYL9OOwXZ2cgL+I0cAEROAqojqGhDodwGvCMWwUAD3Wwm
m7DtlcusfhjoF4MpDGvklwVC6jDTs/EMBWR7g04OdN1WVQYFoMu+LAJLF/jlw7EF
7ksplTvoy/CV3ww6lrYGMooXHjJY9J0hdeccabLPFhiTnTMlFXibvShmTVVrSM/L
mWAku7hHU0rXpZi7TdWpwMZSXQ6nwTasu3GU7yagIbkyp6IIW64=
-----END CERTIFICATE-----
EOF

cat > /etc/XrayR/viefast.key << "EOF"
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCy9y+XSGWwWoxN
PQ5dbYaDixdXYVFl3jDBMOpwEPAgvPM+MoLT3wxNFec5AurVTuTBA1onYsYCK1FO
9imwBVoPixCZvlYG6loz1sU5IkzAVIOz8wPuLVR4WXxU4W70Ol8IKdcZqjGHdupg
Metlj2qbGERkGzcXhSxQM5oQfYWCUFBBHhtWKX7lmfiumR/sb8bdJoW49cWNNJx+
qLsT9d8hAJtZA4P8xeybCycZf11WONO1vWjN0BacdpHmDyjurGfHi1lNOATL8Bj2
zFsNpIchXFCvWtQwEbPg8bScPERaGlxgXgjyb7nzCrFCCmdwc1jCjwn+AXk6V/72
fq+nWSjlAgMBAAECggEAD8LgxFpKKGClHBVNO1Gux817YgTuWgIaOZ1w/CsltsBl
TLw+lOG/L9fGvBjjbSNMVqpQqYjTpvPBLqrTy46BGr7U2LFwWp4PkSKwTmKUr1iS
G8pCdZq05n99CW2sK6KrZWjn6nj4cTV6GTw0PsbFbQDTXxydersOBscwoZSoaiw6
KxZOeFEKfTemUyKrcLs5VtveTCvgtxxlpKhOCQ87TGVLJnMMnB+rZNj4gGK5snTR
Xog8jXXx+NnaYoBJ4O8vkf+6y/CZgKCrfwmaYhjUFhrPE/sQnvYeJVtA8z5ftNqL
NuFkknMjQFwEId497KtgeBU+1ayHoJVt3gYQOfx+cQKBgQDtEmDqF5Gmt1GjdSwn
MUNThEuB39yK0+aPdW7xBwklD29n4aLsBzImMkrrI5lV5FA53UXnbMdIT2lLwZ2A
/Ec+dLRys2l5NlqudCzmnGBuxbM3sNMAJ09uqSc+N5sri8v9V+lktZZQb5sEAL52
VwcmWi6AaYPzWbcRvzrmBqA+UQKBgQDBQSWktu+hK6BRdrkc5/xsVeK8nSKjMGPq
0IWBBxdm0lj9zzYk62s8FzCiRPMN7HU7oiDmh9VH1wLzhHOXPNn9U81Lzx0hx2he
fgFyhr8AwOzfnAwe27IcFK2V5UZRUFdC3EvnkBp7SdSrzr887/uQoN/hnXpfHj6v
TMHiy+b4VQKBgE8HXGVM/BHedImP6usZwf7aUC14SdXBs89I73XLyaGgFpxDnIMg
FviitVTTZi86z/+qIr52Bay2RDyry2yPLNTGJM1Dv7pXgz06nyk1IfRrVUYQXRZl
BFa4bsuPz9thW9wVbUlUO0qPGdboxJVAh7KiR3QpOIJr+togrGq39L0xAoGBAJBB
KPBC/ay4+/rTPGqvYGUd1xoj0W8u9+aXsJAX0wgVjAgpXKlCcdFxHgSCo0uJbhkN
dLGgQzxU6wcLn50M90t5+ozUFVLZnraqKDptCrZtTGO9/+4o4FLFvK1fb5XS+tAV
0TMRBjNxcSauNWIvYQEclQG8o1PNJ82C5ld9DPPhAoGBAMCzltfcPS83Ypyt6n+P
9TgdeXnOTZloBx2gNGXV5RcsgJp7Kbc4LcX+dFZ5y7Rh3Y2qoYeHBvRL6u8F6dhw
nHdBwY9EM70sRDlEy46opkL/YNYwmf9sH7e6um+EO8/3omjmvRF3Y6GJvapFZrm2
aGU6njQK0ycNa80Gmy0C9G1B
-----END PRIVATE KEY-----
EOF

# ==========================================
# KHỞI TẠO FILE CONFIG.YML ĐỘNG (DYNAMIC)
# ==========================================
echo -e "${GREEN}==> Đang biên dịch config.yml theo cấu hình Web và Node...${NC}"

cat > /etc/XrayR/config.yml <<EOF
Log:
  Level: none
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json
RouteConfigPath: # /etc/XrayR/route.json
InboundConfigPath: # /etc/XrayR/custom_inbound.json
OutboundConfigPath: # /etc/XrayR/custom_outbound.json
ConnectionConfig:
  Handshake: 4
  ConnIdle: 30
  UplinkOnly: 2
  DownlinkOnly: 4
  BufferSize: 64
Nodes:
EOF

# -- TẠO NODE VMESS --
for item in "${vmess_nodes[@]}"; do
    w=$(echo "$item" | cut -d'|' -f1)
    id=$(echo "$item" | cut -d'|' -f2)
    set_api_info "$w"
cat >> /etc/XrayR/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: V2ray
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 0
      DeviceLimit: 0
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisAddr: 127.0.0.1:6379
        RedisPassword: YOUR PASSWORD
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      FallBackConfigs: []
      CertConfig:
        CertMode: none
        CertDomain: "${PUBLIC_IP}"
        Provider: cloudflare
EOF
done

# -- TẠO NODE TROJAN --
for item in "${trojan_nodes[@]}"; do
    w=$(echo "$item" | cut -d'|' -f1)
    id=$(echo "$item" | cut -d'|' -f2)
    set_api_info "$w"
cat >> /etc/XrayR/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: Trojan
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 0
      DeviceLimit: 0
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisAddr: 127.0.0.1:6379
        RedisPassword: YOUR PASSWORD
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      FallBackConfigs: []
      CertConfig:
        CertMode: file
        CertDomain: "${PUBLIC_IP}"
        CertFile: /etc/XrayR/viefast.crt
        KeyFile: /etc/XrayR/viefast.key
        Provider: cloudflare
EOF
done

# -- TẠO NODE SHADOWSOCKS --
for item in "${ss_nodes[@]}"; do
    w=$(echo "$item" | cut -d'|' -f1)
    id=$(echo "$item" | cut -d'|' -f2)
    set_api_info "$w"
cat >> /etc/XrayR/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: Shadowsocks
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 0
      DeviceLimit: 0
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisAddr: 127.0.0.1:6379
        RedisPassword: YOUR PASSWORD
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      FallBackConfigs: []
      CertConfig:
        CertMode: none
        CertDomain: "${PUBLIC_IP}"
        Provider: cloudflare
EOF
done

# -- TẠO NODE VLESS REALITY --
for item in "${vless_nodes[@]}"; do
    w=$(echo "$item" | cut -d'|' -f1)
    id=$(echo "$item" | cut -d'|' -f2)
    sni=$(echo "$item" | cut -d'|' -f3)
    set_api_info "$w"
cat >> /etc/XrayR/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: V2ray
      EnableVless: true
      EnableXTLS: false
      Timeout: 30
      SpeedLimit: 0
      DeviceLimit: 0
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      DisableSniffing: true
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      EnableREALITY: true
      DisableLocalREALITYConfig: false
      REALITYConfigs:
        Show: false
        Dest: "${sni}:443"
        ProxyProtocolVer: 0
        ServerNames: ["${sni}"]
        PrivateKey: "${CUR_REALITY_KEY}"
        ShortIds: ["${CUR_SID}"]
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisAddr: 127.0.0.1:6379
        RedisPassword: YOUR PASSWORD
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      CertConfig:
        CertMode: none
EOF
done

# ==========================================
# KHỞI ĐỘNG VÀ HOÀN TẤT
# ==========================================
echo -e "${GREEN}==> Đang khởi động lại dịch vụ XrayR...${NC}"
cd /root
xrayr restart

clear
echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}🎉 CÀI ĐẶT HOÀN TẤT! CÁC NODE CỦA BẠN ĐÃ LÊN HÌNH.${NC}"
echo -e "${WHITE}Log hệ thống XrayR: ${YELLOW}xrayr log${NC}"
echo -e "${CYAN}====================================================${NC}"
