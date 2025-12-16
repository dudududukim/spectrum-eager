---
title: "Chipyard Tutorial (ASPLOS 2023)"
date: 2025-09-29
section: "tech-bites"
category: "tech-bite"
categories: ["SoC"]
tags: ["tech-tutorial", "chipyard", "berkeley", "ASIC"]
description: "Open-source tool for HDL, focused on RISC-V architecture chipyard"
reading_time: 10
---

# Chipyard Tutorial

GitHub repository: [chipyard](https://github.com/ucb-bar/chipyard)

FireSim: https://fires.im/publications/#userpapers

## Introduction

We are in a **Golden Age of Computer Architecture**, but we're also in a **Dark Age for Computer Architecture Tools**.

### Key Questions and Solutions

- **Where to get collections of well-tested hardware IP + SW?** → **CHIPYARD**
- **How do I quickly obtain performance measurements for novel HW/SW?** → **FireSim**
- **How do I get ASIC QoR feedback quickly?** → **Hammer**

## Core Architectures

### Rocket and BOOM

- **Rocket**: In-order RISC-V 64-bit core
- **SonicBOOM**: Out-of-order (OoO) core
- **Sodor Education Cores**: RISC-V 32-bit cores for educational purposes (not for commercial use)

### Simulation Tools

- **Spike**: ISA simulation model with C++ - focused on functionality
- **gem5**: Performance analysis and detailed simulation

## Accelerator Integration

### MMIO Accelerator (TileLink-Attached Accelerator)

- **Communication through memory-mapped registers**
- Uses standard load/store instructions
- Connected through bus system

### RoCC Accelerator (Tightly-Coupled)

- **Communication through custom RISC-V instructions**
- Uses dedicated instructions in the form: `customX rd, rs1, rs2, funct`
- Directly connected to processor core

### AXI4 Integration

AXI4 BUS can be easily integrated using Chipyard's AXI4ToTL bridge, since Chipyard uses the TileLink bus system.

## Chipyard Learning Curve

### Exploratory Level

- Configure a custom SoC from pre-existing components
- Generate RTL and simulate it at the RTL level
- Evaluate existing RISC-V designs

### Evaluation Level

- Integrate or develop custom hardware IP into Chipyard
- Run FireSim FPGA-accelerated simulations
- Push a design through the Hammer VLSI flow
- Build your own system

### Advanced Level

- Configure custom IO/clocking setups
- Develop custom FireSim extensions
- Integrate and tape-out a complete SoC