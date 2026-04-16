NASA GSFC LDPC codec (7136, 8160) from Blue book CCSDS 131.0-B-2 for xilinx 7-series & US chips. 

Decoder support only shortened code mode. 

Decoder has 16 bit data interfaces & 16 entry LLR interface. 

Decoder performance is up to 4Gbps at input for 8 iterations at > 350MHz core clock. 

Maximum decode interations is 8 (!!!). Any interations more then 8 is saturated to 8.

Demo example with reference QPSK mapper inside. The expected results is inside "expected_results.png" file. 