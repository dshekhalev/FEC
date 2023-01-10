onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/bch/*.sv
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/bch/erasure/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/bch $tbdir/bch/bch_eras_enc_dec_tb.sv

set seed [clock seconds]

vsim -sv_seed $seed bch_eras_enc_dec_tb -lib $workdir
run -all
