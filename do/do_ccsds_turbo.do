onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/buffer/*.sv

vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ccsds_turbo $rtldir/ccsds_turbo/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ccsds_turbo/enc $rtldir/ccsds_turbo/enc/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/ccsds_turbo/dec $rtldir/ccsds_turbo/dec/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/bch $tbdir/ccsds_turbo/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir +nowarn+3813
run -all
