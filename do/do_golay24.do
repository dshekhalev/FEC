onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/golay24 $rtldir/golay24/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/golay24/dec $rtldir/golay24/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/golay24 $tbdir/golay24/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
