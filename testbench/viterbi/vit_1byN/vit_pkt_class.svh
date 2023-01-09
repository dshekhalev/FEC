//
// Project       : viterbi
// Author        : Shekhalev Denis (des00)
// Workfile      : vit_pkt_class.svh
// Description   : viterbi 1byN codec data packet class
//

  `include "pkt_class.svh"

  class vit_pkt_class extends pkt_class #(1);

    int term_bit_num;

    function new (int n, int term_bit_num = 0);
      super.new(n + term_bit_num);
      this.term_bit_num = term_bit_num;
    endfunction : new

    function void post_randomize ();
      // add termination bits if need
      for (int i = $size(dat) - term_bit_num; i < $size(dat); i++) begin
        dat[i] = 0;
      end
    endfunction

    function int do_compare (vit_pkt_class rdat);
      int err;
    begin
      assert (rdat.dat.size() == dat.size()) else begin
        $error("data array size compare mismatch");
        return dat.size();
      end
      err = 0;
      for (int i = 0; i < $size(dat) - term_bit_num; i++) begin
        err += (dat[i] != rdat.dat[i]);
      end
      return err;
    end
    endfunction

  endclass

