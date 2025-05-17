# UART Transmitter (8-bit) for FPGA

## 📡 Overview

This project implements a minimal UART (Universal Asynchronous Receiver Transmitter) transmitter using Verilog 2001. It repeatedly sends the ASCII string `"HELLO\r\n"` through a UART TX line, making it ideal for FPGA-based serial communication experiments and hardware bring-up diagnostics.

It includes:

- A parameterized UART TX core: `uart.v`
- A finite state machine-based controller: `top.v`
- Designed to operate at a clock frequency of **27 MHz**
- Baud rate configured for **115200 bps**

---

## 📂 File Structure

```plaintext
|-- uart.v     
|-- top.v      
|-- uart_tx_hello.cst 
