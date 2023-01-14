Static configuration DVB-S2 LDPC code ETSI EN 302 307 V1.2.1 (2009-08) 

Support all coderates and graphs. 

Encoder has fixed performance engine with variable interface bitwidth. Encoder input/core/output work in different clock domains.  

There is only encoder in repo, keep an eye out for changes)

vivado 2019.1 Artix 7 - 2 

Coderate = 5/6, Block length = 64800 bits.

Encoder interface = 8 bits per tick

Encoder 	: LUT/REG/RAMB 	3.7k/3.5k/15 	iface >250MHz(1.65Gbps -> 2Gbps), core >250MHz (~25.5Gbps at output) 

Attention: Strongly speaking it's not DVB-S2 codec, because there is no parity bits transpose inside. It should be done external of encoder during bit interleaving procedure !!!
