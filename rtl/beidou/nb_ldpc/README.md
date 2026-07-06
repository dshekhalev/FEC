BeiDou Navigation Satellite System non-binary LDPC (Open Service Signal B1C (Version 1.0))

Encoder architecture code modes support 

BCNV1_SF3 : 64-ary LDPC (88,44)

BCNV1_SF2 : 64-ary LDPC (200, 100)

BCNV2     : 64-ary LDPC (96,  48)

BCNV3     : 64-ary LDPC (162, 81)

Encoder can switch code modes each block independetly. 

vivado 2020.2 Kintex 7 - 2, all modes support 

Encoder 	: LUT/REG/RAMB 	~200/~300/10	>250MHz (BCNV1_SF3/BCNV1_SF2 ~4.1/28.1us for block)
