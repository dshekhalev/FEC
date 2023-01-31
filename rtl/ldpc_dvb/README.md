Static configuration DVB-S2 LDPC code ETSI EN 302 307 V1.2.1 (2009-08) 

Support all coderates and codewords.

Encoder has fixed performance engine with variable interface bitwidth. 

Decoder use 2D normalized Min-Sum algorithm with near fixed performance engine & fast decoder syndrome based stop logic.

Attention only decoder with least performance include in repo!!! 

Codec input/core/output work in different clock domains. 

vivado 2019.1 Kintex 7 - 2 (artix worked but has timings routing problem)

Encoder settings : coderate = 5/6, block length = 64800 bits, interface 8 bits per tick

Encoder 	: LUT/REG/RAMB 	3.7k/3.5k/15 	iface >250MHz(1.65Gbps -> 2Gbps), core >250MHz (~25.5Gbps at output) 

Decoder settings : coderate = 1/2, block length = 64800 bits, 8 LLR/bits per tick, pLLR_W = 4 bits, 25 iterations

pNODE_W = 6 bits (optimal codegain for 4 bit LLR)

Decoder 	: LUT/REG/RAMB 	56k/69k/133.5 	iface >250MHz, core >250MHz (480Mbps -> 240Mbps)

pNODE_W = 5 bits (good codegain for 4 bit LLR)

Decoder 	: LUT/REG/RAMB 	47k/61k/118.5 	iface >250MHz, core >250MHz (480Mbps -> 240Mbps)

pNODE_W = 4 bits (worst codegain for 4 bit LLR)

Decoder 	: LUT/REG/RAMB 	38k/53k/103.5 	iface >250MHz, core >250MHz (480Mbps -> 240Mbps)

Attention: The coder and decoder correspond each other but can have different bit order with standard codes. Strongly speaking it's not DVB-S2 codec, because there is no parity bits reorder inside. It should be done external of codec during bit interleaving procedure !!! 
