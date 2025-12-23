/*



  parameter int pDAT_W  = 7 ;
  parameter bit pIDX    = 0 ;



  logic                gsfc_ldpc_enc_fbsrl__iclk            ;
  logic                gsfc_ldpc_enc_fbsrl__ireset          ;
  logic                gsfc_ldpc_enc_fbsrl__iclkena         ;
  logic                gsfc_ldpc_enc_fbsrl__iload           ;
  logic        [3 : 0] gsfc_ldpc_enc_fbsrl__iload_idx       ;
  logic                gsfc_ldpc_enc_fbsrl__ishift          ;
  logic [pDAT_W-1 : 0] gsfc_ldpc_enc_fbsrl__obdat     [511] ;



  gsfc_ldpc_enc_fbsrl
  #(
    .pDAT_W ( pDAT_W ) ,
    .pIDX   ( pIDX   )
  )
  gsfc_ldpc_enc_fbsrl
  (
    .iclk      ( gsfc_ldpc_enc_fbsrl__iclk      ) ,
    .ireset    ( gsfc_ldpc_enc_fbsrl__ireset    ) ,
    .iclkena   ( gsfc_ldpc_enc_fbsrl__iclkena   ) ,
    .iload     ( gsfc_ldpc_enc_fbsrl__iload     ) ,
    .iload_idx ( gsfc_ldpc_enc_fbsrl__iload_idx ) ,
    .ishift    ( gsfc_ldpc_enc_fbsrl__ishift    ) ,
    .obdat     ( gsfc_ldpc_enc_fbsrl__obdat     )
  );


  assign gsfc_ldpc_enc_fbsrl__iclk      = '0 ;
  assign gsfc_ldpc_enc_fbsrl__ireset    = '0 ;
  assign gsfc_ldpc_enc_fbsrl__iclkena   = '0 ;
  assign gsfc_ldpc_enc_fbsrl__iload     = '0 ;
  assign gsfc_ldpc_enc_fbsrl__iload_idx = '0 ;
  assign gsfc_ldpc_enc_fbsrl__ishift    = '0 ;



*/

//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_enc_fbsrl.sv
// Description   : The feedback shift register used for LDPC matrix generation, with fixed encoding parameters and variable word length 7/73/511.
//

module gsfc_ldpc_enc_fbsrl
#(
  parameter int pDAT_W  = 7 ,
  parameter bit pIDX    = 0
)
(
  iclk      ,
  ireset    ,
  iclkena   ,
  //
  iload     ,
  iload_idx ,
  ishift    ,
  //
  obdat
);

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  input  logic                iclk            ;
  input  logic                ireset          ;
  input  logic                iclkena         ;
  //
  input  logic                iload           ;
  input  logic        [3 : 0] iload_idx       ;
  input  logic                ishift          ;
  //
  output logic [pDAT_W-1 : 0] obdat     [511] ;

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  typedef bit [510 : 0] dat_t;

  localparam dat_t cBTAB[16][2] = '{
    '{511'h55BF56CC55283DFEEFEA8C8CFF04E1EBD9067710988E25048D67525426939E2068D2DC6FCD2F822BEB6BD96C8A76F4932AAE9BC53AD20A2A9C86BB461E43759C,
      511'h6855AE08698A50AA3051768793DC238544AF3FE987391021AAF6383A6503409C3CE971A80B3ECE12363EE809A01D91204F1811123EAB867D3E40E8C652585D28},
    '{511'h62B21CF0AEE0649FA67B7D0EA6551C1CD194CA77501E0FCF8C85867B9CF679C18BCF7939E10F8550661848A4E0A9E9EDB7DAB9EDABA18C168C8E28AACDDEAB1E,
      511'h64B71F486AD57125660C4512247B229F0017BA649C6C11148FB00B70808286F1A9790748D296A593FA4FD2C6D7AAF7750F0C71B31AEE5B400C7F5D73AAF00710},
    '{511'h681A8E51420BD8294ECE13E491D618083FFBBA830DB5FAF330209877D801F92B5E07117C57E75F6F0D873B3E520F21EAFD78C1612C6228111A369D5790F5929A,
      511'h04DF1DD77F1C20C1FB570D7DD7A1219EAECEA4B2877282651B0FFE713DF338A63263BC0E324A87E2DC1AD64C9F10AAA585ED6905946EE167A73CF04AD2AF9218},
    '{511'h35951FEE6F20C902296C9488003345E6C5526C5519230454C556B8A04FC0DC642D682D94B4594B5197037DF15B5817B26F16D0A3302C09383412822F6D2B234E,
      511'h7681CF7F278380E28F1262B22F40BF3405BFB92311A8A34D084C086464777431DBFDDD2E82A2E6742BAD6533B51B2BDEE0377E9F6E63DCA0B0F1DF97E73D5CD8},
    '{511'h188157AE41830744BAE0ADA6295E08B79A44081E111F69BBE7831D07BEEBF76232E065F752D4F218D39B6C5BF20AE5B8FF172A7F1F680E6BF5AAC3C4343736C2,
      511'h5D80A6007C175B5C0DD88A442440E2C29C6A136BBCE0D95A58A83B48CA0E7474E9476C92E33D164BFF943A61CE1031DFF441B0B175209B498394F4794644392E},
    '{511'h60CD1F1C282A1612657E8C7C1420332CA245C0756F78744C807966C3E1326438878BD2CCC83388415A612705AB192B3512EEF0D95248F7B73E5B0F412BF76DB4,
      511'h434B697B98C9F3E48502C8DBD891D0A0386996146DEBEF11D4B833033E05EDC28F808F25E8F314135E6675B7608B66F7FF3392308242930025DDC4BB65CD7B6E},
    '{511'h766855125CFDC804DAF8DBE3660E8686420230ED4E049DF11D82E357C54FE256EA01F5681D95544C7A1E32B7C30A8E6CF5D0869E754FFDE6AEFA6D7BE8F1B148,
      511'h222975D325A487FE560A6D146311578D9C5501D28BC0A1FB48C9BDA173E869133A3AA9506C42AE9F466E85611FC5F8F74E439638D66D2F00C682987A96D8887C},
    '{511'h14B5F98E8D55FC8E9B4EE453C6963E052147A857AC1E08675D99A308E7269FAC5600D7B155DE8CB1BAC786F45B46B523073692DE745FDF10724DDA38FD093B1C,
      511'h1B71AFFB8117BCF8B5D002A99FEEA49503C0359B056963FE5271140E626F6F8FCE9F29B37047F9CA89EBCE760405C6277F329065DF21AB3B779AB3E8C8955400},
    '{511'h0008B4E899E5F7E692BDCE69CE3FAD997183CFAEB2785D0C3D9CAE510316D4BD65A2A06CBA7F4E4C4A80839ACA81012343648EEA8DBBA2464A68E115AB3F4034,
      511'h5B7FE6808A10EA42FEF0ED9B41920F82023085C106FBBC1F56B567A14257021BC5FDA60CBA05B08FAD6DC3B0410295884C7CCDE0E56347D649DE6DDCEEB0C95E},
    '{511'h5E9B2B33EF82D0E64AA2226D6A0ADCD179D5932EE1CF401B336449D0FF775754CA56650716E61A43F963D59865C7F017F53830514306649822CAA72C152F6EB2,
      511'h2CD8140C8A37DE0D0261259F63AA2A420A8F81FECB661DBA5C62DF6C817B4A61D2BC1F068A50DFD0EA8FE1BD387601062E2276A4987A19A70B460C54F215E184},
    '{511'h06F1FF249192F2EAF063488E267EEE994E7760995C4FA6FFA0E4241825A7F5B65C74FB16AC4C891BC008D33AD4FF97523EE5BD14126916E0502FF2F8E4A07FC2,
      511'h65287840D00243278F41CE1156D1868F24E02F91D3A1886ACE906CE741662B40B4EFDFB90F76C1ADD884D920AFA8B3427EEB84A759FA02E00635743F50B942F0},
    '{511'h4109DA2A24E41B1F375645229981D4B7E88C36A12DAB64E91C764CC43CCEC188EC8C5855C8FF488BB91003602BEF43DBEC4A621048906A2CDC5DBD4103431DB8,
      511'h2185E3BC7076BA51AAD6B199C8C60BCD70E8245B874927136E6D8DD527DF0693DC10A1C8E51B5BE93FF7538FA138B335738F4315361ABF8C73BF40593AE22BE4},
    '{511'h228845775A262505B47288E065B23B4A6D78AFBDDB2356B392C692EF56A35AB4AA27767DE72F058C6484457C95A8CCDD0EF225ABA56B7657B7F0E947DC17F972,
      511'h2630C6F79878E50CF5ABD353A6ED80BEACC7169179EA57435E44411BC7D566136DFA983019F3443DE8E4C60940BC4E31DCEAD514D755AF95A622585D69572692},
    '{511'h7273E8342918E097B1C1F5FEF32A150AEF5E11184782B5BD5A1D8071E94578B0AC722D7BF49E8C78D391294371FFBA7B88FABF8CC03A62B940CE60D669DFB7B6,
      511'h087EA12042793307045B283D7305E93D8F74725034E77D25D3FF043ADC5F8B5B186DB70A968A816835EFB575952EAE7EA4E76DF0D5F097590E1A2A978025573E},
    // padding
    '{511'h0, 511'h0},
    '{511'h0, 511'h0}
  };

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  dat_t   b_srl;
  dat_t   tmp_b_srl [pDAT_W];

  //------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------

  always_ff @(posedge iclk) begin
    if (iclkena) begin
      if (iload) begin
        b_srl <= bit_reverse(cBTAB[iload_idx][pIDX]);
      end
      else if (ishift) begin
        b_srl <= revert_rShift(tmp_b_srl[pDAT_W-1]);
      end
    end
  end

  always_comb begin
    tmp_b_srl[0] = b_srl;
    for (int i = 1; i < pDAT_W; i++) begin
      tmp_b_srl[i] = revert_rShift(tmp_b_srl[i-1]);
    end
    //
    for (int z = 0; z < 511; z++) begin
      for (int i = 0; i < pDAT_W; i++) begin
        obdat[z][i] = tmp_b_srl[i][z];
      end
    end
  end

  //------------------------------------------------------------------------------------------------------
  // usefull functions
  //------------------------------------------------------------------------------------------------------

  function automatic dat_t revert_rShift (dat_t dat);
    revert_rShift = {dat[$high(dat)-1 : 0], dat[$high(dat)]};
  endfunction

  function automatic dat_t bit_reverse (dat_t dat);
    for (int i = 0; i < $size(dat); i++) begin
      bit_reverse[$high(dat)-i] = dat[i];
    end
  endfunction

endmodule
