DVB-S2/S2X compliant codec.

Support dynamic mode & decode parameters changes on fly, BB scrambler in MSB first mode inside. 

Symbol clock can be up to 400MHz (at core clock/system clock > 300/250MHz). 

Core support mode list:

DVB-S2
	QPSK/8PSK short frame all modes 
 
DVB-S2X VL-SNR 
	VL-SNR set 1 BPSK modes only
	VL-SNR set 2 all modes  

Other modes will not working correctly (!!!)

There is demo example with reference QPSK/BSPK mapper. 

The expected resuls is inside expected_results.png file. 