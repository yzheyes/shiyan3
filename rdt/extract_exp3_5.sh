#!/bin/bash
# 提取实验3和实验5的数据

echo "=== 实验3和实验5数据提取 ==="

cd simulator_new

# 提取函数
extract_data() {
    local file=$1
    local eff=$(grep "Efficiency" "$file" | grep -oP '\d+(?=%)' | head -1)
    local ret=$(grep "retransmitted" "$file" | awk '{sum+=$NF} END {print sum}')
    local timeout=$(grep "Timeouts:" "$file" | awk '{sum+=$NF} END {print sum}')
    local sent=$(grep "Total data frames sent" "$file" | awk '{sum+=$NF} END {print sum}')
    local accepted=$(grep "Payloads accepted" "$file" | awk '{sum+=$NF} END {print sum}')
    echo "${eff:-0},${ret:-0},${timeout:-0},${sent:-0},${accepted:-0}"
}

echo ""
echo "=== 实验3：事件优先级对比 ==="
echo "优先级方案,效率(%),重传帧数,超时次数,发送帧数,接受载荷数"

echo -n "原始-帧到达优先,"
extract_data "exp3_results/priority_original.txt"

echo -n "超时优先,"
extract_data "exp3_results/priority_timeout_first.txt"

echo -n "网络层就绪优先,"
extract_data "exp3_results/priority_network_first.txt"

echo ""
echo "=== 实验5：时间推进优化对比 ==="
echo "版本,效率(%),重传帧数,超时次数,发送帧数,接受载荷数"

echo -n "原始版本,"
extract_data "exp5_results/original_perf.txt"

echo -n "优化版本,"
extract_data "exp5_results/optimized_perf.txt"
