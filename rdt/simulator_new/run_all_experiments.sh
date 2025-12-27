#!/bin/bash
# 一次性运行所有基础实验
# 包括：实验一（协议性能）、实验二（协议对比）、实验四（重传研究）

echo "========================================"
echo "  RDT协议实验 - 综合实验执行脚本"
echo "========================================"
echo "开始时间: $(date)"
echo ""

# 创建所有结果目录
mkdir -p exp1_results exp2_results exp4_results

# ========== 实验一：协议性能研究 ==========
echo ""
echo "=========================================="
echo "实验一：协议5性能研究"
echo "=========================================="

# 实验组A：超时间隔（9个实验）
echo ""
echo "[1/3] 实验组A：超时间隔对性能的影响"
echo "固定参数: 协议5, events=50000, 丢包率=10%, 校验和=5%"
for timeout in 20 30 40 50 60 80 100 120 150; do
    echo -n "  运行: 超时间隔=$timeout ... "
    ./sim 5 50000 $timeout 10 5 0 > exp1_results/A_timeout_${timeout}.txt 2>&1
    echo "完成"
done

# 实验组B：丢包率（7个实验）
echo ""
echo "[2/3] 实验组B：丢包率对性能的影响"
echo "固定参数: 协议5, events=50000, 超时间隔=50, 校验和=5%"
for loss in 0 5 10 15 20 25 30; do
    echo -n "  运行: 丢包率=$loss% ... "
    ./sim 5 50000 50 $loss 5 0 > exp1_results/B_loss_${loss}.txt 2>&1
    echo "完成"
done

# 实验组C：校验和错误率（6个实验）
echo ""
echo "[3/3] 实验组C：校验和错误率对性能的影响"
echo "固定参数: 协议5, events=50000, 超时间隔=50, 丢包率=10%"
for cksum in 0 5 10 15 20 25; do
    echo -n "  运行: 校验和错误率=$cksum% ... "
    ./sim 5 50000 50 10 $cksum 0 > exp1_results/C_cksum_${cksum}.txt 2>&1
    echo "完成"
done

echo ""
echo "✓ 实验一完成！共完成 22 个实验"

# ========== 实验二：协议对比研究 ==========
echo ""
echo "=========================================="
echo "实验二：协议5与协议6性能对比"
echo "=========================================="

# 实验组D：不同丢包率（14个实验：7×2）
echo ""
echo "[1/3] 实验组D：不同丢包率下的对比"
echo "固定参数: events=50000, 超时间隔=50, 校验和=5%"
for loss in 0 5 10 15 20 25 30; do
    echo -n "  运行: 丢包率=$loss%, 协议5 ... "
    ./sim 5 50000 50 $loss 5 0 > exp2_results/D_loss_${loss}_p5.txt 2>&1
    echo -n "完成; 协议6 ... "
    ./sim 6 50000 50 $loss 5 0 > exp2_results/D_loss_${loss}_p6.txt 2>&1
    echo "完成"
done

# 实验组E：不同超时间隔（14个实验：7×2）
echo ""
echo "[2/3] 实验组E：不同超时间隔下的对比"
echo "固定参数: events=50000, 丢包率=10%, 校验和=5%"
for timeout in 20 30 40 50 60 80 100; do
    echo -n "  运行: 超时间隔=$timeout, 协议5 ... "
    ./sim 5 50000 $timeout 10 5 0 > exp2_results/E_timeout_${timeout}_p5.txt 2>&1
    echo -n "完成; 协议6 ... "
    ./sim 6 50000 $timeout 10 5 0 > exp2_results/E_timeout_${timeout}_p6.txt 2>&1
    echo "完成"
done

# 实验组F：不同校验和错误率（12个实验：6×2）
echo ""
echo "[3/3] 实验组F：不同校验和错误率下的对比"
echo "固定参数: events=50000, 超时间隔=50, 丢包率=10%"
for cksum in 0 5 10 15 20 25; do
    echo -n "  运行: 校验和=$cksum%, 协议5 ... "
    ./sim 5 50000 50 10 $cksum 0 > exp2_results/F_cksum_${cksum}_p5.txt 2>&1
    echo -n "完成; 协议6 ... "
    ./sim 6 50000 50 10 $cksum 0 > exp2_results/F_cksum_${cksum}_p6.txt 2>&1
    echo "完成"
done

echo ""
echo "✓ 实验二完成！共完成 40 个实验"

# ========== 实验四：重传帧数量研究 ==========
echo ""
echo "=========================================="
echo "实验四：重传帧数量研究"
echo "=========================================="

# 实验组G：协议5重传（54个实验：9×6）
echo ""
echo "[1/2] 实验组G：协议5重传研究"
echo "固定参数: 协议5, events=50000, 校验和=5%"
total=0
for timeout in 20 30 40 50 60 80 100 120 150; do
    for loss in 0 5 10 15 20 25; do
        total=$((total + 1))
        echo -n "  [$total/54] 超时=$timeout, 丢包=$loss% ... "
        ./sim 5 50000 $timeout $loss 5 0 > exp4_results/P5_t${timeout}_l${loss}.txt 2>&1
        echo "完成"
    done
done

# 实验组H：协议6重传（54个实验：9×6）
echo ""
echo "[2/2] 实验组H：协议6重传研究"
echo "固定参数: 协议6, events=50000, 校验和=5%"
total=0
for timeout in 20 30 40 50 60 80 100 120 150; do
    for loss in 0 5 10 15 20 25; do
        total=$((total + 1))
        echo -n "  [$total/54] 超时=$timeout, 丢包=$loss% ... "
        ./sim 6 50000 $timeout $loss 5 0 > exp4_results/P6_t${timeout}_l${loss}.txt 2>&1
        echo "完成"
    done
done

echo ""
echo "✓ 实验四完成！共完成 108 个实验"

# ========== 完成 ==========
echo ""
echo "========================================"
echo "  所有实验完成！"
echo "========================================"
echo "结束时间: $(date)"
echo ""
echo "实验统计："
echo "  - 实验一: 22 个实验"
echo "  - 实验二: 40 个实验"
echo "  - 实验四: 108 个实验"
echo "  - 总计: 170 个实验"
echo ""
echo "结果保存位置："
echo "  - exp1_results/ (实验一数据)"
echo "  - exp2_results/ (实验二数据)"
echo "  - exp4_results/ (实验四数据)"
echo ""
echo "下一步："
echo "  运行 ./extract_all_data.sh 提取所有数据到CSV文件"
echo "========================================"
