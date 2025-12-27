#!/bin/bash
# 实验一：协议性能研究

echo "=== 实验一：协议性能研究 ==="
echo "开始时间: $(date)"

# 创建输出目录
mkdir -p exp1_results

# 实验组A：超时间隔
echo ""
echo "=== 实验组A：超时间隔对性能的影响 ==="
for timeout in 20 30 40 50 60 80 100 120 150; do
    echo "运行实验: 超时间隔=$timeout"
    ./sim 5 50000 $timeout 10 5 0 > exp1_results/A_timeout_${timeout}.txt 2>&1
    sleep 1
done

# 实验组B：丢包率
echo ""
echo "=== 实验组B：丢包率对性能的影响 ==="
for loss in 0 5 10 15 20 25 30; do
    echo "运行实验: 丢包率=$loss%"
    ./sim 5 50000 50 $loss 5 0 > exp1_results/B_loss_${loss}.txt 2>&1
    sleep 1
done

# 实验组C：校验和错误率
echo ""
echo "=== 实验组C：校验和错误率对性能的影响 ==="
for cksum in 0 5 10 15 20 25; do
    echo "运行实验: 校验和错误率=$cksum%"
    ./sim 5 50000 50 10 $cksum 0 > exp1_results/C_cksum_${cksum}.txt 2>&1
    sleep 1
done

echo ""
echo "实验一完成！结束时间: $(date)"
echo "结果保存在 exp1_results/ 目录中"
