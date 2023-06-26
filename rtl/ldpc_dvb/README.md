Static configuration DVB-S2 LDPC code ETSI EN 302 307 V1.2.1 (2009-08) and DVB-S2X LDPC code DVB BlueBook A083-2 (Feb 2020) 

Support all coderates and codewords.

Encoder has fixed performance engine with variable interface bitwidth. 

Decoder use 2D normalized Min-Sum algorithm with near fixed performance engine, fast decoder syndrome based stop logic, optional 2 types of normalization and self-corrected algorithm.

Attention only decoder with least performance include in repo!!! 

Codec input/core/output work in different clock domains. 

vivado 2019.1 Kintex 7 - 2 (artix worked but has timings routing problem)

Encoder settings : DVB-S2 coderate = 5/6, block length = 64800 bits, interface 8 bits per tick

Encoder 	: LUT/REG/RAMB 	3.7k/3.5k/15 	iface >250MHz(1.65Gbps -> 2Gbps), core >250MHz (~25.5Gbps at output) 

Decoder settings : DVB-S2 coderate = 1/2, block length = 64800 bits, 8 LLR/bits per tick, pLLR_W = 4 bits, pNORM_OFFSET = 0, pUSE_SC_MODE = 1, 25 iterations

pNODE_W = 6 bits (optimal codegain for 4 bit LLR)

Decoder 	: LUT/REG/RAMB 	57k/63k/107.5 	iface >250MHz, core >250MHz (480Mbps -> 240Mbps)

pNODE_W = 5 bits (good codegain for 4 bit LLR)

Decoder 	: LUT/REG/RAMB 	49k/56k/97.5 	iface >250MHz, core >250MHz (480Mbps -> 240Mbps)

pNODE_W = 4 bits (worst codegain for 4 bit LLR)

Decoder 	: LUT/REG/RAMB 	41k/49k/87.5 	iface >250MHz, core >250MHz (480Mbps -> 240Mbps)

Attention: The coder and decoder correspond each other but can have different bit order with standard codes. Strongly speaking it's not DVB-S2 codec, because there is no parity bits reorder inside. It should be done external of codec during bit interleaving procedure !!! 
