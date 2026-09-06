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
[ -z "$PUBLIC_IP" ] && PUBLIC_IP="127.0.0.1"
sleep 1
clear

# ==========================================
# KHAI BÁO PANEL (WEB QUẢN LÝ) - NHẬP ĐỘNG
# ==========================================
# Mỗi phần tử lưu dạng: "Tên hiển thị|ApiHost|ApiKey|RealityKey|SID|DefaultSNI|HoTroVless(yes/no)"
panels=()

add_panel() {
    echo -e "${WHITE}--- Thêm Web/Panel quản lý mới ---${NC}"
    echo -e -n "${WHITE} ↳ Tên gợi nhớ (VD: kingcloud): ${CYAN}"; read p_name
    echo -e -n "${WHITE} ↳ ApiHost (VD: https://kingcloud.click): ${CYAN}"; read p_host
    echo -e -n "${WHITE} ↳ ApiKey: ${CYAN}"; read p_key

    echo -e -n "${WHITE} ↳ Panel này có hỗ trợ VLESS Reality không? (y/n): ${CYAN}"; read p_vless_support
    p_vless_support=$(echo "$p_vless_support" | tr '[:upper:]' '[:lower:]')

    p_reality_key=""
    p_sid=""
    p_sni="www.apple.com"
    if [ "$p_vless_support" == "y" ]; then
        echo -e -n "${WHITE} ↳ Reality Private Key: ${CYAN}"; read p_reality_key
        echo -e -n "${WHITE} ↳ Short ID (SID): ${CYAN}"; read p_sid
        echo -e -n "${WHITE} ↳ SNI mặc định ${YELLOW}(Enter = www.apple.com)${WHITE}: ${CYAN}"; read p_sni_input
        [ -n "$p_sni_input" ] && p_sni="$p_sni_input"
    fi

    [ -z "$p_name" ] && p_name="panel${#panels[@]}"

    panels+=("${p_name}|${p_host}|${p_key}|${p_reality_key}|${p_sid}|${p_sni}|${p_vless_support}")
    echo -e "${GREEN}✔ Đã thêm panel: ${p_name}${NC}"
    echo -e "${NC}--------------------------"
}

setup_panels() {
    while true; do
        add_panel
        echo -e -n "${WHITE}Thêm panel khác không? (y/n): ${CYAN}"; read more
        more=$(echo "$more" | tr '[:upper:]' '[:lower:]')
        [ "$more" != "y" ] && break
    done

    if [ "${#panels[@]}" -eq 0 ]; then
        echo -e "${RED}❌ Bạn chưa khai báo panel nào, không thể tiếp tục!${NC}"
        exit 1
    fi
}

# Trả về thông tin panel theo index (1-based) vào các biến CUR_*
set_api_info() {
    local idx=$1
    local arr_idx=$((idx - 1))
    IFS='|' read -r CUR_NAME CUR_API_HOST CUR_API_KEY CUR_REALITY_KEY CUR_SID DEFAULT_SNI CUR_VLESS_SUPPORT <<< "${panels[$arr_idx]}"
}

show_web_menu() {
    echo -e "${WHITE}Chọn Web/Panel quản lý:${NC}"
    local i=1
    for p in "${panels[@]}"; do
        IFS='|' read -r p_name _ _ _ _ _ _ <<< "$p"
        echo -e "  ${PURPLE}${i}.${NC} ${p_name}"
        ((i++))
    done
}

show_vless_web_menu() {
    echo -e "${WHITE}Chọn Web/Panel quản lý (chỉ hiện panel hỗ trợ VLESS):${NC}"
    local i=1
    for p in "${panels[@]}"; do
        IFS='|' read -r p_name _ _ _ _ _ p_support <<< "$p"
        if [ "$p_support" == "y" ]; then
            echo -e "  ${PURPLE}${i}.${NC} ${p_name}"
        fi
        ((i++))
    done
}

is_panel_valid() {
    local idx=$1
    [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le "${#panels[@]}" ]
}

is_panel_vless_capable() {
    local idx=$1
    is_panel_valid "$idx" || return 1
    local arr_idx=$((idx - 1))
    IFS='|' read -r _ _ _ _ _ _ p_support <<< "${panels[$arr_idx]}"
    [ "$p_support" == "y" ]
}

# ==========================================
# HÀM HỎI THÔNG TIN NODE (GỘP CHUNG, DÙNG LẠI CHO MỌI GIAO THỨC)
# ==========================================
vmess_nodes=()
trojan_nodes=()
ss_nodes=()
vless_nodes=()
hysteria_nodes=()

# ask_generic_nodes <TenGiaoThuc> <MauSac> <ten_bien_mang_ket_qua>
ask_generic_nodes() {
    local proto_label="$1"
    local color="$2"
    local -n out_array="$3"

    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node ${color}${proto_label}${WHITE}? : ${CYAN}"
    read count
    for ((i=1; i<=count; i++)); do
        echo -e "${NC}--- Cấu hình ${proto_label} thứ $i ---"
        show_web_menu
        local w
        while true; do
            echo -e -n "${WHITE} ↳ Chọn số panel: ${CYAN}"; read w
            if is_panel_valid "$w"; then
                break
            else
                echo -e "${RED}❌ Số panel không hợp lệ, vui lòng chọn lại!${NC}"
            fi
        done
        echo -e -n "${WHITE} ↳ Nhập Node ID: ${CYAN}"; read id
        if [ -n "$id" ]; then out_array+=("$w|$id"); fi
    done
    echo -e "${NC}--------------------------"
}

ask_vmess()    { ask_generic_nodes "VMess"       "${PURPLE}" vmess_nodes; }
ask_trojan()   { ask_generic_nodes "Trojan"      "${YELLOW}" trojan_nodes; }
ask_ss()       { ask_generic_nodes "Shadowsocks" "${GREEN}"  ss_nodes; }
ask_hysteria() { ask_generic_nodes "Hysteria 2"  "${CYAN}"   hysteria_nodes; }

ask_vless() {
    echo -e -n "${WHITE}Bạn muốn cài bao nhiêu node ${PURPLE}VLESS (Reality)${WHITE}? : ${CYAN}"
    read count
    for ((i=1; i<=count; i++)); do
        echo -e "${NC}--- Cấu hình VLESS thứ $i ---"

        while true; do
            show_vless_web_menu
            echo -e -n "${WHITE} ↳ Chọn số panel: ${CYAN}"; read w
            if is_panel_vless_capable "$w"; then
                break
            else
                echo -e "${RED}❌ Panel bạn chọn không hợp lệ hoặc chưa hỗ trợ VLESS. Vui lòng chọn lại!${NC}"
            fi
        done

        echo -e -n "${WHITE} ↳ Nhập Node ID: ${CYAN}"; read id

        set_api_info "$w"

        echo -e -n "${WHITE} ↳ Nhập SNI ${YELLOW}(Enter để mặc định $DEFAULT_SNI)${WHITE}: ${CYAN}"; read sni
        if [ -z "$sni" ]; then sni="$DEFAULT_SNI"; fi

        if [ -n "$id" ]; then vless_nodes+=("$w|$id|$sni"); fi
    done
    echo -e "${NC}--------------------------"
}

# ==========================================
# BƯỚC 1: KHAI BÁO CÁC PANEL TRƯỚC
# ==========================================
echo -e "${YELLOW}=== BƯỚC 1: KHAI BÁO WEB / PANEL QUẢN LÝ ===${NC}"
setup_panels
clear

# ==========================================
# MENU LỰA CHỌN TỔNG
# ==========================================
while true; do
    vmess_nodes=()
    trojan_nodes=()
    ss_nodes=()
    vless_nodes=()
    hysteria_nodes=()

    echo -e "${WHITE}CHỌN COMBO GIAO THỨC CHO ${YELLOW}VieWarp${WHITE}:"
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
    echo -e "${PURPLE} 13.${WHITE} Chỉ chạy ${CYAN}Hysteria 2"
    echo -e "${PURPLE} 14.${WHITE} ${PURPLE}VMess${WHITE} & ${YELLOW}Trojan${WHITE} & ${PURPLE}VLESS${WHITE} & ${CYAN}Hysteria 2"
    echo -e "${PURPLE} 15.${WHITE} ${YELLOW}Trojan${WHITE} & ${PURPLE}VLESS${WHITE} & ${CYAN}Hysteria 2"
    echo -e "${PURPLE} 16.${WHITE} ${PURPLE}VLESS${WHITE} & ${CYAN}Hysteria 2"
    echo -e "${PURPLE} 17.${WHITE} ${YELLOW}Trojan${WHITE} & ${CYAN}Hysteria 2"
    echo "--------------------------"
    echo -e -n "${WHITE}Nhập lựa chọn của bạn (1-17): ${CYAN}"
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
        13) ask_hysteria ;;
        14) ask_vmess; ask_trojan; ask_vless; ask_hysteria ;;
        15) ask_trojan; ask_vless; ask_hysteria ;;
        16) ask_vless; ask_hysteria ;;
        17) ask_trojan; ask_hysteria ;;
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
# CÀI ĐẶT CORE VIEWARP
# ==========================================
echo -e "${GREEN}==> Đang cài đặt VieWarp Core...${NC}"
wget -qO /tmp/install.sh https://raw.githubusercontent.com/khuuvandoan/VieFast/main/install.sh
bash /tmp/install.sh || true

BINARY=$(find /usr/local/viewarp -type f \( -name "xrayr" -o -name "XrayR" -o -name "*xray*" \) -executable 2>/dev/null | head -n 1)

if [ -z "$BINARY" ]; then
    echo -e "${RED}❌ Không tìm thấy file thực thi (binary)!${NC}"
    exit 1
fi

chmod +x "$BINARY"
echo -e "${GREEN}✔ Đã tìm thấy và cấp quyền cho binary: ${CYAN}$BINARY${NC}"

# ==========================================
# TẠO CHỨNG CHỈ SSL FAKE
# ==========================================
echo -e "${GREEN}==> Đang tạo chứng chỉ SSL ảo (viefast.crt / viefast.key)...${NC}"
mkdir -p /etc/viewarp

cat > /etc/viewarp/viefast.crt << "EOF"
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

cat > /etc/viewarp/viefast.key << "EOF"
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
# KHỞI TẠO FILE CHẶN SPEEDTEST & TORRENT
# ==========================================
echo -e "${GREEN}==> Đang tạo bộ lọc chặn Speedtest và Torrent (Bản Nâng Cao)...${NC}"
cat > /etc/viewarp/rulelist << "EOF"
# Chặn Speedtest (Quốc tế & Việt Nam)
speedtest
fast.com
speed.cloudflare.com
nperf.com
speedtest.vn
openspeedtest.com
speed.io

# Chặn Keyword giao thức Torrent / P2P
bittorrent
torrent
tracker
announce
peer_id
info_hash
get_peers
find_node
magnet
bt_

# Chặn các trang web chia sẻ Torrent lớn (Phòng DMCA AWS/DigitalOcean)
thepiratebay
1337x
nyaa
rutracker
yts
rarbg
eztv
EOF

# ==========================================
# KHỞI TẠO FILE CONFIG.YML ĐỘNG (DYNAMIC)
# ==========================================
echo -e "${GREEN}==> Đang biên dịch config.yml theo cấu hình Web và Node...${NC}"

cat > /etc/viewarp/config.yml <<EOF
Log:
  Level: none
  AccessPath: # /etc/viewarp/access.Log
  ErrorPath: # /etc/viewarp/error.log
DnsConfigPath: # /etc/viewarp/dns.json
RouteConfigPath: # /etc/viewarp/route.json
InboundConfigPath: # /etc/viewarp/custom_inbound.json
OutboundConfigPath: # /etc/viewarp/custom_outbound.json
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
cat >> /etc/viewarp/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: V2ray
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 150
      DeviceLimit: 0
      RuleListPath: /etc/viewarp/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 30
        WarnTimes: 0
        LimitSpeed: 30
        LimitDuration: 60
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
cat >> /etc/viewarp/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: Trojan
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 150
      DeviceLimit: 0
      RuleListPath: /etc/viewarp/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 30
        WarnTimes: 0
        LimitSpeed: 30
        LimitDuration: 60
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
        CertFile: /etc/viewarp/viefast.crt
        KeyFile: /etc/viewarp/viefast.key
        Provider: cloudflare
EOF
done

# -- TẠO NODE SHADOWSOCKS --
for item in "${ss_nodes[@]}"; do
    w=$(echo "$item" | cut -d'|' -f1)
    id=$(echo "$item" | cut -d'|' -f2)
    set_api_info "$w"
cat >> /etc/viewarp/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: Shadowsocks
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 150
      DeviceLimit: 0
      RuleListPath: /etc/viewarp/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 30
        WarnTimes: 0
        LimitSpeed: 30
        LimitDuration: 60
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
cat >> /etc/viewarp/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: V2ray
      EnableVless: true
      EnableXTLS: false
      Timeout: 30
      SpeedLimit: 150
      DeviceLimit: 0
      RuleListPath: /etc/viewarp/rulelist
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
        Limit: 30
        WarnTimes: 0
        LimitSpeed: 30
        LimitDuration: 60
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

# -- TẠO NODE HYSTERIA 2 --
for item in "${hysteria_nodes[@]}"; do
    w=$(echo "$item" | cut -d'|' -f1)
    id=$(echo "$item" | cut -d'|' -f2)
    set_api_info "$w"
cat >> /etc/viewarp/config.yml <<EOF
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "${CUR_API_HOST}"
      ApiKey: "${CUR_API_KEY}"
      NodeID: ${id}
      NodeType: Hysteria2
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 150
      DeviceLimit: 0
      RuleListPath: /etc/viewarp/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 30
        WarnTimes: 0
        LimitSpeed: 30
        LimitDuration: 60
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
        CertFile: /etc/viewarp/viefast.crt
        KeyFile: /etc/viewarp/viefast.key
        Provider: cloudflare
EOF
done

# ==========================================
# KHỞI TẠO SYSTEMD VÀ HOÀN TẤT
# ==========================================
echo -e "${GREEN}==> Đang thiết lập Systemd Service...${NC}"
cat > /etc/systemd/system/viewarp.service <<EOF
[Unit]
Description=VieWarp Service
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/viewarp
ExecStart=${BINARY} -c /etc/viewarp/config.yml
Restart=always
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}==> Đang khởi động lại dịch vụ VieWarp...${NC}"
systemctl daemon-reload
systemctl enable viewarp
systemctl restart viewarp

# ==========================================
# KHÓA CỔNG 8080 (CHẶN TẬN GỐC SPEEDTEST)
# ==========================================
echo -e "${GREEN}==> Đang khóa cổng 8080 chặn Speedtest cấp độ mạng...${NC}"
iptables -D OUTPUT -p tcp --dport 8080 -j REJECT 2>/dev/null
iptables -D OUTPUT -p udp --dport 8080 -j REJECT 2>/dev/null
iptables -A OUTPUT -p tcp --dport 8080 -j REJECT
iptables -A OUTPUT -p udp --dport 8080 -j REJECT

DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent netfilter-persistent >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
echo -e "${GREEN}✔ Đã khóa thành công port 8080.${NC}"

sleep 2

clear
echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}🎉 CÀI ĐẶT HOÀN TẤT! CÁC NODE CỦA BẠN ĐÃ LÊN HÌNH.${NC}"
echo -e "${WHITE}Mở Menu Quản Lý: ${YELLOW}viewarp${NC}"
echo -e "${WHITE}Xem Trạng Thái Systemd: ${YELLOW}systemctl status viewarp${NC}"
echo -e "${CYAN}====================================================${NC}"

systemctl status viewarp --no-pager -l | head -n 20
