#!/bin/bash
# Run multiple Adaptive Gshare experiments automatically
# Author: Varsha (for ACA project)

SIM="./sim-bpred"
BENCH="/home/varsha/Documents/ACA/simplescalar-20251025T091721Z-1-001/simplescalar/simplesim-3.0/tests-pisa/bin.little/test-fmath"
# Bench has address to your test-fmath benchmark.
RESULT_DIR="results"

# Ensure results directory exists
mkdir -p $RESULT_DIR

# List of experiments: short_hist long_hist chooser_sz
EXPERIMENTS=(
  "4 20 8192"
"6 18 16384"
"6 20 16384"
"6 20 32768"
"8 24 32768"
"10 24 32768"
"12 30 32768"
)

echo "Running Adaptive Gshare experiments..."
echo "--------------------------------------"

EXP_ID=1

for EXP in "${EXPERIMENTS[@]}"; do
  set -- $EXP
  SHORT=$1
  LONG=$2
  CHOOSER=$3

  echo ""
  echo ">>> Experiment $EXP_ID: short=$SHORT, long=$LONG, chooser=$CHOOSER"

  # Modify parameters via command-line defines (requires you to read them in bpred_create)
  OUTPUT_FILE="$RESULT_DIR/exp_${EXP_ID}_s${SHORT}_l${LONG}_c${CHOOSER}.txt"
 (
  SHORT_HIST=$SHORT LONG_HIST=$LONG CHOOSER_SZ=$CHOOSER \
  $SIM -bpred adaptivegshare $BENCH > "$OUTPUT_FILE" 2>&1
)


  # Extract summary metrics (optional)
  ADDR_RATE=$(grep "bpred_adaptivegshare.bpred_addr_rate" "$OUTPUT_FILE" | awk '{print $2}')
  DIR_RATE=$(grep "bpred_adaptivegshare.bpred_dir_rate" "$OUTPUT_FILE" | awk '{print $2}')
  MISSES=$(grep "bpred_adaptivegshare.misses" "$OUTPUT_FILE" | awk '{print $2}')
  Addr_hits=$(grep "bpred_adaptivegshare.addr_hits" "$OUTPUT_FILE" | awk '{print $2}')
   dir_hits=$(grep "bpred_adaptivegshare.dir_hits" "$OUTPUT_FILE" | awk '{print $2}')
   jr_rate=$(grep "bpred_adaptivegshare.bpred_jr_rate" "$OUTPUT_FILE" | awk '{print $2}') 
  echo "  -> Addr Rate: $ADDR_RATE, Dir Rate: $DIR_RATE, Misses: $MISSES, Addr_hits: $Addr_hits, dir_hits: $dir_hits, jr_hits: $jr_rate"
  
  ((EXP_ID++))
done

echo ""
echo "All experiments completed."
echo "Results saved in: $RESULT_DIR/"

