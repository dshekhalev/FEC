//
// Project       : coding library
// Author        : Shekhalev Denis (des00)
// Workfile      : pkt_class.vh
// Description   : base codec data packet class
//

  class pkt_class #(parameter int m = 1);
    rand bit [m-1 : 0] dat [];

    function new (int n);
      dat = new [n];
    endfunction : new

    function int do_compare (pkt_class #(m) rdat);
      int err;
    begin
      assert (rdat.dat.size() == dat.size()) else begin
        $error("data array size compare mismatch");
        return dat.size();
      end
      err = 0;
      for (int i = 0; i < $size(dat); i++) begin
        err += sum_err(dat[i] ^ rdat.dat[i]);
      end
      return err;
    end
    endfunction

    function int sum_err (input bit [m-1 : 0] biterr);
      sum_err = 0;
      for (int i = 0; i < m; i++) begin
        sum_err += biterr[i];
      end
    endfunction

  endclass

