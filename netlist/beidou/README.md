BeiDou Navigation Satellite System non-binary LDPC (Open Service Signal B1C (Version 1.0))

Decoder support only BCNV1 SF3 : 64-ary LDPC (88, 44), other codes is not inside netlist.

Decoder use improved extended min-sum (IEMS) decoding with 8 truncated symbols per vector. There is no any post-processing to make decoder better for decoder stall events. There is hard & soft decision (4 bit LLR) decoder netlist. 
 
Maximum decode interations is 8 (!!!). Any interations more then 8 is saturated to 8.

Demo example inside. The expected results is inside "expected_results.png" file. 

vivado 2020.2 Kintex 7 - 2

Decoder	HD : LUT/REG/RAMB 	~3k/~4k/3	~200MHz (BCNV1 SF3 decoding time ~0.4ms for 8 iterations)
Decoder	SD : LUT/REG/RAMB 	~4k/~6k/5	~200MHz (BCNV1 SF3 decoding time ~0.4ms for 8 iterations)
