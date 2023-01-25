Static configuration 3GPP QC-LDPC + SPC code TS 38.212 v15.7.0

Support Graph1/Graph2

Support all List sets and List index (interface/codec parameters must correspond to selected expansion factor)

Support all coderate (puncture is optional) from 22/24 to 22/68 (Graph1) and from 10/12 to 10/52 (Graph2) 

Coder use special QC-LDPC and SPC engine

Decoder use 2D normalized Min-Sum algorithm with optional metric self-corrected feature 

Attention only decoder with least performance include in repo!!!

vivado 2019.1 Artix 7 - 2 

Graph1, coderate = 22/24, data length = 5632 bits

Encoder speed = 8 bits per tick 

Encoder : LUT/REG/RAMB 	1.4k/1.7k/1.0	>250MHz (1.25Gbps -> 1.4Gbps) 

Decoder speed 1 metrics in 25 column & 4 row per tick, LLR/Node bitwidth = 4bits, data interface 4bits, self-corrected mode on, 10 iteration

Decoder : LUT/REG/RAMB 	8k/12k/61.0 	~250MHz (270Mbps -> 250Mbps) 






