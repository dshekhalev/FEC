Static configuration Reed-Solomon decoder based upon Reformulated Inversion-less Berlekamp algorithm & Chieny Search. 

Generator polynomial generated automatically from module settings. 

There is 4 version of RIBM realisation in simple decoder. The fastest one use "t = d/2" tick only for decoding.

There is 2 verion of RIBM realization in erasure decoder. The fastest one use "2*t = d" tick only for decoding.

Decoders has no any FIFO and use strong external synchronisation inside. It should be reliable completely)

vivado 2019.1 Artix 7 - 2 

RS (240, 210, 30), RIBM take 6*30=180 ticks for simple decoding & 2*30=60 ticks for erasure decoding

Encoder 	      : LUT/REG 	    240/252		      >250MHz (1.75Gbps -> 2Gbps) 

Decoder simple	: LUT/REG/RAMB 	2.2k/1.6k/1.0 	~250MHz (2Gbps -> 1.75Gbps) 

Decoder erasure : LUT/REG/RAMB 	10k/2.6k/1.0 	  ~225MHz (1.8Gbps -> 1.55Gbps) 

Attention: Simple decoder don't revert back symbol errors if "decoder fail" occurred. 
The erasure decoder will revert back symbols to input channel state in that case 


