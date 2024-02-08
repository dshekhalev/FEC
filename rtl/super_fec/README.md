ITU-T G.975.1 (Super FEC) some codes realization 

I.3 Concatenated BCH super FEC codes 

vivado 2020.2 Kintex 7 - 2 

Encoder: 	

LUT/REG/BRAM 	~2k/~2.5k/7.5	> 250MHz ( > 32Gbps)

Decoder, 3 iterations, endpoint mode: 

LUT/REG/BRAM	~113k/~97k/73.5	> 156.25MHz (with fanout optimization) ( > 20Gbps)

Attention: The coder and decoder correspond each other but can have different bit order with standard codes.  
