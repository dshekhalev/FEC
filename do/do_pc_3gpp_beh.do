onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/pc_3gpp/beh $rtldir/pc_3gpp/beh/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/pc_3gpp $tbdir/pc_3gpp/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
