Static configuration BCH decoder based upon Inversion-less & Reformulated Inversion-less Berlekamp algorithm & Chieny Search. 

Generator polynomial can be generated automatically from module settings or used from static tables based upon module settings. 

There is 3 version of RIBM realisation in simple, usual and erasure decoders. The fastest one use "t = d/2" tick only for decoding.

There is 3 verion of IBM realization in simple and usual decoder. The fastest one use "2*t = d" tick only for decoding.

Decoders has no any FIFO and use strong external synchronisation inside. It should be reliable completely)


vivado 2019.1 Artix 7 - 2 

BCH (255, 223, 4/9), RIBM take 4*(2*4+1)+1 = 37 ticks for decoding

Encoder 	: LUT/REG 	23/37		~400MHz (350Mbps -> 400Mbps) 

Decoder simple	: LUT/REG/RAMB 	285/357/0.5 	~250MHz (250Mbps -> 220Mbps) 

Decoder 	: LUT/REG/RAMB 	312/402/1.0 	~250MHz (250Mbps -> 220Mbps) 

Decoder erasure : LUT/REG/RAMB 	486/703/1.0 	~250MHz (250Mbps -> 220Mbps) 

Attention: Simple decoder don't revert back symbol errors if "decoder fail" occurred. The erasure and usual decoder will revert back symbols to input channel state in that case 

