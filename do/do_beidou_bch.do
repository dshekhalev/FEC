onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/buffer $rtldir/buffer/*.sv

vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/beidou/bch $rtldir/beidou/bch/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/beidou/bch $tbdir/beidou/bch/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
