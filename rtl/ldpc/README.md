Static configuration Wimax QC-LDPC code IEEE 802.16-2012

Support modes 1/2, 2/3B, 3/4A, 5/6, 2/3A, 3/4B and length from 576 to 2304 bits 

It's my first generation QC-LDPC RTL architecture:

Coder work on fly and use register architecture 

Decoder use 2D normalized Min-Sum algorithm with optional metric self-corrected feature 

Only decoder with least performance include in repo!!!

vivado 2019.1 Artix 7 - 2 

Coderate = 5/6, Block length = 2304 bits

Encoder speed = 8 bits per tick 

Encoder 	: LUT/REG 	755/252		>250MHz (1.65Gbps -> 2Gbps) 

Decoder speed 8 metrics per tick, LLR bitwidth = 4bits, 10 iteration

Decoder simple	: LUT/REG/RAMB 	4.6k/7.6k/17.0 	~250MHz (90Mbps -> 75Mbps) 

Attention: to facilitate synthesis, the decoder uses the address file generated during the simulation. The file content depend on the decoder performance settings. Before synthesizing the decoder, run the simulation in the desired mode!!!





