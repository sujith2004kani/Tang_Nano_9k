# 🔌 UART-Controlled LED Selector – Tang Nano 9K

This FPGA project demonstrates how to control on-board LEDs via **UART** using the **Tang Nano 9K**. It receives 8-bit serial data and lights up **only one LED** based on the lower 6 bits of the value received.

---

## Overview

-  **UART RX** operating at **115200 baud**
-  Single **active-low LED** ON based on received index (`0–5`)
-  Out-of-range values turn **all LEDs OFF**
-  Implemented in **Verilog 2001**, tested on **Tang Nano 9K**
-  Fully synthesizable and works with open or official Gowin toolchain

---

## Specifications

| Parameter        | Value         |
|------------------|---------------|
| FPGA Board       | Tang Nano 9K  |
| Clock Frequency  | 27 MHz        |
| Baud Rate        | 115200        |
| UART Interface   | RX only       |
| LED Logic        | Active-Low    |
| LED Count        | 6             |

---
