onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/buffer/*.sv
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ldpc/enc $rtldir/ldpc/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ldpc/dec $rtldir/ldpc/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/ldpc $tbdir/ldpc/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
