import serial
import time
COM_PORT='COM17'    #Change the port according to your device
BAUD_RATE=115200
try:
    ser=serial.Serial(COM_PORT, BAUD_RATE, timeout=1)
    print(f"[INFO] {COM_PORT} at {BAUD_RATE} baud active.")
    time.sleep(2)
except serial.SerialException:
    print(f"[ERROR] Could not open {COM_PORT}.")
    exit(1)
try:
    while True:
        user_input=input("Enter a number or 'exit': ")
        if user_input.lower()=='exit':
            break
        try:
            val=int(user_input)
            if 0<=val<=63:
                ser.write(bytes([val]))
                print(f"[TX] Sent: {val} (0x{val:02X})")
            else:
                print("[WARN] Between 0 and 63.")
        except ValueError:
            print("[WARN] Invalid input.")
except KeyboardInterrupt:
    print("\n[INFO] Terminated.")
finally:
    ser.close()
    print("[INFO] Port closed.")
