# Adaptive-Branch-Predictor
Advanced Computer Architecture Project

---

# 🧠 Adaptive Branch Predictor

### 📘 Project Overview

This project explores and evaluates **adaptive branch prediction mechanisms** using the **SimpleScalar 3.0 simulator**. Two hybrid predictor models were implemented and compared against the baseline **two-level adaptive predictor (2lev)** to enhance prediction accuracy and reduce mispredictions.

---

## 👥 Team

**Group 13**

* Varsha Swaraj (22CS02005)
* Varri Navya (22CS02010)

**Submission Date:** 11th November 2025

---

## 🎯 Objectives

1. **Adaptive Gshare Predictor:**
   Combine two Gshare predictors — one with short history and another with long history — to capture both local and global branch correlations.
2. **Hybrid Bimod + 2-Level Predictor:**
   Combine a Bimodal predictor and a Two-Level Adaptive predictor using a meta (chooser) table to select the best predictor dynamically.

---

## ⚙️ Simulator Setup

* **Simulator:** SimpleScalar 3.0
* **Benchmarks:**

  * Adaptive Gshare → `test-fmath`
  * Hybrid Bimod+2lev → `test-math`
* **Modified Files:**

  * `bpred.c`
  * `bpred.h`
  * `sim-bpred.c`
  * `stats.h`
  * `run_experiments.sh`

---

## 🧩 Implementation Details

### 🔹 Adaptive Gshare Predictor

* Combines **short** (6-bit) and **long** (20-bit) history Gshare predictors.
* Uses a **chooser table (16K entries)** with 3-bit saturating counters to select between the two.
* **Files Modified:**

  * `bpred_create()` initializes both predictors and chooser table.
  * `bpred_lookup()` computes predictions.
  * `bpred_update()` updates predictors and chooser counters based on actual outcomes.

### 🔹 Hybrid Bimod + 2-Level Predictor

* Combines a **bimodal predictor** and a **two-level adaptive predictor (2lev)**.
* A **meta predictor** (combining table) selects which one to trust.
* **Typical Parameters:**

  * Bimodal Table: 2048 entries
  * 2-Level Predictor: L1 = 1, L2 = 8192 entries, History = 12 bits
  * Meta Table: 2048 entries

---

## 🧪 Experimental Setup

**Metrics Evaluated:**

* **Address Prediction Rate:** Correct target predictions ratio
* **Direction Prediction Rate:** Correct taken/not-taken predictions ratio
* **Total Misses:** Number of mispredictions
* **JR Rate:** Jump and return instruction prediction accuracy

**Baselines:**

* `2lev` predictor
* `bimodal` predictor

---

## 📊 Results Summary

| Predictor Type         | Benchmark  | Addr Rate  | Dir Rate   | Misses   |
| ---------------------- | ---------- | ---------- | ---------- | -------- |
| 2lev (baseline)        | test-fmath | 0.8548     | 0.8845     | 1212     |
| Adaptive Gshare (6/20) | test-fmath | **0.8589** | **0.8589** | **1118** |
| Hybrid Bimod+2lev      | test-math  | **0.8893** | **0.9040** | **3090** |

---

## 🏁 Conclusion

Both adaptive predictors outperformed the baseline 2-level predictor.

* The **Adaptive Gshare** effectively balanced short- and long-term branch behaviors, reducing mispredictions.
* The **Hybrid Bimod+2lev** achieved higher directional accuracy through dynamic predictor selection.

These designs demonstrate that **hybrid adaptive prediction schemes** significantly improve branch prediction performance with minimal hardware overhead.

---

## ▶️ Run Instructions

To simulate:

```bash
# Baseline 2-Level Predictor
./sim-bpred -bpred 2lev -bpred:2lev 1 2048 10 0 ./tests-pisa/bin.little/test-math > results/baseline_2lev.log

# Adaptive Gshare Predictor
./sim-bpred -bpred adaptive -bpred:ghist1 6 -bpred:ghist2 20 -bpred:chooser 16384 ./tests-pisa/bin.little/test-fmath > results/adaptive_gshare.log

# Hybrid Bimod + 2-Level Predictor
./sim-bpred -bpred hybrid -bpred:bimod 2048 -bpred:2lev 1 8192 12 1 -bpred:comb 2048 ./tests-pisa/bin.little/test-math > results/hybrid_bimod_2lev.log
```

---

## 📂 Repository Structure

```
├── bpred.c
├── bpred.h
├── sim-bpred.c
├── stats.h
├── run_experiments.sh
├── results/
│   ├── adaptive_gshare.log
│   ├── hybrid_bimod_2lev.log
│   └── baseline_2lev.log
└── README.md
```

---
