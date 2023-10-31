Wimax 802.16-2012 BTC code based upon Turbo Product Code (TPC).

Coder/Decoder architecture base upon least RAMB resources using. Decoder use soft decision engines for SPC and Extended Hamming code. 

This units can switch component code modes SPC/eHAM and size 8/16/32/64 each block independetly. 

Decoder input/core/output work in different clock domains. 

vivado 2020.2 Kintex 7 - 2 

Encoder 	: LUT/REG/RAMB 	~310/~300/1.5	>250MHz (up to 250Mbps)

Decoder settings : pLLR_W = 4 bits, 4 iterations

Decoder 	: LUT/REG/RAMB 	4k/5.2k/2.5	>250MHz (~100-200Mbps)

Decoder performance for 4 iteration: 
(57, 64)x(57, 64) = 4889 tick

(26, 32)x(26, 32) = 1561 tick

(11, 16)x(11, 16) = 665 tick 

(4, 8)x(4, 8)     = 345 tick 

(63, 64)x(63, 64) = 4743 tick 

(31, 32)x(31, 32) = 1417 tick 

(15, 16)x(15, 16) = 521 tick 

(7, 8)x(7, 8)     = 256 tick 

Attention: There is no any code shortening(!!!). The coder and decoder correspond each other but can have different bit order with standard codes.  
