//
// Project       : 4D-8PSK TCM
// Author        : Shekhalev Denis (des00)
// Workfile      : tcm_pkt_class.svh
// Description   : 4D-8PSK TCM codec data packet class
//

  `include "pkt_class.svh"

  class tcm_pkt_class extends pkt_class #(11);

    bit [1 : 0] code;

    function new (int n, int code = 0);
      super.new(n);
      this.code = code;
    endfunction : new

    constraint data_range
    {
      if (code == 0)
        foreach ( dat[i] ) dat[i][10: 8] == 0;
      else if (code == 1)
        foreach ( dat[i] ) dat[i][10: 9] == 0;
      else if (code == 2)
        foreach ( dat[i] ) dat[i][10:10] == 0;
    }

  endclass

