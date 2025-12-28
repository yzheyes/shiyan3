#!/bin/bash
# 提取实验6数据

cd simulator_new

echo "=== 实验6：延迟方差影响数据 ==="

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
echo "协议5在不同延迟环境下的表现:"
echo "超时间隔(延迟),效率(%),重传帧数,超时次数,发送帧数,接受载荷数"
for timeout in 30 50 70 100 150; do
    echo -n "$timeout,"
    extract_data "exp6_results/p5_delay_${timeout}.txt"
done

echo ""
echo "协议6在不同延迟环境下的表现:"
echo "超时间隔(延迟),效率(%),重传帧数,超时次数,发送帧数,接受载荷数"
for timeout in 30 50 70 100 150; do
    echo -n "$timeout,"
    extract_data "exp6_results/p6_delay_${timeout}.txt"
done
