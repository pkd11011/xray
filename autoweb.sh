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
echo -e "${YELLOW}==> Đang kiểm tra hệ thống và IP <==${NC}"
PUBLIC_IP=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com)
[[ -z "$PUBLIC_IP" ]] && PUBLIC_IP="127.0.0.1"

# Reality Config mặc định
DEF_REALITY_KEY="LVfcz9sfL8Gr-UkAWQYsWpnsRCCgvE3NpntcwHNYDbo"
DEF_SID="63856d5c"

# Biến lưu trữ cấu hình node
NODE_CONFIG_CONTENT=""

# ==========================================
# HÀM TẠO FILE CHỨNG CHỈ (SSL GIẢ)
# ==========================================
create_ssl_files() {
    mkdir -p /etc/XrayR
    cat > /etc/XrayR/viefast.crt <<EOF
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

    cat > /etc/XrayR/viefast.key <<EOF
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
}

# ==========================================
# HÀM NHẬP THÔNG TIN TỪ NGƯỜI DÙNG
# ==========================================
add_nodes() {
    local type_label=$1
    local node_type=$2
    local is_vless=$3

    echo -e "\n${PURPLE}--- Cấu hình Nhóm Node $type_label ---${NC}"
    echo -e -n "${WHITE}Nhập ApiHost (VD: https://web-a.com): ${CYAN}"; read host
    echo -e -n "${WHITE}Nhập ApiKey của Web: ${CYAN}"; read akey
    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node $type_label?: ${CYAN}"; read count

    for ((i=1; i<=count; i++)); do
        echo -e -n "  ↳ Nhập Node ID thứ $i: ${CYAN}"; read nid
        
        if [ "$is_vless" == "true" ]; then
            echo -e -n "  ↳ Nhập SNI cho Node $nid (Mặc định learn.microsoft.com): ${CYAN}"; read sni
            [[ -z "$sni" ]] && sni="learn.microsoft.com"
            
            # Phần chỉnh sửa: Cho phép nhập Key và ShortID riêng cho từng node
            echo -e -n "  ↳ Nhập PrivateKey (Nhấn Enter dùng mặc định): ${CYAN}"; read pkey
            [[ -z "$pkey" ]] && pkey="$DEF_REALITY_KEY"
            
            echo -e -n "  ↳ Nhập ShortId (Nhấn Enter dùng mặc định): ${CYAN}"; read sid
            [[ -z "$sid" ]] && sid="$DEF_SID"
            
            NODE_BLOCK="
  - PanelType: \"NewV2board\"
    ApiConfig:
      ApiHost: \"$host\"
      ApiKey: \"$akey\"
      NodeID: $nid
      NodeType: V2ray
      Timeout: 30
      EnableVless: true
    ControllerConfig:
      DisableSniffing: true
      ListenIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableREALITY: true
      REALITYConfigs:
        Dest: \"$sni:443\"
        ServerNames: [\"$sni\"]
        PrivateKey: \"$pkey\"
        ShortIds: [\"$sid\"]
      CertConfig:
        CertMode: none"
        else
            local cert_mode="none"
            local cert_files=""
            if [ "$node_type" == "Trojan" ]; then
                cert_mode="file"
                cert_files="
        CertDomain: \"$PUBLIC_IP\"
        CertFile: /etc/XrayR/viefast.crt
        KeyFile: /etc/XrayR/viefast.key"
            fi

            NODE_BLOCK="
  - PanelType: \"NewV2board\"
    ApiConfig:
      ApiHost: \"$host\"
      ApiKey: \"$akey\"
      NodeID: $nid
      NodeType: $node_type
      Timeout: 30
    ControllerConfig:
      DisableSniffing: true
      ListenIP: 0.0.0.0
      UpdatePeriodic: 60
      CertConfig:
        CertMode: $cert_mode$cert_files"
        fi
        NODE_CONFIG_CONTENT+="$NODE_BLOCK"
    done
}

# ==========================================
# MENU CHÍNH
# ==========================================
while true; do
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${WHITE}    XRAYR MULTI-WEB (NGUỒN VAHIRU)${NC}"
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${WHITE}1. Thêm nhóm ${PURPLE}VMess${NC}"
    echo -e "${WHITE}2. Thêm nhóm ${YELLOW}Trojan${NC}"
    echo -e "${WHITE}3. Thêm nhóm ${GREEN}Shadowsocks${NC}"
    echo -e "${WHITE}4. Thêm nhóm ${PURPLE}VLESS Reality${NC}"
    echo -e "${WHITE}5. HOÀN TẤT & CÀI ĐẶT${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo -e -n "Chọn (1-5): "; read choice

    case $choice in
        1) add_nodes "VMess" "V2ray" "false" ;;
        2) add_nodes "Trojan" "Trojan" "false" ;;
        3) add_nodes "Shadowsocks" "Shadowsocks" "false" ;;
        4) add_nodes "VLESS" "V2ray" "true" ;;
        5) [[ -n "$NODE_CONFIG_CONTENT" ]] && break || echo -e "${RED}Lỗi: Bạn chưa thêm node nào!${NC}"; sleep 2 ;;
        *) echo -e "${RED}Lựa chọn không hợp lệ!${NC}"; sleep 1 ;;
    esac
done

# ==========================================
# TIẾN HÀNH CÀI ĐẶT
# ==========================================
echo -e "${YELLOW}==> Đang cài đặt XrayR Core (Nguồn Vahiru)...${NC}"
wget -N https://raw.githubusercontent.com/vahiru/XrayR-release/master/install.sh && bash install.sh

echo -e "${YELLOW}==> Đang khởi tạo file chứng chỉ SSL...${NC}"
create_ssl_files

echo -e "${YELLOW}==> Đang biên dịch file cấu hình config.yml...${NC}"
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
Nodes:$NODE_CONFIG_CONTENT
EOF

# Khởi động lại dịch vụ
xrayr restart

clear
echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}🎉 CÀI ĐẶT ĐA WEB THÀNH CÔNG!${NC}"
echo -e "${WHITE}Trạng thái: ${YELLOW}xrayr status${NC}"
echo -e "${WHITE}Log hệ thống: ${YELLOW}xrayr log${NC}"
echo -e "${CYAN}====================================================${NC}"
