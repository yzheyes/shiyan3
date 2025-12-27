#!/bin/bash
# 提取实验一数据

echo "=== 提取实验一数据 ==="

# 函数：提取单个文件的数据
extract_data() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "N/A N/A N/A N/A N/A N/A N/A"
        return
    fi
    
    local eff=$(grep "Efficiency" "$file" | grep -oP '\d+(?=%)')
    local p0_sent=$(grep -A 15 "Process 0:" "$file" | grep "Total data frames sent:" | awk '{print $NF}')
    local p1_sent=$(grep -A 15 "Process 1:" "$file" | grep "Total data frames sent:" | awk '{print $NF}')
    local p0_retrans=$(grep -A 15 "Process 0:" "$file" | grep "Frames retransmitted:" | awk '{print $NF}')
    local p1_retrans=$(grep -A 15 "Process 1:" "$file" | grep "Frames retransmitted:" | awk '{print $NF}')
    local p0_payload=$(grep -A 15 "Process 0:" "$file" | grep "Payloads accepted:" | awk '{print $NF}')
    local p1_payload=$(grep -A 15 "Process 1:" "$file" | grep "Payloads accepted:" | awk '{print $NF}')
    local p0_timeout=$(grep -A 15 "Process 0:" "$file" | grep "Timeouts:" | awk '{print $NF}')
    local p1_timeout=$(grep -A 15 "Process 1:" "$file" | grep "Timeouts:" | awk '{print $NF}')
    local p0_lost=$(grep -A 15 "Process 0:" "$file" | grep "Data frames lost:" | awk '{print $NF}')
    local p1_lost=$(grep -A 15 "Process 1:" "$file" | grep "Data frames lost:" | awk '{print $NF}')
    local p0_bad=$(grep -A 15 "Process 0:" "$file" | grep "Bad data frames rec'd:" | awk '{print $NF}')
    local p1_bad=$(grep -A 15 "Process 1:" "$file" | grep "Bad data frames rec'd:" | awk '{print $NF}')
    
    local total_sent=$((p0_sent + p1_sent))
    local total_retrans=$((p0_retrans + p1_retrans))
    local total_payload=$((p0_payload + p1_payload))
    local total_timeout=$((p0_timeout + p1_timeout))
    local total_lost=$((p0_lost + p1_lost))
    local total_bad=$((p0_bad + p1_bad))
    
    echo "$eff $total_sent $total_payload $total_retrans $total_timeout $total_lost $total_bad"
}

# 实验组A：超时间隔
echo ""
echo "=== 实验组A：超时间隔实验数据 ==="
printf "%-10s %-8s %-10s %-12s %-10s %-10s %-8s %-8s\n" \
    "超时间隔" "效率(%)" "发送帧数" "接受载荷数" "重传帧数" "超时次数" "丢包数" "坏帧数"
echo "--------------------------------------------------------------------------------"

for timeout in 20 30 40 50 60 80 100 120 150; do
    data=$(extract_data "exp1_results/A_timeout_${timeout}.txt")
    printf "%-10s %-8s %-10s %-12s %-10s %-10s %-8s %-8s\n" \
        "$timeout" $data
done

# 实验组B：丢包率
echo ""
echo "=== 实验组B：丢包率实验数据 ==="
printf "%-8s %-8s %-10s %-12s %-10s %-10s %-8s %-8s\n" \
    "丢包率" "效率(%)" "发送帧数" "接受载荷数" "重传帧数" "超时次数" "丢包数" "坏帧数"
echo "--------------------------------------------------------------------------------"

for loss in 0 5 10 15 20 25 30; do
    data=$(extract_data "exp1_results/B_loss_${loss}.txt")
    printf "%-8s %-8s %-10s %-12s %-10s %-10s %-8s %-8s\n" \
        "${loss}%" $data
done

# 实验组C：校验和错误率
echo ""
echo "=== 实验组C：校验和错误率实验数据 ==="
printf "%-14s %-8s %-10s %-12s %-10s %-10s %-8s %-8s\n" \
    "校验和错误率" "效率(%)" "发送帧数" "接受载荷数" "重传帧数" "超时次数" "丢包数" "坏帧数"
echo "--------------------------------------------------------------------------------"

for cksum in 0 5 10 15 20 25; do
    data=$(extract_data "exp1_results/C_cksum_${cksum}.txt")
    printf "%-14s %-8s %-10s %-12s %-10s %-10s %-8s %-8s\n" \
        "${cksum}%" $data
done

echo ""
echo "数据提取完成！"
