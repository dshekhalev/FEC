onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/bch/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/rs/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/g709 $rtldir/g709/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/g709 $tbdir/g709/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
