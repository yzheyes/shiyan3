#!/bin/bash
# 实验二：协议5与协议6性能对比

echo "=== 实验二：协议5与协议6性能对比 ==="
echo "开始时间: $(date)"

mkdir -p exp2_results

# 实验组D：不同丢包率
echo ""
echo "=== 实验组D：不同丢包率下的对比 ==="
for loss in 0 5 10 15 20 25 30; do
    echo "运行实验: 丢包率=$loss%"
    echo "  协议5..."
    ./sim 5 50000 50 $loss 5 0 > exp2_results/D_loss_${loss}_p5.txt 2>&1
    echo "  协议6..."
    ./sim 6 50000 50 $loss 5 0 > exp2_results/D_loss_${loss}_p6.txt 2>&1
    sleep 1
done

# 实验组E：不同超时间隔
echo ""
echo "=== 实验组E：不同超时间隔下的对比 ==="
for timeout in 20 30 40 50 60 80 100; do
    echo "运行实验: 超时间隔=$timeout"
    echo "  协议5..."
    ./sim 5 50000 $timeout 10 5 0 > exp2_results/E_timeout_${timeout}_p5.txt 2>&1
    echo "  协议6..."
    ./sim 6 50000 $timeout 10 5 0 > exp2_results/E_timeout_${timeout}_p6.txt 2>&1
    sleep 1
done

# 实验组F：不同校验和错误率
echo ""
echo "=== 实验组F：不同校验和错误率下的对比 ==="
for cksum in 0 5 10 15 20 25; do
    echo "运行实验: 校验和错误率=$cksum%"
    echo "  协议5..."
    ./sim 5 50000 50 10 $cksum 0 > exp2_results/F_cksum_${cksum}_p5.txt 2>&1
    echo "  协议6..."
    ./sim 6 50000 50 10 $cksum 0 > exp2_results/F_cksum_${cksum}_p6.txt 2>&1
    sleep 1
done

echo ""
echo "实验二完成！结束时间: $(date)"
echo "结果保存在 exp2_results/ 目录中"
