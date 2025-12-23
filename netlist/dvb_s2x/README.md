DVB-S2/S2X compliant codec for xilinx 7-series & US chips.

Support dynamic mode & decode parameters changes on fly, BB scrambler in MSB first mode inside. 

Symbol clock can be up to 400MHz (at core clock/system clock > 300/250MHz). 

Core support mode list:

DVB-S2

	QPSK/8PSK short frame all modes 
 
DVB-S2X VL-SNR 

	VL-SNR set 1 BPSK modes only

	VL-SNR set 2 all modes  

Other modes is not inside netlist & don't working  (!!!)

Demo example with reference QPSK/BSPK mapper inside. The expected results is inside "expected_results.png" file. 