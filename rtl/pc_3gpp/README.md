Non systematic Polar code with frozen bits map from 3GPP TS 38.212 V15.1.1 (2018-4)

Code block size 1024 bits. Coderate [1...1023]/1024. Optional CRC support.

Coder use recursive polar coding algorithm based upon x8 polar codes encode ALU. 

Decoder use fast serial successive cancellation algorithm based upon x4 polar codes decode ALU. 

vivado 2019.1 Artix 7 - 2, LLR = 4bits, coderate = 1/2

Encoder 	: LUT/REG/RAMB 	172/204/2.5	  >250MHz (125Mbps -> 250Mbps) 

Decoder 	: LUT/REG/RAMB 	1.9k/850/4.5 	~125MHz (40Mbps -> 20Mbps) 

Attention: this IP contain behaviour SV models too with separate testbench, because it's not so clear how it works from RTL code. See it in pc_3gpp/beh folder





