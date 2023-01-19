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
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/rsc $rtldir/rsc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/rsc/enc $rtldir/rsc/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/rsc/dec $rtldir/rsc/dec/*.sv
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/rsc2 $rtldir/rsc2/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/rsc2/enc $rtldir/rsc2/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/rsc2/dec $rtldir/rsc2/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/rsc $tbdir/rsc2/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir +nowarn+3015+3813+2241
run -all
