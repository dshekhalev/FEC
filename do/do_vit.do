onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/viterbi/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/viterbi/vit_1byN $rtldir/viterbi/vit_1byN/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/viterbi/vit_1byN $tbdir/viterbi/vit_1byN/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
