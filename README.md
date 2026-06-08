# 8-bit ALU — Verilog

An 8-bit Arithmetic Logic Unit implemented in Verilog supporting 8 operations.

## Operations

| op[2:0] | Operation | Description          |
|---------|-----------|----------------------|
| 000     | ADD       | A + B with carry     |
| 001     | SUB       | A - B with borrow    |
| 010     | AND       | A & B                |
| 011     | OR        | A | B                |
| 100     | XOR       | A ^ B                |
| 101     | NOT       | ~A                   |
| 110     | SHL       | A << 1               |
| 111     | SHR       | A >> 1               |

## Output Flags
- `zero` — result is 0x00
- `carry` — carry/borrow out
- `overflow` — signed overflow
- `negative` — MSB of result

## Simulation

Tool: Icarus Verilog 12.0 on EDA Playground

Run locally:
```bash
iverilog -o sim/alu_sim rtl/alu_8bit.v tb/alu_8bit_tb.v
vvp sim/alu_sim
```

## Waveform

![Simulation waveform](docs/waveform.png)

## Results

26/26 test vectors passed covering all 8 operations including edge cases
(carry out, zero flag, signed overflow, borrow).

## Tools Used
- Language: Verilog (IEEE 1364-2001)
- Simulator: Icarus Verilog 12.0
- Waveform viewer: EPWave / GTKWave# alu-8bit-verilog
8-bit ALU in Verilog with testbench - ADD SUB AND OR XOR NOT SHL SHR
