# UART Receiver with LED Control on Tang Nano 9K FPGA

## Project Overview

This project implements a **UART Receiver** module on the Tang Nano 9K FPGA board that receives 8-bit data transmitted from a PC and controls onboard LEDs accordingly.

- **UART RX**: Receives serial data at 115200 baud with a 27 MHz system clock.
- **LED Control**: Lights up 6 LEDs based on the received number (0–63).
- **Data Range**: Only accepts numbers between 0 and 63 (6-bit).
- **Inverted Output**: LEDs display the bitwise inverted received value for visual effect.

---

## Modules Description

### 1. `uart_rx.v`

- Implements an 8-bit UART receiver.
- Supports standard serial communication format:
  - 1 Start bit (low)
  - 8 Data bits (LSB first)
  - 1 Stop bit (high)
- Generates `rx_data` when a full byte is received.
- Provides `rx_ready` flag to indicate data availability.

### 2. `led.v`

- Controls 6 LEDs based on input data.
- Inverts the input bits before lighting LEDs.
- Includes a simple delay counter for stable LED updates.

### 3. `uart_rx_top.v`

- Top-level module integrating `uart_rx` and `led`.
- Receives data through UART RX pin.
- Passes received data to the LED module.
- Resets system and handles synchronous clocking.

---

## Hardware Specifications

| Parameter      | Value       |
|----------------|-------------|
| System Clock   | 27 MHz      |
| UART Baud Rate | 115200      |
| Data Bits      | 8           |
| Stop Bits      | 1           |
| LED Count      | 6           |

---

## Pin Connections (Tang Nano 9K)

| Signal       | FPGA Pin       | Description           |
|--------------|----------------|-----------------------|
| `clk`        | Board Clock Pin| 27 MHz system clock   |
| `rst_n`      | Reset Pin      | Active-low reset      |
| `uart_rx`    | UART RX Pin    | Receive serial data   |
| `led[5:0]`   | LED Pins       | Onboard LEDs          |

*(Adjust pins according to your board’s pinout and constraints file.)*

---

## How to Use

### Step 1: Synthesize and Program FPGA

- Load `uart_rx_top.v` (which instantiates `uart_rx.v` and `led.v`) into your FPGA toolchain.
- Assign pins accordingly.
- Synthesize, implement, and program the FPGA.

### Step 2: Connect to FPGA UART

- Connect FPGA UART RX line to a USB-to-UART converter or a PC serial port.
- Configure serial communication on PC:
  - **Port:** e.g., `COM17` or `/dev/ttyUSB0`
  - **Baud Rate:** 115200
  - **Data bits:** 8
  - **Stop bits:** 1
  - **Parity:** None

### Step 3: Send Data from PC

Use a serial terminal or the provided Python script to send numbers between 0 and 63.
