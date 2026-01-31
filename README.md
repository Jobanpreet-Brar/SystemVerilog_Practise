# SystemVerilog Practice

I'm using this repository to improve my RTL design and Verification skills.

## Modules

### 1. LED Blinker
A simple counter-based toggle.
* **What I learned:** Refreshed on the difference between registered outputs vs. combinational assignment. Moved the logic outside the `always_ff` block to ensure immediate updates.

### 2. Parameterized Up/Down Counter
A flexible counter that can change width (e.g., 4-bit, 8-bit) via parameters.
* **Features:**
  * Direction control (Up/Down).
  * Overflow flag (pulses high when wrapping around).
* **Testbench:** Instantiated two counters of different widths (4-bit and 8-bit) running simultaneously to verify parameterization works correctly.

### 3. UART Transmitter
A standard 8N1 serial transmitter (1 Start, 8 Data, 1 Stop).
* **Design:** Used a Single-Process FSM (everything in one `always_ff` block).
* **Why:** I found this easier to synchronize than separating the Next State logic, and it avoids accidental latches.
* **Status:** Verified with `0xA5` pattern in simulation.

---
**Tools Used:** Vivado 2016.2  
**Language:** SystemVerilog
