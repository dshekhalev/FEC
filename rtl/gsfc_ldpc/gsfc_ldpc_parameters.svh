
//
// Project       : GSFC ldpc (7154, 8176)
// Author        : Shekhalev Denis (des00)
// Workfile      : gsfc_ldpc_parameters.svh
// Description   : LDPC codec parameters and needed functions
//

  //------------------------------------------------------------------------------------------------------
  // LDPC code parameters matrix parameters :
  // coderate  - 7/8
  // length    - 8176
  //------------------------------------------------------------------------------------------------------

  localparam int pCODE      =    7;
  localparam int pN         = 8176;

  localparam int pZF        =  511; //  expansion factor

  localparam int pW         =    2; //  weight of submatrix row/column
  localparam int pC         =    2; //  number of submatrix in column
  localparam int pT         =   16; //  number of submatrix in row

  localparam int cLDPC_NUM  = pT * pZF;
  localparam int cLDPC_DNUM = (pT - pC) * pZF;

  typedef int H_t [pC][pT][pW];

  H_t Hb;

  assign Hb = '{
    '{
      '{  0, 176},
      '{ 12, 239},
      '{  0, 352},
      '{ 24, 431},
      '{  0, 392},
      '{151, 409},
      '{  0, 351},
      '{  9, 359},
      '{  0, 307},
      '{ 53, 329},
      '{  0, 207},
      '{ 18, 281},
      '{  0, 399},
      '{202, 457},
      '{  0, 247},
      '{ 36, 261}
    },
    '{
      '{ 99, 471},
      '{130, 473},
      '{198, 435},
      '{260, 478},
      '{215, 420},
      '{282, 481},
      '{ 48, 396},
      '{193, 445},
      '{273, 430},
      '{302, 451},
      '{ 96, 379},
      '{191, 386},
      '{244, 467},
      '{364, 470},
      '{ 51, 382},
      '{192, 414}
    }
  };

  //
  // 2D min-sum normalization factors for all coderates
  //  v-step/h-step normalization is cNORM_BY_8_FACTOR/8

  localparam int cNORM_FACTOR = 6;
