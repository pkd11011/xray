#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Current folder
cur_dir=$(pwd)
# Color
red='\033[0;31m'
green='\033[0;32m'
#yellow='\033[0;33m'
plain='\033[0m'
operation=(Install Update UpdateConfig logs restart delete)
# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] Chưa vào root kìa !, vui lòng xin phép ROOT trước!" && exit 1

#Check system
check_sys() {
  local checkType=$1
  local value=$2
  local release=''
  local systemPackage=''

  if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
  elif grep -Eqi "debian|raspbian" /etc/issue; then
    release="debian"
    systemPackage="apt"
  elif grep -Eqi "ubuntu" /etc/issue; then
    release="ubuntu"
    systemPackage="apt"
  elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
    release="centos"
    systemPackage="yum"
  elif grep -Eqi "debian|raspbian" /proc/version; then
    release="debian"
    systemPackage="apt"
  elif grep -Eqi "ubuntu" /proc/version; then
    release="ubuntu"
    systemPackage="apt"
  elif grep -Eqi "centos|red hat|redhat" /proc/version; then
    release="centos"
    systemPackage="yum"
  fi

  if [[ "${checkType}" == "sysRelease" ]]; then
    if [ "${value}" == "${release}" ]; then
      return 0
    else
      return 1
    fi
  elif [[ "${checkType}" == "packageManager" ]]; then
    if [ "${value}" == "${systemPackage}" ]; then
      return 0
    else
      return 1
    fi
  fi
}

# Get version
getversion() {
  if [[ -s /etc/redhat-release ]]; then
    grep -oE "[0-9.]+" /etc/redhat-release
  else
    grep -oE "[0-9.]+" /etc/issue
  fi
}

# CentOS version
centosversion() {
  if check_sys sysRelease centos; then
    local code=$1
    local version="$(getversion)"
    local main_ver=${version%%.*}
    if [ "$main_ver" == "$code" ]; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

get_char() {
  SAVEDSTTY=$(stty -g)
  stty -echo
  stty cbreak
  dd if=/dev/tty bs=1 count=1 2>/dev/null
  stty -raw
  stty echo
  stty $SAVEDSTTY
}
error_detect_depends() {
  local command=$1
  local depend=$(echo "${command}" | awk '{print $4}')
  echo -e "[${green}Info${plain}] Bắt đầu cài đặt các gói ${depend}"
  ${command} >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "[${red}Error${plain}] Cài đặt gói không thành công ${red}${depend}${plain}"
    exit 1
  fi
}

# Pre-installation settings
pre_install_docker_compose() {
    read -p "Nhập Node ID port 443 :" node_443
    echo -e "Node_80 là : ${node_443}"

    read -p "Nhập subdomain hoặc ip vps vpn cho port443:" CertDomain443
    echo -e "CertDomain port 443 là = ${CertDomain}"
}

# Config docker
config_docker() {
  cd ${cur_dir} || exit
  echo "Bắt đầu cài đặt các gói"
  install_dependencies
  echo "Tải tệp cấu hình DOCKER"
  cat >docker-compose.yml <<EOF
version: '3'
services: 
  xrayr: 
    image: ghcr.io/xrayr-project/xrayr:latest
    volumes:
      - ./config.yml:/etc/XrayR/config.yml
      - ./dns.json:/etc/XrayR/dns.json
      - ./crt.crt:/etc/XrayR/crt.crt
      - ./key.key:/etc/XrayR/key.key
    restart: always
    network_mode: host
    
EOF
  cat >dns.json <<EOF
{
    "servers": [
        "1.1.1.1",
        "8.8.8.8",
        "localhost"
    ],
    "tag": "dns_inbound"
}
EOF
  cat >key.key <<EOF
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
  cat >crt.crt <<EOF
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
  cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # ./access.Log
  ErrorPath: # ./error.log
DnsConfigPath: # ./dns.json Path to dns config
ConnetionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 864 # Connection idle time limit, Second
  UplinkOnly: 20 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 40 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel
    ApiConfig:
      ApiHost: "https://daily4g.com"
      ApiKey: "daily4gsieure.site"
      NodeID: $node_443
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan
      Timeout: 10 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # ./rulelist Path to local arulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableUploadTraffic: false # Disable Upload Traffic to the panel
      DisableGetRule: false # Disable Get Rule from the panel
      DisableIVCheck: false # Disable the anti-reply protection for Shadowsocks
      DisableSniffing: true # Disable domain sniffing 
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI:  # TLS SNI(Server Name Indication), Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$CertDomain443" # Domain to cert
        CertFile: /etc/XrayR/crt.crt
        KeyFile: /etc/XrayR/key.key
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: aaa
          CLOUDFLARE_API_KEY: bbb
EOF

}

# Install docker and docker compose
install_docker() {
  echo -e "bắt đầu cài đặt DOCKER "
 sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
systemctl enable docker
  echo -e "bắt đầu cài đặt Docker Compose "
curl -fsSL https://get.docker.com | bash -s docker
curl -L "https://github.com/docker/compose/releases/download/1.26.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
  echo "khởi động Docker "
  service docker start
  echo "khởi động Docker-Compose "
  docker-compose up -d
  echo
  echo -e "Đã hoàn tất cài đặt phụ trợ ！"
  echo -e "0 0 */3 * *  cd /root/${cur_dir} && /usr/local/bin/docker-compose pull && /usr/local/bin/docker-compose up -d" >>/etc/crontab
  echo -e "Cài đặt cập nhật thời gian kết thúc đã hoàn tất! hệ thống sẽ update sau [${green}24H${plain}] Từ lúc bạn cài đặt"
}

install_check() {
  if check_sys packageManager yum || check_sys packageManager apt; then
    if centosversion 5; then
      return 1
    fi
    return 0
  else
    return 1
  fi
}

install_dependencies() {
  if check_sys packageManager yum; then
    echo -e "[${green}Info${plain}] Kiểm tra kho EPEL ..."
    if [ ! -f /etc/yum.repos.d/epel.repo ]; then
      yum install -y epel-release >/dev/null 2>&1
    fi
    [ ! -f /etc/yum.repos.d/epel.repo ] && echo -e "[${red}Error${plain}] Không cài đặt được kho EPEL, vui lòng kiểm tra." && exit 1
    [ ! "$(command -v yum-config-manager)" ] && yum install -y yum-utils >/dev/null 2>&1
    [ x"$(yum-config-manager epel | grep -w enabled | awk '{print $3}')" != x"True" ] && yum-config-manager --enable epel >/dev/null 2>&1
    echo -e "[${green}Info${plain}] Kiểm tra xem kho lưu trữ EPEL đã hoàn tất chưa ..."

    yum_depends=(
      curl
    )
    for depend in ${yum_depends[@]}; do
      error_detect_depends "yum -y install ${depend}"
    done
  elif check_sys packageManager apt; then
    apt_depends=(
      curl
    )
    apt-get -y update
    for depend in ${apt_depends[@]}; do
      error_detect_depends "apt-get -y install ${depend}"
    done
  fi
  echo -e "[${green}Info${plain}] Đặt múi giờ thành phố Hà Nội GTM+7"
  ln -sf /usr/share/zoneinfo/Asia/Hanoi  /etc/localtime
  date -s "$(curl -sI g.cn | grep Date | cut -d' ' -f3-6)Z"

}

#update_image
Update_xrayr() {
  cd ${cur_dir}
  echo "Tải Plugin DOCKER"
  docker-compose pull
  echo "Bắt đầu chạy dịch vụ DOCKER"
  docker-compose up -d
}

#show last 100 line log

logs_xrayr() {
  echo "nhật ký chạy sẽ được hiển thị"
  docker-compose logs --tail 100
}

# Update config
UpdateConfig_xrayr() {
  cd ${cur_dir}
  echo "đóng dịch vụ hiện tại"
  docker-compose down
  pre_install_docker_compose
  config_docker
  echo "Bắt đầu chạy dịch vụ DOKCER"
  docker-compose up -d
}

restart_xrayr() {
  cd ${cur_dir}
  docker-compose down
  docker-compose up -d
  echo "Khởi động lại thành công!"
}
delete_xrayr() {
  cd ${cur_dir}
  docker-compose down
  cd ~
  rm -Rf ${cur_dir}
  echo "đã xóa thành công!"
}
# Install xrayr
Install_xrayr() {
  pre_install_docker_compose
  config_docker
  install_docker
}

# Initialization step
clear
while true; do
  echo "Vui lòng nhập một số để Thực Hiện Câu Lệnh:"
  for ((i = 1; i <= ${#operation[@]}; i++)); do
    hint="${operation[$i - 1]}"
    echo -e "${green}${i}${plain}) ${hint}"
  done
  read -p "Vui lòng chọn một số và nhấn Enter (Enter theo mặc định ${operation[0]}):" selected
  [ -z "${selected}" ] && selected="1"
  case "${selected}" in
  1 | 2 | 3 | 4 | 5 | 6 | 7)
    echo
    echo "Bắt Đầu : ${operation[${selected} - 1]}"
    echo
    ${operation[${selected} - 1]}_xrayr
    break
    ;;
  *)
    echo -e "[${red}Error${plain}] Vui lòng nhập số chính xác [1-6]"
    ;;
  esac

done
