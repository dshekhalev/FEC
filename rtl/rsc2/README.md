Dynamic configuration DVB-RSC2 (ETSI EN 301 545-2 V1.2.1) duo-binary convolution turbo code with MAX-Log-MAP decoding.

Supported modes: all modes defined in Table A-1/2/4/5

Supports code rates: [1/3; 1/2; 2/3; 3/4; 4/5; 5/6; 6/7; 7/8]

Encoder uses two pass coding with minimal delays. 

Decoder uses special MAP engine with 1 duo-bits per tick processing and simultaneous forward/backard recursion. 

vivado 2019.1 Artix 7 - 2 

Wimax OFDMA Nduobits = 152(304 bits), coderate = 1/2, 5bit metric, 10 iteration. Encoder use output buffer 

Encoder 	: LUT/REG/RAMB	330/255/2.0	>200MHz (245Mbps -> 490Mbps) 

Decoder simple	: LUT/REG/RAMB 	9.5k/8k/10.0 	~160MHz (29Mbps -> 14.5Mbps) 

Attention: This is only CTC codec. There is no bits permutation or interleaving. The coder and decoder correspond each other but can have different bit order with standard codes. 
