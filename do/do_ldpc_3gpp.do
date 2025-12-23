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
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/biterr_cnt/*.sv
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ldpc_3gpp/enc $rtldir/ldpc_3gpp/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ldpc_3gpp/dec $rtldir/ldpc_3gpp/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/ldpc $tbdir/ldpc_3gpp/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
