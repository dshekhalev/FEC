Static configurated Gray bit canstellation mapper for BSPK..QAM4096 modulation and corresponding LLR demapper.

Even QAMs and BPSK/8PSK LLR bitwidth can be any, others odd QAMs only LLR = 4bit

vivado 2019.1 Artix 7 - 2 

Gray bit mapper up to QAM4096 		: LUT/REG 	74/181 		>350MHz 

Even QAM LLR demapper up to 4096	: LUT/REG 	500/545 	>250MHz 

Odd QAM LLR demapper up to QAM2048	: LUT/REG/RAMB 	600/760/12.0 	>250MHz 

Odd QAM LLR demapper up to QAM512 	: LUT/REG/RAMB 	331/483/7.5 	>250MHz 

Odd QAM LLR demapper up to QAM128 	: LUT/REG/RAMB 	151/275/3.0 	>250MHz 
					: LUT/REG 	645/548 	>250MHz 

Attnetion: the used map bits to quadrature value converter rules see in tb_qam_mapper.sv file (!!!)
