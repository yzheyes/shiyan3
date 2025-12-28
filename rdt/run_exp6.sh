#!/bin/bash
# 实验6：网络延迟方差对协议性能的影响
# 通过调整超时间隔来模拟不同的网络延迟环境

cd simulator_new

echo "=== 实验6：延迟方差影响研究 ==="
echo "开始时间: $(date)"

mkdir -p exp6_results

# 测试不同的超时间隔（模拟不同的延迟环境）
# 协议5测试
echo ""
echo "=== 协议5在不同延迟环境下的表现 ==="
for timeout in 30 50 70 100 150; do
    echo "测试超时间隔=$timeout (模拟延迟环境)"
    ./sim 5 50000 $timeout 10 5 0 > exp6_results/p5_delay_${timeout}.txt 2>&1
    sleep 0.5
done

# 协议6测试
echo ""
echo "=== 协议6在不同延迟环境下的表现 ==="
for timeout in 30 50 70 100 150; do
    echo "测试超时间隔=$timeout (模拟延迟环境)"
    ./sim 6 50000 $timeout 10 5 0 > exp6_results/p6_delay_${timeout}.txt 2>&1
    sleep 0.5
done

echo ""
echo "实验6完成！结束时间: $(date)"
