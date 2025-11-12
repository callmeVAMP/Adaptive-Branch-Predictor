#!/bin/bash
# Run Hybrid and Bimodal Branch Predictor Experiments Automatically
# Author: Navya Varri (ACA Project)

# Simulator and paths
SIM="./sim-bpred"
BENCH="./tests-pisa/bin.little/test-math"
RESULT_DIR="results"

# Ensure results directory exists
mkdir -p $RESULT_DIR

echo "-------------------------------------------"
echo " Running Bimodal and Hybrid Predictor Tests "
echo "-------------------------------------------"

# 1️⃣ Bimodal baseline
echo ""
echo ">>> Running baseline bimodal (2048 entries)..."
$SIM -bpred bimod -bpred:bimod 2048 $BENCH > $RESULT_DIR/bimod_2048.log 2>&1
grep "bpred_bimod.bpred_dir_rate" $RESULT_DIR/bimod_2048.log

# 2️⃣ Hybrid: hist=12, meta=2048
echo ""
echo ">>> Running hybrid: L1=1, L2=2048, Hist=12, XOR=1, Meta=2048..."
$SIM -bpred hybrid \
  -bpred:bimod 2048 \
  -bpred:2lev 1 2048 12 1 \
  -bpred:comb 2048 \
  $BENCH > $RESULT_DIR/hybrid_hist12_meta2048.log 2>&1
grep "bpred_hybrid.bpred_dir_rate" $RESULT_DIR/hybrid_hist12_meta2048.log

# 3️⃣ Hybrid: L1=1, L2=4096, Hist=12, XOR=1, Meta=1024
echo ""
echo ">>> Running hybrid: L1=1, L2=4096, Hist=12, XOR=1, Meta=1024..."
$SIM -bpred hybrid \
  -bpred:bimod 2048 \
  -bpred:2lev 1 4096 12 1 \
  -bpred:comb 1024 \
  $BENCH > $RESULT_DIR/hybrid_meta1024.log 2>&1
grep "bpred_hybrid.bpred_dir_rate" $RESULT_DIR/hybrid_meta1024.log

# 4️⃣ Hybrid: L1=256, L2=8192, Hist=12, XOR=1, Meta=2048
echo ""
echo ">>> Running hybrid: L1=256, L2=8192, Hist=12, XOR=1, Meta=2048..."
$SIM -bpred hybrid \
  -bpred:bimod 2048 \
  -bpred:2lev 256 8192 12 1 \
  -bpred:comb 2048 \
  $BENCH > $RESULT_DIR/hybrid_l1_256.log 2>&1
grep "bpred_hybrid.bpred_dir_rate" $RESULT_DIR/hybrid_l1_256.log

# 5️⃣ Hybrid: No XOR (XOR=0)
echo ""
echo ">>> Running hybrid: XOR=0 (no XOR indexing)..."
$SIM -bpred hybrid \
  -bpred:bimod 2048 \
  -bpred:2lev 1 2048 10 0 \
  -bpred:comb 1024 \
  $BENCH > $RESULT_DIR/hybrid_noXOR.log 2>&1
grep "bpred_hybrid.bpred_dir_rate" $RESULT_DIR/hybrid_noXOR.log

echo ""
echo "✅ All experiments completed successfully."
echo "Results saved in: $RESULT_DIR/"
echo "-------------------------------------------"

# Optional summary extraction
for file in $RESULT_DIR/*.log; do
  echo ""
  echo "Results for $(basename $file):"
  grep -E "bpred_hybrid.bpred_(addr_rate|dir_rate)|bpred_hybrid.misses" "$file"
done
