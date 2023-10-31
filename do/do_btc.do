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
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/fifo/*.sv
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/btc/enc $rtldir/btc/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/btc/dec $rtldir/btc/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/btc $tbdir/btc/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
