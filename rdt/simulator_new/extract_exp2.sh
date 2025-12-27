#!/bin/bash
# 提取实验二数据

echo "=== 实验二：协议5与协议6对比数据 ==="

# 函数：提取单个文件的数据
extract_data() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "N/A N/A N/A N/A"
        return
    fi
    
    local eff=$(grep "Efficiency" "$file" | grep -oP '\d+(?=%)')
    local p0_sent=$(grep -A 15 "Process 0:" "$file" | grep "Total data frames sent:" | awk '{print $NF}')
    local p1_sent=$(grep -A 15 "Process 1:" "$file" | grep "Total data frames sent:" | awk '{print $NF}')
    local p0_retrans=$(grep -A 15 "Process 0:" "$file" | grep "Frames retransmitted:" | awk '{print $NF}')
    local p1_retrans=$(grep -A 15 "Process 1:" "$file" | grep "Frames retransmitted:" | awk '{print $NF}')
    local p0_timeout=$(grep -A 15 "Process 0:" "$file" | grep "Timeouts:" | awk '{print $NF}')
    local p1_timeout=$(grep -A 15 "Process 1:" "$file" | grep "Timeouts:" | awk '{print $NF}')
    
    local total_sent=$((p0_sent + p1_sent))
    local total_retrans=$((p0_retrans + p1_retrans))
    local total_timeout=$((p0_timeout + p1_timeout))
    
    echo "$eff $total_retrans $total_timeout $total_sent"
}

# 实验组D：丢包率对比
echo ""
echo "=== 实验组D：丢包率对比数据 ==="
printf "%-8s %-10s %-10s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
    "丢包率" "P5效率(%)" "P6效率(%)" "P5重传" "P6重传" "P5超时" "P6超时" "P5发送" "P6发送"
echo "--------------------------------------------------------------------------------------------"

for loss in 0 5 10 15 20 25 30; do
    p5_data=$(extract_data "exp2_results/D_loss_${loss}_p5.txt")
    p6_data=$(extract_data "exp2_results/D_loss_${loss}_p6.txt")
    
    p5_eff=$(echo $p5_data | awk '{print $1}')
    p5_ret=$(echo $p5_data | awk '{print $2}')
    p5_to=$(echo $p5_data | awk '{print $3}')
    p5_sent=$(echo $p5_data | awk '{print $4}')
    
    p6_eff=$(echo $p6_data | awk '{print $1}')
    p6_ret=$(echo $p6_data | awk '{print $2}')
    p6_to=$(echo $p6_data | awk '{print $3}')
    p6_sent=$(echo $p6_data | awk '{print $4}')
    
    printf "%-8s %-10s %-10s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
        "${loss}%" "$p5_eff" "$p6_eff" "$p5_ret" "$p6_ret" "$p5_to" "$p6_to" "$p5_sent" "$p6_sent"
done

# 实验组E：超时间隔对比
echo ""
echo "=== 实验组E：超时间隔对比数据 ==="
printf "%-10s %-10s %-10s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
    "超时间隔" "P5效率(%)" "P6效率(%)" "P5重传" "P6重传" "P5超时" "P6超时" "P5发送" "P6发送"
echo "--------------------------------------------------------------------------------------------"

for timeout in 20 30 40 50 60 80 100; do
    p5_data=$(extract_data "exp2_results/E_timeout_${timeout}_p5.txt")
    p6_data=$(extract_data "exp2_results/E_timeout_${timeout}_p6.txt")
    
    p5_eff=$(echo $p5_data | awk '{print $1}')
    p5_ret=$(echo $p5_data | awk '{print $2}')
    p5_to=$(echo $p5_data | awk '{print $3}')
    p5_sent=$(echo $p5_data | awk '{print $4}')
    
    p6_eff=$(echo $p6_data | awk '{print $1}')
    p6_ret=$(echo $p6_data | awk '{print $2}')
    p6_to=$(echo $p6_data | awk '{print $3}')
    p6_sent=$(echo $p6_data | awk '{print $4}')
    
    printf "%-10s %-10s %-10s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
        "$timeout" "$p5_eff" "$p6_eff" "$p5_ret" "$p6_ret" "$p5_to" "$p6_to" "$p5_sent" "$p6_sent"
done

# 实验组F：校验和错误率对比
echo ""
echo "=== 实验组F：校验和错误率对比数据 ==="
printf "%-14s %-10s %-10s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
    "校验和错误率" "P5效率(%)" "P6效率(%)" "P5重传" "P6重传" "P5超时" "P6超时" "P5发送" "P6发送"
echo "--------------------------------------------------------------------------------------------"

for cksum in 0 5 10 15 20 25; do
    p5_data=$(extract_data "exp2_results/F_cksum_${cksum}_p5.txt")
    p6_data=$(extract_data "exp2_results/F_cksum_${cksum}_p6.txt")
    
    p5_eff=$(echo $p5_data | awk '{print $1}')
    p5_ret=$(echo $p5_data | awk '{print $2}')
    p5_to=$(echo $p5_data | awk '{print $3}')
    p5_sent=$(echo $p5_data | awk '{print $4}')
    
    p6_eff=$(echo $p6_data | awk '{print $1}')
    p6_ret=$(echo $p6_data | awk '{print $2}')
    p6_to=$(echo $p6_data | awk '{print $3}')
    p6_sent=$(echo $p6_data | awk '{print $4}')
    
    printf "%-14s %-10s %-10s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
        "${cksum}%" "$p5_eff" "$p6_eff" "$p5_ret" "$p6_ret" "$p5_to" "$p6_to" "$p5_sent" "$p6_sent"
done

echo ""
echo "数据提取完成！"
