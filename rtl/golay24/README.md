Extended Gollay (24,12,8) soft decoder. Generator polynome is g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1 (12'hC75) 

Encoder use syndrome coding.
Decoder use Chase II algorithm with 16 candidates and syndrome decoding.

vivado 2019.1 Artix 7 - 2

Encoder : LUT/REG 	18/52 		>250MHz (3Gbps) 
Decoder : LUT/REG/RAMB 	652/936/2 	>250MHz (250Mbps) 