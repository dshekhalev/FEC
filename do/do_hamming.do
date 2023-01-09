onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir +incdir+$incdir+$rtldir/hamming $rtldir/hamming/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir $tbdir/hamming/hamming_tb.sv

set seed [clock seconds]

vsim -sv_seed $seed hamming_tb -lib $workdir
run -all
