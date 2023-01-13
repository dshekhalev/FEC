onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/buffer/*.sv

vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/pc_3gpp $rtldir/pc_3gpp/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/pc_3gpp/enc $rtldir/pc_3gpp/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/pc_3gpp/dec $rtldir/pc_3gpp/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/pc_3gpp $tbdir/pc_3gpp/bertest_rtl.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest_rtl -lib $workdir
run -all
