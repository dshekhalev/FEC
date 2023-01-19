Static configuration DVB-RSC (ETSI EN 301 790 V1.5.1) & Wimax CTC (IEEE Std 802.16-2009) duo-binary convolution turbo code with MAX-Log-MAP decoding.

Supported modes: DVB-RCS 12 modes, Wimax OFDM 4 P0 factor up to 4096 duo-bits , Wimax OFDMA 16 modes.

Supports code rates: all defined in the standards + additional code rates like 7/8, 8/9, 9/10 or 3/7 

Encoder uses two pass coding with minimal delays. 

Decoder uses special MAP engine with 1 duo-bits per tick processing and simultaneous forward/backard recursion. 

vivado 2019.1 Artix 7 - 2 

Wimax OFDMA Nduobits = 1920(3840 bits), coderate = 2/3, 5bit metric, 10 iteration. Encoder use output buffer 

Encoder 	: LUT/REG/RAMB	210/179/2.0	>200MHz (200Mbps -> 300Mbps) 

Decoder simple	: LUT/REG/RAMB 	5.3k/4.7k/12.0 	~160MHz (24Mbps -> 16Mbps) 

Attention: This is only CTC codecs. There is no bits permutation or interleaving. The coder and decoder correspond each other but can have different bit order with standard codes. 
