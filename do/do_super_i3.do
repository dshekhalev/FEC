onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/bch/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/bch/gf $rtldir/bch/gf/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/super_fec/i3 $rtldir/super_fec/i3/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/super_fec/i3 $tbdir/super_fec/i3/bertest.sv

set seed [clock seconds]

vsim -sv_seed $seed bertest -lib $workdir
run -all
