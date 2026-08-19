# DMA_Implementation

A simple **Direct Memory Access (DMA) controller implemented in Verilog HDL**. This project demonstrates transferring 32-bit data from a source memory location to a destination memory location using an FSM-based DMA controller.

## 1. Project Overview

The DMA controller performs the following operations:

1. Accepts the source address, destination address, and transfer length.
2. Reads data from the source memory.
3. Stores the read data temporarily.
4. Writes the data to the destination memory.
5. Increments both addresses by 4 bytes.
6. Repeats until all words are transferred.
7. Generates `done` and `interrupt` when the transfer is complete.

### Repository Files

| File | Description |
|---|---|
| `dma.v` | DMA FSM implementation |
| `dma_engine.v` | Top-level DMA engine |
| `memory.v` | Memory model |
| `dma_tb.v` | DMA engine testbench |
| `engine_tb.v` | FSM testbench |
| `README.md` | Project documentation |

## 2. DMA Architecture

The DMA uses a finite-state machine to control the transfer.

The main states are:

- **IDLE** – Waits for a start request.
- **READ** – Requests data from the source.
- **WAIT_READ** – Waits for the read operation to complete.
- **WRITE** – Requests a write to the destination.
- **WAIT_WRITE** – Waits for the write operation to complete.
- **INC_ADDR** – Updates addresses and transfer count.
- **DONE** – Indicates that the transfer is complete.

The memory contains **256 words of 32-bit data**. Each transfer moves one 32-bit word, and the addresses increase by 4 bytes after every transfer.

## 3. DMA Interface

| Signal | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 bit | System clock |
| `rst` | Input | 1 bit | Active-low reset |
| `start` | Input | 1 bit | Starts the transfer |
| `src_addr` | Input | 32 bits | Source address |
| `dst_addr` | Input | 32 bits | Destination address |
| `length` | Input | 32 bits | Number of words to transfer |
| `busy` | Output | 1 bit | Indicates active transfer |
| `done` | Output | 1 bit | Indicates completed transfer |
| `error` | Output | 1 bit | Error indication |
| `interrupt` | Output | 1 bit | Transfer completion interrupt |

## 4. Verification and Simulation

The testbench initializes four source values:

- `1111_AAAA`
- `2222_BBBB`
- `3333_CCCC`
- `4444_DDDD`

The DMA transfers these values from address `0x00000000` to `0x00000040` with a length of 4 words.

The expected destination values are:

- `mem[16] = 1111_AAAA`
- `mem[17] = 2222_BBBB`
- `mem[18] = 3333_CCCC`
- `mem[19] = 4444_DDDD`

### Simulation

Using Icarus Verilog:

```
iverilog -o dma_sim dma.v dma_engine.v memory.v dma_tb.v
vvp dma_sim
```


## 5. Features and Future Improvements

### Features

- 32-bit DMA transfers
- Configurable source and destination addresses
- Configurable transfer length
- FSM-based control
- Synchronous memory model
- `busy`, `done`, and `interrupt` signals
- Separate testbenches for verification

### Future Improvements

- AXI/AHB bus support
- Burst transfers
- Error detection
- FIFO buffering
- Larger memory support
- Additional assertions and verification

### Author

**furqanahmed28**

### License

For educational and research purposes.
