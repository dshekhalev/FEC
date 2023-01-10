Convolution turbocode from Green Boook CCSDS 130.1-G-2. 

Decoder use MAX-Log Map algorithm and module arithmetic for state registers with extrinsic metric self-corrected algorithm.
Special Extrinsic Memory Architecture give 1 bit per tick decoding speed.


vivado 2019.1 Artix 7 - 2 

data size 1784*5 = 8920 bit, coderate 1/6, decoder iteration = 10

Encoder 	: LUT/REG/RAMB 	175/187/2.0	~200MHz (33Mbps -> 200Mbps) 

Decoder 	: LUT/REG/RAMB 	4k/4.2K/125.0 	~160MHz (48Mbps -> 8Mbps) 
