#!/bin/bash
# 提取所有实验数据并生成CSV文件

echo "========================================"
echo "  数据提取与汇总"
echo "========================================"

# 函数：提取单个文件的完整数据
extract_full_data() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "N/A,N/A,N/A,N/A,N/A,N/A,N/A"
        return
    fi
    
    local eff=$(grep "Efficiency" "$file" | grep -oP '\d+(?=%)')
    
    # 提取Process 0的数据 (使用head -1确保只取第一行)
    local p0_sent=$(grep -A 20 "Process 0:" "$file" | grep "Total data frames sent:" | awk '{print $NF}' | head -1)
    local p0_retrans=$(grep -A 20 "Process 0:" "$file" | grep "Frames retransmitted:" | awk '{print $NF}' | head -1)
    local p0_payload=$(grep -A 20 "Process 0:" "$file" | grep "Payloads accepted:" | awk '{print $NF}' | head -1)
    local p0_timeout=$(grep -A 20 "Process 0:" "$file" | grep "Timeouts:" | awk '{print $NF}' | head -1)
    local p0_lost=$(grep -A 20 "Process 0:" "$file" | grep "Data frames lost:" | awk '{print $NF}' | head -1)
    local p0_bad=$(grep -A 20 "Process 0:" "$file" | grep "Bad data frames rec'd:" | awk '{print $NF}' | head -1)
    
    # 提取Process 1的数据 (使用head -1确保只取第一行)
    local p1_sent=$(grep -A 20 "Process 1:" "$file" | grep "Total data frames sent:" | awk '{print $NF}' | head -1)
    local p1_retrans=$(grep -A 20 "Process 1:" "$file" | grep "Frames retransmitted:" | awk '{print $NF}' | head -1)
    local p1_payload=$(grep -A 20 "Process 1:" "$file" | grep "Payloads accepted:" | awk '{print $NF}' | head -1)
    local p1_timeout=$(grep -A 20 "Process 1:" "$file" | grep "Timeouts:" | awk '{print $NF}' | head -1)
    local p1_lost=$(grep -A 20 "Process 1:" "$file" | grep "Data frames lost:" | awk '{print $NF}' | head -1)
    local p1_bad=$(grep -A 20 "Process 1:" "$file" | grep "Bad data frames rec'd:" | awk '{print $NF}' | head -1)
    
    # 确保变量不为空，默认为0
    p0_sent=${p0_sent:-0}
    p1_sent=${p1_sent:-0}
    p0_retrans=${p0_retrans:-0}
    p1_retrans=${p1_retrans:-0}
    p0_payload=${p0_payload:-0}
    p1_payload=${p1_payload:-0}
    p0_timeout=${p0_timeout:-0}
    p1_timeout=${p1_timeout:-0}
    p0_lost=${p0_lost:-0}
    p1_lost=${p1_lost:-0}
    p0_bad=${p0_bad:-0}
    p1_bad=${p1_bad:-0}
    
    # 计算总和
    local total_sent=$((p0_sent + p1_sent))
    local total_retrans=$((p0_retrans + p1_retrans))
    local total_payload=$((p0_payload + p1_payload))
    local total_timeout=$((p0_timeout + p1_timeout))
    local total_lost=$((p0_lost + p1_lost))
    local total_bad=$((p0_bad + p1_bad))
    
    echo "${eff},${total_retrans},${total_timeout},${total_sent},${total_payload},${total_lost},${total_bad}"
}

# 创建CSV文件
CSV_FILE="../实验数据汇总.csv"
echo "实验组,协议,超时间隔,丢包率,校验和错误率,效率(%),重传帧数,超时次数,发送帧数,接受载荷数,丢包数,坏帧数,备注" > "$CSV_FILE"

echo ""
echo "提取实验一数据..."

# 实验组A：超时间隔
echo "  处理实验组A..."
for timeout in 20 30 40 50 60 80 100 120 150; do
    data=$(extract_full_data "exp1_results/A_timeout_${timeout}.txt")
    echo "实验组A,P5,${timeout},10,5,${data}," >> "$CSV_FILE"
done

# 实验组B：丢包率
echo "  处理实验组B..."
for loss in 0 5 10 15 20 25 30; do
    data=$(extract_full_data "exp1_results/B_loss_${loss}.txt")
    echo "实验组B,P5,50,${loss},5,${data}," >> "$CSV_FILE"
done

# 实验组C：校验和错误率
echo "  处理实验组C..."
for cksum in 0 5 10 15 20 25; do
    data=$(extract_full_data "exp1_results/C_cksum_${cksum}.txt")
    echo "实验组C,P5,50,10,${cksum},${data}," >> "$CSV_FILE"
done

echo ""
echo "提取实验二数据..."

# 实验组D：丢包率对比
echo "  处理实验组D..."
for loss in 0 5 10 15 20 25 30; do
    p5_data=$(extract_full_data "exp2_results/D_loss_${loss}_p5.txt")
    echo "实验组D,P5,50,${loss},5,${p5_data}," >> "$CSV_FILE"
    p6_data=$(extract_full_data "exp2_results/D_loss_${loss}_p6.txt")
    echo "实验组D,P6,50,${loss},5,${p6_data}," >> "$CSV_FILE"
done

# 实验组E：超时间隔对比
echo "  处理实验组E..."
for timeout in 20 30 40 50 60 80 100; do
    p5_data=$(extract_full_data "exp2_results/E_timeout_${timeout}_p5.txt")
    echo "实验组E,P5,${timeout},10,5,${p5_data}," >> "$CSV_FILE"
    p6_data=$(extract_full_data "exp2_results/E_timeout_${timeout}_p6.txt")
    echo "实验组E,P6,${timeout},10,5,${p6_data}," >> "$CSV_FILE"
done

# 实验组F：校验和错误率对比
echo "  处理实验组F..."
for cksum in 0 5 10 15 20 25; do
    p5_data=$(extract_full_data "exp2_results/F_cksum_${cksum}_p5.txt")
    echo "实验组F,P5,50,10,${cksum},${p5_data}," >> "$CSV_FILE"
    p6_data=$(extract_full_data "exp2_results/F_cksum_${cksum}_p6.txt")
    echo "实验组F,P6,50,10,${cksum},${p6_data}," >> "$CSV_FILE"
done

echo ""
echo "提取实验四数据..."

# 实验组G：协议5重传
echo "  处理实验组G (协议5重传)..."
for timeout in 20 30 40 50 60 80 100 120 150; do
    for loss in 0 5 10 15 20 25; do
        data=$(extract_full_data "exp4_results/P5_t${timeout}_l${loss}.txt")
        echo "实验组G,P5,${timeout},${loss},5,${data}," >> "$CSV_FILE"
    done
done

# 实验组H：协议6重传
echo "  处理实验组H (协议6重传)..."
for timeout in 20 30 40 50 60 80 100 120 150; do
    for loss in 0 5 10 15 20 25; do
        data=$(extract_full_data "exp4_results/P6_t${timeout}_l${loss}.txt")
        echo "实验组H,P6,${timeout},${loss},5,${data}," >> "$CSV_FILE"
    done
done

echo ""
echo "========================================"
echo "  数据提取完成！"
echo "========================================"
echo ""
echo "CSV文件位置: $CSV_FILE"
echo ""
echo "数据统计："
total_lines=$(wc -l < "$CSV_FILE")
data_lines=$((total_lines - 1))
echo "  - 总记录数: $data_lines 条"
echo ""
echo "现在生成数据摘要报告..."

# 生成摘要报告
REPORT_FILE="../实验数据摘要.txt"

cat > "$REPORT_FILE" << 'REPORT_START'
========================================
  RDT协议实验数据摘要报告
========================================

REPORT_START

echo "" >> "$REPORT_FILE"
echo "生成时间: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 实验一摘要
echo "========================================" >> "$REPORT_FILE"
echo "实验一：协议5性能研究" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "实验组A：超时间隔对性能的影响" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
printf "%-10s %-8s %-10s %-10s %-10s\n" "超时间隔" "效率(%)" "重传帧数" "超时次数" "发送帧数" >> "$REPORT_FILE"
for timeout in 20 30 40 50 60 80 100 120 150; do
    data=$(extract_full_data "exp1_results/A_timeout_${timeout}.txt")
    eff=$(echo $data | cut -d',' -f1)
    retrans=$(echo $data | cut -d',' -f2)
    timeouts=$(echo $data | cut -d',' -f3)
    sent=$(echo $data | cut -d',' -f4)
    printf "%-10s %-8s %-10s %-10s %-10s\n" "$timeout" "$eff" "$retrans" "$timeouts" "$sent" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"
echo "实验组B：丢包率对性能的影响" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
printf "%-8s %-8s %-10s %-10s %-10s\n" "丢包率" "效率(%)" "重传帧数" "超时次数" "发送帧数" >> "$REPORT_FILE"
for loss in 0 5 10 15 20 25 30; do
    data=$(extract_full_data "exp1_results/B_loss_${loss}.txt")
    eff=$(echo $data | cut -d',' -f1)
    retrans=$(echo $data | cut -d',' -f2)
    timeouts=$(echo $data | cut -d',' -f3)
    sent=$(echo $data | cut -d',' -f4)
    printf "%-8s %-8s %-10s %-10s %-10s\n" "${loss}%" "$eff" "$retrans" "$timeouts" "$sent" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"
echo "实验组C：校验和错误率对性能的影响" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
printf "%-14s %-8s %-10s %-10s %-10s\n" "校验和错误率" "效率(%)" "重传帧数" "超时次数" "发送帧数" >> "$REPORT_FILE"
for cksum in 0 5 10 15 20 25; do
    data=$(extract_full_data "exp1_results/C_cksum_${cksum}.txt")
    eff=$(echo $data | cut -d',' -f1)
    retrans=$(echo $data | cut -d',' -f2)
    timeouts=$(echo $data | cut -d',' -f3)
    sent=$(echo $data | cut -d',' -f4)
    printf "%-14s %-8s %-10s %-10s %-10s\n" "${cksum}%" "$eff" "$retrans" "$timeouts" "$sent" >> "$REPORT_FILE"
done

# 实验二摘要
echo "" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "实验二：协议5与协议6性能对比" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "实验组D：不同丢包率下的对比" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
printf "%-8s %-10s %-10s %-8s %-8s %-8s %-8s\n" "丢包率" "P5效率(%)" "P6效率(%)" "P5重传" "P6重传" "P5超时" "P6超时" >> "$REPORT_FILE"
for loss in 0 5 10 15 20 25 30; do
    p5_data=$(extract_full_data "exp2_results/D_loss_${loss}_p5.txt")
    p6_data=$(extract_full_data "exp2_results/D_loss_${loss}_p6.txt")
    p5_eff=$(echo $p5_data | cut -d',' -f1)
    p6_eff=$(echo $p6_data | cut -d',' -f1)
    p5_ret=$(echo $p5_data | cut -d',' -f2)
    p6_ret=$(echo $p6_data | cut -d',' -f2)
    p5_to=$(echo $p5_data | cut -d',' -f3)
    p6_to=$(echo $p6_data | cut -d',' -f3)
    printf "%-8s %-10s %-10s %-8s %-8s %-8s %-8s\n" "${loss}%" "$p5_eff" "$p6_eff" "$p5_ret" "$p6_ret" "$p5_to" "$p6_to" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"
echo "实验组E：不同超时间隔下的对比" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
printf "%-10s %-10s %-10s %-8s %-8s %-8s %-8s\n" "超时间隔" "P5效率(%)" "P6效率(%)" "P5重传" "P6重传" "P5超时" "P6超时" >> "$REPORT_FILE"
for timeout in 20 30 40 50 60 80 100; do
    p5_data=$(extract_full_data "exp2_results/E_timeout_${timeout}_p5.txt")
    p6_data=$(extract_full_data "exp2_results/E_timeout_${timeout}_p6.txt")
    p5_eff=$(echo $p5_data | cut -d',' -f1)
    p6_eff=$(echo $p6_data | cut -d',' -f1)
    p5_ret=$(echo $p5_data | cut -d',' -f2)
    p6_ret=$(echo $p6_data | cut -d',' -f2)
    p5_to=$(echo $p5_data | cut -d',' -f3)
    p6_to=$(echo $p6_data | cut -d',' -f3)
    printf "%-10s %-10s %-10s %-8s %-8s %-8s %-8s\n" "$timeout" "$p5_eff" "$p6_eff" "$p5_ret" "$p6_ret" "$p5_to" "$p6_to" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "报告生成完成" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"

echo ""
echo "摘要报告位置: $REPORT_FILE"
echo ""
echo "========================================"
echo "  所有文件生成完成！"
echo "========================================"
echo ""
echo "生成的文件："
echo "  1. $CSV_FILE - 完整数据（可用Excel打开）"
echo "  2. $REPORT_FILE - 文本摘要报告"
echo ""
echo "这些数据足够完成实验报告！"
echo "========================================"
