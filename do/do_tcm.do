onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir $rtldir/viterbi/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/TCM_4D_8PSK/enc $rtldir/TCM_4D_8PSK/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/TCM_4D_8PSK/dec $rtldir/TCM_4D_8PSK/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/TCM_4D_8PSK $tbdir/TCM_4D_8PSK/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
