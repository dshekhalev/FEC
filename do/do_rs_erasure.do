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
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir $rtldir/rs/erasure/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/bch $tbdir/rs/rs_eras_enc_dec_tb.sv

set seed [clock seconds]

vsim -sv_seed $seed rs_eras_enc_dec_tb -lib $workdir
run -all
