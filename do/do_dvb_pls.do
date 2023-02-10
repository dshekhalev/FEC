onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/dvb_pls $rtldir/dvb_pls/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/dvb_pls $tbdir/dvb_pls/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
