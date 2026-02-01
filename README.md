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

  
### 4. AXI4-Lite Slave Register File
A memory-mapped slave module compliant with the AMBA AXI4-Lite protocol.
* **Features:**
  * Independent Read and Write channels using standard `VALID`/`READY` handshakes.
  * **Register Map:** Includes Read/Write registers, a Read-Only Status register, and a specialized **Traffic Counter**.
  * **Traffic Statistics:** A hardware counter at address `0x10` that automatically increments on every valid write transaction to the block.
* **Verification:**
  * Built a **Bus Functional Model (BFM)** testbench.
  * Replaced manual wire-toggling with reusable SystemVerilog `tasks` (`axi_write`, `axi_read`) to simulate a Master CPU.
  * **Key Lesson:** Learned to use Blocking Assignments (`=`) inside tasks to prevent race conditions when capturing read data from the DUT.

### 5. SPI Master (Mode 0)
A synthesizable Serial Peripheral Interface (SPI) Master core designed for Mode 0 operation (CPOL=0, CPHA=0).
* **Functionality:**
  * Serializes 8-bit parallel data from the host into standard SPI signals (`MOSI`, `SCLK`, `CS_n`).
  * Generates an `SCLK` frequency at 1/10th of the system clock (10 MHz SPI from 100 MHz System).
* **Architecture:**
  * **2-State FSM:** Used a clean `IDLE` -> `TRANSFER` state machine to manage the transaction lifecycle.
  * **Integrated Clock Generation:** Derived `SCLK` logic directly from internal counters to ensure zero skew between data (`MOSI`) transitions and clock edges.
  * **Handshake Interface:** Implements a `valid`/`ready` protocol to synchronize with the host system.
* **Note:** This is currently a **Transmit-Only** implementation. The `MISO` (Master In Slave Out) port is reserved for future receive-path logic.
---
**Tools Used:** Vivado 2016.2  
**Language:** SystemVerilog
