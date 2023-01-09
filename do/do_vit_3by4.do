onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/viterbi/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/viterbi/vit_3by4 $rtldir/viterbi/vit_3by4/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/viterbi/vit_3by4 $tbdir/viterbi/vit_3by4/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
