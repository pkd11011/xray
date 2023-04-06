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
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAupBJh7xJqNKU
UDZtd0MinKIdWu91TTdi8wR1Awl6VUYianyTZ0WJZkgDstgiaZgF9rZGM4GbTr/W
ZqpzwdXUPIlLdWKqJ1qIwXRNI7QgRA0Nu6v888uyuFN5tGh7lFe8CiiRjgvfMkqj
ciA3z68jVZo/FQ4fOoUUkkDllm6471rNJNE5cwRnMRHkv383biMs5JCrA8aLxJfQ
4xZDXv21Ur4HCuGQYCRAuiQs+uOv6o+0ASFza1IpqL824caejvxZ/KYy+o2RMXJe
XH1kgNaRMvZOgN5wwM7JHIbyBUeIJpoKhBEVcbE6hol7MWjdnsjyUy0bgpoTX3lN
0U4hwEIHAgMBAAECggEAXYzRh9eapjiLytEqsjTvQgg8yrn+vPYXufCTS8cHHTny
Ordss9IvlzOuJhl0PzP5Rn/MV0QeF8iAZu5bs6e1hvlBfX7DvysuD26z6NO5VeYi
XfWoVLb0O9KsNknDY6UMdyqJKaoFCjirsS2vBNhLP4AISLGMMs1hlqwtUyQTp7Ex
42UXDcErk47y4+qj4jlcXgen3MVkTPiyRZ2M9WKz11ZaZatWaF7scBRYWWAkn7my
9hbTk/sLmcMVgKLED6qA3VWF6aEBSTu8UBBQxCZ5I+kpyXpgzqI81PmCk1UAzerE
xAPOL4M2Es/s9OPAfF6L4Ol8KbZ73OXEHVkZ8fnKgQKBgQD9ZW1CFhC/uihJV/D4
ynZTfMmzntKZ6WTII40kP0IVdynAiqStkGoPYWMUQ2w2j0JlXFeHp7gDGdlyJ8Ov
qyU/yAI5FlkGeRcdWZKrsMLm0tpKSApRtiFUtDU/34zCnTyTpNPRQCvwCZ332QAc
/e178JvcO17Ec+2R8Xhgrx4ggQKBgQDCtYw0Q5+9XnmwW0lrKonrUc4l/3ibR3Vv
yi3WJf7GoORkaHS0NJSf/vTAag3n3uMK8GuHoE/Vj0BBmxeIkIvPHuzmi8MjbNV0
OWCKVHiHgaaBP4WZn/cvkavxlwHCL+uJU4JBvu4ARDO+3ZCL5NnIAfFH4IA8+Pq0
m94peg4ehwKBgHVS6OuYW9jp0I1k8mW/GFo/hQRtnQU2Uzt3eno179sQeXx0tRrH
qtPEO6O+M/RvEEbuInjk5wZIia2ZS7mifHSznpPgDQg6OMGWH5rvFM7bAccy49RB
h904Mw+H6hyRwOJ7hrd0BuP1D/cZujuyNqsUFJY7xv0ez/iq3Rmm+0QBAoGBALRA
m9Y6kGQgVSl1qSdDz0CBkAXPVtjxs39VPU/WBuHdSvLFXN0DHGBuCCklRVBWH/wd
jH6XY7ECF+tkZ8nufu+04n2f/3wJIiahg4UsJBTWas2Wf9kzpQNtqS9Tq7YY5MVS
APFajzzB5uGYfltz9kVZvwPaiv1nRbjz3xyouO97AoGATLF977IoBHN1FppkUrf0
Mh7ZAXkgxJWgra5d+kZT4bab5mux6Un4u6JqBqFcB4zFQNgr3iks2iVXTwWjZoIe
i5TSlPpJjjIc7aUrLV8arMgiqKR9VtgFenrW1oPOUlQGO/cEPrnXmywxEintLz/y
6KB71ToWcccLD0pM7aZmolg=
-----END PRIVATE KEY-----
EOF
  cat >crt.crt <<EOF
-----BEGIN CERTIFICATE-----
MIIEojCCA4qgAwIBAgIUeC7p5QpyQktsRP0WsuIMjr6dleEwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTIzMDQwNjE0MDYwMFoXDTI0MDQwNTE0MDYwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwLqQSYe8SajSlFA2bXdDIpyiHVrvdU03YvME
dQMJelVGImp8k2dFiWZIA7LYImmYBfa2RjOBm06/1maqc8HV1DyJS3ViqidaiMF0
TSO0IEQNDbur/PPLsrhTebRoe5RXvAookY4L3zJKo3IgN8+vI1WaPxUOHzqFFJJA
5ZZuuO9azSTROXMEZzER5L9/N24jLOSQqwPGi8SX0OMWQ179tVK+BwrhkGAkQLok
LPrjr+qPtAEhc2tSKai/NuHGno78WfymMvqNkTFyXlx9ZIDWkTL2ToDecMDOyRyG
8gVHiCaaCoQRFXGxOoaJezFo3Z7I8lMtG4KaE195TdFOIcBCBwIDAQABo4IBJDCC
ASAwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSJDfvBh/FMngI5mJjoTyzyT8jUNTAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAlBgNVHREEHjAcgg0qLmRhaWx5NGcuY29tggtkYWlseTRnLmNvbTA4BgNVHR8E
MTAvMC2gK6AphidodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdpbl9jYS5j
cmwwDQYJKoZIhvcNAQELBQADggEBAB35irWnAy6yt23S7yh1PSGLRPlfPUidNUKY
FW+TdA9rgPMbMkqZzLKwPXVz6N7Wio/8y2iD4k40ZUesBa22zMy7GDtLxWxBJrfc
o5C1VaroKmTC1ZIMi5lz3oUAaHo1aCfsRWPSJDLc6xj+qIn8akZHevCI6NfLYSYi
IAW3VsRSADT7R81YHgCUTczilSbwfpqWgkAjwZXOUP1Ymzbdugm2LJprwHobhXJZ
i9EPyoinfJ/lXkJ8EHQn+y6XgCzD0IgCSBmfJuO9jk4dAHvG3m0DceyfV6f2AcIW
ovgXHfPFu+LknfAiUxR/A+RdYpqLGKOJ/Q1naomnOVoTZ0dHtj8=
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
