`ifndef __DEFINE_VH__

  `define __DEFINE_VH__

  //------------------------------------------------------------------------------------------------------
  // useful function's
  //------------------------------------------------------------------------------------------------------

  //
  // function to count logarithm for parameters
  //

  function automatic int clogb2 (input int data);
    int i;
    clogb2 = 0;
    if (data > 0) begin
      for (i = 0; 2**i < data; i++) begin
        clogb2 = i + 1;
      end
    end
  endfunction


  function automatic int clog2 (input int data);
    int i;
    clog2 = 0;
    if (data > 0) begin
      for (i = 0; 2**i < data; i++) begin
        clog2 = i + 1;
      end
    end
  endfunction


  function automatic int max (input int a,b);
    max = (a >= b) ? a : b;
  endfunction


  function automatic int min (input int a,b);
    min = (a <= b) ? a : b;
  endfunction


  //
  // function to count ceil(num/div) == floor(num/div) + ((num % div != 0) ? 1 : 0)
  //

  function automatic int ceil (input int num, div);
    ceil = (num/div) + (((num % div) != 0) ? 1 : 0);
  endfunction

`endif
