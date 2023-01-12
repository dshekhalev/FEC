onerror {resume}

set incdir  ../include
set rtldir  ../rtl
set tbdir   ../testbench
set workdir ../work
#
vlib $workdir
#
vlog -work $workdir -incr -sv +incdir+$incdir+$rtldir/llr $rtldir/llr/*.sv

vlog -work $workdir +initreg+0 -sv +incdir+$incdir+$tbdir/bch $tbdir/llr/tb_qam_demapper.sv

set seed [clock seconds]

vsim -sv_seed $seed tb_qam_demapper -lib $workdir +nowarn+8233
run -all
