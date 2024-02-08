ITU-T G.709 FEC realization

vivado 2020.2 Kintex 7 - 2 

Encoder: 	

LUT/REG	~2.4k/~2.3k	> 250MHz ( > 32Gbps)

Decoder: 

LUT/REG/RAM ~18.8K/~15.1K/10    > 250MHz ( > 32Gbps) 

Attention: The coder and decoder correspond each other but can have different bit order with standard codes.

Decoder don't use RS code decfail decision. If decfail occured it sends incorrect bit fix to output. Change it if needed. 
 

