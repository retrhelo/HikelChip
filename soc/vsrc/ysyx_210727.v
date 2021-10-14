module ysyx_210727_Fetch(
  input         clock,
  input         reset,
  input         io_enable,
  input         io_trap,
  output [63:0] io_iread_bits_addr,
  input         io_iread_bits_excp,
  input         io_iread_bits_misalign,
  input  [63:0] io_iread_bits_data,
  output        io_iread_valid,
  input         io_iread_ready,
  output        io_hshake,
  input         io_change_pc,
  input  [31:0] io_new_pc,
  input         io_mret,
  output [31:0] io_out_pc,
  output        io_out_excp,
  output [3:0]  io_out_code,
  output [31:0] io_out_inst,
  input  [63:0] mepc_0,
  input  [63:0] mtvec_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_pc_1; // @[Fetch.scala 44:37]
  wire [31:0] next_pc = reg_pc_1 + 32'h4; // @[Fetch.scala 45:38]
  wire [31:0] _GEN_5 = io_enable ? next_pc : reg_pc_1; // @[Fetch.scala 60:36 Fetch.scala 61:32 Fetch.scala 44:37]
  wire [31:0] mepc = mepc_0[31:0];
  wire [31:0] mtvec = mtvec_0[31:0];
  reg [31:0] reg_inst_1; // @[Fetch.scala 71:39]
  assign io_iread_bits_addr = {{32'd0}, reg_pc_1}; // @[Fetch.scala 66:36]
  assign io_iread_valid = 1'h1; // @[Fetch.scala 65:32]
  assign io_hshake = ~io_iread_valid | io_iread_valid & io_iread_ready; // @[Fetch.scala 69:46]
  assign io_out_pc = reg_pc_1; // @[Fetch.scala 80:27]
  assign io_out_excp = io_iread_bits_excp; // @[Fetch.scala 84:29]
  assign io_out_code = io_iread_bits_misalign ? 4'h0 : 4'h1; // @[Fetch.scala 85:35]
  assign io_out_inst = io_hshake ? io_iread_bits_data[31:0] : reg_inst_1; // @[Fetch.scala 79:35]
  always @(posedge clock) begin
    if (reset) begin // @[Fetch.scala 44:37]
      reg_pc_1 <= 32'h30000000; // @[Fetch.scala 44:37]
    end else if (io_trap) begin // @[Fetch.scala 51:32]
      reg_pc_1 <= mtvec; // @[Fetch.scala 52:32]
    end else if (io_mret) begin // @[Fetch.scala 54:37]
      reg_pc_1 <= mepc; // @[Fetch.scala 55:32]
    end else if (io_change_pc) begin // @[Fetch.scala 57:42]
      reg_pc_1 <= io_new_pc; // @[Fetch.scala 58:32]
    end else begin
      reg_pc_1 <= _GEN_5;
    end
    if (reset) begin // @[Fetch.scala 71:39]
      reg_inst_1 <= 32'h0; // @[Fetch.scala 71:39]
    end else if (io_hshake) begin // @[Fetch.scala 72:34]
      reg_inst_1 <= io_iread_bits_data[31:0]; // @[Fetch.scala 73:34]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_pc_1 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_inst_1 = _RAND_1[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_InstDecode(
  input  [31:0] io_inst,
  output        io_out_illegal,
  output        io_out_lui,
  output        io_out_auipc,
  output        io_out_jal,
  output        io_out_jalr,
  output        io_out_branch,
  output        io_out_load,
  output        io_out_store,
  output        io_out_csr,
  output        io_out_ecall,
  output        io_out_ebreak,
  output        io_out_mret,
  output        io_out_rd_wen,
  output [2:0]  io_out_imm_type,
  output        io_out_rs1_use,
  output        io_out_rs2_use,
  output        io_out_arith,
  output        io_out_word
);
  wire [31:0] _list_T = io_inst & 32'h7f; // @[Lookup.scala 31:38]
  wire  list_1 = 32'h37 == _list_T; // @[Lookup.scala 31:38]
  wire  _list_T_3 = 32'h17 == _list_T; // @[Lookup.scala 31:38]
  wire  _list_T_5 = 32'h6f == _list_T; // @[Lookup.scala 31:38]
  wire [31:0] _list_T_6 = io_inst & 32'h707f; // @[Lookup.scala 31:38]
  wire  _list_T_7 = 32'h67 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_9 = 32'h63 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_11 = 32'h1063 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_13 = 32'h4063 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_15 = 32'h5063 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_17 = 32'h6063 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_19 = 32'h7063 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_21 = 32'h3 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_23 = 32'h1003 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_25 = 32'h2003 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_27 = 32'h4003 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_29 = 32'h5003 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_31 = 32'h6003 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_33 = 32'h3003 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_35 = 32'h23 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_37 = 32'h1023 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_39 = 32'h2023 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_41 = 32'h3023 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_43 = 32'h13 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_45 = 32'h1b == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_47 = 32'h2013 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_49 = 32'h3013 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_51 = 32'h4013 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_53 = 32'h6013 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_55 = 32'h7013 == _list_T_6; // @[Lookup.scala 31:38]
  wire [31:0] _list_T_56 = io_inst & 32'hfc00707f; // @[Lookup.scala 31:38]
  wire  _list_T_57 = 32'h1013 == _list_T_56; // @[Lookup.scala 31:38]
  wire [31:0] _list_T_58 = io_inst & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _list_T_59 = 32'h101b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_61 = 32'h5013 == _list_T_56; // @[Lookup.scala 31:38]
  wire  _list_T_63 = 32'h501b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_65 = 32'h40005013 == _list_T_56; // @[Lookup.scala 31:38]
  wire  _list_T_67 = 32'h4000501b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_69 = 32'h33 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_71 = 32'h3b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_73 = 32'h40000033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_75 = 32'h4000003b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_77 = 32'h1033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_79 = 32'h103b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_81 = 32'h2033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_83 = 32'h3033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_85 = 32'h4033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_87 = 32'h5033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_89 = 32'h503b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_91 = 32'h40005033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_93 = 32'h4000503b == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_95 = 32'h6033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_97 = 32'h7033 == _list_T_58; // @[Lookup.scala 31:38]
  wire  _list_T_99 = 32'hf == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_101 = 32'h73 == io_inst; // @[Lookup.scala 31:38]
  wire  _list_T_103 = 32'h100073 == io_inst; // @[Lookup.scala 31:38]
  wire  _list_T_105 = 32'h30200073 == io_inst; // @[Lookup.scala 31:38]
  wire  _list_T_107 = 32'h1073 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_109 = 32'h2073 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_111 = 32'h3073 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_113 = 32'h5073 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_115 = 32'h6073 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_117 = 32'h7073 == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_119 = 32'h100f == _list_T_6; // @[Lookup.scala 31:38]
  wire  _list_T_120 = _list_T_119 ? 1'h0 : 1'h1; // @[Lookup.scala 33:37]
  wire  _list_T_121 = _list_T_117 ? 1'h0 : _list_T_120; // @[Lookup.scala 33:37]
  wire  _list_T_122 = _list_T_115 ? 1'h0 : _list_T_121; // @[Lookup.scala 33:37]
  wire  _list_T_123 = _list_T_113 ? 1'h0 : _list_T_122; // @[Lookup.scala 33:37]
  wire  _list_T_124 = _list_T_111 ? 1'h0 : _list_T_123; // @[Lookup.scala 33:37]
  wire  _list_T_125 = _list_T_109 ? 1'h0 : _list_T_124; // @[Lookup.scala 33:37]
  wire  _list_T_126 = _list_T_107 ? 1'h0 : _list_T_125; // @[Lookup.scala 33:37]
  wire  _list_T_127 = _list_T_105 ? 1'h0 : _list_T_126; // @[Lookup.scala 33:37]
  wire  _list_T_128 = _list_T_103 ? 1'h0 : _list_T_127; // @[Lookup.scala 33:37]
  wire  _list_T_129 = _list_T_101 ? 1'h0 : _list_T_128; // @[Lookup.scala 33:37]
  wire  _list_T_130 = _list_T_99 ? 1'h0 : _list_T_129; // @[Lookup.scala 33:37]
  wire  _list_T_131 = _list_T_97 ? 1'h0 : _list_T_130; // @[Lookup.scala 33:37]
  wire  _list_T_132 = _list_T_95 ? 1'h0 : _list_T_131; // @[Lookup.scala 33:37]
  wire  _list_T_133 = _list_T_93 ? 1'h0 : _list_T_132; // @[Lookup.scala 33:37]
  wire  _list_T_134 = _list_T_91 ? 1'h0 : _list_T_133; // @[Lookup.scala 33:37]
  wire  _list_T_135 = _list_T_89 ? 1'h0 : _list_T_134; // @[Lookup.scala 33:37]
  wire  _list_T_136 = _list_T_87 ? 1'h0 : _list_T_135; // @[Lookup.scala 33:37]
  wire  _list_T_137 = _list_T_85 ? 1'h0 : _list_T_136; // @[Lookup.scala 33:37]
  wire  _list_T_138 = _list_T_83 ? 1'h0 : _list_T_137; // @[Lookup.scala 33:37]
  wire  _list_T_139 = _list_T_81 ? 1'h0 : _list_T_138; // @[Lookup.scala 33:37]
  wire  _list_T_140 = _list_T_79 ? 1'h0 : _list_T_139; // @[Lookup.scala 33:37]
  wire  _list_T_141 = _list_T_77 ? 1'h0 : _list_T_140; // @[Lookup.scala 33:37]
  wire  _list_T_142 = _list_T_75 ? 1'h0 : _list_T_141; // @[Lookup.scala 33:37]
  wire  _list_T_143 = _list_T_73 ? 1'h0 : _list_T_142; // @[Lookup.scala 33:37]
  wire  _list_T_144 = _list_T_71 ? 1'h0 : _list_T_143; // @[Lookup.scala 33:37]
  wire  _list_T_145 = _list_T_69 ? 1'h0 : _list_T_144; // @[Lookup.scala 33:37]
  wire  _list_T_146 = _list_T_67 ? 1'h0 : _list_T_145; // @[Lookup.scala 33:37]
  wire  _list_T_147 = _list_T_65 ? 1'h0 : _list_T_146; // @[Lookup.scala 33:37]
  wire  _list_T_148 = _list_T_63 ? 1'h0 : _list_T_147; // @[Lookup.scala 33:37]
  wire  _list_T_149 = _list_T_61 ? 1'h0 : _list_T_148; // @[Lookup.scala 33:37]
  wire  _list_T_150 = _list_T_59 ? 1'h0 : _list_T_149; // @[Lookup.scala 33:37]
  wire  _list_T_151 = _list_T_57 ? 1'h0 : _list_T_150; // @[Lookup.scala 33:37]
  wire  _list_T_152 = _list_T_55 ? 1'h0 : _list_T_151; // @[Lookup.scala 33:37]
  wire  _list_T_153 = _list_T_53 ? 1'h0 : _list_T_152; // @[Lookup.scala 33:37]
  wire  _list_T_154 = _list_T_51 ? 1'h0 : _list_T_153; // @[Lookup.scala 33:37]
  wire  _list_T_155 = _list_T_49 ? 1'h0 : _list_T_154; // @[Lookup.scala 33:37]
  wire  _list_T_156 = _list_T_47 ? 1'h0 : _list_T_155; // @[Lookup.scala 33:37]
  wire  _list_T_157 = _list_T_45 ? 1'h0 : _list_T_156; // @[Lookup.scala 33:37]
  wire  _list_T_158 = _list_T_43 ? 1'h0 : _list_T_157; // @[Lookup.scala 33:37]
  wire  _list_T_159 = _list_T_41 ? 1'h0 : _list_T_158; // @[Lookup.scala 33:37]
  wire  _list_T_160 = _list_T_39 ? 1'h0 : _list_T_159; // @[Lookup.scala 33:37]
  wire  _list_T_161 = _list_T_37 ? 1'h0 : _list_T_160; // @[Lookup.scala 33:37]
  wire  _list_T_162 = _list_T_35 ? 1'h0 : _list_T_161; // @[Lookup.scala 33:37]
  wire  _list_T_163 = _list_T_33 ? 1'h0 : _list_T_162; // @[Lookup.scala 33:37]
  wire  _list_T_164 = _list_T_31 ? 1'h0 : _list_T_163; // @[Lookup.scala 33:37]
  wire  _list_T_165 = _list_T_29 ? 1'h0 : _list_T_164; // @[Lookup.scala 33:37]
  wire  _list_T_166 = _list_T_27 ? 1'h0 : _list_T_165; // @[Lookup.scala 33:37]
  wire  _list_T_167 = _list_T_25 ? 1'h0 : _list_T_166; // @[Lookup.scala 33:37]
  wire  _list_T_168 = _list_T_23 ? 1'h0 : _list_T_167; // @[Lookup.scala 33:37]
  wire  _list_T_169 = _list_T_21 ? 1'h0 : _list_T_168; // @[Lookup.scala 33:37]
  wire  _list_T_170 = _list_T_19 ? 1'h0 : _list_T_169; // @[Lookup.scala 33:37]
  wire  _list_T_171 = _list_T_17 ? 1'h0 : _list_T_170; // @[Lookup.scala 33:37]
  wire  _list_T_172 = _list_T_15 ? 1'h0 : _list_T_171; // @[Lookup.scala 33:37]
  wire  _list_T_173 = _list_T_13 ? 1'h0 : _list_T_172; // @[Lookup.scala 33:37]
  wire  _list_T_174 = _list_T_11 ? 1'h0 : _list_T_173; // @[Lookup.scala 33:37]
  wire  _list_T_175 = _list_T_9 ? 1'h0 : _list_T_174; // @[Lookup.scala 33:37]
  wire  _list_T_176 = _list_T_7 ? 1'h0 : _list_T_175; // @[Lookup.scala 33:37]
  wire  _list_T_177 = _list_T_5 ? 1'h0 : _list_T_176; // @[Lookup.scala 33:37]
  wire  _list_T_178 = _list_T_3 ? 1'h0 : _list_T_177; // @[Lookup.scala 33:37]
  wire  _list_T_355 = _list_T_3 ? 1'h0 : _list_T_5; // @[Lookup.scala 33:37]
  wire  _list_T_413 = _list_T_5 ? 1'h0 : _list_T_7; // @[Lookup.scala 33:37]
  wire  _list_T_414 = _list_T_3 ? 1'h0 : _list_T_413; // @[Lookup.scala 33:37]
  wire  _list_T_471 = _list_T_7 ? 1'h0 : _list_T_9 | (_list_T_11 | (_list_T_13 | (_list_T_15 | (_list_T_17 | _list_T_19)
    ))); // @[Lookup.scala 33:37]
  wire  _list_T_472 = _list_T_5 ? 1'h0 : _list_T_471; // @[Lookup.scala 33:37]
  wire  _list_T_473 = _list_T_3 ? 1'h0 : _list_T_472; // @[Lookup.scala 33:37]
  wire  _list_T_524 = _list_T_19 ? 1'h0 : _list_T_21 | (_list_T_23 | (_list_T_25 | (_list_T_27 | (_list_T_29 | (
    _list_T_31 | _list_T_33))))); // @[Lookup.scala 33:37]
  wire  _list_T_525 = _list_T_17 ? 1'h0 : _list_T_524; // @[Lookup.scala 33:37]
  wire  _list_T_526 = _list_T_15 ? 1'h0 : _list_T_525; // @[Lookup.scala 33:37]
  wire  _list_T_527 = _list_T_13 ? 1'h0 : _list_T_526; // @[Lookup.scala 33:37]
  wire  _list_T_528 = _list_T_11 ? 1'h0 : _list_T_527; // @[Lookup.scala 33:37]
  wire  _list_T_529 = _list_T_9 ? 1'h0 : _list_T_528; // @[Lookup.scala 33:37]
  wire  _list_T_530 = _list_T_7 ? 1'h0 : _list_T_529; // @[Lookup.scala 33:37]
  wire  _list_T_531 = _list_T_5 ? 1'h0 : _list_T_530; // @[Lookup.scala 33:37]
  wire  _list_T_532 = _list_T_3 ? 1'h0 : _list_T_531; // @[Lookup.scala 33:37]
  wire  _list_T_576 = _list_T_33 ? 1'h0 : _list_T_35 | (_list_T_37 | (_list_T_39 | _list_T_41)); // @[Lookup.scala 33:37]
  wire  _list_T_577 = _list_T_31 ? 1'h0 : _list_T_576; // @[Lookup.scala 33:37]
  wire  _list_T_578 = _list_T_29 ? 1'h0 : _list_T_577; // @[Lookup.scala 33:37]
  wire  _list_T_579 = _list_T_27 ? 1'h0 : _list_T_578; // @[Lookup.scala 33:37]
  wire  _list_T_580 = _list_T_25 ? 1'h0 : _list_T_579; // @[Lookup.scala 33:37]
  wire  _list_T_581 = _list_T_23 ? 1'h0 : _list_T_580; // @[Lookup.scala 33:37]
  wire  _list_T_582 = _list_T_21 ? 1'h0 : _list_T_581; // @[Lookup.scala 33:37]
  wire  _list_T_583 = _list_T_19 ? 1'h0 : _list_T_582; // @[Lookup.scala 33:37]
  wire  _list_T_584 = _list_T_17 ? 1'h0 : _list_T_583; // @[Lookup.scala 33:37]
  wire  _list_T_585 = _list_T_15 ? 1'h0 : _list_T_584; // @[Lookup.scala 33:37]
  wire  _list_T_586 = _list_T_13 ? 1'h0 : _list_T_585; // @[Lookup.scala 33:37]
  wire  _list_T_587 = _list_T_11 ? 1'h0 : _list_T_586; // @[Lookup.scala 33:37]
  wire  _list_T_588 = _list_T_9 ? 1'h0 : _list_T_587; // @[Lookup.scala 33:37]
  wire  _list_T_589 = _list_T_7 ? 1'h0 : _list_T_588; // @[Lookup.scala 33:37]
  wire  _list_T_590 = _list_T_5 ? 1'h0 : _list_T_589; // @[Lookup.scala 33:37]
  wire  _list_T_591 = _list_T_3 ? 1'h0 : _list_T_590; // @[Lookup.scala 33:37]
  wire  _list_T_599 = _list_T_105 ? 1'h0 : _list_T_107 | (_list_T_109 | (_list_T_111 | (_list_T_113 | (_list_T_115 |
    _list_T_117)))); // @[Lookup.scala 33:37]
  wire  _list_T_600 = _list_T_103 ? 1'h0 : _list_T_599; // @[Lookup.scala 33:37]
  wire  _list_T_601 = _list_T_101 ? 1'h0 : _list_T_600; // @[Lookup.scala 33:37]
  wire  _list_T_602 = _list_T_99 ? 1'h0 : _list_T_601; // @[Lookup.scala 33:37]
  wire  _list_T_603 = _list_T_97 ? 1'h0 : _list_T_602; // @[Lookup.scala 33:37]
  wire  _list_T_604 = _list_T_95 ? 1'h0 : _list_T_603; // @[Lookup.scala 33:37]
  wire  _list_T_605 = _list_T_93 ? 1'h0 : _list_T_604; // @[Lookup.scala 33:37]
  wire  _list_T_606 = _list_T_91 ? 1'h0 : _list_T_605; // @[Lookup.scala 33:37]
  wire  _list_T_607 = _list_T_89 ? 1'h0 : _list_T_606; // @[Lookup.scala 33:37]
  wire  _list_T_608 = _list_T_87 ? 1'h0 : _list_T_607; // @[Lookup.scala 33:37]
  wire  _list_T_609 = _list_T_85 ? 1'h0 : _list_T_608; // @[Lookup.scala 33:37]
  wire  _list_T_610 = _list_T_83 ? 1'h0 : _list_T_609; // @[Lookup.scala 33:37]
  wire  _list_T_611 = _list_T_81 ? 1'h0 : _list_T_610; // @[Lookup.scala 33:37]
  wire  _list_T_612 = _list_T_79 ? 1'h0 : _list_T_611; // @[Lookup.scala 33:37]
  wire  _list_T_613 = _list_T_77 ? 1'h0 : _list_T_612; // @[Lookup.scala 33:37]
  wire  _list_T_614 = _list_T_75 ? 1'h0 : _list_T_613; // @[Lookup.scala 33:37]
  wire  _list_T_615 = _list_T_73 ? 1'h0 : _list_T_614; // @[Lookup.scala 33:37]
  wire  _list_T_616 = _list_T_71 ? 1'h0 : _list_T_615; // @[Lookup.scala 33:37]
  wire  _list_T_617 = _list_T_69 ? 1'h0 : _list_T_616; // @[Lookup.scala 33:37]
  wire  _list_T_618 = _list_T_67 ? 1'h0 : _list_T_617; // @[Lookup.scala 33:37]
  wire  _list_T_619 = _list_T_65 ? 1'h0 : _list_T_618; // @[Lookup.scala 33:37]
  wire  _list_T_620 = _list_T_63 ? 1'h0 : _list_T_619; // @[Lookup.scala 33:37]
  wire  _list_T_621 = _list_T_61 ? 1'h0 : _list_T_620; // @[Lookup.scala 33:37]
  wire  _list_T_622 = _list_T_59 ? 1'h0 : _list_T_621; // @[Lookup.scala 33:37]
  wire  _list_T_623 = _list_T_57 ? 1'h0 : _list_T_622; // @[Lookup.scala 33:37]
  wire  _list_T_624 = _list_T_55 ? 1'h0 : _list_T_623; // @[Lookup.scala 33:37]
  wire  _list_T_625 = _list_T_53 ? 1'h0 : _list_T_624; // @[Lookup.scala 33:37]
  wire  _list_T_626 = _list_T_51 ? 1'h0 : _list_T_625; // @[Lookup.scala 33:37]
  wire  _list_T_627 = _list_T_49 ? 1'h0 : _list_T_626; // @[Lookup.scala 33:37]
  wire  _list_T_628 = _list_T_47 ? 1'h0 : _list_T_627; // @[Lookup.scala 33:37]
  wire  _list_T_629 = _list_T_45 ? 1'h0 : _list_T_628; // @[Lookup.scala 33:37]
  wire  _list_T_630 = _list_T_43 ? 1'h0 : _list_T_629; // @[Lookup.scala 33:37]
  wire  _list_T_631 = _list_T_41 ? 1'h0 : _list_T_630; // @[Lookup.scala 33:37]
  wire  _list_T_632 = _list_T_39 ? 1'h0 : _list_T_631; // @[Lookup.scala 33:37]
  wire  _list_T_633 = _list_T_37 ? 1'h0 : _list_T_632; // @[Lookup.scala 33:37]
  wire  _list_T_634 = _list_T_35 ? 1'h0 : _list_T_633; // @[Lookup.scala 33:37]
  wire  _list_T_635 = _list_T_33 ? 1'h0 : _list_T_634; // @[Lookup.scala 33:37]
  wire  _list_T_636 = _list_T_31 ? 1'h0 : _list_T_635; // @[Lookup.scala 33:37]
  wire  _list_T_637 = _list_T_29 ? 1'h0 : _list_T_636; // @[Lookup.scala 33:37]
  wire  _list_T_638 = _list_T_27 ? 1'h0 : _list_T_637; // @[Lookup.scala 33:37]
  wire  _list_T_639 = _list_T_25 ? 1'h0 : _list_T_638; // @[Lookup.scala 33:37]
  wire  _list_T_640 = _list_T_23 ? 1'h0 : _list_T_639; // @[Lookup.scala 33:37]
  wire  _list_T_641 = _list_T_21 ? 1'h0 : _list_T_640; // @[Lookup.scala 33:37]
  wire  _list_T_642 = _list_T_19 ? 1'h0 : _list_T_641; // @[Lookup.scala 33:37]
  wire  _list_T_643 = _list_T_17 ? 1'h0 : _list_T_642; // @[Lookup.scala 33:37]
  wire  _list_T_644 = _list_T_15 ? 1'h0 : _list_T_643; // @[Lookup.scala 33:37]
  wire  _list_T_645 = _list_T_13 ? 1'h0 : _list_T_644; // @[Lookup.scala 33:37]
  wire  _list_T_646 = _list_T_11 ? 1'h0 : _list_T_645; // @[Lookup.scala 33:37]
  wire  _list_T_647 = _list_T_9 ? 1'h0 : _list_T_646; // @[Lookup.scala 33:37]
  wire  _list_T_648 = _list_T_7 ? 1'h0 : _list_T_647; // @[Lookup.scala 33:37]
  wire  _list_T_649 = _list_T_5 ? 1'h0 : _list_T_648; // @[Lookup.scala 33:37]
  wire  _list_T_650 = _list_T_3 ? 1'h0 : _list_T_649; // @[Lookup.scala 33:37]
  wire  _list_T_661 = _list_T_99 ? 1'h0 : _list_T_101; // @[Lookup.scala 33:37]
  wire  _list_T_662 = _list_T_97 ? 1'h0 : _list_T_661; // @[Lookup.scala 33:37]
  wire  _list_T_663 = _list_T_95 ? 1'h0 : _list_T_662; // @[Lookup.scala 33:37]
  wire  _list_T_664 = _list_T_93 ? 1'h0 : _list_T_663; // @[Lookup.scala 33:37]
  wire  _list_T_665 = _list_T_91 ? 1'h0 : _list_T_664; // @[Lookup.scala 33:37]
  wire  _list_T_666 = _list_T_89 ? 1'h0 : _list_T_665; // @[Lookup.scala 33:37]
  wire  _list_T_667 = _list_T_87 ? 1'h0 : _list_T_666; // @[Lookup.scala 33:37]
  wire  _list_T_668 = _list_T_85 ? 1'h0 : _list_T_667; // @[Lookup.scala 33:37]
  wire  _list_T_669 = _list_T_83 ? 1'h0 : _list_T_668; // @[Lookup.scala 33:37]
  wire  _list_T_670 = _list_T_81 ? 1'h0 : _list_T_669; // @[Lookup.scala 33:37]
  wire  _list_T_671 = _list_T_79 ? 1'h0 : _list_T_670; // @[Lookup.scala 33:37]
  wire  _list_T_672 = _list_T_77 ? 1'h0 : _list_T_671; // @[Lookup.scala 33:37]
  wire  _list_T_673 = _list_T_75 ? 1'h0 : _list_T_672; // @[Lookup.scala 33:37]
  wire  _list_T_674 = _list_T_73 ? 1'h0 : _list_T_673; // @[Lookup.scala 33:37]
  wire  _list_T_675 = _list_T_71 ? 1'h0 : _list_T_674; // @[Lookup.scala 33:37]
  wire  _list_T_676 = _list_T_69 ? 1'h0 : _list_T_675; // @[Lookup.scala 33:37]
  wire  _list_T_677 = _list_T_67 ? 1'h0 : _list_T_676; // @[Lookup.scala 33:37]
  wire  _list_T_678 = _list_T_65 ? 1'h0 : _list_T_677; // @[Lookup.scala 33:37]
  wire  _list_T_679 = _list_T_63 ? 1'h0 : _list_T_678; // @[Lookup.scala 33:37]
  wire  _list_T_680 = _list_T_61 ? 1'h0 : _list_T_679; // @[Lookup.scala 33:37]
  wire  _list_T_681 = _list_T_59 ? 1'h0 : _list_T_680; // @[Lookup.scala 33:37]
  wire  _list_T_682 = _list_T_57 ? 1'h0 : _list_T_681; // @[Lookup.scala 33:37]
  wire  _list_T_683 = _list_T_55 ? 1'h0 : _list_T_682; // @[Lookup.scala 33:37]
  wire  _list_T_684 = _list_T_53 ? 1'h0 : _list_T_683; // @[Lookup.scala 33:37]
  wire  _list_T_685 = _list_T_51 ? 1'h0 : _list_T_684; // @[Lookup.scala 33:37]
  wire  _list_T_686 = _list_T_49 ? 1'h0 : _list_T_685; // @[Lookup.scala 33:37]
  wire  _list_T_687 = _list_T_47 ? 1'h0 : _list_T_686; // @[Lookup.scala 33:37]
  wire  _list_T_688 = _list_T_45 ? 1'h0 : _list_T_687; // @[Lookup.scala 33:37]
  wire  _list_T_689 = _list_T_43 ? 1'h0 : _list_T_688; // @[Lookup.scala 33:37]
  wire  _list_T_690 = _list_T_41 ? 1'h0 : _list_T_689; // @[Lookup.scala 33:37]
  wire  _list_T_691 = _list_T_39 ? 1'h0 : _list_T_690; // @[Lookup.scala 33:37]
  wire  _list_T_692 = _list_T_37 ? 1'h0 : _list_T_691; // @[Lookup.scala 33:37]
  wire  _list_T_693 = _list_T_35 ? 1'h0 : _list_T_692; // @[Lookup.scala 33:37]
  wire  _list_T_694 = _list_T_33 ? 1'h0 : _list_T_693; // @[Lookup.scala 33:37]
  wire  _list_T_695 = _list_T_31 ? 1'h0 : _list_T_694; // @[Lookup.scala 33:37]
  wire  _list_T_696 = _list_T_29 ? 1'h0 : _list_T_695; // @[Lookup.scala 33:37]
  wire  _list_T_697 = _list_T_27 ? 1'h0 : _list_T_696; // @[Lookup.scala 33:37]
  wire  _list_T_698 = _list_T_25 ? 1'h0 : _list_T_697; // @[Lookup.scala 33:37]
  wire  _list_T_699 = _list_T_23 ? 1'h0 : _list_T_698; // @[Lookup.scala 33:37]
  wire  _list_T_700 = _list_T_21 ? 1'h0 : _list_T_699; // @[Lookup.scala 33:37]
  wire  _list_T_701 = _list_T_19 ? 1'h0 : _list_T_700; // @[Lookup.scala 33:37]
  wire  _list_T_702 = _list_T_17 ? 1'h0 : _list_T_701; // @[Lookup.scala 33:37]
  wire  _list_T_703 = _list_T_15 ? 1'h0 : _list_T_702; // @[Lookup.scala 33:37]
  wire  _list_T_704 = _list_T_13 ? 1'h0 : _list_T_703; // @[Lookup.scala 33:37]
  wire  _list_T_705 = _list_T_11 ? 1'h0 : _list_T_704; // @[Lookup.scala 33:37]
  wire  _list_T_706 = _list_T_9 ? 1'h0 : _list_T_705; // @[Lookup.scala 33:37]
  wire  _list_T_707 = _list_T_7 ? 1'h0 : _list_T_706; // @[Lookup.scala 33:37]
  wire  _list_T_708 = _list_T_5 ? 1'h0 : _list_T_707; // @[Lookup.scala 33:37]
  wire  _list_T_709 = _list_T_3 ? 1'h0 : _list_T_708; // @[Lookup.scala 33:37]
  wire  _list_T_719 = _list_T_101 ? 1'h0 : _list_T_103; // @[Lookup.scala 33:37]
  wire  _list_T_720 = _list_T_99 ? 1'h0 : _list_T_719; // @[Lookup.scala 33:37]
  wire  _list_T_721 = _list_T_97 ? 1'h0 : _list_T_720; // @[Lookup.scala 33:37]
  wire  _list_T_722 = _list_T_95 ? 1'h0 : _list_T_721; // @[Lookup.scala 33:37]
  wire  _list_T_723 = _list_T_93 ? 1'h0 : _list_T_722; // @[Lookup.scala 33:37]
  wire  _list_T_724 = _list_T_91 ? 1'h0 : _list_T_723; // @[Lookup.scala 33:37]
  wire  _list_T_725 = _list_T_89 ? 1'h0 : _list_T_724; // @[Lookup.scala 33:37]
  wire  _list_T_726 = _list_T_87 ? 1'h0 : _list_T_725; // @[Lookup.scala 33:37]
  wire  _list_T_727 = _list_T_85 ? 1'h0 : _list_T_726; // @[Lookup.scala 33:37]
  wire  _list_T_728 = _list_T_83 ? 1'h0 : _list_T_727; // @[Lookup.scala 33:37]
  wire  _list_T_729 = _list_T_81 ? 1'h0 : _list_T_728; // @[Lookup.scala 33:37]
  wire  _list_T_730 = _list_T_79 ? 1'h0 : _list_T_729; // @[Lookup.scala 33:37]
  wire  _list_T_731 = _list_T_77 ? 1'h0 : _list_T_730; // @[Lookup.scala 33:37]
  wire  _list_T_732 = _list_T_75 ? 1'h0 : _list_T_731; // @[Lookup.scala 33:37]
  wire  _list_T_733 = _list_T_73 ? 1'h0 : _list_T_732; // @[Lookup.scala 33:37]
  wire  _list_T_734 = _list_T_71 ? 1'h0 : _list_T_733; // @[Lookup.scala 33:37]
  wire  _list_T_735 = _list_T_69 ? 1'h0 : _list_T_734; // @[Lookup.scala 33:37]
  wire  _list_T_736 = _list_T_67 ? 1'h0 : _list_T_735; // @[Lookup.scala 33:37]
  wire  _list_T_737 = _list_T_65 ? 1'h0 : _list_T_736; // @[Lookup.scala 33:37]
  wire  _list_T_738 = _list_T_63 ? 1'h0 : _list_T_737; // @[Lookup.scala 33:37]
  wire  _list_T_739 = _list_T_61 ? 1'h0 : _list_T_738; // @[Lookup.scala 33:37]
  wire  _list_T_740 = _list_T_59 ? 1'h0 : _list_T_739; // @[Lookup.scala 33:37]
  wire  _list_T_741 = _list_T_57 ? 1'h0 : _list_T_740; // @[Lookup.scala 33:37]
  wire  _list_T_742 = _list_T_55 ? 1'h0 : _list_T_741; // @[Lookup.scala 33:37]
  wire  _list_T_743 = _list_T_53 ? 1'h0 : _list_T_742; // @[Lookup.scala 33:37]
  wire  _list_T_744 = _list_T_51 ? 1'h0 : _list_T_743; // @[Lookup.scala 33:37]
  wire  _list_T_745 = _list_T_49 ? 1'h0 : _list_T_744; // @[Lookup.scala 33:37]
  wire  _list_T_746 = _list_T_47 ? 1'h0 : _list_T_745; // @[Lookup.scala 33:37]
  wire  _list_T_747 = _list_T_45 ? 1'h0 : _list_T_746; // @[Lookup.scala 33:37]
  wire  _list_T_748 = _list_T_43 ? 1'h0 : _list_T_747; // @[Lookup.scala 33:37]
  wire  _list_T_749 = _list_T_41 ? 1'h0 : _list_T_748; // @[Lookup.scala 33:37]
  wire  _list_T_750 = _list_T_39 ? 1'h0 : _list_T_749; // @[Lookup.scala 33:37]
  wire  _list_T_751 = _list_T_37 ? 1'h0 : _list_T_750; // @[Lookup.scala 33:37]
  wire  _list_T_752 = _list_T_35 ? 1'h0 : _list_T_751; // @[Lookup.scala 33:37]
  wire  _list_T_753 = _list_T_33 ? 1'h0 : _list_T_752; // @[Lookup.scala 33:37]
  wire  _list_T_754 = _list_T_31 ? 1'h0 : _list_T_753; // @[Lookup.scala 33:37]
  wire  _list_T_755 = _list_T_29 ? 1'h0 : _list_T_754; // @[Lookup.scala 33:37]
  wire  _list_T_756 = _list_T_27 ? 1'h0 : _list_T_755; // @[Lookup.scala 33:37]
  wire  _list_T_757 = _list_T_25 ? 1'h0 : _list_T_756; // @[Lookup.scala 33:37]
  wire  _list_T_758 = _list_T_23 ? 1'h0 : _list_T_757; // @[Lookup.scala 33:37]
  wire  _list_T_759 = _list_T_21 ? 1'h0 : _list_T_758; // @[Lookup.scala 33:37]
  wire  _list_T_760 = _list_T_19 ? 1'h0 : _list_T_759; // @[Lookup.scala 33:37]
  wire  _list_T_761 = _list_T_17 ? 1'h0 : _list_T_760; // @[Lookup.scala 33:37]
  wire  _list_T_762 = _list_T_15 ? 1'h0 : _list_T_761; // @[Lookup.scala 33:37]
  wire  _list_T_763 = _list_T_13 ? 1'h0 : _list_T_762; // @[Lookup.scala 33:37]
  wire  _list_T_764 = _list_T_11 ? 1'h0 : _list_T_763; // @[Lookup.scala 33:37]
  wire  _list_T_765 = _list_T_9 ? 1'h0 : _list_T_764; // @[Lookup.scala 33:37]
  wire  _list_T_766 = _list_T_7 ? 1'h0 : _list_T_765; // @[Lookup.scala 33:37]
  wire  _list_T_767 = _list_T_5 ? 1'h0 : _list_T_766; // @[Lookup.scala 33:37]
  wire  _list_T_768 = _list_T_3 ? 1'h0 : _list_T_767; // @[Lookup.scala 33:37]
  wire  _list_T_867 = _list_T_41 ? 1'h0 : _list_T_43 | (_list_T_45 | (_list_T_47 | (_list_T_49 | (_list_T_51 | (
    _list_T_53 | (_list_T_55 | (_list_T_57 | (_list_T_59 | (_list_T_61 | (_list_T_63 | (_list_T_65 | (_list_T_67 | (
    _list_T_69 | (_list_T_71 | (_list_T_73 | (_list_T_75 | (_list_T_77 | (_list_T_79 | (_list_T_81 | (_list_T_83 | (
    _list_T_85 | (_list_T_87 | (_list_T_89 | (_list_T_91 | (_list_T_93 | (_list_T_95 | (_list_T_97 | _list_T_602))))))))
    ))))))))))))))))))); // @[Lookup.scala 33:37]
  wire  _list_T_868 = _list_T_39 ? 1'h0 : _list_T_867; // @[Lookup.scala 33:37]
  wire  _list_T_869 = _list_T_37 ? 1'h0 : _list_T_868; // @[Lookup.scala 33:37]
  wire  _list_T_870 = _list_T_35 ? 1'h0 : _list_T_869; // @[Lookup.scala 33:37]
  wire  _list_T_878 = _list_T_19 ? 1'h0 : _list_T_21 | (_list_T_23 | (_list_T_25 | (_list_T_27 | (_list_T_29 | (
    _list_T_31 | (_list_T_33 | _list_T_870)))))); // @[Lookup.scala 33:37]
  wire  _list_T_879 = _list_T_17 ? 1'h0 : _list_T_878; // @[Lookup.scala 33:37]
  wire  _list_T_880 = _list_T_15 ? 1'h0 : _list_T_879; // @[Lookup.scala 33:37]
  wire  _list_T_881 = _list_T_13 ? 1'h0 : _list_T_880; // @[Lookup.scala 33:37]
  wire  _list_T_882 = _list_T_11 ? 1'h0 : _list_T_881; // @[Lookup.scala 33:37]
  wire  _list_T_883 = _list_T_9 ? 1'h0 : _list_T_882; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_888 = _list_T_117 ? 3'h6 : 3'h0; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_889 = _list_T_115 ? 3'h6 : _list_T_888; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_890 = _list_T_113 ? 3'h6 : _list_T_889; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_891 = _list_T_111 ? 3'h0 : _list_T_890; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_892 = _list_T_109 ? 3'h0 : _list_T_891; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_893 = _list_T_107 ? 3'h0 : _list_T_892; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_894 = _list_T_105 ? 3'h0 : _list_T_893; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_895 = _list_T_103 ? 3'h0 : _list_T_894; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_896 = _list_T_101 ? 3'h0 : _list_T_895; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_897 = _list_T_99 ? 3'h0 : _list_T_896; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_898 = _list_T_97 ? 3'h0 : _list_T_897; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_899 = _list_T_95 ? 3'h0 : _list_T_898; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_900 = _list_T_93 ? 3'h0 : _list_T_899; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_901 = _list_T_91 ? 3'h0 : _list_T_900; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_902 = _list_T_89 ? 3'h0 : _list_T_901; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_903 = _list_T_87 ? 3'h0 : _list_T_902; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_904 = _list_T_85 ? 3'h0 : _list_T_903; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_905 = _list_T_83 ? 3'h0 : _list_T_904; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_906 = _list_T_81 ? 3'h0 : _list_T_905; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_907 = _list_T_79 ? 3'h0 : _list_T_906; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_908 = _list_T_77 ? 3'h0 : _list_T_907; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_909 = _list_T_75 ? 3'h0 : _list_T_908; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_910 = _list_T_73 ? 3'h0 : _list_T_909; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_911 = _list_T_71 ? 3'h0 : _list_T_910; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_912 = _list_T_69 ? 3'h0 : _list_T_911; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_913 = _list_T_67 ? 3'h1 : _list_T_912; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_914 = _list_T_65 ? 3'h1 : _list_T_913; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_915 = _list_T_63 ? 3'h1 : _list_T_914; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_916 = _list_T_61 ? 3'h1 : _list_T_915; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_917 = _list_T_59 ? 3'h1 : _list_T_916; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_918 = _list_T_57 ? 3'h1 : _list_T_917; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_919 = _list_T_55 ? 3'h1 : _list_T_918; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_920 = _list_T_53 ? 3'h1 : _list_T_919; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_921 = _list_T_51 ? 3'h1 : _list_T_920; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_922 = _list_T_49 ? 3'h1 : _list_T_921; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_923 = _list_T_47 ? 3'h1 : _list_T_922; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_924 = _list_T_45 ? 3'h1 : _list_T_923; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_925 = _list_T_43 ? 3'h1 : _list_T_924; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_926 = _list_T_41 ? 3'h2 : _list_T_925; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_927 = _list_T_39 ? 3'h2 : _list_T_926; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_928 = _list_T_37 ? 3'h2 : _list_T_927; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_929 = _list_T_35 ? 3'h2 : _list_T_928; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_930 = _list_T_33 ? 3'h1 : _list_T_929; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_931 = _list_T_31 ? 3'h1 : _list_T_930; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_932 = _list_T_29 ? 3'h1 : _list_T_931; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_933 = _list_T_27 ? 3'h1 : _list_T_932; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_934 = _list_T_25 ? 3'h1 : _list_T_933; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_935 = _list_T_23 ? 3'h1 : _list_T_934; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_936 = _list_T_21 ? 3'h1 : _list_T_935; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_937 = _list_T_19 ? 3'h5 : _list_T_936; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_938 = _list_T_17 ? 3'h5 : _list_T_937; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_939 = _list_T_15 ? 3'h5 : _list_T_938; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_940 = _list_T_13 ? 3'h5 : _list_T_939; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_941 = _list_T_11 ? 3'h5 : _list_T_940; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_942 = _list_T_9 ? 3'h5 : _list_T_941; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_943 = _list_T_7 ? 3'h1 : _list_T_942; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_944 = _list_T_5 ? 3'h4 : _list_T_943; // @[Lookup.scala 33:37]
  wire [2:0] _list_T_945 = _list_T_3 ? 3'h3 : _list_T_944; // @[Lookup.scala 33:37]
  wire  _list_T_972 = _list_T_67 ? 1'h0 : _list_T_69 | (_list_T_71 | (_list_T_73 | (_list_T_75 | (_list_T_77 | (
    _list_T_79 | (_list_T_81 | (_list_T_83 | (_list_T_85 | (_list_T_87 | (_list_T_89 | (_list_T_91 | (_list_T_93 | (
    _list_T_95 | _list_T_97))))))))))))); // @[Lookup.scala 33:37]
  wire  _list_T_973 = _list_T_65 ? 1'h0 : _list_T_972; // @[Lookup.scala 33:37]
  wire  _list_T_974 = _list_T_63 ? 1'h0 : _list_T_973; // @[Lookup.scala 33:37]
  wire  _list_T_975 = _list_T_61 ? 1'h0 : _list_T_974; // @[Lookup.scala 33:37]
  wire  _list_T_976 = _list_T_59 ? 1'h0 : _list_T_975; // @[Lookup.scala 33:37]
  wire  _list_T_977 = _list_T_57 ? 1'h0 : _list_T_976; // @[Lookup.scala 33:37]
  wire  _list_T_978 = _list_T_55 ? 1'h0 : _list_T_977; // @[Lookup.scala 33:37]
  wire  _list_T_979 = _list_T_53 ? 1'h0 : _list_T_978; // @[Lookup.scala 33:37]
  wire  _list_T_980 = _list_T_51 ? 1'h0 : _list_T_979; // @[Lookup.scala 33:37]
  wire  _list_T_981 = _list_T_49 ? 1'h0 : _list_T_980; // @[Lookup.scala 33:37]
  wire  _list_T_982 = _list_T_47 ? 1'h0 : _list_T_981; // @[Lookup.scala 33:37]
  wire  _list_T_983 = _list_T_45 ? 1'h0 : _list_T_982; // @[Lookup.scala 33:37]
  wire  _list_T_984 = _list_T_43 ? 1'h0 : _list_T_983; // @[Lookup.scala 33:37]
  wire  _list_T_989 = _list_T_33 ? 1'h0 : _list_T_35 | (_list_T_37 | (_list_T_39 | (_list_T_41 | _list_T_984))); // @[Lookup.scala 33:37]
  wire  _list_T_990 = _list_T_31 ? 1'h0 : _list_T_989; // @[Lookup.scala 33:37]
  wire  _list_T_991 = _list_T_29 ? 1'h0 : _list_T_990; // @[Lookup.scala 33:37]
  wire  _list_T_992 = _list_T_27 ? 1'h0 : _list_T_991; // @[Lookup.scala 33:37]
  wire  _list_T_993 = _list_T_25 ? 1'h0 : _list_T_992; // @[Lookup.scala 33:37]
  wire  _list_T_994 = _list_T_23 ? 1'h0 : _list_T_993; // @[Lookup.scala 33:37]
  wire  _list_T_995 = _list_T_21 ? 1'h0 : _list_T_994; // @[Lookup.scala 33:37]
  wire  _list_T_1002 = _list_T_7 ? 1'h0 : _list_T_9 | (_list_T_11 | (_list_T_13 | (_list_T_15 | (_list_T_17 | (
    _list_T_19 | _list_T_995))))); // @[Lookup.scala 33:37]
  wire  _list_T_1003 = _list_T_5 ? 1'h0 : _list_T_1002; // @[Lookup.scala 33:37]
  wire  _list_T_1004 = _list_T_3 ? 1'h0 : _list_T_1003; // @[Lookup.scala 33:37]
  wire  _list_T_1012 = _list_T_105 ? 1'h0 : _list_T_107 | (_list_T_109 | _list_T_111); // @[Lookup.scala 33:37]
  wire  _list_T_1013 = _list_T_103 ? 1'h0 : _list_T_1012; // @[Lookup.scala 33:37]
  wire  _list_T_1014 = _list_T_101 ? 1'h0 : _list_T_1013; // @[Lookup.scala 33:37]
  wire  _list_T_1015 = _list_T_99 ? 1'h0 : _list_T_1014; // @[Lookup.scala 33:37]
  wire  _list_T_1045 = _list_T_39 | (_list_T_41 | (_list_T_43 | (_list_T_45 | (_list_T_47 | (_list_T_49 | (_list_T_51 |
    (_list_T_53 | (_list_T_55 | (_list_T_57 | (_list_T_59 | (_list_T_61 | (_list_T_63 | (_list_T_65 | (_list_T_67 | (
    _list_T_69 | (_list_T_71 | (_list_T_73 | (_list_T_75 | (_list_T_77 | (_list_T_79 | (_list_T_81 | (_list_T_83 | (
    _list_T_85 | (_list_T_87 | (_list_T_89 | (_list_T_91 | (_list_T_93 | (_list_T_95 | (_list_T_97 | _list_T_1015)))))))
    )))))))))))))))))))))); // @[Lookup.scala 33:37]
  wire  _list_T_1062 = _list_T_5 ? 1'h0 : _list_T_7 | (_list_T_9 | (_list_T_11 | (_list_T_13 | (_list_T_15 | (_list_T_17
     | (_list_T_19 | (_list_T_21 | (_list_T_23 | (_list_T_25 | (_list_T_27 | (_list_T_29 | (_list_T_31 | (_list_T_33 | (
    _list_T_35 | (_list_T_37 | _list_T_1045))))))))))))))); // @[Lookup.scala 33:37]
  wire  _list_T_1063 = _list_T_3 ? 1'h0 : _list_T_1062; // @[Lookup.scala 33:37]
  wire  _list_T_1079 = _list_T_89 ? 1'h0 : _list_T_91 | _list_T_93; // @[Lookup.scala 33:37]
  wire  _list_T_1080 = _list_T_87 ? 1'h0 : _list_T_1079; // @[Lookup.scala 33:37]
  wire  _list_T_1081 = _list_T_85 ? 1'h0 : _list_T_1080; // @[Lookup.scala 33:37]
  wire  _list_T_1082 = _list_T_83 ? 1'h0 : _list_T_1081; // @[Lookup.scala 33:37]
  wire  _list_T_1083 = _list_T_81 ? 1'h0 : _list_T_1082; // @[Lookup.scala 33:37]
  wire  _list_T_1084 = _list_T_79 ? 1'h0 : _list_T_1083; // @[Lookup.scala 33:37]
  wire  _list_T_1085 = _list_T_77 ? 1'h0 : _list_T_1084; // @[Lookup.scala 33:37]
  wire  _list_T_1088 = _list_T_71 ? 1'h0 : _list_T_73 | (_list_T_75 | _list_T_1085); // @[Lookup.scala 33:37]
  wire  _list_T_1089 = _list_T_69 ? 1'h0 : _list_T_1088; // @[Lookup.scala 33:37]
  wire  _list_T_1092 = _list_T_63 ? 1'h0 : _list_T_65 | (_list_T_67 | _list_T_1089); // @[Lookup.scala 33:37]
  wire  _list_T_1093 = _list_T_61 ? 1'h0 : _list_T_1092; // @[Lookup.scala 33:37]
  wire  _list_T_1094 = _list_T_59 ? 1'h0 : _list_T_1093; // @[Lookup.scala 33:37]
  wire  _list_T_1095 = _list_T_57 ? 1'h0 : _list_T_1094; // @[Lookup.scala 33:37]
  wire  _list_T_1096 = _list_T_55 ? 1'h0 : _list_T_1095; // @[Lookup.scala 33:37]
  wire  _list_T_1097 = _list_T_53 ? 1'h0 : _list_T_1096; // @[Lookup.scala 33:37]
  wire  _list_T_1098 = _list_T_51 ? 1'h0 : _list_T_1097; // @[Lookup.scala 33:37]
  wire  _list_T_1099 = _list_T_49 ? 1'h0 : _list_T_1098; // @[Lookup.scala 33:37]
  wire  _list_T_1100 = _list_T_47 ? 1'h0 : _list_T_1099; // @[Lookup.scala 33:37]
  wire  _list_T_1101 = _list_T_45 ? 1'h0 : _list_T_1100; // @[Lookup.scala 33:37]
  wire  _list_T_1102 = _list_T_43 ? 1'h0 : _list_T_1101; // @[Lookup.scala 33:37]
  wire  _list_T_1103 = _list_T_41 ? 1'h0 : _list_T_1102; // @[Lookup.scala 33:37]
  wire  _list_T_1104 = _list_T_39 ? 1'h0 : _list_T_1103; // @[Lookup.scala 33:37]
  wire  _list_T_1105 = _list_T_37 ? 1'h0 : _list_T_1104; // @[Lookup.scala 33:37]
  wire  _list_T_1106 = _list_T_35 ? 1'h0 : _list_T_1105; // @[Lookup.scala 33:37]
  wire  _list_T_1107 = _list_T_33 ? 1'h0 : _list_T_1106; // @[Lookup.scala 33:37]
  wire  _list_T_1108 = _list_T_31 ? 1'h0 : _list_T_1107; // @[Lookup.scala 33:37]
  wire  _list_T_1109 = _list_T_29 ? 1'h0 : _list_T_1108; // @[Lookup.scala 33:37]
  wire  _list_T_1110 = _list_T_27 ? 1'h0 : _list_T_1109; // @[Lookup.scala 33:37]
  wire  _list_T_1111 = _list_T_25 ? 1'h0 : _list_T_1110; // @[Lookup.scala 33:37]
  wire  _list_T_1112 = _list_T_23 ? 1'h0 : _list_T_1111; // @[Lookup.scala 33:37]
  wire  _list_T_1113 = _list_T_21 ? 1'h0 : _list_T_1112; // @[Lookup.scala 33:37]
  wire  _list_T_1114 = _list_T_19 ? 1'h0 : _list_T_1113; // @[Lookup.scala 33:37]
  wire  _list_T_1115 = _list_T_17 ? 1'h0 : _list_T_1114; // @[Lookup.scala 33:37]
  wire  _list_T_1116 = _list_T_15 ? 1'h0 : _list_T_1115; // @[Lookup.scala 33:37]
  wire  _list_T_1117 = _list_T_13 ? 1'h0 : _list_T_1116; // @[Lookup.scala 33:37]
  wire  _list_T_1118 = _list_T_11 ? 1'h0 : _list_T_1117; // @[Lookup.scala 33:37]
  wire  _list_T_1119 = _list_T_9 ? 1'h0 : _list_T_1118; // @[Lookup.scala 33:37]
  wire  _list_T_1120 = _list_T_7 ? 1'h0 : _list_T_1119; // @[Lookup.scala 33:37]
  wire  _list_T_1121 = _list_T_5 ? 1'h0 : _list_T_1120; // @[Lookup.scala 33:37]
  wire  _list_T_1122 = _list_T_3 ? 1'h0 : _list_T_1121; // @[Lookup.scala 33:37]
  wire  _list_T_1137 = _list_T_91 ? 1'h0 : _list_T_93; // @[Lookup.scala 33:37]
  wire  _list_T_1139 = _list_T_87 ? 1'h0 : _list_T_89 | _list_T_1137; // @[Lookup.scala 33:37]
  wire  _list_T_1140 = _list_T_85 ? 1'h0 : _list_T_1139; // @[Lookup.scala 33:37]
  wire  _list_T_1141 = _list_T_83 ? 1'h0 : _list_T_1140; // @[Lookup.scala 33:37]
  wire  _list_T_1142 = _list_T_81 ? 1'h0 : _list_T_1141; // @[Lookup.scala 33:37]
  wire  _list_T_1144 = _list_T_77 ? 1'h0 : _list_T_79 | _list_T_1142; // @[Lookup.scala 33:37]
  wire  _list_T_1146 = _list_T_73 ? 1'h0 : _list_T_75 | _list_T_1144; // @[Lookup.scala 33:37]
  wire  _list_T_1148 = _list_T_69 ? 1'h0 : _list_T_71 | _list_T_1146; // @[Lookup.scala 33:37]
  wire  _list_T_1150 = _list_T_65 ? 1'h0 : _list_T_67 | _list_T_1148; // @[Lookup.scala 33:37]
  wire  _list_T_1152 = _list_T_61 ? 1'h0 : _list_T_63 | _list_T_1150; // @[Lookup.scala 33:37]
  wire  _list_T_1154 = _list_T_57 ? 1'h0 : _list_T_59 | _list_T_1152; // @[Lookup.scala 33:37]
  wire  _list_T_1155 = _list_T_55 ? 1'h0 : _list_T_1154; // @[Lookup.scala 33:37]
  wire  _list_T_1156 = _list_T_53 ? 1'h0 : _list_T_1155; // @[Lookup.scala 33:37]
  wire  _list_T_1157 = _list_T_51 ? 1'h0 : _list_T_1156; // @[Lookup.scala 33:37]
  wire  _list_T_1158 = _list_T_49 ? 1'h0 : _list_T_1157; // @[Lookup.scala 33:37]
  wire  _list_T_1159 = _list_T_47 ? 1'h0 : _list_T_1158; // @[Lookup.scala 33:37]
  wire  _list_T_1161 = _list_T_43 ? 1'h0 : _list_T_45 | _list_T_1159; // @[Lookup.scala 33:37]
  wire  _list_T_1162 = _list_T_41 ? 1'h0 : _list_T_1161; // @[Lookup.scala 33:37]
  wire  _list_T_1163 = _list_T_39 ? 1'h0 : _list_T_1162; // @[Lookup.scala 33:37]
  wire  _list_T_1164 = _list_T_37 ? 1'h0 : _list_T_1163; // @[Lookup.scala 33:37]
  wire  _list_T_1165 = _list_T_35 ? 1'h0 : _list_T_1164; // @[Lookup.scala 33:37]
  wire  _list_T_1166 = _list_T_33 ? 1'h0 : _list_T_1165; // @[Lookup.scala 33:37]
  wire  _list_T_1167 = _list_T_31 ? 1'h0 : _list_T_1166; // @[Lookup.scala 33:37]
  wire  _list_T_1168 = _list_T_29 ? 1'h0 : _list_T_1167; // @[Lookup.scala 33:37]
  wire  _list_T_1169 = _list_T_27 ? 1'h0 : _list_T_1168; // @[Lookup.scala 33:37]
  wire  _list_T_1170 = _list_T_25 ? 1'h0 : _list_T_1169; // @[Lookup.scala 33:37]
  wire  _list_T_1171 = _list_T_23 ? 1'h0 : _list_T_1170; // @[Lookup.scala 33:37]
  wire  _list_T_1172 = _list_T_21 ? 1'h0 : _list_T_1171; // @[Lookup.scala 33:37]
  wire  _list_T_1173 = _list_T_19 ? 1'h0 : _list_T_1172; // @[Lookup.scala 33:37]
  wire  _list_T_1174 = _list_T_17 ? 1'h0 : _list_T_1173; // @[Lookup.scala 33:37]
  wire  _list_T_1175 = _list_T_15 ? 1'h0 : _list_T_1174; // @[Lookup.scala 33:37]
  wire  _list_T_1176 = _list_T_13 ? 1'h0 : _list_T_1175; // @[Lookup.scala 33:37]
  wire  _list_T_1177 = _list_T_11 ? 1'h0 : _list_T_1176; // @[Lookup.scala 33:37]
  wire  _list_T_1178 = _list_T_9 ? 1'h0 : _list_T_1177; // @[Lookup.scala 33:37]
  wire  _list_T_1179 = _list_T_7 ? 1'h0 : _list_T_1178; // @[Lookup.scala 33:37]
  wire  _list_T_1180 = _list_T_5 ? 1'h0 : _list_T_1179; // @[Lookup.scala 33:37]
  wire  _list_T_1181 = _list_T_3 ? 1'h0 : _list_T_1180; // @[Lookup.scala 33:37]
  wire  _list_T_1190 = _list_T_103 ? 1'h0 : _list_T_105; // @[Lookup.scala 33:37]
  wire  _list_T_1191 = _list_T_101 ? 1'h0 : _list_T_1190; // @[Lookup.scala 33:37]
  wire  _list_T_1192 = _list_T_99 ? 1'h0 : _list_T_1191; // @[Lookup.scala 33:37]
  wire  _list_T_1193 = _list_T_97 ? 1'h0 : _list_T_1192; // @[Lookup.scala 33:37]
  wire  _list_T_1194 = _list_T_95 ? 1'h0 : _list_T_1193; // @[Lookup.scala 33:37]
  wire  _list_T_1195 = _list_T_93 ? 1'h0 : _list_T_1194; // @[Lookup.scala 33:37]
  wire  _list_T_1196 = _list_T_91 ? 1'h0 : _list_T_1195; // @[Lookup.scala 33:37]
  wire  _list_T_1197 = _list_T_89 ? 1'h0 : _list_T_1196; // @[Lookup.scala 33:37]
  wire  _list_T_1198 = _list_T_87 ? 1'h0 : _list_T_1197; // @[Lookup.scala 33:37]
  wire  _list_T_1199 = _list_T_85 ? 1'h0 : _list_T_1198; // @[Lookup.scala 33:37]
  wire  _list_T_1200 = _list_T_83 ? 1'h0 : _list_T_1199; // @[Lookup.scala 33:37]
  wire  _list_T_1201 = _list_T_81 ? 1'h0 : _list_T_1200; // @[Lookup.scala 33:37]
  wire  _list_T_1202 = _list_T_79 ? 1'h0 : _list_T_1201; // @[Lookup.scala 33:37]
  wire  _list_T_1203 = _list_T_77 ? 1'h0 : _list_T_1202; // @[Lookup.scala 33:37]
  wire  _list_T_1204 = _list_T_75 ? 1'h0 : _list_T_1203; // @[Lookup.scala 33:37]
  wire  _list_T_1205 = _list_T_73 ? 1'h0 : _list_T_1204; // @[Lookup.scala 33:37]
  wire  _list_T_1206 = _list_T_71 ? 1'h0 : _list_T_1205; // @[Lookup.scala 33:37]
  wire  _list_T_1207 = _list_T_69 ? 1'h0 : _list_T_1206; // @[Lookup.scala 33:37]
  wire  _list_T_1208 = _list_T_67 ? 1'h0 : _list_T_1207; // @[Lookup.scala 33:37]
  wire  _list_T_1209 = _list_T_65 ? 1'h0 : _list_T_1208; // @[Lookup.scala 33:37]
  wire  _list_T_1210 = _list_T_63 ? 1'h0 : _list_T_1209; // @[Lookup.scala 33:37]
  wire  _list_T_1211 = _list_T_61 ? 1'h0 : _list_T_1210; // @[Lookup.scala 33:37]
  wire  _list_T_1212 = _list_T_59 ? 1'h0 : _list_T_1211; // @[Lookup.scala 33:37]
  wire  _list_T_1213 = _list_T_57 ? 1'h0 : _list_T_1212; // @[Lookup.scala 33:37]
  wire  _list_T_1214 = _list_T_55 ? 1'h0 : _list_T_1213; // @[Lookup.scala 33:37]
  wire  _list_T_1215 = _list_T_53 ? 1'h0 : _list_T_1214; // @[Lookup.scala 33:37]
  wire  _list_T_1216 = _list_T_51 ? 1'h0 : _list_T_1215; // @[Lookup.scala 33:37]
  wire  _list_T_1217 = _list_T_49 ? 1'h0 : _list_T_1216; // @[Lookup.scala 33:37]
  wire  _list_T_1218 = _list_T_47 ? 1'h0 : _list_T_1217; // @[Lookup.scala 33:37]
  wire  _list_T_1219 = _list_T_45 ? 1'h0 : _list_T_1218; // @[Lookup.scala 33:37]
  wire  _list_T_1220 = _list_T_43 ? 1'h0 : _list_T_1219; // @[Lookup.scala 33:37]
  wire  _list_T_1221 = _list_T_41 ? 1'h0 : _list_T_1220; // @[Lookup.scala 33:37]
  wire  _list_T_1222 = _list_T_39 ? 1'h0 : _list_T_1221; // @[Lookup.scala 33:37]
  wire  _list_T_1223 = _list_T_37 ? 1'h0 : _list_T_1222; // @[Lookup.scala 33:37]
  wire  _list_T_1224 = _list_T_35 ? 1'h0 : _list_T_1223; // @[Lookup.scala 33:37]
  wire  _list_T_1225 = _list_T_33 ? 1'h0 : _list_T_1224; // @[Lookup.scala 33:37]
  wire  _list_T_1226 = _list_T_31 ? 1'h0 : _list_T_1225; // @[Lookup.scala 33:37]
  wire  _list_T_1227 = _list_T_29 ? 1'h0 : _list_T_1226; // @[Lookup.scala 33:37]
  wire  _list_T_1228 = _list_T_27 ? 1'h0 : _list_T_1227; // @[Lookup.scala 33:37]
  wire  _list_T_1229 = _list_T_25 ? 1'h0 : _list_T_1228; // @[Lookup.scala 33:37]
  wire  _list_T_1230 = _list_T_23 ? 1'h0 : _list_T_1229; // @[Lookup.scala 33:37]
  wire  _list_T_1231 = _list_T_21 ? 1'h0 : _list_T_1230; // @[Lookup.scala 33:37]
  wire  _list_T_1232 = _list_T_19 ? 1'h0 : _list_T_1231; // @[Lookup.scala 33:37]
  wire  _list_T_1233 = _list_T_17 ? 1'h0 : _list_T_1232; // @[Lookup.scala 33:37]
  wire  _list_T_1234 = _list_T_15 ? 1'h0 : _list_T_1233; // @[Lookup.scala 33:37]
  wire  _list_T_1235 = _list_T_13 ? 1'h0 : _list_T_1234; // @[Lookup.scala 33:37]
  wire  _list_T_1236 = _list_T_11 ? 1'h0 : _list_T_1235; // @[Lookup.scala 33:37]
  wire  _list_T_1237 = _list_T_9 ? 1'h0 : _list_T_1236; // @[Lookup.scala 33:37]
  wire  _list_T_1238 = _list_T_7 ? 1'h0 : _list_T_1237; // @[Lookup.scala 33:37]
  wire  _list_T_1239 = _list_T_5 ? 1'h0 : _list_T_1238; // @[Lookup.scala 33:37]
  wire  _list_T_1240 = _list_T_3 ? 1'h0 : _list_T_1239; // @[Lookup.scala 33:37]
  assign io_out_illegal = list_1 ? 1'h0 : _list_T_178; // @[Lookup.scala 33:37]
  assign io_out_lui = 32'h37 == _list_T; // @[Lookup.scala 31:38]
  assign io_out_auipc = list_1 ? 1'h0 : _list_T_3; // @[Lookup.scala 33:37]
  assign io_out_jal = list_1 ? 1'h0 : _list_T_355; // @[Lookup.scala 33:37]
  assign io_out_jalr = list_1 ? 1'h0 : _list_T_414; // @[Lookup.scala 33:37]
  assign io_out_branch = list_1 ? 1'h0 : _list_T_473; // @[Lookup.scala 33:37]
  assign io_out_load = list_1 ? 1'h0 : _list_T_532; // @[Lookup.scala 33:37]
  assign io_out_store = list_1 ? 1'h0 : _list_T_591; // @[Lookup.scala 33:37]
  assign io_out_csr = list_1 ? 1'h0 : _list_T_650; // @[Lookup.scala 33:37]
  assign io_out_ecall = list_1 ? 1'h0 : _list_T_709; // @[Lookup.scala 33:37]
  assign io_out_ebreak = list_1 ? 1'h0 : _list_T_768; // @[Lookup.scala 33:37]
  assign io_out_mret = list_1 ? 1'h0 : _list_T_1240; // @[Lookup.scala 33:37]
  assign io_out_rd_wen = list_1 | (_list_T_3 | (_list_T_5 | (_list_T_7 | _list_T_883))); // @[Lookup.scala 33:37]
  assign io_out_imm_type = list_1 ? 3'h3 : _list_T_945; // @[Lookup.scala 33:37]
  assign io_out_rs1_use = list_1 | _list_T_1063; // @[Lookup.scala 33:37]
  assign io_out_rs2_use = list_1 ? 1'h0 : _list_T_1004; // @[Lookup.scala 33:37]
  assign io_out_arith = list_1 ? 1'h0 : _list_T_1122; // @[Lookup.scala 33:37]
  assign io_out_word = list_1 ? 1'h0 : _list_T_1181; // @[Lookup.scala 33:37]
endmodule
module ysyx_210727_ImmGen(
  input  [31:0] io_inst,
  input  [2:0]  io_itype,
  output [31:0] io_imm32
);
  wire [20:0] i_imm32_hi_hi = io_inst[31] ? 21'h1fffff : 21'h0; // @[Bitwise.scala 72:12]
  wire [5:0] i_imm32_hi_lo = io_inst[30:25]; // @[ImmGen.scala 22:24]
  wire [3:0] i_imm32_lo_hi = io_inst[24:21]; // @[ImmGen.scala 22:41]
  wire  i_imm32_lo_lo = io_inst[20]; // @[ImmGen.scala 22:58]
  wire [31:0] i_imm32 = {i_imm32_hi_hi,i_imm32_hi_lo,i_imm32_lo_hi,i_imm32_lo_lo}; // @[Cat.scala 30:58]
  wire [3:0] s_imm32_lo_hi = io_inst[11:8]; // @[ImmGen.scala 26:41]
  wire  s_imm32_lo_lo = io_inst[7]; // @[ImmGen.scala 26:57]
  wire [31:0] s_imm32 = {i_imm32_hi_hi,i_imm32_hi_lo,s_imm32_lo_hi,s_imm32_lo_lo}; // @[Cat.scala 30:58]
  wire [19:0] b_imm32_hi_hi_hi = io_inst[31] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] b_imm32 = {b_imm32_hi_hi_hi,s_imm32_lo_lo,i_imm32_hi_lo,s_imm32_lo_hi,1'h0}; // @[Cat.scala 30:58]
  wire [10:0] u_imm32_hi_lo = io_inst[30:20]; // @[ImmGen.scala 33:37]
  wire [7:0] u_imm32_lo_hi = io_inst[19:12]; // @[ImmGen.scala 33:54]
  wire [31:0] u_imm32 = {io_inst[31],u_imm32_hi_lo,u_imm32_lo_hi,12'h0}; // @[Cat.scala 30:58]
  wire [11:0] j_imm32_hi_hi_hi = io_inst[31] ? 12'hfff : 12'h0; // @[Bitwise.scala 72:12]
  wire [31:0] j_imm32 = {j_imm32_hi_hi_hi,u_imm32_lo_hi,i_imm32_lo_lo,i_imm32_hi_lo,i_imm32_lo_hi,1'h0}; // @[Cat.scala 30:58]
  wire [4:0] csr_imm32_lo = io_inst[19:15]; // @[ImmGen.scala 42:51]
  wire [31:0] csr_imm32 = {27'h0,csr_imm32_lo}; // @[Cat.scala 30:58]
  wire [31:0] _io_imm32_T_1 = 3'h1 == io_itype ? i_imm32 : 32'h0; // @[Mux.scala 80:57]
  wire [31:0] _io_imm32_T_3 = 3'h2 == io_itype ? s_imm32 : _io_imm32_T_1; // @[Mux.scala 80:57]
  wire [31:0] _io_imm32_T_5 = 3'h5 == io_itype ? b_imm32 : _io_imm32_T_3; // @[Mux.scala 80:57]
  wire [31:0] _io_imm32_T_7 = 3'h3 == io_itype ? u_imm32 : _io_imm32_T_5; // @[Mux.scala 80:57]
  wire [31:0] _io_imm32_T_9 = 3'h4 == io_itype ? j_imm32 : _io_imm32_T_7; // @[Mux.scala 80:57]
  assign io_imm32 = 3'h6 == io_itype ? csr_imm32 : _io_imm32_T_9; // @[Mux.scala 80:57]
endmodule
module ysyx_210727_Decode(
  input         clock,
  input         reset,
  input         io_enable,
  input         io_clear,
  input         io_trap,
  output        io_lsu_write,
  input  [31:0] io_in_pc,
  input         io_in_excp,
  input  [3:0]  io_in_code,
  input  [31:0] io_in_inst,
  output [31:0] io_out_pc,
  output        io_out_excp,
  output [3:0]  io_out_code,
  output        io_out_valid,
  output [31:0] io_out_inst,
  output [63:0] io_out_rs1_addr,
  output        io_out_rs1_use,
  output [63:0] io_out_rs2_addr,
  output        io_out_rs2_use,
  output [63:0] io_out_imm,
  output [4:0]  io_out_uop,
  output [4:0]  io_out_rd_addr,
  output [11:0] io_out_csr_addr,
  output        io_out_rd_wen,
  output        io_out_csr_use,
  output        io_out_lsu_use,
  output        io_out_jb_use,
  output        io_out_mret
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] decoder_io_inst; // @[Decode.scala 34:37]
  wire  decoder_io_out_illegal; // @[Decode.scala 34:37]
  wire  decoder_io_out_lui; // @[Decode.scala 34:37]
  wire  decoder_io_out_auipc; // @[Decode.scala 34:37]
  wire  decoder_io_out_jal; // @[Decode.scala 34:37]
  wire  decoder_io_out_jalr; // @[Decode.scala 34:37]
  wire  decoder_io_out_branch; // @[Decode.scala 34:37]
  wire  decoder_io_out_load; // @[Decode.scala 34:37]
  wire  decoder_io_out_store; // @[Decode.scala 34:37]
  wire  decoder_io_out_csr; // @[Decode.scala 34:37]
  wire  decoder_io_out_ecall; // @[Decode.scala 34:37]
  wire  decoder_io_out_ebreak; // @[Decode.scala 34:37]
  wire  decoder_io_out_mret; // @[Decode.scala 34:37]
  wire  decoder_io_out_rd_wen; // @[Decode.scala 34:37]
  wire [2:0] decoder_io_out_imm_type; // @[Decode.scala 34:37]
  wire  decoder_io_out_rs1_use; // @[Decode.scala 34:37]
  wire  decoder_io_out_rs2_use; // @[Decode.scala 34:37]
  wire  decoder_io_out_arith; // @[Decode.scala 34:37]
  wire  decoder_io_out_word; // @[Decode.scala 34:37]
  wire [31:0] imm_gen_io_inst; // @[Decode.scala 38:37]
  wire [2:0] imm_gen_io_itype; // @[Decode.scala 38:37]
  wire [31:0] imm_gen_io_imm32; // @[Decode.scala 38:37]
  wire  rst = reset | io_clear & io_enable | io_trap; // @[Stage.scala 39:56]
  reg [31:0] reg_pc; // @[Stage.scala 42:50]
  reg  reg_valid; // @[Stage.scala 45:42]
  reg [31:0] reg_inst; // @[Stage.scala 46:42]
  wire  _GEN_3 = io_enable | reg_valid; // @[Stage.scala 47:31 Stage.scala 51:41 Stage.scala 45:42]
  wire [31:0] imm_hi = imm_gen_io_imm32[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [4:0] _io_out_rs1_addr_T_1 = decoder_io_out_lui ? 5'h0 : io_out_inst[19:15]; // @[Decode.scala 45:47]
  wire  io_out_uop_hi_hi = decoder_io_out_store | decoder_io_out_jal | decoder_io_out_word; // @[Decode.scala 52:68]
  wire  io_out_uop_hi_lo = decoder_io_out_load | decoder_io_out_jalr | decoder_io_out_arith; // @[Decode.scala 53:68]
  wire [2:0] io_out_uop_lo = decoder_io_out_lui | decoder_io_out_auipc ? 3'h0 : io_out_inst[14:12]; // @[Decode.scala 54:28]
  wire [1:0] io_out_uop_hi = {io_out_uop_hi_hi,io_out_uop_hi_lo}; // @[Cat.scala 30:58]
  wire  _io_out_jb_use_T = decoder_io_out_branch | decoder_io_out_jal; // @[Decode.scala 62:58]
  reg  reg_excp_1; // @[Decode.scala 65:39]
  reg [3:0] reg_code_1; // @[Decode.scala 66:39]
  wire  _io_out_excp_T_1 = decoder_io_out_ebreak | decoder_io_out_ecall | decoder_io_out_illegal; // @[Decode.scala 72:82]
  wire [3:0] _io_out_code_T = decoder_io_out_ecall ? 4'hb : 4'h2; // @[Decode.scala 77:36]
  wire [3:0] _io_out_code_T_1 = decoder_io_out_ebreak ? 4'h3 : _io_out_code_T; // @[Decode.scala 76:36]
  ysyx_210727_InstDecode decoder ( // @[Decode.scala 34:37]
    .io_inst(decoder_io_inst),
    .io_out_illegal(decoder_io_out_illegal),
    .io_out_lui(decoder_io_out_lui),
    .io_out_auipc(decoder_io_out_auipc),
    .io_out_jal(decoder_io_out_jal),
    .io_out_jalr(decoder_io_out_jalr),
    .io_out_branch(decoder_io_out_branch),
    .io_out_load(decoder_io_out_load),
    .io_out_store(decoder_io_out_store),
    .io_out_csr(decoder_io_out_csr),
    .io_out_ecall(decoder_io_out_ecall),
    .io_out_ebreak(decoder_io_out_ebreak),
    .io_out_mret(decoder_io_out_mret),
    .io_out_rd_wen(decoder_io_out_rd_wen),
    .io_out_imm_type(decoder_io_out_imm_type),
    .io_out_rs1_use(decoder_io_out_rs1_use),
    .io_out_rs2_use(decoder_io_out_rs2_use),
    .io_out_arith(decoder_io_out_arith),
    .io_out_word(decoder_io_out_word)
  );
  ysyx_210727_ImmGen imm_gen ( // @[Decode.scala 38:37]
    .io_inst(imm_gen_io_inst),
    .io_itype(imm_gen_io_itype),
    .io_imm32(imm_gen_io_imm32)
  );
  assign io_lsu_write = decoder_io_out_store; // @[Decode.scala 80:30]
  assign io_out_pc = reg_pc; // @[Stage.scala 55:41]
  assign io_out_excp = _io_out_excp_T_1 | reg_excp_1; // @[Decode.scala 73:56]
  assign io_out_code = reg_excp_1 ? reg_code_1 : _io_out_code_T_1; // @[Decode.scala 75:39]
  assign io_out_valid = reg_valid; // @[Stage.scala 58:33]
  assign io_out_inst = reg_inst; // @[Stage.scala 59:33]
  assign io_out_rs1_addr = {{59'd0}, _io_out_rs1_addr_T_1}; // @[Decode.scala 45:47]
  assign io_out_rs1_use = decoder_io_out_rs1_use; // @[Decode.scala 46:41]
  assign io_out_rs2_addr = {{59'd0}, io_out_inst[24:20]}; // @[Decode.scala 47:55]
  assign io_out_rs2_use = decoder_io_out_rs2_use; // @[Decode.scala 48:41]
  assign io_out_imm = {imm_hi,imm_gen_io_imm32}; // @[Cat.scala 30:58]
  assign io_out_uop = {io_out_uop_hi,io_out_uop_lo}; // @[Cat.scala 30:58]
  assign io_out_rd_addr = io_out_inst[11:7]; // @[Decode.scala 56:46]
  assign io_out_csr_addr = io_out_inst[31:20]; // @[Decode.scala 57:47]
  assign io_out_rd_wen = decoder_io_out_rd_wen; // @[Decode.scala 59:33]
  assign io_out_csr_use = decoder_io_out_csr; // @[Decode.scala 60:33]
  assign io_out_lsu_use = decoder_io_out_load | decoder_io_out_store; // @[Decode.scala 61:56]
  assign io_out_jb_use = _io_out_jb_use_T | decoder_io_out_jalr; // @[Decode.scala 63:52]
  assign io_out_mret = decoder_io_out_mret; // @[Decode.scala 78:33]
  assign decoder_io_inst = io_out_inst; // @[Decode.scala 35:33]
  assign imm_gen_io_inst = io_out_inst; // @[Decode.scala 39:33]
  assign imm_gen_io_itype = decoder_io_out_imm_type; // @[Decode.scala 40:34]
  always @(posedge clock) begin
    if (rst) begin // @[Stage.scala 42:50]
      reg_pc <= 32'h0; // @[Stage.scala 42:50]
    end else if (io_enable) begin // @[Stage.scala 47:31]
      reg_pc <= io_in_pc; // @[Stage.scala 48:41]
    end
    if (rst) begin // @[Stage.scala 45:42]
      reg_valid <= 1'h0; // @[Stage.scala 45:42]
    end else begin
      reg_valid <= _GEN_3;
    end
    if (rst) begin // @[Stage.scala 46:42]
      reg_inst <= 32'h13; // @[Stage.scala 46:42]
    end else if (io_enable) begin // @[Stage.scala 47:31]
      reg_inst <= io_in_inst; // @[Stage.scala 52:41]
    end
    if (rst) begin // @[Decode.scala 65:39]
      reg_excp_1 <= 1'h0; // @[Decode.scala 65:39]
    end else if (io_enable) begin // @[Decode.scala 67:31]
      reg_excp_1 <= io_in_excp; // @[Decode.scala 68:41]
    end
    if (rst) begin // @[Decode.scala 66:39]
      reg_code_1 <= 4'h0; // @[Decode.scala 66:39]
    end else if (io_enable) begin // @[Decode.scala 67:31]
      reg_code_1 <= io_in_code; // @[Decode.scala 69:41]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_valid = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  reg_inst = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  reg_excp_1 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_code_1 = _RAND_4[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_Issue(
  input         clock,
  input         reset,
  input         io_enable,
  input         io_clear,
  input         io_trap,
  output [4:0]  io_regfile_read_0_addr,
  input  [63:0] io_regfile_read_0_data,
  output [4:0]  io_regfile_read_1_addr,
  input  [63:0] io_regfile_read_1_data,
  output [11:0] io_csrfile_read_addr,
  input  [63:0] io_csrfile_read_data,
  output [63:0] io_brcond_in0,
  output [63:0] io_brcond_in1,
  output [31:0] io_brcond_pc,
  output [63:0] io_brcond_imm,
  output [4:0]  io_brcond_uop,
  output        io_brcond_sel,
  output        io_lsu_write,
  input  [31:0] io_in_pc,
  input         io_in_excp,
  input  [3:0]  io_in_code,
  input         io_in_valid,
  input  [63:0] io_in_rs1_addr,
  input         io_in_rs1_use,
  input  [63:0] io_in_rs2_addr,
  input         io_in_rs2_use,
  input  [63:0] io_in_imm,
  input  [4:0]  io_in_uop,
  input  [4:0]  io_in_rd_addr,
  input  [11:0] io_in_csr_addr,
  input         io_in_rd_wen,
  input         io_in_csr_use,
  input         io_in_lsu_use,
  input         io_in_jb_use,
  input         io_in_mret,
  output [31:0] io_out_pc,
  output        io_out_excp,
  output [3:0]  io_out_code,
  output        io_out_valid,
  output [63:0] io_out_rs1_data,
  output [63:0] io_out_rs2_data,
  output [63:0] io_out_imm,
  output [4:0]  io_out_uop,
  output [4:0]  io_out_rd_addr,
  output [11:0] io_out_csr_addr,
  output        io_out_rd_wen,
  output        io_out_csr_use,
  output        io_out_lsu_use,
  output        io_out_mret,
  input  [11:0] commit_csr_addr,
  input  [63:0] commit_rd_data_0,
  input         commit_csr_use,
  input  [63:0] exec_rd_data_0,
  input         exec_csr_use,
  input         commit_rd_wen_0,
  input  [11:0] exec_csr_addr,
  input         exec_rd_wen_0,
  input  [63:0] commit_csr_data,
  input  [63:0] exec_csr_data,
  input  [4:0]  commit_rd_addr_0,
  input  [4:0]  exec_rd_addr_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  wire  rst = reset | io_clear & io_enable | io_trap; // @[Stage.scala 39:56]
  reg [31:0] reg_pc; // @[Stage.scala 42:50]
  reg  reg_excp; // @[Stage.scala 43:42]
  reg [3:0] reg_code; // @[Stage.scala 44:42]
  reg  reg_valid; // @[Stage.scala 45:42]
  reg [4:0] reg_rs1_addr; // @[Issue.scala 59:50]
  reg  reg_rs1_use; // @[Issue.scala 60:50]
  reg [4:0] reg_rs2_addr; // @[Issue.scala 61:50]
  reg  reg_rs2_use; // @[Issue.scala 62:50]
  reg [63:0] reg_imm; // @[Issue.scala 63:50]
  reg [4:0] reg_uop; // @[Issue.scala 64:50]
  reg [4:0] reg_rd_addr; // @[Issue.scala 65:50]
  reg [11:0] reg_csr_addr; // @[Issue.scala 66:50]
  reg  reg_rd_wen; // @[Issue.scala 67:50]
  reg  reg_csr_use; // @[Issue.scala 68:50]
  reg  reg_lsu_use; // @[Issue.scala 69:50]
  reg  reg_jb_use; // @[Issue.scala 70:50]
  reg  reg_mret; // @[Issue.scala 71:50]
  wire [63:0] _GEN_5 = io_enable ? io_in_rs1_addr : {{59'd0}, reg_rs1_addr}; // @[Issue.scala 72:31 Issue.scala 73:41 Issue.scala 59:50]
  wire [63:0] _GEN_7 = io_enable ? io_in_rs2_addr : {{59'd0}, reg_rs2_addr}; // @[Issue.scala 72:31 Issue.scala 75:41 Issue.scala 61:50]
  wire  rs1_data_rs1_redir = reg_rs1_use & 5'h0 != reg_rs1_addr; // @[Issue.scala 107:53]
  wire  _rs1_data_exec_conflict_T_1 = exec_rd_addr_0 == reg_rs1_addr; // @[Issue.scala 109:54]
  wire  rs1_data_exec_conflict = rs1_data_rs1_redir & exec_rd_wen_0 & _rs1_data_exec_conflict_T_1; // @[Issue.scala 108:70]
  wire  _rs1_data_commit_conflict_T_1 = commit_rd_addr_0 == reg_rs1_addr; // @[Issue.scala 111:56]
  wire  rs1_data_commit_conflict = rs1_data_rs1_redir & commit_rd_wen_0 & _rs1_data_commit_conflict_T_1; // @[Issue.scala 110:74]
  wire [63:0] _rs1_data_T = rs1_data_commit_conflict ? commit_rd_data_0 : io_regfile_read_0_data; // @[Issue.scala 113:44]
  wire [63:0] rs1_data = rs1_data_exec_conflict ? exec_rd_data_0 : _rs1_data_T; // @[Issue.scala 112:28]
  wire  rs2_data_rs2_redir = reg_rs2_use & 5'h0 != reg_rs2_addr; // @[Issue.scala 117:53]
  wire  _rs2_data_exec_conflict_T_1 = exec_rd_addr_0 == reg_rs2_addr; // @[Issue.scala 119:54]
  wire  rs2_data_exec_conflict = rs2_data_rs2_redir & exec_rd_wen_0 & _rs2_data_exec_conflict_T_1; // @[Issue.scala 118:70]
  wire  _rs2_data_commit_conflict_T_1 = commit_rd_addr_0 == reg_rs2_addr; // @[Issue.scala 121:56]
  wire  rs2_data_commit_conflict = rs2_data_rs2_redir & commit_rd_wen_0 & _rs2_data_commit_conflict_T_1; // @[Issue.scala 120:74]
  wire [63:0] _rs2_data_rs2_T = rs2_data_commit_conflict ? commit_rd_data_0 : io_regfile_read_1_data; // @[Issue.scala 123:44]
  wire [63:0] rs2_data_rs2 = rs2_data_exec_conflict ? exec_rd_data_0 : _rs2_data_rs2_T; // @[Issue.scala 122:38]
  wire [63:0] rs2_data = reg_rs2_use ? rs2_data_rs2 : reg_imm; // @[Issue.scala 125:28]
  wire  csr_rdata_exec_conflict = exec_csr_use & exec_csr_addr == reg_csr_addr; // @[Issue.scala 138:58]
  wire  csr_rdata_commit_conflict = commit_csr_use & commit_csr_addr == reg_csr_addr; // @[Issue.scala 146:62]
  wire [63:0] _csr_rdata_T = csr_rdata_commit_conflict ? commit_csr_data : io_csrfile_read_data; // @[Issue.scala 150:44]
  wire [63:0] csr_rdata = csr_rdata_exec_conflict ? exec_csr_data : _csr_rdata_T; // @[Issue.scala 149:28]
  wire [1:0] cmd = reg_uop[1:0]; // @[Issue.scala 156:42]
  wire [63:0] mask = reg_rs1_use ? rs1_data : reg_imm; // @[Issue.scala 157:39]
  wire  csr_clear = 2'h3 == cmd; // @[Issue.scala 158:59]
  wire [63:0] _csr_mask_T = ~mask; // @[Issue.scala 160:52]
  wire [63:0] csr_mask = csr_clear ? _csr_mask_T : mask; // @[Issue.scala 160:40]
  wire  csr_uop_hi_lo = 2'h1 == cmd; // @[Issue.scala 161:67]
  wire [2:0] csr_uop_lo = csr_clear ? 3'h7 : 3'h6; // @[Issue.scala 162:44]
  wire [4:0] csr_uop = {1'h0,csr_uop_hi_lo,csr_uop_lo}; // @[Cat.scala 30:58]
  wire [63:0] _io_out_rs1_data_T_2 = reg_rs1_use & ~reg_jb_use ? rs1_data : {{32'd0}, io_out_pc}; // @[Issue.scala 175:36]
  wire [63:0] _io_out_rs2_data_T = reg_jb_use ? 64'h4 : rs2_data; // @[Issue.scala 177:36]
  wire [4:0] _io_out_uop_T = reg_jb_use ? 5'h0 : reg_uop; // @[Issue.scala 179:81]
  assign io_regfile_read_0_addr = reg_rs1_addr; // @[Issue.scala 89:41]
  assign io_regfile_read_1_addr = reg_rs2_addr; // @[Issue.scala 90:41]
  assign io_csrfile_read_addr = reg_csr_addr; // @[Issue.scala 129:41]
  assign io_brcond_in0 = rs1_data_exec_conflict ? exec_rd_data_0 : _rs1_data_T; // @[Issue.scala 112:28]
  assign io_brcond_in1 = reg_rs2_use ? rs2_data_rs2 : reg_imm; // @[Issue.scala 125:28]
  assign io_brcond_pc = io_out_pc; // @[Issue.scala 168:30]
  assign io_brcond_imm = reg_imm; // @[Issue.scala 169:31]
  assign io_brcond_uop = reg_uop; // @[Issue.scala 170:31]
  assign io_brcond_sel = reg_jb_use; // @[Issue.scala 171:31]
  assign io_lsu_write = reg_lsu_use & io_out_uop[4]; // @[Issue.scala 187:56]
  assign io_out_pc = reg_pc; // @[Stage.scala 55:41]
  assign io_out_excp = reg_excp; // @[Stage.scala 56:33]
  assign io_out_code = reg_code; // @[Stage.scala 57:33]
  assign io_out_valid = reg_valid; // @[Stage.scala 58:33]
  assign io_out_rs1_data = reg_csr_use ? csr_rdata : _io_out_rs1_data_T_2; // @[Issue.scala 174:47]
  assign io_out_rs2_data = reg_csr_use ? csr_mask : _io_out_rs2_data_T; // @[Issue.scala 176:47]
  assign io_out_imm = reg_imm; // @[Issue.scala 178:49]
  assign io_out_uop = reg_csr_use ? csr_uop : _io_out_uop_T; // @[Issue.scala 179:55]
  assign io_out_rd_addr = reg_rd_addr; // @[Issue.scala 180:41]
  assign io_out_csr_addr = reg_csr_addr; // @[Issue.scala 181:41]
  assign io_out_rd_wen = reg_rd_wen; // @[Issue.scala 182:41]
  assign io_out_csr_use = reg_csr_use; // @[Issue.scala 183:41]
  assign io_out_lsu_use = reg_lsu_use; // @[Issue.scala 184:41]
  assign io_out_mret = reg_mret; // @[Issue.scala 185:41]
  always @(posedge clock) begin
    if (rst) begin // @[Stage.scala 42:50]
      reg_pc <= 32'h0; // @[Stage.scala 42:50]
    end else if (io_enable) begin // @[Stage.scala 47:31]
      reg_pc <= io_in_pc; // @[Stage.scala 48:41]
    end
    if (rst) begin // @[Stage.scala 43:42]
      reg_excp <= 1'h0; // @[Stage.scala 43:42]
    end else if (io_enable) begin // @[Stage.scala 47:31]
      reg_excp <= io_in_excp; // @[Stage.scala 49:41]
    end
    if (rst) begin // @[Stage.scala 44:42]
      reg_code <= 4'h0; // @[Stage.scala 44:42]
    end else if (io_enable) begin // @[Stage.scala 47:31]
      reg_code <= io_in_code; // @[Stage.scala 50:41]
    end
    if (rst) begin // @[Stage.scala 45:42]
      reg_valid <= 1'h0; // @[Stage.scala 45:42]
    end else if (io_enable) begin // @[Stage.scala 47:31]
      reg_valid <= io_in_valid; // @[Stage.scala 51:41]
    end
    if (rst) begin // @[Issue.scala 59:50]
      reg_rs1_addr <= 5'h0; // @[Issue.scala 59:50]
    end else begin
      reg_rs1_addr <= _GEN_5[4:0];
    end
    if (rst) begin // @[Issue.scala 60:50]
      reg_rs1_use <= 1'h0; // @[Issue.scala 60:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_rs1_use <= io_in_rs1_use; // @[Issue.scala 74:41]
    end
    if (rst) begin // @[Issue.scala 61:50]
      reg_rs2_addr <= 5'h0; // @[Issue.scala 61:50]
    end else begin
      reg_rs2_addr <= _GEN_7[4:0];
    end
    if (rst) begin // @[Issue.scala 62:50]
      reg_rs2_use <= 1'h0; // @[Issue.scala 62:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_rs2_use <= io_in_rs2_use; // @[Issue.scala 76:41]
    end
    if (rst) begin // @[Issue.scala 63:50]
      reg_imm <= 64'h0; // @[Issue.scala 63:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_imm <= io_in_imm; // @[Issue.scala 77:49]
    end
    if (rst) begin // @[Issue.scala 64:50]
      reg_uop <= 5'h0; // @[Issue.scala 64:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_uop <= io_in_uop; // @[Issue.scala 78:49]
    end
    if (rst) begin // @[Issue.scala 65:50]
      reg_rd_addr <= 5'h0; // @[Issue.scala 65:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_rd_addr <= io_in_rd_addr; // @[Issue.scala 79:41]
    end
    if (rst) begin // @[Issue.scala 66:50]
      reg_csr_addr <= 12'h0; // @[Issue.scala 66:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_csr_addr <= io_in_csr_addr; // @[Issue.scala 80:41]
    end
    if (rst) begin // @[Issue.scala 67:50]
      reg_rd_wen <= 1'h0; // @[Issue.scala 67:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_rd_wen <= io_in_rd_wen; // @[Issue.scala 81:49]
    end
    if (rst) begin // @[Issue.scala 68:50]
      reg_csr_use <= 1'h0; // @[Issue.scala 68:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_csr_use <= io_in_csr_use; // @[Issue.scala 82:41]
    end
    if (rst) begin // @[Issue.scala 69:50]
      reg_lsu_use <= 1'h0; // @[Issue.scala 69:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_lsu_use <= io_in_lsu_use; // @[Issue.scala 83:41]
    end
    if (rst) begin // @[Issue.scala 70:50]
      reg_jb_use <= 1'h0; // @[Issue.scala 70:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_jb_use <= io_in_jb_use; // @[Issue.scala 84:49]
    end
    if (rst) begin // @[Issue.scala 71:50]
      reg_mret <= 1'h0; // @[Issue.scala 71:50]
    end else if (io_enable) begin // @[Issue.scala 72:31]
      reg_mret <= io_in_mret; // @[Issue.scala 85:49]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_excp = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  reg_code = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  reg_valid = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_rs1_addr = _RAND_4[4:0];
  _RAND_5 = {1{`RANDOM}};
  reg_rs1_use = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  reg_rs2_addr = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  reg_rs2_use = _RAND_7[0:0];
  _RAND_8 = {2{`RANDOM}};
  reg_imm = _RAND_8[63:0];
  _RAND_9 = {1{`RANDOM}};
  reg_uop = _RAND_9[4:0];
  _RAND_10 = {1{`RANDOM}};
  reg_rd_addr = _RAND_10[4:0];
  _RAND_11 = {1{`RANDOM}};
  reg_csr_addr = _RAND_11[11:0];
  _RAND_12 = {1{`RANDOM}};
  reg_rd_wen = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  reg_csr_use = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  reg_lsu_use = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  reg_jb_use = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  reg_mret = _RAND_16[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_Execute(
  input         clock,
  input         reset,
  input         io__enable,
  input         io__clear,
  input         io__trap,
  output [4:0]  io__alu_in_op,
  output [63:0] io__alu_in_in0,
  output [63:0] io__alu_in_in1,
  input  [63:0] io__alu_res,
  output [63:0] io__dread_bits_addr,
  output [2:0]  io__dread_bits_op,
  input         io__dread_bits_excp,
  input         io__dread_bits_misalign,
  input  [63:0] io__dread_bits_data,
  output        io__dread_valid,
  input         io__dread_ready,
  output        io__hshake,
  output        io__lsu_write,
  input  [31:0] io__in_pc,
  input         io__in_excp,
  input  [3:0]  io__in_code,
  input         io__in_valid,
  input  [63:0] io__in_rs1_data,
  input  [63:0] io__in_rs2_data,
  input  [63:0] io__in_imm,
  input  [4:0]  io__in_uop,
  input  [4:0]  io__in_rd_addr,
  input  [11:0] io__in_csr_addr,
  input         io__in_rd_wen,
  input         io__in_csr_use,
  input         io__in_lsu_use,
  input         io__in_mret,
  output [31:0] io__out_pc,
  output        io__out_excp,
  output [3:0]  io__out_code,
  output        io__out_valid,
  output [4:0]  io__out_rd_addr,
  output [11:0] io__out_csr_addr,
  output        io__out_rd_wen,
  output        io__out_csr_use,
  output        io__out_lsu_use,
  output [2:0]  io__out_lsu_op,
  output        io__out_mret,
  output [63:0] io__out_data1,
  output [63:0] io__out_data2,
  output [63:0] io_out_data1,
  output        io_out_csr_use,
  output [11:0] io_out_csr_addr,
  output        io_out_rd_wen,
  output [63:0] io_out_data2,
  output [4:0]  io_out_rd_addr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
`endif // RANDOMIZE_REG_INIT
  wire  rst = reset | io__clear & io__enable | io__trap; // @[Stage.scala 39:56]
  reg [31:0] reg_pc; // @[Stage.scala 42:50]
  reg  reg_valid; // @[Stage.scala 45:42]
  reg [63:0] reg_rs1_data; // @[Execute.scala 49:50]
  reg [63:0] reg_rs2_data; // @[Execute.scala 50:50]
  reg [63:0] reg_imm; // @[Execute.scala 51:50]
  reg [4:0] reg_uop; // @[Execute.scala 52:50]
  reg [4:0] reg_rd_addr; // @[Execute.scala 53:50]
  reg [11:0] reg_csr_addr; // @[Execute.scala 54:50]
  reg  reg_rd_wen; // @[Execute.scala 55:50]
  reg  reg_csr_use; // @[Execute.scala 56:50]
  reg  reg_lsu_use; // @[Execute.scala 57:50]
  reg  reg_mret; // @[Execute.scala 58:50]
  wire  _io_alu_in_op_T_1 = ~reg_csr_use; // @[Execute.scala 75:54]
  wire  io_alu_in_op_hi_hi = reg_uop[4] & ~reg_csr_use; // @[Execute.scala 75:51]
  wire  io_alu_in_op_hi_lo = reg_uop[3] & _io_alu_in_op_T_1; // @[Execute.scala 76:44]
  wire [2:0] io_alu_in_op_lo = reg_uop[2:0]; // @[Execute.scala 77:40]
  wire [1:0] io_alu_in_op_hi = {io_alu_in_op_hi_hi,io_alu_in_op_hi_lo}; // @[Cat.scala 30:58]
  wire  lsu_load = reg_uop[3] & reg_lsu_use; // @[Execute.scala 82:50]
  wire  lsu_store = reg_uop[4] & reg_lsu_use; // @[Execute.scala 83:51]
  wire [63:0] _lsu_addr_T_1 = reg_rs1_data + reg_imm; // @[Execute.scala 84:42]
  reg  reg_excp_1; // @[Execute.scala 93:42]
  reg [3:0] reg_code_1; // @[Execute.scala 94:42]
  wire [3:0] _io_out_code_T = io__dread_bits_misalign ? 4'h4 : 4'h5; // @[Execute.scala 101:36]
  wire [31:0] lsu_addr = _lsu_addr_T_1[31:0]; // @[Execute.scala 81:36 Execute.scala 84:26]
  wire [63:0] _io_out_data1_T = lsu_store ? {{32'd0}, lsu_addr} : io__alu_res; // @[Execute.scala 116:36]
  wire [63:0] _io_out_data1_T_1 = lsu_load ? io__dread_bits_data : _io_out_data1_T; // @[Execute.scala 115:36]
  wire [63:0] _io_out_data1_T_2 = io__dread_valid ? io__dread_bits_data : _io_out_data1_T_1; // @[Execute.scala 114:36]
  wire [63:0] _io_out_data2_T_2 = reg_csr_use & reg_uop[3] ? reg_rs2_data : io__alu_res; // @[Execute.scala 120:36]
  assign io__alu_in_op = {io_alu_in_op_hi,io_alu_in_op_lo}; // @[Cat.scala 30:58]
  assign io__alu_in_in0 = reg_rs1_data; // @[Execute.scala 73:33]
  assign io__alu_in_in1 = reg_rs2_data; // @[Execute.scala 74:33]
  assign io__dread_bits_addr = {{32'd0}, lsu_addr}; // @[Execute.scala 81:36 Execute.scala 84:26]
  assign io__dread_bits_op = reg_uop[2:0]; // @[Execute.scala 80:37]
  assign io__dread_valid = reg_uop[3] & reg_lsu_use; // @[Execute.scala 82:50]
  assign io__hshake = ~io__dread_valid | io__dread_valid & io__dread_ready; // @[Execute.scala 89:46]
  assign io__lsu_write = reg_uop[4] & reg_lsu_use; // @[Execute.scala 90:44]
  assign io__out_pc = reg_pc; // @[Stage.scala 55:41]
  assign io__out_excp = reg_excp_1 | io__dread_bits_excp; // @[Execute.scala 99:45]
  assign io__out_code = reg_excp_1 ? reg_code_1 : _io_out_code_T; // @[Execute.scala 100:39]
  assign io__out_valid = reg_valid; // @[Stage.scala 58:33]
  assign io__out_rd_addr = reg_rd_addr; // @[Execute.scala 104:33]
  assign io__out_csr_addr = reg_csr_addr; // @[Execute.scala 105:33]
  assign io__out_rd_wen = reg_rd_wen; // @[Execute.scala 106:33]
  assign io__out_csr_use = reg_csr_use; // @[Execute.scala 107:33]
  assign io__out_lsu_use = reg_uop[4] & reg_lsu_use; // @[Execute.scala 83:51]
  assign io__out_lsu_op = reg_uop[2:0]; // @[Execute.scala 109:43]
  assign io__out_mret = reg_mret; // @[Execute.scala 110:33]
  assign io__out_data1 = reg_csr_use ? reg_rs1_data : _io_out_data1_T_2; // @[Execute.scala 113:39]
  assign io__out_data2 = lsu_store ? reg_rs2_data : _io_out_data2_T_2; // @[Execute.scala 119:39]
  assign io_out_data1 = io__out_data1;
  assign io_out_csr_use = io__out_csr_use;
  assign io_out_csr_addr = io__out_csr_addr;
  assign io_out_rd_wen = io__out_rd_wen;
  assign io_out_data2 = io__out_data2;
  assign io_out_rd_addr = io__out_rd_addr;
  always @(posedge clock) begin
    if (rst) begin // @[Stage.scala 42:50]
      reg_pc <= 32'h0; // @[Stage.scala 42:50]
    end else if (io__enable) begin // @[Stage.scala 47:31]
      reg_pc <= io__in_pc; // @[Stage.scala 48:41]
    end
    if (rst) begin // @[Stage.scala 45:42]
      reg_valid <= 1'h0; // @[Stage.scala 45:42]
    end else if (io__enable) begin // @[Stage.scala 47:31]
      reg_valid <= io__in_valid; // @[Stage.scala 51:41]
    end
    if (rst) begin // @[Execute.scala 49:50]
      reg_rs1_data <= 64'h0; // @[Execute.scala 49:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_rs1_data <= io__in_rs1_data; // @[Execute.scala 60:41]
    end
    if (rst) begin // @[Execute.scala 50:50]
      reg_rs2_data <= 64'h0; // @[Execute.scala 50:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_rs2_data <= io__in_rs2_data; // @[Execute.scala 61:41]
    end
    if (rst) begin // @[Execute.scala 51:50]
      reg_imm <= 64'h0; // @[Execute.scala 51:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_imm <= io__in_imm; // @[Execute.scala 62:49]
    end
    if (rst) begin // @[Execute.scala 52:50]
      reg_uop <= 5'h0; // @[Execute.scala 52:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_uop <= io__in_uop; // @[Execute.scala 63:49]
    end
    if (rst) begin // @[Execute.scala 53:50]
      reg_rd_addr <= 5'h0; // @[Execute.scala 53:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_rd_addr <= io__in_rd_addr; // @[Execute.scala 64:41]
    end
    if (rst) begin // @[Execute.scala 54:50]
      reg_csr_addr <= 12'h0; // @[Execute.scala 54:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_csr_addr <= io__in_csr_addr; // @[Execute.scala 65:41]
    end
    if (rst) begin // @[Execute.scala 55:50]
      reg_rd_wen <= 1'h0; // @[Execute.scala 55:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_rd_wen <= io__in_rd_wen; // @[Execute.scala 66:49]
    end
    if (rst) begin // @[Execute.scala 56:50]
      reg_csr_use <= 1'h0; // @[Execute.scala 56:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_csr_use <= io__in_csr_use; // @[Execute.scala 67:41]
    end
    if (rst) begin // @[Execute.scala 57:50]
      reg_lsu_use <= 1'h0; // @[Execute.scala 57:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_lsu_use <= io__in_lsu_use; // @[Execute.scala 68:41]
    end
    if (rst) begin // @[Execute.scala 58:50]
      reg_mret <= 1'h0; // @[Execute.scala 58:50]
    end else if (io__enable) begin // @[Execute.scala 59:31]
      reg_mret <= io__in_mret; // @[Execute.scala 69:49]
    end
    if (rst) begin // @[Execute.scala 93:42]
      reg_excp_1 <= 1'h0; // @[Execute.scala 93:42]
    end else if (io__enable) begin // @[Execute.scala 95:31]
      reg_excp_1 <= io__in_excp; // @[Execute.scala 96:41]
    end
    if (rst) begin // @[Execute.scala 94:42]
      reg_code_1 <= 4'h0; // @[Execute.scala 94:42]
    end else if (io__enable) begin // @[Execute.scala 95:31]
      reg_code_1 <= io__in_code; // @[Execute.scala 97:41]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_valid = _RAND_1[0:0];
  _RAND_2 = {2{`RANDOM}};
  reg_rs1_data = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  reg_rs2_data = _RAND_3[63:0];
  _RAND_4 = {2{`RANDOM}};
  reg_imm = _RAND_4[63:0];
  _RAND_5 = {1{`RANDOM}};
  reg_uop = _RAND_5[4:0];
  _RAND_6 = {1{`RANDOM}};
  reg_rd_addr = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  reg_csr_addr = _RAND_7[11:0];
  _RAND_8 = {1{`RANDOM}};
  reg_rd_wen = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  reg_csr_use = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  reg_lsu_use = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  reg_mret = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  reg_excp_1 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  reg_code_1 = _RAND_13[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_Commit(
  input         clock,
  input         reset,
  input         io__enable,
  input         io__clear,
  input         io__trap,
  output [4:0]  io__regfile_write_rd_addr,
  output [63:0] io__regfile_write_rd_data,
  output        io__regfile_write_rd_wen,
  output [11:0] io__csrfile_write_addr,
  output [63:0] io__csrfile_write_data,
  output        io__csrfile_write_wen,
  output [63:0] io__dwrite_bits_addr,
  output [2:0]  io__dwrite_bits_op,
  input         io__dwrite_bits_excp,
  input         io__dwrite_bits_misalign,
  output [63:0] io__dwrite_bits_data,
  output        io__dwrite_valid,
  input         io__dwrite_ready,
  output        io__mret,
  output        io__hshake,
  output        io__lsu_write,
  input  [31:0] io__in_pc,
  input         io__in_excp,
  input  [3:0]  io__in_code,
  input         io__in_valid,
  input  [4:0]  io__in_rd_addr,
  input  [11:0] io__in_csr_addr,
  input         io__in_rd_wen,
  input         io__in_csr_use,
  input         io__in_lsu_use,
  input  [2:0]  io__in_lsu_op,
  input         io__in_mret,
  input  [63:0] io__in_data1,
  input  [63:0] io__in_data2,
  output [31:0] io__out_pc,
  output        io__out_excp,
  output [3:0]  io__out_code,
  output        io__out_valid,
  output [11:0] io_csrfile_write_addr,
  output [63:0] io_regfile_write_rd_data,
  output        io_csrfile_write_wen,
  output        io_regfile_write_rd_wen,
  output [63:0] io_csrfile_write_data,
  output [4:0]  io_regfile_write_rd_addr,
  output        minstret_en_0,
  output        io_mret,
  output [31:0] io_out_pc
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_REG_INIT
  wire  rst = reset | io__clear & io__enable | io__trap; // @[Stage.scala 39:56]
  reg [31:0] reg_pc; // @[Stage.scala 42:50]
  reg  reg_valid; // @[Stage.scala 45:42]
  reg [4:0] reg_rd_addr; // @[Commit.scala 55:50]
  reg [11:0] reg_csr_addr; // @[Commit.scala 56:50]
  reg  reg_rd_wen; // @[Commit.scala 57:50]
  reg  reg_csr_use; // @[Commit.scala 58:50]
  reg  reg_lsu_use; // @[Commit.scala 59:50]
  reg [2:0] reg_lsu_op; // @[Commit.scala 60:50]
  reg  reg_mret; // @[Commit.scala 61:50]
  reg [63:0] reg_data1; // @[Commit.scala 62:50]
  reg [63:0] reg_data2; // @[Commit.scala 63:50]
  wire  _io_regfile_write_rd_wen_T = ~io__trap; // @[Commit.scala 83:66]
  reg  reg_excp_1; // @[Commit.scala 110:39]
  reg [3:0] reg_code_1; // @[Commit.scala 111:39]
  wire [3:0] _io_out_code_T = io__dwrite_bits_misalign ? 4'h6 : 4'h7; // @[Commit.scala 118:36]
  wire  minstret_en = io__enable & io__out_valid & _io_regfile_write_rd_wen_T; // @[Commit.scala 122:55]
  assign io__regfile_write_rd_addr = reg_rd_addr; // @[Commit.scala 84:49]
  assign io__regfile_write_rd_data = reg_data1; // @[Commit.scala 85:49]
  assign io__regfile_write_rd_wen = reg_rd_wen & ~io__trap; // @[Commit.scala 83:63]
  assign io__csrfile_write_addr = reg_csr_addr; // @[Commit.scala 92:49]
  assign io__csrfile_write_data = reg_data2; // @[Commit.scala 93:49]
  assign io__csrfile_write_wen = reg_csr_use & _io_regfile_write_rd_wen_T; // @[Commit.scala 94:64]
  assign io__dwrite_bits_addr = {{32'd0}, reg_data1[31:0]}; // @[Commit.scala 104:49]
  assign io__dwrite_bits_op = reg_lsu_op; // @[Commit.scala 103:35]
  assign io__dwrite_bits_data = reg_data2; // @[Commit.scala 102:37]
  assign io__dwrite_valid = reg_lsu_use; // @[Commit.scala 101:33]
  assign io__mret = reg_mret; // @[Commit.scala 76:25]
  assign io__hshake = ~io__dwrite_valid | io__dwrite_valid & io__dwrite_ready; // @[Commit.scala 106:47]
  assign io__lsu_write = io__dwrite_valid; // @[Commit.scala 107:30]
  assign io__out_pc = reg_pc; // @[Stage.scala 55:41]
  assign io__out_excp = reg_excp_1 | io__dwrite_bits_excp; // @[Commit.scala 116:42]
  assign io__out_code = reg_excp_1 ? reg_code_1 : _io_out_code_T; // @[Commit.scala 117:35]
  assign io__out_valid = reg_valid; // @[Stage.scala 58:33]
  assign io_csrfile_write_addr = io__csrfile_write_addr;
  assign io_regfile_write_rd_data = io__regfile_write_rd_data;
  assign io_csrfile_write_wen = io__csrfile_write_wen;
  assign io_regfile_write_rd_wen = io__regfile_write_rd_wen;
  assign io_csrfile_write_data = io__csrfile_write_data;
  assign io_regfile_write_rd_addr = io__regfile_write_rd_addr;
  assign minstret_en_0 = minstret_en;
  assign io_mret = io__mret;
  assign io_out_pc = io__out_pc;
  always @(posedge clock) begin
    if (rst) begin // @[Stage.scala 42:50]
      reg_pc <= 32'h0; // @[Stage.scala 42:50]
    end else if (io__enable) begin // @[Stage.scala 47:31]
      reg_pc <= io__in_pc; // @[Stage.scala 48:41]
    end
    if (rst) begin // @[Stage.scala 45:42]
      reg_valid <= 1'h0; // @[Stage.scala 45:42]
    end else if (io__enable) begin // @[Stage.scala 47:31]
      reg_valid <= io__in_valid; // @[Stage.scala 51:41]
    end
    if (rst) begin // @[Commit.scala 55:50]
      reg_rd_addr <= 5'h0; // @[Commit.scala 55:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_rd_addr <= io__in_rd_addr; // @[Commit.scala 65:41]
    end
    if (rst) begin // @[Commit.scala 56:50]
      reg_csr_addr <= 12'h0; // @[Commit.scala 56:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_csr_addr <= io__in_csr_addr; // @[Commit.scala 66:41]
    end
    if (rst) begin // @[Commit.scala 57:50]
      reg_rd_wen <= 1'h0; // @[Commit.scala 57:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_rd_wen <= io__in_rd_wen; // @[Commit.scala 67:49]
    end
    if (rst) begin // @[Commit.scala 58:50]
      reg_csr_use <= 1'h0; // @[Commit.scala 58:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_csr_use <= io__in_csr_use; // @[Commit.scala 68:41]
    end
    if (rst) begin // @[Commit.scala 59:50]
      reg_lsu_use <= 1'h0; // @[Commit.scala 59:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_lsu_use <= io__in_lsu_use; // @[Commit.scala 69:41]
    end
    if (rst) begin // @[Commit.scala 60:50]
      reg_lsu_op <= 3'h0; // @[Commit.scala 60:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_lsu_op <= io__in_lsu_op; // @[Commit.scala 70:49]
    end
    if (rst) begin // @[Commit.scala 61:50]
      reg_mret <= 1'h0; // @[Commit.scala 61:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_mret <= io__in_mret; // @[Commit.scala 71:49]
    end
    if (rst) begin // @[Commit.scala 62:50]
      reg_data1 <= 64'h0; // @[Commit.scala 62:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_data1 <= io__in_data1; // @[Commit.scala 72:49]
    end
    if (rst) begin // @[Commit.scala 63:50]
      reg_data2 <= 64'h0; // @[Commit.scala 63:50]
    end else if (io__enable) begin // @[Commit.scala 64:31]
      reg_data2 <= io__in_data2; // @[Commit.scala 73:49]
    end
    if (rst) begin // @[Commit.scala 110:39]
      reg_excp_1 <= 1'h0; // @[Commit.scala 110:39]
    end else if (io__enable) begin // @[Commit.scala 112:31]
      reg_excp_1 <= io__in_excp; // @[Commit.scala 113:34]
    end
    if (rst) begin // @[Commit.scala 111:39]
      reg_code_1 <= 4'h0; // @[Commit.scala 111:39]
    end else if (io__enable) begin // @[Commit.scala 112:31]
      reg_code_1 <= io__in_code; // @[Commit.scala 114:34]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_valid = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  reg_rd_addr = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  reg_csr_addr = _RAND_3[11:0];
  _RAND_4 = {1{`RANDOM}};
  reg_rd_wen = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  reg_csr_use = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  reg_lsu_use = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  reg_lsu_op = _RAND_7[2:0];
  _RAND_8 = {1{`RANDOM}};
  reg_mret = _RAND_8[0:0];
  _RAND_9 = {2{`RANDOM}};
  reg_data1 = _RAND_9[63:0];
  _RAND_10 = {2{`RANDOM}};
  reg_data2 = _RAND_10[63:0];
  _RAND_11 = {1{`RANDOM}};
  reg_excp_1 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  reg_code_1 = _RAND_12[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_BrCond(
  input  [63:0] io_in_in0,
  input  [63:0] io_in_in1,
  input  [31:0] io_in_pc,
  input  [63:0] io_in_imm,
  input  [4:0]  io_in_uop,
  input         io_in_sel,
  output        io_change_pc,
  output [31:0] io_new_pc
);
  wire  jal = io_in_uop[4]; // @[BrCond.scala 26:44]
  wire  jalr = io_in_uop[3]; // @[BrCond.scala 27:44]
  wire  lt = io_in_uop[2]; // @[BrCond.scala 28:44]
  wire  unsigned_ = io_in_uop[1]; // @[BrCond.scala 29:36]
  wire  not_ = io_in_uop[0]; // @[BrCond.scala 30:44]
  wire  do_jump = jal | jalr; // @[BrCond.scala 33:27]
  wire  do_eql = io_in_in0 == io_in_in1; // @[BrCond.scala 35:32]
  wire  _do_lt_T_3 = $signed(io_in_in0) < $signed(io_in_in1); // @[BrCond.scala 37:42]
  wire  do_lt = unsigned_ ? io_in_in0 < io_in_in1 : _do_lt_T_3; // @[BrCond.scala 36:24]
  wire  _do_branch_T = lt ? do_lt : do_eql; // @[BrCond.scala 38:34]
  wire  do_branch = not_ ^ _do_branch_T; // @[BrCond.scala 38:29]
  wire [63:0] _io_new_pc_T_1 = io_in_in0 + io_in_imm; // @[BrCond.scala 41:42]
  wire [63:0] _GEN_0 = {{32'd0}, io_in_pc}; // @[BrCond.scala 42:34]
  wire [63:0] _io_new_pc_T_3 = _GEN_0 + io_in_imm; // @[BrCond.scala 42:34]
  wire [63:0] _io_new_pc_T_4 = jalr ? _io_new_pc_T_1 : _io_new_pc_T_3; // @[BrCond.scala 41:25]
  assign io_change_pc = (do_jump | do_branch) & io_in_sel; // @[BrCond.scala 40:48]
  assign io_new_pc = _io_new_pc_T_4[31:0]; // @[BrCond.scala 41:19]
endmodule
module ysyx_210727_RegFile(
  input         clock,
  input  [4:0]  io_read_0_addr,
  output [63:0] io_read_0_data,
  input  [4:0]  io_read_1_addr,
  output [63:0] io_read_1_data,
  input  [4:0]  io_write_rd_addr,
  input  [63:0] io_write_rd_data,
  input         io_write_rd_wen
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [63:0] _RAND_13;
  reg [63:0] _RAND_14;
  reg [63:0] _RAND_15;
  reg [63:0] _RAND_16;
  reg [63:0] _RAND_17;
  reg [63:0] _RAND_18;
  reg [63:0] _RAND_19;
  reg [63:0] _RAND_20;
  reg [63:0] _RAND_21;
  reg [63:0] _RAND_22;
  reg [63:0] _RAND_23;
  reg [63:0] _RAND_24;
  reg [63:0] _RAND_25;
  reg [63:0] _RAND_26;
  reg [63:0] _RAND_27;
  reg [63:0] _RAND_28;
  reg [63:0] _RAND_29;
  reg [63:0] _RAND_30;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] regfile_1; // @[RegFile.scala 35:26]
  reg [63:0] regfile_2; // @[RegFile.scala 35:26]
  reg [63:0] regfile_3; // @[RegFile.scala 35:26]
  reg [63:0] regfile_4; // @[RegFile.scala 35:26]
  reg [63:0] regfile_5; // @[RegFile.scala 35:26]
  reg [63:0] regfile_6; // @[RegFile.scala 35:26]
  reg [63:0] regfile_7; // @[RegFile.scala 35:26]
  reg [63:0] regfile_8; // @[RegFile.scala 35:26]
  reg [63:0] regfile_9; // @[RegFile.scala 35:26]
  reg [63:0] regfile_10; // @[RegFile.scala 35:26]
  reg [63:0] regfile_11; // @[RegFile.scala 35:26]
  reg [63:0] regfile_12; // @[RegFile.scala 35:26]
  reg [63:0] regfile_13; // @[RegFile.scala 35:26]
  reg [63:0] regfile_14; // @[RegFile.scala 35:26]
  reg [63:0] regfile_15; // @[RegFile.scala 35:26]
  reg [63:0] regfile_16; // @[RegFile.scala 35:26]
  reg [63:0] regfile_17; // @[RegFile.scala 35:26]
  reg [63:0] regfile_18; // @[RegFile.scala 35:26]
  reg [63:0] regfile_19; // @[RegFile.scala 35:26]
  reg [63:0] regfile_20; // @[RegFile.scala 35:26]
  reg [63:0] regfile_21; // @[RegFile.scala 35:26]
  reg [63:0] regfile_22; // @[RegFile.scala 35:26]
  reg [63:0] regfile_23; // @[RegFile.scala 35:26]
  reg [63:0] regfile_24; // @[RegFile.scala 35:26]
  reg [63:0] regfile_25; // @[RegFile.scala 35:26]
  reg [63:0] regfile_26; // @[RegFile.scala 35:26]
  reg [63:0] regfile_27; // @[RegFile.scala 35:26]
  reg [63:0] regfile_28; // @[RegFile.scala 35:26]
  reg [63:0] regfile_29; // @[RegFile.scala 35:26]
  reg [63:0] regfile_30; // @[RegFile.scala 35:26]
  reg [63:0] regfile_31; // @[RegFile.scala 35:26]
  wire [63:0] _GEN_1 = 5'h1 == io_read_0_addr ? regfile_1 : 64'h0; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_2 = 5'h2 == io_read_0_addr ? regfile_2 : _GEN_1; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_3 = 5'h3 == io_read_0_addr ? regfile_3 : _GEN_2; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_4 = 5'h4 == io_read_0_addr ? regfile_4 : _GEN_3; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_5 = 5'h5 == io_read_0_addr ? regfile_5 : _GEN_4; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_6 = 5'h6 == io_read_0_addr ? regfile_6 : _GEN_5; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_7 = 5'h7 == io_read_0_addr ? regfile_7 : _GEN_6; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_8 = 5'h8 == io_read_0_addr ? regfile_8 : _GEN_7; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_9 = 5'h9 == io_read_0_addr ? regfile_9 : _GEN_8; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_10 = 5'ha == io_read_0_addr ? regfile_10 : _GEN_9; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_11 = 5'hb == io_read_0_addr ? regfile_11 : _GEN_10; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_12 = 5'hc == io_read_0_addr ? regfile_12 : _GEN_11; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_13 = 5'hd == io_read_0_addr ? regfile_13 : _GEN_12; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_14 = 5'he == io_read_0_addr ? regfile_14 : _GEN_13; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_15 = 5'hf == io_read_0_addr ? regfile_15 : _GEN_14; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_16 = 5'h10 == io_read_0_addr ? regfile_16 : _GEN_15; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_17 = 5'h11 == io_read_0_addr ? regfile_17 : _GEN_16; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_18 = 5'h12 == io_read_0_addr ? regfile_18 : _GEN_17; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_19 = 5'h13 == io_read_0_addr ? regfile_19 : _GEN_18; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_20 = 5'h14 == io_read_0_addr ? regfile_20 : _GEN_19; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_21 = 5'h15 == io_read_0_addr ? regfile_21 : _GEN_20; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_22 = 5'h16 == io_read_0_addr ? regfile_22 : _GEN_21; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_23 = 5'h17 == io_read_0_addr ? regfile_23 : _GEN_22; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_24 = 5'h18 == io_read_0_addr ? regfile_24 : _GEN_23; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_25 = 5'h19 == io_read_0_addr ? regfile_25 : _GEN_24; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_26 = 5'h1a == io_read_0_addr ? regfile_26 : _GEN_25; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_27 = 5'h1b == io_read_0_addr ? regfile_27 : _GEN_26; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_28 = 5'h1c == io_read_0_addr ? regfile_28 : _GEN_27; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_29 = 5'h1d == io_read_0_addr ? regfile_29 : _GEN_28; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_30 = 5'h1e == io_read_0_addr ? regfile_30 : _GEN_29; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_33 = 5'h1 == io_read_1_addr ? regfile_1 : 64'h0; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_34 = 5'h2 == io_read_1_addr ? regfile_2 : _GEN_33; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_35 = 5'h3 == io_read_1_addr ? regfile_3 : _GEN_34; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_36 = 5'h4 == io_read_1_addr ? regfile_4 : _GEN_35; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_37 = 5'h5 == io_read_1_addr ? regfile_5 : _GEN_36; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_38 = 5'h6 == io_read_1_addr ? regfile_6 : _GEN_37; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_39 = 5'h7 == io_read_1_addr ? regfile_7 : _GEN_38; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_40 = 5'h8 == io_read_1_addr ? regfile_8 : _GEN_39; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_41 = 5'h9 == io_read_1_addr ? regfile_9 : _GEN_40; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_42 = 5'ha == io_read_1_addr ? regfile_10 : _GEN_41; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_43 = 5'hb == io_read_1_addr ? regfile_11 : _GEN_42; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_44 = 5'hc == io_read_1_addr ? regfile_12 : _GEN_43; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_45 = 5'hd == io_read_1_addr ? regfile_13 : _GEN_44; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_46 = 5'he == io_read_1_addr ? regfile_14 : _GEN_45; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_47 = 5'hf == io_read_1_addr ? regfile_15 : _GEN_46; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_48 = 5'h10 == io_read_1_addr ? regfile_16 : _GEN_47; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_49 = 5'h11 == io_read_1_addr ? regfile_17 : _GEN_48; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_50 = 5'h12 == io_read_1_addr ? regfile_18 : _GEN_49; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_51 = 5'h13 == io_read_1_addr ? regfile_19 : _GEN_50; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_52 = 5'h14 == io_read_1_addr ? regfile_20 : _GEN_51; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_53 = 5'h15 == io_read_1_addr ? regfile_21 : _GEN_52; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_54 = 5'h16 == io_read_1_addr ? regfile_22 : _GEN_53; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_55 = 5'h17 == io_read_1_addr ? regfile_23 : _GEN_54; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_56 = 5'h18 == io_read_1_addr ? regfile_24 : _GEN_55; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_57 = 5'h19 == io_read_1_addr ? regfile_25 : _GEN_56; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_58 = 5'h1a == io_read_1_addr ? regfile_26 : _GEN_57; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_59 = 5'h1b == io_read_1_addr ? regfile_27 : _GEN_58; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_60 = 5'h1c == io_read_1_addr ? regfile_28 : _GEN_59; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_61 = 5'h1d == io_read_1_addr ? regfile_29 : _GEN_60; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  wire [63:0] _GEN_62 = 5'h1e == io_read_1_addr ? regfile_30 : _GEN_61; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  assign io_read_0_data = 5'h1f == io_read_0_addr ? regfile_31 : _GEN_30; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  assign io_read_1_data = 5'h1f == io_read_1_addr ? regfile_31 : _GEN_62; // @[RegFile.scala 40:27 RegFile.scala 40:27]
  always @(posedge clock) begin
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_1 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h2 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_2 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h3 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_3 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h4 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_4 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h5 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_5 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h6 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_6 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h7 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_7 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h8 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_8 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h9 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_9 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'ha == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_10 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'hb == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_11 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'hc == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_12 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'hd == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_13 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'he == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_14 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'hf == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_15 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h10 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_16 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h11 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_17 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h12 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_18 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h13 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_19 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h14 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_20 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h15 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_21 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h16 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_22 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h17 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_23 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h18 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_24 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h19 == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_25 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1a == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_26 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1b == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_27 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1c == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_28 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1d == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_29 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1e == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_30 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
    if (io_write_rd_wen) begin // @[RegFile.scala 43:32]
      if (5'h1f == io_write_rd_addr) begin // @[RegFile.scala 44:43]
        regfile_31 <= io_write_rd_data; // @[RegFile.scala 44:43]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  regfile_1 = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  regfile_2 = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  regfile_3 = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  regfile_4 = _RAND_3[63:0];
  _RAND_4 = {2{`RANDOM}};
  regfile_5 = _RAND_4[63:0];
  _RAND_5 = {2{`RANDOM}};
  regfile_6 = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  regfile_7 = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  regfile_8 = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  regfile_9 = _RAND_8[63:0];
  _RAND_9 = {2{`RANDOM}};
  regfile_10 = _RAND_9[63:0];
  _RAND_10 = {2{`RANDOM}};
  regfile_11 = _RAND_10[63:0];
  _RAND_11 = {2{`RANDOM}};
  regfile_12 = _RAND_11[63:0];
  _RAND_12 = {2{`RANDOM}};
  regfile_13 = _RAND_12[63:0];
  _RAND_13 = {2{`RANDOM}};
  regfile_14 = _RAND_13[63:0];
  _RAND_14 = {2{`RANDOM}};
  regfile_15 = _RAND_14[63:0];
  _RAND_15 = {2{`RANDOM}};
  regfile_16 = _RAND_15[63:0];
  _RAND_16 = {2{`RANDOM}};
  regfile_17 = _RAND_16[63:0];
  _RAND_17 = {2{`RANDOM}};
  regfile_18 = _RAND_17[63:0];
  _RAND_18 = {2{`RANDOM}};
  regfile_19 = _RAND_18[63:0];
  _RAND_19 = {2{`RANDOM}};
  regfile_20 = _RAND_19[63:0];
  _RAND_20 = {2{`RANDOM}};
  regfile_21 = _RAND_20[63:0];
  _RAND_21 = {2{`RANDOM}};
  regfile_22 = _RAND_21[63:0];
  _RAND_22 = {2{`RANDOM}};
  regfile_23 = _RAND_22[63:0];
  _RAND_23 = {2{`RANDOM}};
  regfile_24 = _RAND_23[63:0];
  _RAND_24 = {2{`RANDOM}};
  regfile_25 = _RAND_24[63:0];
  _RAND_25 = {2{`RANDOM}};
  regfile_26 = _RAND_25[63:0];
  _RAND_26 = {2{`RANDOM}};
  regfile_27 = _RAND_26[63:0];
  _RAND_27 = {2{`RANDOM}};
  regfile_28 = _RAND_27[63:0];
  _RAND_28 = {2{`RANDOM}};
  regfile_29 = _RAND_28[63:0];
  _RAND_29 = {2{`RANDOM}};
  regfile_30 = _RAND_29[63:0];
  _RAND_30 = {2{`RANDOM}};
  regfile_31 = _RAND_30[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_Alu(
  input  [4:0]  io_in_op,
  input  [63:0] io_in_in0,
  input  [63:0] io_in_in1,
  output [63:0] io_res
);
  wire [2:0] op = io_in_op[2:0]; // @[Alu.scala 34:35]
  wire  arith = io_in_op[3]; // @[Alu.scala 35:35]
  wire  word = io_in_op[4]; // @[Alu.scala 36:35]
  wire  _in0_T_1 = io_in_in0[31] & arith; // @[Alu.scala 38:56]
  wire [31:0] in0_hi = _in0_T_1 ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] in0_lo = io_in_in0[31:0]; // @[Alu.scala 38:75]
  wire [63:0] _in0_T_3 = {in0_hi,in0_lo}; // @[Cat.scala 30:58]
  wire [63:0] in0 = word ? _in0_T_3 : io_in_in0; // @[Alu.scala 38:22]
  wire  _in1_T_1 = io_in_in1[31] & arith; // @[Alu.scala 39:56]
  wire [31:0] in1_hi = _in1_T_1 ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] in1_lo = io_in_in1[31:0]; // @[Alu.scala 39:75]
  wire [63:0] _in1_T_3 = {in1_hi,in1_lo}; // @[Cat.scala 30:58]
  wire [63:0] in1 = word ? _in1_T_3 : io_in_in1; // @[Alu.scala 39:22]
  wire [63:0] _add_in1_T = ~io_in_in1; // @[Alu.scala 40:34]
  wire [63:0] _add_in1_T_2 = _add_in1_T + 64'h1; // @[Alu.scala 40:45]
  wire [63:0] add_in1 = arith ? _add_in1_T_2 : io_in_in1; // @[Alu.scala 40:26]
  wire [4:0] shmt_lo = io_in_in1[4:0]; // @[Alu.scala 42:48]
  wire [5:0] _shmt_T = {1'h0,shmt_lo}; // @[Cat.scala 30:58]
  wire [5:0] shmt = word ? _shmt_T : io_in_in1[5:0]; // @[Alu.scala 42:23]
  wire [63:0] _res_T_1 = in0 + add_in1; // @[Alu.scala 46:33]
  wire [63:0] _res_T_2 = word ? _in0_T_3 : io_in_in0; // @[Alu.scala 47:33]
  wire [63:0] _res_T_3 = word ? _in1_T_3 : io_in_in1; // @[Alu.scala 47:46]
  wire  _res_T_4 = $signed(_res_T_2) < $signed(_res_T_3); // @[Alu.scala 47:40]
  wire  _res_T_5 = in0 < in1; // @[Alu.scala 48:40]
  wire [63:0] _res_T_6 = in0 ^ in1; // @[Alu.scala 49:33]
  wire [63:0] _res_T_7 = in0 | in1; // @[Alu.scala 50:41]
  wire [63:0] _res_T_8 = in0 & in1; // @[Alu.scala 51:33]
  wire [126:0] _GEN_0 = {{63'd0}, in0}; // @[Alu.scala 52:33]
  wire [126:0] _res_T_9 = _GEN_0 << shmt; // @[Alu.scala 52:33]
  wire [63:0] _res_T_12 = $signed(_res_T_2) >>> shmt; // @[Alu.scala 53:60]
  wire [63:0] _res_T_13 = in0 >> shmt; // @[Alu.scala 53:72]
  wire [63:0] _res_T_14 = arith ? _res_T_12 : _res_T_13; // @[Alu.scala 53:31]
  wire [63:0] _res_T_16 = 3'h2 == op ? {{63'd0}, _res_T_4} : _res_T_1; // @[Mux.scala 80:57]
  wire [63:0] _res_T_18 = 3'h3 == op ? {{63'd0}, _res_T_5} : _res_T_16; // @[Mux.scala 80:57]
  wire [63:0] _res_T_20 = 3'h4 == op ? _res_T_6 : _res_T_18; // @[Mux.scala 80:57]
  wire [63:0] _res_T_22 = 3'h6 == op ? _res_T_7 : _res_T_20; // @[Mux.scala 80:57]
  wire [63:0] _res_T_24 = 3'h7 == op ? _res_T_8 : _res_T_22; // @[Mux.scala 80:57]
  wire [126:0] _res_T_26 = 3'h1 == op ? _res_T_9 : {{63'd0}, _res_T_24}; // @[Mux.scala 80:57]
  wire [126:0] res = 3'h5 == op ? {{63'd0}, _res_T_14} : _res_T_26; // @[Mux.scala 80:57]
  wire [31:0] io_res_hi = res[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] io_res_lo = res[31:0]; // @[Alu.scala 56:61]
  wire [63:0] _io_res_T_2 = {io_res_hi,io_res_lo}; // @[Cat.scala 30:58]
  wire [126:0] _io_res_T_3 = word ? {{63'd0}, _io_res_T_2} : res; // @[Alu.scala 56:22]
  assign io_res = _io_res_T_3[63:0]; // @[Alu.scala 56:16]
endmodule
module ysyx_210727_TrapCtrl(
  input         io__excp_do_excp,
  input  [3:0]  io__excp_code,
  output        io__do_trap,
  input         io__inst_done,
  input  [63:0] mip_0,
  output        io_do_trap,
  output        mcause_int_0,
  input  [63:0] mstatus_0,
  output [3:0]  mcause_code_0,
  input  [63:0] mie_0
);
  wire  mstatus_ie = mstatus_0[3]; // @[TrapCtrl.scala 31:33]
  wire  do_timer = mie_0[7] & mip_0[7]; // @[TrapCtrl.scala 43:51]
  wire  do_extern = mie_0[11] & mip_0[11]; // @[TrapCtrl.scala 44:52]
  wire  do_soft = mie_0[3] & mip_0[3]; // @[TrapCtrl.scala 47:50]
  wire  do_interrupt = mstatus_ie & (do_timer | do_extern | do_soft); // @[TrapCtrl.scala 49:44]
  wire [3:0] _int_code_T = do_soft ? 4'h3 : 4'h7; // @[TrapCtrl.scala 52:36]
  wire [3:0] int_code = do_extern ? 4'h3 : _int_code_T; // @[TrapCtrl.scala 51:32]
  wire [3:0] mcause_code = io__excp_do_excp ? io__excp_code : int_code; // @[TrapCtrl.scala 63:27]
  wire  mcause_int = ~io__excp_do_excp & do_interrupt; // @[TrapCtrl.scala 64:40]
  assign io__do_trap = (io__excp_do_excp | do_interrupt) & io__inst_done; // @[TrapCtrl.scala 56:57]
  assign io_do_trap = io__do_trap;
  assign mcause_int_0 = mcause_int;
  assign mcause_code_0 = mcause_code;
endmodule
module ysyx_210727_MCycle(
  input         clock,
  input         reset,
  output [63:0] io_rdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mcycle; // @[CsrPerf.scala 15:29]
  wire [63:0] _mcycle_T_1 = mcycle + 64'h1; // @[CsrPerf.scala 24:26]
  assign io_rdata = mcycle; // @[CsrPerf.scala 18:18]
  always @(posedge clock) begin
    if (reset) begin // @[CsrPerf.scala 15:29]
      mcycle <= 64'h0; // @[CsrPerf.scala 15:29]
    end else begin
      mcycle <= _mcycle_T_1; // @[CsrPerf.scala 24:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mcycle = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MInstret(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input         minstret_en
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] minstret; // @[CsrPerf.scala 28:31]
  wire [63:0] _minstret_T_1 = minstret + 64'h1; // @[CsrPerf.scala 39:38]
  assign io_rdata = minstret; // @[CsrPerf.scala 30:18]
  always @(posedge clock) begin
    if (reset) begin // @[CsrPerf.scala 28:31]
      minstret <= 64'h0; // @[CsrPerf.scala 28:31]
    end else if (minstret_en) begin // @[CsrPerf.scala 38:23]
      minstret <= _minstret_T_1; // @[CsrPerf.scala 39:26]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  minstret = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MStatus(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input  [63:0] io_wdata,
  input         io_wen,
  input         do_trap_0,
  output [63:0] io_rdata_3,
  input         do_mret_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  mie; // @[CsrTrap.scala 39:34]
  reg  mpie; // @[CsrTrap.scala 40:34]
  wire [31:0] io_rdata_lo = {16'h0,8'h18,mpie,1'h0,2'h0,mie,1'h0,2'h0}; // @[CsrTrap.scala 48:40]
  wire  _GEN_1 = io_wen ? io_wdata[7] : mpie; // @[CsrTrap.scala 65:28 CsrTrap.scala 67:25 CsrTrap.scala 40:34]
  wire  _GEN_3 = do_mret_0 | _GEN_1; // @[CsrTrap.scala 61:29 CsrTrap.scala 63:25]
  assign io_rdata = {32'h0,io_rdata_lo}; // @[CsrTrap.scala 48:40]
  assign io_rdata_3 = io_rdata;
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 39:34]
      mie <= 1'h0; // @[CsrTrap.scala 39:34]
    end else if (do_trap_0) begin // @[CsrTrap.scala 57:24]
      mie <= 1'h0; // @[CsrTrap.scala 58:25]
    end else if (do_mret_0) begin // @[CsrTrap.scala 61:29]
      mie <= mpie; // @[CsrTrap.scala 62:25]
    end else if (io_wen) begin // @[CsrTrap.scala 65:28]
      mie <= io_wdata[3]; // @[CsrTrap.scala 66:25]
    end
    if (reset) begin // @[CsrTrap.scala 40:34]
      mpie <= 1'h0; // @[CsrTrap.scala 40:34]
    end else if (do_trap_0) begin // @[CsrTrap.scala 57:24]
      mpie <= mie; // @[CsrTrap.scala 59:25]
    end else begin
      mpie <= _GEN_3;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  mie = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  mpie = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MEDeleg(
  output [63:0] io_rdata
);
  assign io_rdata = 64'h0; // @[CsrTrap.scala 74:25]
endmodule
module ysyx_210727_MIDeleg(
  output [63:0] io_rdata
);
  assign io_rdata = 64'h0; // @[CsrTrap.scala 80:25]
endmodule
module ysyx_210727_MtVec(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input  [63:0] io_wdata,
  input         io_wen,
  output [63:0] io_rdata_6
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [61:0] BASE; // @[CsrTrap.scala 90:27]
  wire  align = ~(|io_wdata[1:0]); // @[CsrTrap.scala 99:21]
  assign io_rdata = {BASE,2'h0}; // @[Cat.scala 30:58]
  assign io_rdata_6 = io_rdata;
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 90:27]
      BASE <= 62'h0; // @[CsrTrap.scala 90:27]
    end else if (io_wen & align) begin // @[CsrTrap.scala 100:32]
      BASE <= io_wdata[63:2]; // @[CsrTrap.scala 101:25]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  BASE = _RAND_0[61:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MScratch(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input  [63:0] io_wdata,
  input         io_wen
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mscratch; // @[CsrTrap.scala 106:31]
  assign io_rdata = mscratch; // @[CsrTrap.scala 108:18]
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 106:31]
      mscratch <= 64'h0; // @[CsrTrap.scala 106:31]
    end else if (io_wen) begin // @[CsrTrap.scala 111:23]
      mscratch <= io_wdata; // @[CsrTrap.scala 112:26]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mscratch = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MEpc(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input  [63:0] io_wdata,
  input         io_wen,
  input         do_trap_0,
  output [63:0] io_rdata_2,
  input  [31:0] mepc_pc_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [29:0] mepc; // @[CsrTrap.scala 117:27]
  wire [31:0] _io_rdata_T = {mepc,2'h0}; // @[Cat.scala 30:58]
  assign io_rdata = {{32'd0}, _io_rdata_T}; // @[Cat.scala 30:58]
  assign io_rdata_2 = io_rdata;
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 117:27]
      mepc <= 30'h0; // @[CsrTrap.scala 117:27]
    end else if (do_trap_0) begin // @[CsrTrap.scala 129:24]
      mepc <= mepc_pc_0[31:2]; // @[CsrTrap.scala 130:22]
    end else if (io_wen) begin // @[CsrTrap.scala 132:28]
      mepc <= io_wdata[31:2]; // @[CsrTrap.scala 133:22]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  mepc = _RAND_0[29:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MCause(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input         do_trap_0,
  input         mcause_int_0,
  input  [3:0]  mcause_code_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  int_; // @[CsrTrap.scala 169:26]
  reg [3:0] excp_code; // @[CsrTrap.scala 170:32]
  wire [59:0] mcause_hi = {int_,59'h0}; // @[Cat.scala 30:58]
  assign io_rdata = {mcause_hi,excp_code}; // @[Cat.scala 30:58]
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 169:26]
      int_ <= 1'h0; // @[CsrTrap.scala 169:26]
    end else if (do_trap_0) begin // @[CsrTrap.scala 187:24]
      int_ <= mcause_int_0; // @[CsrTrap.scala 188:21]
    end
    if (reset) begin // @[CsrTrap.scala 170:32]
      excp_code <= 4'h0; // @[CsrTrap.scala 170:32]
    end else if (do_trap_0) begin // @[CsrTrap.scala 187:24]
      excp_code <= mcause_code_0; // @[CsrTrap.scala 189:27]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  int_ = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  excp_code = _RAND_1[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_MtVal(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input  [63:0] io_wdata,
  input         io_wen
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mtval; // @[CsrTrap.scala 194:28]
  assign io_rdata = mtval; // @[CsrTrap.scala 196:18]
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 194:28]
      mtval <= 64'h0; // @[CsrTrap.scala 194:28]
    end else if (io_wen) begin // @[CsrTrap.scala 199:23]
      mtval <= io_wdata; // @[CsrTrap.scala 200:23]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mtval = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_Mip(
  output [63:0] io__rdata,
  output [63:0] io_rdata,
  input         do_external_0,
  input         do_soft_0,
  input         do_timer_0
);
  wire [15:0] io_rdata_lo_lo = {4'h0,do_external_0,1'h0,2'h0,do_timer_0,1'h0,2'h0,do_soft_0,1'h0,2'h0}; // @[CsrTrap.scala 229:25]
  wire [31:0] io_rdata_lo = {16'h0,io_rdata_lo_lo}; // @[CsrTrap.scala 229:25]
  assign io__rdata = {32'h0,io_rdata_lo}; // @[CsrTrap.scala 229:25]
  assign io_rdata = io__rdata;
endmodule
module ysyx_210727_Mie(
  input         clock,
  input         reset,
  output [63:0] io_rdata,
  input  [63:0] io_wdata,
  input         io_wen,
  output [63:0] io_rdata_7
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg  msie; // @[CsrTrap.scala 234:27]
  reg  mtie; // @[CsrTrap.scala 235:27]
  reg  meie; // @[CsrTrap.scala 236:27]
  wire [15:0] io_rdata_lo_lo = {4'h0,meie,1'h0,2'h0,mtie,1'h0,2'h0,msie,1'h0,2'h0}; // @[CsrTrap.scala 247:29]
  wire [31:0] io_rdata_lo = {16'h0,io_rdata_lo_lo}; // @[CsrTrap.scala 247:29]
  assign io_rdata = {32'h0,io_rdata_lo}; // @[CsrTrap.scala 247:29]
  assign io_rdata_7 = io_rdata;
  always @(posedge clock) begin
    if (reset) begin // @[CsrTrap.scala 234:27]
      msie <= 1'h0; // @[CsrTrap.scala 234:27]
    end else if (io_wen) begin // @[CsrTrap.scala 251:23]
      msie <= io_wdata[3]; // @[CsrTrap.scala 252:22]
    end
    if (reset) begin // @[CsrTrap.scala 235:27]
      mtie <= 1'h0; // @[CsrTrap.scala 235:27]
    end else if (io_wen) begin // @[CsrTrap.scala 251:23]
      mtie <= io_wdata[7]; // @[CsrTrap.scala 253:22]
    end
    if (reset) begin // @[CsrTrap.scala 236:27]
      meie <= 1'h0; // @[CsrTrap.scala 236:27]
    end else if (io_wen) begin // @[CsrTrap.scala 251:23]
      meie <= io_wdata[11]; // @[CsrTrap.scala 254:22]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  msie = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  mtie = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  meie = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_CsrFile(
  input         clock,
  input         reset,
  input  [11:0] io_read_addr,
  output [63:0] io_read_data,
  input  [11:0] io_write_addr,
  input  [63:0] io_write_data,
  input         io_write_wen,
  output [63:0] mip_0,
  input         io_int_extern,
  input         io_do_trap,
  output [63:0] mepc_0,
  input         mcause_int,
  output [63:0] mstatus_0,
  input         io_int_soft,
  input  [3:0]  mcause_code,
  input         minstret_en,
  output [63:0] mtvec_0,
  input         io_int_timer,
  output [63:0] mie_0,
  input         io_mret,
  input  [31:0] io_out_pc
);
  wire  csrfile_4_clock; // @[CsrFile.scala 77:23]
  wire  csrfile_4_reset; // @[CsrFile.scala 77:23]
  wire [63:0] csrfile_4_io_rdata; // @[CsrFile.scala 77:23]
  wire  csrfile_5_clock; // @[CsrFile.scala 77:43]
  wire  csrfile_5_reset; // @[CsrFile.scala 77:43]
  wire [63:0] csrfile_5_io_rdata; // @[CsrFile.scala 77:43]
  wire  csrfile_5_minstret_en; // @[CsrFile.scala 77:43]
  wire  csrfile_6_clock; // @[CsrFile.scala 78:23]
  wire  csrfile_6_reset; // @[CsrFile.scala 78:23]
  wire [63:0] csrfile_6_io_rdata; // @[CsrFile.scala 78:23]
  wire [63:0] csrfile_6_io_wdata; // @[CsrFile.scala 78:23]
  wire  csrfile_6_io_wen; // @[CsrFile.scala 78:23]
  wire  csrfile_6_do_trap_0; // @[CsrFile.scala 78:23]
  wire [63:0] csrfile_6_io_rdata_3; // @[CsrFile.scala 78:23]
  wire  csrfile_6_do_mret_0; // @[CsrFile.scala 78:23]
  wire [63:0] csrfile_7_io_rdata; // @[CsrFile.scala 78:44]
  wire [63:0] csrfile_8_io_rdata; // @[CsrFile.scala 78:65]
  wire  csrfile_9_clock; // @[CsrFile.scala 78:86]
  wire  csrfile_9_reset; // @[CsrFile.scala 78:86]
  wire [63:0] csrfile_9_io_rdata; // @[CsrFile.scala 78:86]
  wire [63:0] csrfile_9_io_wdata; // @[CsrFile.scala 78:86]
  wire  csrfile_9_io_wen; // @[CsrFile.scala 78:86]
  wire [63:0] csrfile_9_io_rdata_6; // @[CsrFile.scala 78:86]
  wire  csrfile_10_clock; // @[CsrFile.scala 78:105]
  wire  csrfile_10_reset; // @[CsrFile.scala 78:105]
  wire [63:0] csrfile_10_io_rdata; // @[CsrFile.scala 78:105]
  wire [63:0] csrfile_10_io_wdata; // @[CsrFile.scala 78:105]
  wire  csrfile_10_io_wen; // @[CsrFile.scala 78:105]
  wire  csrfile_11_clock; // @[CsrFile.scala 79:23]
  wire  csrfile_11_reset; // @[CsrFile.scala 79:23]
  wire [63:0] csrfile_11_io_rdata; // @[CsrFile.scala 79:23]
  wire [63:0] csrfile_11_io_wdata; // @[CsrFile.scala 79:23]
  wire  csrfile_11_io_wen; // @[CsrFile.scala 79:23]
  wire  csrfile_11_do_trap_0; // @[CsrFile.scala 79:23]
  wire [63:0] csrfile_11_io_rdata_2; // @[CsrFile.scala 79:23]
  wire [31:0] csrfile_11_mepc_pc_0; // @[CsrFile.scala 79:23]
  wire  csrfile_12_clock; // @[CsrFile.scala 79:41]
  wire  csrfile_12_reset; // @[CsrFile.scala 79:41]
  wire [63:0] csrfile_12_io_rdata; // @[CsrFile.scala 79:41]
  wire  csrfile_12_do_trap_0; // @[CsrFile.scala 79:41]
  wire  csrfile_12_mcause_int_0; // @[CsrFile.scala 79:41]
  wire [3:0] csrfile_12_mcause_code_0; // @[CsrFile.scala 79:41]
  wire  csrfile_13_clock; // @[CsrFile.scala 79:61]
  wire  csrfile_13_reset; // @[CsrFile.scala 79:61]
  wire [63:0] csrfile_13_io_rdata; // @[CsrFile.scala 79:61]
  wire [63:0] csrfile_13_io_wdata; // @[CsrFile.scala 79:61]
  wire  csrfile_13_io_wen; // @[CsrFile.scala 79:61]
  wire [63:0] csrfile_14_io__rdata; // @[CsrFile.scala 79:80]
  wire [63:0] csrfile_14_io_rdata; // @[CsrFile.scala 79:80]
  wire  csrfile_14_do_external_0; // @[CsrFile.scala 79:80]
  wire  csrfile_14_do_soft_0; // @[CsrFile.scala 79:80]
  wire  csrfile_14_do_timer_0; // @[CsrFile.scala 79:80]
  wire  csrfile_15_clock; // @[CsrFile.scala 79:97]
  wire  csrfile_15_reset; // @[CsrFile.scala 79:97]
  wire [63:0] csrfile_15_io_rdata; // @[CsrFile.scala 79:97]
  wire [63:0] csrfile_15_io_wdata; // @[CsrFile.scala 79:97]
  wire  csrfile_15_io_wen; // @[CsrFile.scala 79:97]
  wire [63:0] csrfile_15_io_rdata_7; // @[CsrFile.scala 79:97]
  wire  sel_8 = 12'hb00 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_20 = sel_8 ? csrfile_4_io_rdata : 64'h0; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_10 = 12'hb02 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_25 = sel_10 ? csrfile_5_io_rdata : _GEN_20; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_12 = 12'h300 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_30 = sel_12 ? csrfile_6_io_rdata : _GEN_25; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_13 = 12'h300 == io_write_addr; // @[CsrFile.scala 93:46]
  wire  sel_14 = 12'h302 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_35 = sel_14 ? csrfile_7_io_rdata : _GEN_30; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_16 = 12'h303 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_40 = sel_16 ? csrfile_8_io_rdata : _GEN_35; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_18 = 12'h305 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_45 = sel_18 ? csrfile_9_io_rdata : _GEN_40; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_19 = 12'h305 == io_write_addr; // @[CsrFile.scala 93:46]
  wire  sel_20 = 12'h340 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_50 = sel_20 ? csrfile_10_io_rdata : _GEN_45; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_21 = 12'h340 == io_write_addr; // @[CsrFile.scala 93:46]
  wire  sel_22 = 12'h341 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_55 = sel_22 ? csrfile_11_io_rdata : _GEN_50; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_23 = 12'h341 == io_write_addr; // @[CsrFile.scala 93:46]
  wire  sel_24 = 12'h342 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_60 = sel_24 ? csrfile_12_io_rdata : _GEN_55; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_26 = 12'h343 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_65 = sel_26 ? csrfile_13_io_rdata : _GEN_60; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_27 = 12'h343 == io_write_addr; // @[CsrFile.scala 93:46]
  wire  sel_28 = 12'h344 == io_read_addr; // @[CsrFile.scala 86:46]
  wire [63:0] _GEN_70 = sel_28 ? csrfile_14_io__rdata : _GEN_65; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  wire  sel_30 = 12'h304 == io_read_addr; // @[CsrFile.scala 86:46]
  wire  sel_31 = 12'h304 == io_write_addr; // @[CsrFile.scala 93:46]
  ysyx_210727_MCycle csrfile_4 ( // @[CsrFile.scala 77:23]
    .clock(csrfile_4_clock),
    .reset(csrfile_4_reset),
    .io_rdata(csrfile_4_io_rdata)
  );
  ysyx_210727_MInstret csrfile_5 ( // @[CsrFile.scala 77:43]
    .clock(csrfile_5_clock),
    .reset(csrfile_5_reset),
    .io_rdata(csrfile_5_io_rdata),
    .minstret_en(csrfile_5_minstret_en)
  );
  ysyx_210727_MStatus csrfile_6 ( // @[CsrFile.scala 78:23]
    .clock(csrfile_6_clock),
    .reset(csrfile_6_reset),
    .io_rdata(csrfile_6_io_rdata),
    .io_wdata(csrfile_6_io_wdata),
    .io_wen(csrfile_6_io_wen),
    .do_trap_0(csrfile_6_do_trap_0),
    .io_rdata_3(csrfile_6_io_rdata_3),
    .do_mret_0(csrfile_6_do_mret_0)
  );
  ysyx_210727_MEDeleg csrfile_7 ( // @[CsrFile.scala 78:44]
    .io_rdata(csrfile_7_io_rdata)
  );
  ysyx_210727_MIDeleg csrfile_8 ( // @[CsrFile.scala 78:65]
    .io_rdata(csrfile_8_io_rdata)
  );
  ysyx_210727_MtVec csrfile_9 ( // @[CsrFile.scala 78:86]
    .clock(csrfile_9_clock),
    .reset(csrfile_9_reset),
    .io_rdata(csrfile_9_io_rdata),
    .io_wdata(csrfile_9_io_wdata),
    .io_wen(csrfile_9_io_wen),
    .io_rdata_6(csrfile_9_io_rdata_6)
  );
  ysyx_210727_MScratch csrfile_10 ( // @[CsrFile.scala 78:105]
    .clock(csrfile_10_clock),
    .reset(csrfile_10_reset),
    .io_rdata(csrfile_10_io_rdata),
    .io_wdata(csrfile_10_io_wdata),
    .io_wen(csrfile_10_io_wen)
  );
  ysyx_210727_MEpc csrfile_11 ( // @[CsrFile.scala 79:23]
    .clock(csrfile_11_clock),
    .reset(csrfile_11_reset),
    .io_rdata(csrfile_11_io_rdata),
    .io_wdata(csrfile_11_io_wdata),
    .io_wen(csrfile_11_io_wen),
    .do_trap_0(csrfile_11_do_trap_0),
    .io_rdata_2(csrfile_11_io_rdata_2),
    .mepc_pc_0(csrfile_11_mepc_pc_0)
  );
  ysyx_210727_MCause csrfile_12 ( // @[CsrFile.scala 79:41]
    .clock(csrfile_12_clock),
    .reset(csrfile_12_reset),
    .io_rdata(csrfile_12_io_rdata),
    .do_trap_0(csrfile_12_do_trap_0),
    .mcause_int_0(csrfile_12_mcause_int_0),
    .mcause_code_0(csrfile_12_mcause_code_0)
  );
  ysyx_210727_MtVal csrfile_13 ( // @[CsrFile.scala 79:61]
    .clock(csrfile_13_clock),
    .reset(csrfile_13_reset),
    .io_rdata(csrfile_13_io_rdata),
    .io_wdata(csrfile_13_io_wdata),
    .io_wen(csrfile_13_io_wen)
  );
  ysyx_210727_Mip csrfile_14 ( // @[CsrFile.scala 79:80]
    .io__rdata(csrfile_14_io__rdata),
    .io_rdata(csrfile_14_io_rdata),
    .do_external_0(csrfile_14_do_external_0),
    .do_soft_0(csrfile_14_do_soft_0),
    .do_timer_0(csrfile_14_do_timer_0)
  );
  ysyx_210727_Mie csrfile_15 ( // @[CsrFile.scala 79:97]
    .clock(csrfile_15_clock),
    .reset(csrfile_15_reset),
    .io_rdata(csrfile_15_io_rdata),
    .io_wdata(csrfile_15_io_wdata),
    .io_wen(csrfile_15_io_wen),
    .io_rdata_7(csrfile_15_io_rdata_7)
  );
  assign io_read_data = sel_30 ? csrfile_15_io_rdata : _GEN_70; // @[CsrFile.scala 87:36 CsrFile.scala 88:49]
  assign mip_0 = csrfile_14_io_rdata;
  assign mepc_0 = csrfile_11_io_rdata_2;
  assign mstatus_0 = csrfile_6_io_rdata_3;
  assign mtvec_0 = csrfile_9_io_rdata_6;
  assign mie_0 = csrfile_15_io_rdata_7;
  assign csrfile_4_clock = clock;
  assign csrfile_4_reset = reset;
  assign csrfile_5_clock = clock;
  assign csrfile_5_reset = reset;
  assign csrfile_5_minstret_en = minstret_en;
  assign csrfile_6_clock = clock;
  assign csrfile_6_reset = reset;
  assign csrfile_6_io_wdata = sel_13 ? io_write_data : 64'h0; // @[CsrFile.scala 94:36 CsrFile.scala 95:49 CsrFile.scala 83:33]
  assign csrfile_6_io_wen = sel_13 & io_write_wen; // @[CsrFile.scala 94:36 CsrFile.scala 96:57 CsrFile.scala 84:41]
  assign csrfile_6_do_trap_0 = io_do_trap;
  assign csrfile_6_do_mret_0 = io_mret;
  assign csrfile_9_clock = clock;
  assign csrfile_9_reset = reset;
  assign csrfile_9_io_wdata = sel_19 ? io_write_data : 64'h0; // @[CsrFile.scala 94:36 CsrFile.scala 95:49 CsrFile.scala 83:33]
  assign csrfile_9_io_wen = sel_19 & io_write_wen; // @[CsrFile.scala 94:36 CsrFile.scala 96:57 CsrFile.scala 84:41]
  assign csrfile_10_clock = clock;
  assign csrfile_10_reset = reset;
  assign csrfile_10_io_wdata = sel_21 ? io_write_data : 64'h0; // @[CsrFile.scala 94:36 CsrFile.scala 95:49 CsrFile.scala 83:33]
  assign csrfile_10_io_wen = sel_21 & io_write_wen; // @[CsrFile.scala 94:36 CsrFile.scala 96:57 CsrFile.scala 84:41]
  assign csrfile_11_clock = clock;
  assign csrfile_11_reset = reset;
  assign csrfile_11_io_wdata = sel_23 ? io_write_data : 64'h0; // @[CsrFile.scala 94:36 CsrFile.scala 95:49 CsrFile.scala 83:33]
  assign csrfile_11_io_wen = sel_23 & io_write_wen; // @[CsrFile.scala 94:36 CsrFile.scala 96:57 CsrFile.scala 84:41]
  assign csrfile_11_do_trap_0 = io_do_trap;
  assign csrfile_11_mepc_pc_0 = io_out_pc;
  assign csrfile_12_clock = clock;
  assign csrfile_12_reset = reset;
  assign csrfile_12_do_trap_0 = io_do_trap;
  assign csrfile_12_mcause_int_0 = mcause_int;
  assign csrfile_12_mcause_code_0 = mcause_code;
  assign csrfile_13_clock = clock;
  assign csrfile_13_reset = reset;
  assign csrfile_13_io_wdata = sel_27 ? io_write_data : 64'h0; // @[CsrFile.scala 94:36 CsrFile.scala 95:49 CsrFile.scala 83:33]
  assign csrfile_13_io_wen = sel_27 & io_write_wen; // @[CsrFile.scala 94:36 CsrFile.scala 96:57 CsrFile.scala 84:41]
  assign csrfile_14_do_external_0 = io_int_extern;
  assign csrfile_14_do_soft_0 = io_int_soft;
  assign csrfile_14_do_timer_0 = io_int_timer;
  assign csrfile_15_clock = clock;
  assign csrfile_15_reset = reset;
  assign csrfile_15_io_wdata = sel_31 ? io_write_data : 64'h0; // @[CsrFile.scala 94:36 CsrFile.scala 95:49 CsrFile.scala 83:33]
  assign csrfile_15_io_wen = sel_31 & io_write_wen; // @[CsrFile.scala 94:36 CsrFile.scala 96:57 CsrFile.scala 84:41]
endmodule
module ysyx_210727_HikelCore(
  input         clock,
  input         reset,
  output [63:0] io_iread_bits_addr,
  input         io_iread_bits_excp,
  input         io_iread_bits_misalign,
  input  [63:0] io_iread_bits_data,
  input         io_iread_ready,
  output [63:0] io_dread_bits_addr,
  output [2:0]  io_dread_bits_op,
  input         io_dread_bits_excp,
  input         io_dread_bits_misalign,
  input  [63:0] io_dread_bits_data,
  output        io_dread_valid,
  input         io_dread_ready,
  output [63:0] io_dwrite_bits_addr,
  output [2:0]  io_dwrite_bits_op,
  input         io_dwrite_bits_excp,
  input         io_dwrite_bits_misalign,
  output [63:0] io_dwrite_bits_data,
  output        io_dwrite_valid,
  input         io_dwrite_ready,
  input         io_int_soft,
  input         io_int_timer,
  input         io_int_extern
);
  wire  fetch_clock; // @[HikelCore.scala 29:41]
  wire  fetch_reset; // @[HikelCore.scala 29:41]
  wire  fetch_io_enable; // @[HikelCore.scala 29:41]
  wire  fetch_io_trap; // @[HikelCore.scala 29:41]
  wire [63:0] fetch_io_iread_bits_addr; // @[HikelCore.scala 29:41]
  wire  fetch_io_iread_bits_excp; // @[HikelCore.scala 29:41]
  wire  fetch_io_iread_bits_misalign; // @[HikelCore.scala 29:41]
  wire [63:0] fetch_io_iread_bits_data; // @[HikelCore.scala 29:41]
  wire  fetch_io_iread_valid; // @[HikelCore.scala 29:41]
  wire  fetch_io_iread_ready; // @[HikelCore.scala 29:41]
  wire  fetch_io_hshake; // @[HikelCore.scala 29:41]
  wire  fetch_io_change_pc; // @[HikelCore.scala 29:41]
  wire [31:0] fetch_io_new_pc; // @[HikelCore.scala 29:41]
  wire  fetch_io_mret; // @[HikelCore.scala 29:41]
  wire [31:0] fetch_io_out_pc; // @[HikelCore.scala 29:41]
  wire  fetch_io_out_excp; // @[HikelCore.scala 29:41]
  wire [3:0] fetch_io_out_code; // @[HikelCore.scala 29:41]
  wire [31:0] fetch_io_out_inst; // @[HikelCore.scala 29:41]
  wire [63:0] fetch_mepc_0; // @[HikelCore.scala 29:41]
  wire [63:0] fetch_mtvec_0; // @[HikelCore.scala 29:41]
  wire  decode_clock; // @[HikelCore.scala 30:41]
  wire  decode_reset; // @[HikelCore.scala 30:41]
  wire  decode_io_enable; // @[HikelCore.scala 30:41]
  wire  decode_io_clear; // @[HikelCore.scala 30:41]
  wire  decode_io_trap; // @[HikelCore.scala 30:41]
  wire  decode_io_lsu_write; // @[HikelCore.scala 30:41]
  wire [31:0] decode_io_in_pc; // @[HikelCore.scala 30:41]
  wire  decode_io_in_excp; // @[HikelCore.scala 30:41]
  wire [3:0] decode_io_in_code; // @[HikelCore.scala 30:41]
  wire [31:0] decode_io_in_inst; // @[HikelCore.scala 30:41]
  wire [31:0] decode_io_out_pc; // @[HikelCore.scala 30:41]
  wire  decode_io_out_excp; // @[HikelCore.scala 30:41]
  wire [3:0] decode_io_out_code; // @[HikelCore.scala 30:41]
  wire  decode_io_out_valid; // @[HikelCore.scala 30:41]
  wire [31:0] decode_io_out_inst; // @[HikelCore.scala 30:41]
  wire [63:0] decode_io_out_rs1_addr; // @[HikelCore.scala 30:41]
  wire  decode_io_out_rs1_use; // @[HikelCore.scala 30:41]
  wire [63:0] decode_io_out_rs2_addr; // @[HikelCore.scala 30:41]
  wire  decode_io_out_rs2_use; // @[HikelCore.scala 30:41]
  wire [63:0] decode_io_out_imm; // @[HikelCore.scala 30:41]
  wire [4:0] decode_io_out_uop; // @[HikelCore.scala 30:41]
  wire [4:0] decode_io_out_rd_addr; // @[HikelCore.scala 30:41]
  wire [11:0] decode_io_out_csr_addr; // @[HikelCore.scala 30:41]
  wire  decode_io_out_rd_wen; // @[HikelCore.scala 30:41]
  wire  decode_io_out_csr_use; // @[HikelCore.scala 30:41]
  wire  decode_io_out_lsu_use; // @[HikelCore.scala 30:41]
  wire  decode_io_out_jb_use; // @[HikelCore.scala 30:41]
  wire  decode_io_out_mret; // @[HikelCore.scala 30:41]
  wire  issue_clock; // @[HikelCore.scala 31:41]
  wire  issue_reset; // @[HikelCore.scala 31:41]
  wire  issue_io_enable; // @[HikelCore.scala 31:41]
  wire  issue_io_clear; // @[HikelCore.scala 31:41]
  wire  issue_io_trap; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_regfile_read_0_addr; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_regfile_read_0_data; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_regfile_read_1_addr; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_regfile_read_1_data; // @[HikelCore.scala 31:41]
  wire [11:0] issue_io_csrfile_read_addr; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_csrfile_read_data; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_brcond_in0; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_brcond_in1; // @[HikelCore.scala 31:41]
  wire [31:0] issue_io_brcond_pc; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_brcond_imm; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_brcond_uop; // @[HikelCore.scala 31:41]
  wire  issue_io_brcond_sel; // @[HikelCore.scala 31:41]
  wire  issue_io_lsu_write; // @[HikelCore.scala 31:41]
  wire [31:0] issue_io_in_pc; // @[HikelCore.scala 31:41]
  wire  issue_io_in_excp; // @[HikelCore.scala 31:41]
  wire [3:0] issue_io_in_code; // @[HikelCore.scala 31:41]
  wire  issue_io_in_valid; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_in_rs1_addr; // @[HikelCore.scala 31:41]
  wire  issue_io_in_rs1_use; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_in_rs2_addr; // @[HikelCore.scala 31:41]
  wire  issue_io_in_rs2_use; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_in_imm; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_in_uop; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_in_rd_addr; // @[HikelCore.scala 31:41]
  wire [11:0] issue_io_in_csr_addr; // @[HikelCore.scala 31:41]
  wire  issue_io_in_rd_wen; // @[HikelCore.scala 31:41]
  wire  issue_io_in_csr_use; // @[HikelCore.scala 31:41]
  wire  issue_io_in_lsu_use; // @[HikelCore.scala 31:41]
  wire  issue_io_in_jb_use; // @[HikelCore.scala 31:41]
  wire  issue_io_in_mret; // @[HikelCore.scala 31:41]
  wire [31:0] issue_io_out_pc; // @[HikelCore.scala 31:41]
  wire  issue_io_out_excp; // @[HikelCore.scala 31:41]
  wire [3:0] issue_io_out_code; // @[HikelCore.scala 31:41]
  wire  issue_io_out_valid; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_out_rs1_data; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_out_rs2_data; // @[HikelCore.scala 31:41]
  wire [63:0] issue_io_out_imm; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_out_uop; // @[HikelCore.scala 31:41]
  wire [4:0] issue_io_out_rd_addr; // @[HikelCore.scala 31:41]
  wire [11:0] issue_io_out_csr_addr; // @[HikelCore.scala 31:41]
  wire  issue_io_out_rd_wen; // @[HikelCore.scala 31:41]
  wire  issue_io_out_csr_use; // @[HikelCore.scala 31:41]
  wire  issue_io_out_lsu_use; // @[HikelCore.scala 31:41]
  wire  issue_io_out_mret; // @[HikelCore.scala 31:41]
  wire [11:0] issue_commit_csr_addr; // @[HikelCore.scala 31:41]
  wire [63:0] issue_commit_rd_data_0; // @[HikelCore.scala 31:41]
  wire  issue_commit_csr_use; // @[HikelCore.scala 31:41]
  wire [63:0] issue_exec_rd_data_0; // @[HikelCore.scala 31:41]
  wire  issue_exec_csr_use; // @[HikelCore.scala 31:41]
  wire  issue_commit_rd_wen_0; // @[HikelCore.scala 31:41]
  wire [11:0] issue_exec_csr_addr; // @[HikelCore.scala 31:41]
  wire  issue_exec_rd_wen_0; // @[HikelCore.scala 31:41]
  wire [63:0] issue_commit_csr_data; // @[HikelCore.scala 31:41]
  wire [63:0] issue_exec_csr_data; // @[HikelCore.scala 31:41]
  wire [4:0] issue_commit_rd_addr_0; // @[HikelCore.scala 31:41]
  wire [4:0] issue_exec_rd_addr_0; // @[HikelCore.scala 31:41]
  wire  execute_clock; // @[HikelCore.scala 32:33]
  wire  execute_reset; // @[HikelCore.scala 32:33]
  wire  execute_io__enable; // @[HikelCore.scala 32:33]
  wire  execute_io__clear; // @[HikelCore.scala 32:33]
  wire  execute_io__trap; // @[HikelCore.scala 32:33]
  wire [4:0] execute_io__alu_in_op; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__alu_in_in0; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__alu_in_in1; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__alu_res; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__dread_bits_addr; // @[HikelCore.scala 32:33]
  wire [2:0] execute_io__dread_bits_op; // @[HikelCore.scala 32:33]
  wire  execute_io__dread_bits_excp; // @[HikelCore.scala 32:33]
  wire  execute_io__dread_bits_misalign; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__dread_bits_data; // @[HikelCore.scala 32:33]
  wire  execute_io__dread_valid; // @[HikelCore.scala 32:33]
  wire  execute_io__dread_ready; // @[HikelCore.scala 32:33]
  wire  execute_io__hshake; // @[HikelCore.scala 32:33]
  wire  execute_io__lsu_write; // @[HikelCore.scala 32:33]
  wire [31:0] execute_io__in_pc; // @[HikelCore.scala 32:33]
  wire  execute_io__in_excp; // @[HikelCore.scala 32:33]
  wire [3:0] execute_io__in_code; // @[HikelCore.scala 32:33]
  wire  execute_io__in_valid; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__in_rs1_data; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__in_rs2_data; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__in_imm; // @[HikelCore.scala 32:33]
  wire [4:0] execute_io__in_uop; // @[HikelCore.scala 32:33]
  wire [4:0] execute_io__in_rd_addr; // @[HikelCore.scala 32:33]
  wire [11:0] execute_io__in_csr_addr; // @[HikelCore.scala 32:33]
  wire  execute_io__in_rd_wen; // @[HikelCore.scala 32:33]
  wire  execute_io__in_csr_use; // @[HikelCore.scala 32:33]
  wire  execute_io__in_lsu_use; // @[HikelCore.scala 32:33]
  wire  execute_io__in_mret; // @[HikelCore.scala 32:33]
  wire [31:0] execute_io__out_pc; // @[HikelCore.scala 32:33]
  wire  execute_io__out_excp; // @[HikelCore.scala 32:33]
  wire [3:0] execute_io__out_code; // @[HikelCore.scala 32:33]
  wire  execute_io__out_valid; // @[HikelCore.scala 32:33]
  wire [4:0] execute_io__out_rd_addr; // @[HikelCore.scala 32:33]
  wire [11:0] execute_io__out_csr_addr; // @[HikelCore.scala 32:33]
  wire  execute_io__out_rd_wen; // @[HikelCore.scala 32:33]
  wire  execute_io__out_csr_use; // @[HikelCore.scala 32:33]
  wire  execute_io__out_lsu_use; // @[HikelCore.scala 32:33]
  wire [2:0] execute_io__out_lsu_op; // @[HikelCore.scala 32:33]
  wire  execute_io__out_mret; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__out_data1; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io__out_data2; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io_out_data1; // @[HikelCore.scala 32:33]
  wire  execute_io_out_csr_use; // @[HikelCore.scala 32:33]
  wire [11:0] execute_io_out_csr_addr; // @[HikelCore.scala 32:33]
  wire  execute_io_out_rd_wen; // @[HikelCore.scala 32:33]
  wire [63:0] execute_io_out_data2; // @[HikelCore.scala 32:33]
  wire [4:0] execute_io_out_rd_addr; // @[HikelCore.scala 32:33]
  wire  commit_clock; // @[HikelCore.scala 33:41]
  wire  commit_reset; // @[HikelCore.scala 33:41]
  wire  commit_io__enable; // @[HikelCore.scala 33:41]
  wire  commit_io__clear; // @[HikelCore.scala 33:41]
  wire  commit_io__trap; // @[HikelCore.scala 33:41]
  wire [4:0] commit_io__regfile_write_rd_addr; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io__regfile_write_rd_data; // @[HikelCore.scala 33:41]
  wire  commit_io__regfile_write_rd_wen; // @[HikelCore.scala 33:41]
  wire [11:0] commit_io__csrfile_write_addr; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io__csrfile_write_data; // @[HikelCore.scala 33:41]
  wire  commit_io__csrfile_write_wen; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io__dwrite_bits_addr; // @[HikelCore.scala 33:41]
  wire [2:0] commit_io__dwrite_bits_op; // @[HikelCore.scala 33:41]
  wire  commit_io__dwrite_bits_excp; // @[HikelCore.scala 33:41]
  wire  commit_io__dwrite_bits_misalign; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io__dwrite_bits_data; // @[HikelCore.scala 33:41]
  wire  commit_io__dwrite_valid; // @[HikelCore.scala 33:41]
  wire  commit_io__dwrite_ready; // @[HikelCore.scala 33:41]
  wire  commit_io__mret; // @[HikelCore.scala 33:41]
  wire  commit_io__hshake; // @[HikelCore.scala 33:41]
  wire  commit_io__lsu_write; // @[HikelCore.scala 33:41]
  wire [31:0] commit_io__in_pc; // @[HikelCore.scala 33:41]
  wire  commit_io__in_excp; // @[HikelCore.scala 33:41]
  wire [3:0] commit_io__in_code; // @[HikelCore.scala 33:41]
  wire  commit_io__in_valid; // @[HikelCore.scala 33:41]
  wire [4:0] commit_io__in_rd_addr; // @[HikelCore.scala 33:41]
  wire [11:0] commit_io__in_csr_addr; // @[HikelCore.scala 33:41]
  wire  commit_io__in_rd_wen; // @[HikelCore.scala 33:41]
  wire  commit_io__in_csr_use; // @[HikelCore.scala 33:41]
  wire  commit_io__in_lsu_use; // @[HikelCore.scala 33:41]
  wire [2:0] commit_io__in_lsu_op; // @[HikelCore.scala 33:41]
  wire  commit_io__in_mret; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io__in_data1; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io__in_data2; // @[HikelCore.scala 33:41]
  wire [31:0] commit_io__out_pc; // @[HikelCore.scala 33:41]
  wire  commit_io__out_excp; // @[HikelCore.scala 33:41]
  wire [3:0] commit_io__out_code; // @[HikelCore.scala 33:41]
  wire  commit_io__out_valid; // @[HikelCore.scala 33:41]
  wire [11:0] commit_io_csrfile_write_addr; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io_regfile_write_rd_data; // @[HikelCore.scala 33:41]
  wire  commit_io_csrfile_write_wen; // @[HikelCore.scala 33:41]
  wire  commit_io_regfile_write_rd_wen; // @[HikelCore.scala 33:41]
  wire [63:0] commit_io_csrfile_write_data; // @[HikelCore.scala 33:41]
  wire [4:0] commit_io_regfile_write_rd_addr; // @[HikelCore.scala 33:41]
  wire  commit_minstret_en_0; // @[HikelCore.scala 33:41]
  wire  commit_io_mret; // @[HikelCore.scala 33:41]
  wire [31:0] commit_io_out_pc; // @[HikelCore.scala 33:41]
  wire [63:0] fetch_io_change_pc_brcond_io_in_in0; // @[HikelCore.scala 62:41]
  wire [63:0] fetch_io_change_pc_brcond_io_in_in1; // @[HikelCore.scala 62:41]
  wire [31:0] fetch_io_change_pc_brcond_io_in_pc; // @[HikelCore.scala 62:41]
  wire [63:0] fetch_io_change_pc_brcond_io_in_imm; // @[HikelCore.scala 62:41]
  wire [4:0] fetch_io_change_pc_brcond_io_in_uop; // @[HikelCore.scala 62:41]
  wire  fetch_io_change_pc_brcond_io_in_sel; // @[HikelCore.scala 62:41]
  wire  fetch_io_change_pc_brcond_io_change_pc; // @[HikelCore.scala 62:41]
  wire [31:0] fetch_io_change_pc_brcond_io_new_pc; // @[HikelCore.scala 62:41]
  wire  regfile_clock; // @[HikelCore.scala 60:42]
  wire [4:0] regfile_io_read_0_addr; // @[HikelCore.scala 60:42]
  wire [63:0] regfile_io_read_0_data; // @[HikelCore.scala 60:42]
  wire [4:0] regfile_io_read_1_addr; // @[HikelCore.scala 60:42]
  wire [63:0] regfile_io_read_1_data; // @[HikelCore.scala 60:42]
  wire [4:0] regfile_io_write_rd_addr; // @[HikelCore.scala 60:42]
  wire [63:0] regfile_io_write_rd_data; // @[HikelCore.scala 60:42]
  wire  regfile_io_write_rd_wen; // @[HikelCore.scala 60:42]
  wire [4:0] alu_io_in_op; // @[HikelCore.scala 66:25]
  wire [63:0] alu_io_in_in0; // @[HikelCore.scala 66:25]
  wire [63:0] alu_io_in_in1; // @[HikelCore.scala 66:25]
  wire [63:0] alu_io_res; // @[HikelCore.scala 66:25]
  wire  trapctrl_io__excp_do_excp; // @[HikelCore.scala 127:35]
  wire [3:0] trapctrl_io__excp_code; // @[HikelCore.scala 127:35]
  wire  trapctrl_io__do_trap; // @[HikelCore.scala 127:35]
  wire  trapctrl_io__inst_done; // @[HikelCore.scala 127:35]
  wire [63:0] trapctrl_mip_0; // @[HikelCore.scala 127:35]
  wire  trapctrl_io_do_trap; // @[HikelCore.scala 127:35]
  wire  trapctrl_mcause_int_0; // @[HikelCore.scala 127:35]
  wire [63:0] trapctrl_mstatus_0; // @[HikelCore.scala 127:35]
  wire [3:0] trapctrl_mcause_code_0; // @[HikelCore.scala 127:35]
  wire [63:0] trapctrl_mie_0; // @[HikelCore.scala 127:35]
  wire  csrfile_clock; // @[HikelCore.scala 110:37]
  wire  csrfile_reset; // @[HikelCore.scala 110:37]
  wire [11:0] csrfile_io_read_addr; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_io_read_data; // @[HikelCore.scala 110:37]
  wire [11:0] csrfile_io_write_addr; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_io_write_data; // @[HikelCore.scala 110:37]
  wire  csrfile_io_write_wen; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_mip_0; // @[HikelCore.scala 110:37]
  wire  csrfile_io_int_extern; // @[HikelCore.scala 110:37]
  wire  csrfile_io_do_trap; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_mepc_0; // @[HikelCore.scala 110:37]
  wire  csrfile_mcause_int; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_mstatus_0; // @[HikelCore.scala 110:37]
  wire  csrfile_io_int_soft; // @[HikelCore.scala 110:37]
  wire [3:0] csrfile_mcause_code; // @[HikelCore.scala 110:37]
  wire  csrfile_minstret_en; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_mtvec_0; // @[HikelCore.scala 110:37]
  wire  csrfile_io_int_timer; // @[HikelCore.scala 110:37]
  wire [63:0] csrfile_mie_0; // @[HikelCore.scala 110:37]
  wire  csrfile_io_mret; // @[HikelCore.scala 110:37]
  wire [31:0] csrfile_io_out_pc; // @[HikelCore.scala 110:37]
  wire  _lsu_write_T = decode_io_lsu_write | issue_io_lsu_write; // @[HikelCore.scala 116:42]
  wire  _lsu_write_T_1 = _lsu_write_T | execute_io__lsu_write; // @[HikelCore.scala 117:44]
  wire  fetch_io_enable_lsu_write = _lsu_write_T_1 | commit_io__lsu_write; // @[HikelCore.scala 118:46]
  wire  _decode_io_enable_T = execute_io__hshake & commit_io__hshake; // @[HikelCore.scala 82:47]
  ysyx_210727_Fetch fetch ( // @[HikelCore.scala 29:41]
    .clock(fetch_clock),
    .reset(fetch_reset),
    .io_enable(fetch_io_enable),
    .io_trap(fetch_io_trap),
    .io_iread_bits_addr(fetch_io_iread_bits_addr),
    .io_iread_bits_excp(fetch_io_iread_bits_excp),
    .io_iread_bits_misalign(fetch_io_iread_bits_misalign),
    .io_iread_bits_data(fetch_io_iread_bits_data),
    .io_iread_valid(fetch_io_iread_valid),
    .io_iread_ready(fetch_io_iread_ready),
    .io_hshake(fetch_io_hshake),
    .io_change_pc(fetch_io_change_pc),
    .io_new_pc(fetch_io_new_pc),
    .io_mret(fetch_io_mret),
    .io_out_pc(fetch_io_out_pc),
    .io_out_excp(fetch_io_out_excp),
    .io_out_code(fetch_io_out_code),
    .io_out_inst(fetch_io_out_inst),
    .mepc_0(fetch_mepc_0),
    .mtvec_0(fetch_mtvec_0)
  );
  ysyx_210727_Decode decode ( // @[HikelCore.scala 30:41]
    .clock(decode_clock),
    .reset(decode_reset),
    .io_enable(decode_io_enable),
    .io_clear(decode_io_clear),
    .io_trap(decode_io_trap),
    .io_lsu_write(decode_io_lsu_write),
    .io_in_pc(decode_io_in_pc),
    .io_in_excp(decode_io_in_excp),
    .io_in_code(decode_io_in_code),
    .io_in_inst(decode_io_in_inst),
    .io_out_pc(decode_io_out_pc),
    .io_out_excp(decode_io_out_excp),
    .io_out_code(decode_io_out_code),
    .io_out_valid(decode_io_out_valid),
    .io_out_inst(decode_io_out_inst),
    .io_out_rs1_addr(decode_io_out_rs1_addr),
    .io_out_rs1_use(decode_io_out_rs1_use),
    .io_out_rs2_addr(decode_io_out_rs2_addr),
    .io_out_rs2_use(decode_io_out_rs2_use),
    .io_out_imm(decode_io_out_imm),
    .io_out_uop(decode_io_out_uop),
    .io_out_rd_addr(decode_io_out_rd_addr),
    .io_out_csr_addr(decode_io_out_csr_addr),
    .io_out_rd_wen(decode_io_out_rd_wen),
    .io_out_csr_use(decode_io_out_csr_use),
    .io_out_lsu_use(decode_io_out_lsu_use),
    .io_out_jb_use(decode_io_out_jb_use),
    .io_out_mret(decode_io_out_mret)
  );
  ysyx_210727_Issue issue ( // @[HikelCore.scala 31:41]
    .clock(issue_clock),
    .reset(issue_reset),
    .io_enable(issue_io_enable),
    .io_clear(issue_io_clear),
    .io_trap(issue_io_trap),
    .io_regfile_read_0_addr(issue_io_regfile_read_0_addr),
    .io_regfile_read_0_data(issue_io_regfile_read_0_data),
    .io_regfile_read_1_addr(issue_io_regfile_read_1_addr),
    .io_regfile_read_1_data(issue_io_regfile_read_1_data),
    .io_csrfile_read_addr(issue_io_csrfile_read_addr),
    .io_csrfile_read_data(issue_io_csrfile_read_data),
    .io_brcond_in0(issue_io_brcond_in0),
    .io_brcond_in1(issue_io_brcond_in1),
    .io_brcond_pc(issue_io_brcond_pc),
    .io_brcond_imm(issue_io_brcond_imm),
    .io_brcond_uop(issue_io_brcond_uop),
    .io_brcond_sel(issue_io_brcond_sel),
    .io_lsu_write(issue_io_lsu_write),
    .io_in_pc(issue_io_in_pc),
    .io_in_excp(issue_io_in_excp),
    .io_in_code(issue_io_in_code),
    .io_in_valid(issue_io_in_valid),
    .io_in_rs1_addr(issue_io_in_rs1_addr),
    .io_in_rs1_use(issue_io_in_rs1_use),
    .io_in_rs2_addr(issue_io_in_rs2_addr),
    .io_in_rs2_use(issue_io_in_rs2_use),
    .io_in_imm(issue_io_in_imm),
    .io_in_uop(issue_io_in_uop),
    .io_in_rd_addr(issue_io_in_rd_addr),
    .io_in_csr_addr(issue_io_in_csr_addr),
    .io_in_rd_wen(issue_io_in_rd_wen),
    .io_in_csr_use(issue_io_in_csr_use),
    .io_in_lsu_use(issue_io_in_lsu_use),
    .io_in_jb_use(issue_io_in_jb_use),
    .io_in_mret(issue_io_in_mret),
    .io_out_pc(issue_io_out_pc),
    .io_out_excp(issue_io_out_excp),
    .io_out_code(issue_io_out_code),
    .io_out_valid(issue_io_out_valid),
    .io_out_rs1_data(issue_io_out_rs1_data),
    .io_out_rs2_data(issue_io_out_rs2_data),
    .io_out_imm(issue_io_out_imm),
    .io_out_uop(issue_io_out_uop),
    .io_out_rd_addr(issue_io_out_rd_addr),
    .io_out_csr_addr(issue_io_out_csr_addr),
    .io_out_rd_wen(issue_io_out_rd_wen),
    .io_out_csr_use(issue_io_out_csr_use),
    .io_out_lsu_use(issue_io_out_lsu_use),
    .io_out_mret(issue_io_out_mret),
    .commit_csr_addr(issue_commit_csr_addr),
    .commit_rd_data_0(issue_commit_rd_data_0),
    .commit_csr_use(issue_commit_csr_use),
    .exec_rd_data_0(issue_exec_rd_data_0),
    .exec_csr_use(issue_exec_csr_use),
    .commit_rd_wen_0(issue_commit_rd_wen_0),
    .exec_csr_addr(issue_exec_csr_addr),
    .exec_rd_wen_0(issue_exec_rd_wen_0),
    .commit_csr_data(issue_commit_csr_data),
    .exec_csr_data(issue_exec_csr_data),
    .commit_rd_addr_0(issue_commit_rd_addr_0),
    .exec_rd_addr_0(issue_exec_rd_addr_0)
  );
  ysyx_210727_Execute execute ( // @[HikelCore.scala 32:33]
    .clock(execute_clock),
    .reset(execute_reset),
    .io__enable(execute_io__enable),
    .io__clear(execute_io__clear),
    .io__trap(execute_io__trap),
    .io__alu_in_op(execute_io__alu_in_op),
    .io__alu_in_in0(execute_io__alu_in_in0),
    .io__alu_in_in1(execute_io__alu_in_in1),
    .io__alu_res(execute_io__alu_res),
    .io__dread_bits_addr(execute_io__dread_bits_addr),
    .io__dread_bits_op(execute_io__dread_bits_op),
    .io__dread_bits_excp(execute_io__dread_bits_excp),
    .io__dread_bits_misalign(execute_io__dread_bits_misalign),
    .io__dread_bits_data(execute_io__dread_bits_data),
    .io__dread_valid(execute_io__dread_valid),
    .io__dread_ready(execute_io__dread_ready),
    .io__hshake(execute_io__hshake),
    .io__lsu_write(execute_io__lsu_write),
    .io__in_pc(execute_io__in_pc),
    .io__in_excp(execute_io__in_excp),
    .io__in_code(execute_io__in_code),
    .io__in_valid(execute_io__in_valid),
    .io__in_rs1_data(execute_io__in_rs1_data),
    .io__in_rs2_data(execute_io__in_rs2_data),
    .io__in_imm(execute_io__in_imm),
    .io__in_uop(execute_io__in_uop),
    .io__in_rd_addr(execute_io__in_rd_addr),
    .io__in_csr_addr(execute_io__in_csr_addr),
    .io__in_rd_wen(execute_io__in_rd_wen),
    .io__in_csr_use(execute_io__in_csr_use),
    .io__in_lsu_use(execute_io__in_lsu_use),
    .io__in_mret(execute_io__in_mret),
    .io__out_pc(execute_io__out_pc),
    .io__out_excp(execute_io__out_excp),
    .io__out_code(execute_io__out_code),
    .io__out_valid(execute_io__out_valid),
    .io__out_rd_addr(execute_io__out_rd_addr),
    .io__out_csr_addr(execute_io__out_csr_addr),
    .io__out_rd_wen(execute_io__out_rd_wen),
    .io__out_csr_use(execute_io__out_csr_use),
    .io__out_lsu_use(execute_io__out_lsu_use),
    .io__out_lsu_op(execute_io__out_lsu_op),
    .io__out_mret(execute_io__out_mret),
    .io__out_data1(execute_io__out_data1),
    .io__out_data2(execute_io__out_data2),
    .io_out_data1(execute_io_out_data1),
    .io_out_csr_use(execute_io_out_csr_use),
    .io_out_csr_addr(execute_io_out_csr_addr),
    .io_out_rd_wen(execute_io_out_rd_wen),
    .io_out_data2(execute_io_out_data2),
    .io_out_rd_addr(execute_io_out_rd_addr)
  );
  ysyx_210727_Commit commit ( // @[HikelCore.scala 33:41]
    .clock(commit_clock),
    .reset(commit_reset),
    .io__enable(commit_io__enable),
    .io__clear(commit_io__clear),
    .io__trap(commit_io__trap),
    .io__regfile_write_rd_addr(commit_io__regfile_write_rd_addr),
    .io__regfile_write_rd_data(commit_io__regfile_write_rd_data),
    .io__regfile_write_rd_wen(commit_io__regfile_write_rd_wen),
    .io__csrfile_write_addr(commit_io__csrfile_write_addr),
    .io__csrfile_write_data(commit_io__csrfile_write_data),
    .io__csrfile_write_wen(commit_io__csrfile_write_wen),
    .io__dwrite_bits_addr(commit_io__dwrite_bits_addr),
    .io__dwrite_bits_op(commit_io__dwrite_bits_op),
    .io__dwrite_bits_excp(commit_io__dwrite_bits_excp),
    .io__dwrite_bits_misalign(commit_io__dwrite_bits_misalign),
    .io__dwrite_bits_data(commit_io__dwrite_bits_data),
    .io__dwrite_valid(commit_io__dwrite_valid),
    .io__dwrite_ready(commit_io__dwrite_ready),
    .io__mret(commit_io__mret),
    .io__hshake(commit_io__hshake),
    .io__lsu_write(commit_io__lsu_write),
    .io__in_pc(commit_io__in_pc),
    .io__in_excp(commit_io__in_excp),
    .io__in_code(commit_io__in_code),
    .io__in_valid(commit_io__in_valid),
    .io__in_rd_addr(commit_io__in_rd_addr),
    .io__in_csr_addr(commit_io__in_csr_addr),
    .io__in_rd_wen(commit_io__in_rd_wen),
    .io__in_csr_use(commit_io__in_csr_use),
    .io__in_lsu_use(commit_io__in_lsu_use),
    .io__in_lsu_op(commit_io__in_lsu_op),
    .io__in_mret(commit_io__in_mret),
    .io__in_data1(commit_io__in_data1),
    .io__in_data2(commit_io__in_data2),
    .io__out_pc(commit_io__out_pc),
    .io__out_excp(commit_io__out_excp),
    .io__out_code(commit_io__out_code),
    .io__out_valid(commit_io__out_valid),
    .io_csrfile_write_addr(commit_io_csrfile_write_addr),
    .io_regfile_write_rd_data(commit_io_regfile_write_rd_data),
    .io_csrfile_write_wen(commit_io_csrfile_write_wen),
    .io_regfile_write_rd_wen(commit_io_regfile_write_rd_wen),
    .io_csrfile_write_data(commit_io_csrfile_write_data),
    .io_regfile_write_rd_addr(commit_io_regfile_write_rd_addr),
    .minstret_en_0(commit_minstret_en_0),
    .io_mret(commit_io_mret),
    .io_out_pc(commit_io_out_pc)
  );
  ysyx_210727_BrCond fetch_io_change_pc_brcond ( // @[HikelCore.scala 62:41]
    .io_in_in0(fetch_io_change_pc_brcond_io_in_in0),
    .io_in_in1(fetch_io_change_pc_brcond_io_in_in1),
    .io_in_pc(fetch_io_change_pc_brcond_io_in_pc),
    .io_in_imm(fetch_io_change_pc_brcond_io_in_imm),
    .io_in_uop(fetch_io_change_pc_brcond_io_in_uop),
    .io_in_sel(fetch_io_change_pc_brcond_io_in_sel),
    .io_change_pc(fetch_io_change_pc_brcond_io_change_pc),
    .io_new_pc(fetch_io_change_pc_brcond_io_new_pc)
  );
  ysyx_210727_RegFile regfile ( // @[HikelCore.scala 60:42]
    .clock(regfile_clock),
    .io_read_0_addr(regfile_io_read_0_addr),
    .io_read_0_data(regfile_io_read_0_data),
    .io_read_1_addr(regfile_io_read_1_addr),
    .io_read_1_data(regfile_io_read_1_data),
    .io_write_rd_addr(regfile_io_write_rd_addr),
    .io_write_rd_data(regfile_io_write_rd_data),
    .io_write_rd_wen(regfile_io_write_rd_wen)
  );
  ysyx_210727_Alu alu ( // @[HikelCore.scala 66:25]
    .io_in_op(alu_io_in_op),
    .io_in_in0(alu_io_in_in0),
    .io_in_in1(alu_io_in_in1),
    .io_res(alu_io_res)
  );
  ysyx_210727_TrapCtrl trapctrl ( // @[HikelCore.scala 127:35]
    .io__excp_do_excp(trapctrl_io__excp_do_excp),
    .io__excp_code(trapctrl_io__excp_code),
    .io__do_trap(trapctrl_io__do_trap),
    .io__inst_done(trapctrl_io__inst_done),
    .mip_0(trapctrl_mip_0),
    .io_do_trap(trapctrl_io_do_trap),
    .mcause_int_0(trapctrl_mcause_int_0),
    .mstatus_0(trapctrl_mstatus_0),
    .mcause_code_0(trapctrl_mcause_code_0),
    .mie_0(trapctrl_mie_0)
  );
  ysyx_210727_CsrFile csrfile ( // @[HikelCore.scala 110:37]
    .clock(csrfile_clock),
    .reset(csrfile_reset),
    .io_read_addr(csrfile_io_read_addr),
    .io_read_data(csrfile_io_read_data),
    .io_write_addr(csrfile_io_write_addr),
    .io_write_data(csrfile_io_write_data),
    .io_write_wen(csrfile_io_write_wen),
    .mip_0(csrfile_mip_0),
    .io_int_extern(csrfile_io_int_extern),
    .io_do_trap(csrfile_io_do_trap),
    .mepc_0(csrfile_mepc_0),
    .mcause_int(csrfile_mcause_int),
    .mstatus_0(csrfile_mstatus_0),
    .io_int_soft(csrfile_io_int_soft),
    .mcause_code(csrfile_mcause_code),
    .minstret_en(csrfile_minstret_en),
    .mtvec_0(csrfile_mtvec_0),
    .io_int_timer(csrfile_io_int_timer),
    .mie_0(csrfile_mie_0),
    .io_mret(csrfile_io_mret),
    .io_out_pc(csrfile_io_out_pc)
  );
  assign io_iread_bits_addr = fetch_io_iread_bits_addr; // @[HikelCore.scala 50:24]
  assign io_dread_bits_addr = execute_io__dread_bits_addr; // @[HikelCore.scala 68:26]
  assign io_dread_bits_op = execute_io__dread_bits_op; // @[HikelCore.scala 68:26]
  assign io_dread_valid = execute_io__dread_valid; // @[HikelCore.scala 68:26]
  assign io_dwrite_bits_addr = commit_io__dwrite_bits_addr; // @[HikelCore.scala 72:26]
  assign io_dwrite_bits_op = commit_io__dwrite_bits_op; // @[HikelCore.scala 72:26]
  assign io_dwrite_bits_data = commit_io__dwrite_bits_data; // @[HikelCore.scala 72:26]
  assign io_dwrite_valid = commit_io__dwrite_valid; // @[HikelCore.scala 72:26]
  assign fetch_clock = clock;
  assign fetch_reset = reset;
  assign fetch_io_enable = fetch_io_hshake & execute_io__hshake & commit_io__hshake & ~fetch_io_enable_lsu_write; // @[HikelCore.scala 77:85]
  assign fetch_io_trap = trapctrl_io__do_trap; // @[HikelCore.scala 79:23]
  assign fetch_io_iread_bits_excp = io_iread_bits_excp; // @[HikelCore.scala 50:24]
  assign fetch_io_iread_bits_misalign = io_iread_bits_misalign; // @[HikelCore.scala 50:24]
  assign fetch_io_iread_bits_data = io_iread_bits_data; // @[HikelCore.scala 50:24]
  assign fetch_io_iread_ready = io_iread_ready; // @[HikelCore.scala 50:24]
  assign fetch_io_change_pc = fetch_io_change_pc_brcond_io_change_pc & issue_io_enable; // @[HikelCore.scala 52:64]
  assign fetch_io_new_pc = fetch_io_change_pc_brcond_io_new_pc; // @[HikelCore.scala 53:41]
  assign fetch_io_mret = commit_io__mret; // @[HikelCore.scala 55:41]
  assign fetch_mepc_0 = csrfile_mepc_0;
  assign fetch_mtvec_0 = csrfile_mtvec_0;
  assign decode_clock = clock;
  assign decode_reset = reset;
  assign decode_io_enable = execute_io__hshake & commit_io__hshake & fetch_io_hshake; // @[HikelCore.scala 82:67]
  assign decode_io_clear = fetch_io_change_pc_brcond_io_change_pc | fetch_io_enable_lsu_write; // @[HikelCore.scala 85:48]
  assign decode_io_trap = trapctrl_io__do_trap | commit_io__mret; // @[HikelCore.scala 86:47]
  assign decode_io_in_pc = fetch_io_out_pc; // @[HikelCore.scala 43:22]
  assign decode_io_in_excp = fetch_io_out_excp; // @[HikelCore.scala 43:22]
  assign decode_io_in_code = fetch_io_out_code; // @[HikelCore.scala 43:22]
  assign decode_io_in_inst = fetch_io_out_inst; // @[HikelCore.scala 43:22]
  assign issue_clock = clock;
  assign issue_reset = reset;
  assign issue_io_enable = _decode_io_enable_T & fetch_io_hshake; // @[HikelCore.scala 89:66]
  assign issue_io_clear = fetch_io_change_pc_brcond_io_change_pc; // @[HikelCore.scala 92:24]
  assign issue_io_trap = trapctrl_io__do_trap | commit_io__mret; // @[HikelCore.scala 93:46]
  assign issue_io_regfile_read_0_data = regfile_io_read_0_data; // @[HikelCore.scala 61:25]
  assign issue_io_regfile_read_1_data = regfile_io_read_1_data; // @[HikelCore.scala 61:25]
  assign issue_io_csrfile_read_data = csrfile_io_read_data; // @[HikelCore.scala 111:31]
  assign issue_io_in_pc = decode_io_out_pc; // @[HikelCore.scala 44:21]
  assign issue_io_in_excp = decode_io_out_excp; // @[HikelCore.scala 44:21]
  assign issue_io_in_code = decode_io_out_code; // @[HikelCore.scala 44:21]
  assign issue_io_in_valid = decode_io_out_valid; // @[HikelCore.scala 44:21]
  assign issue_io_in_rs1_addr = decode_io_out_rs1_addr; // @[HikelCore.scala 44:21]
  assign issue_io_in_rs1_use = decode_io_out_rs1_use; // @[HikelCore.scala 44:21]
  assign issue_io_in_rs2_addr = decode_io_out_rs2_addr; // @[HikelCore.scala 44:21]
  assign issue_io_in_rs2_use = decode_io_out_rs2_use; // @[HikelCore.scala 44:21]
  assign issue_io_in_imm = decode_io_out_imm; // @[HikelCore.scala 44:21]
  assign issue_io_in_uop = decode_io_out_uop; // @[HikelCore.scala 44:21]
  assign issue_io_in_rd_addr = decode_io_out_rd_addr; // @[HikelCore.scala 44:21]
  assign issue_io_in_csr_addr = decode_io_out_csr_addr; // @[HikelCore.scala 44:21]
  assign issue_io_in_rd_wen = decode_io_out_rd_wen; // @[HikelCore.scala 44:21]
  assign issue_io_in_csr_use = decode_io_out_csr_use; // @[HikelCore.scala 44:21]
  assign issue_io_in_lsu_use = decode_io_out_lsu_use; // @[HikelCore.scala 44:21]
  assign issue_io_in_jb_use = decode_io_out_jb_use; // @[HikelCore.scala 44:21]
  assign issue_io_in_mret = decode_io_out_mret; // @[HikelCore.scala 44:21]
  assign issue_commit_csr_addr = commit_io_csrfile_write_addr;
  assign issue_commit_rd_data_0 = commit_io_regfile_write_rd_data;
  assign issue_commit_csr_use = commit_io_csrfile_write_wen;
  assign issue_exec_rd_data_0 = execute_io_out_data1;
  assign issue_exec_csr_use = execute_io_out_csr_use;
  assign issue_commit_rd_wen_0 = commit_io_regfile_write_rd_wen;
  assign issue_exec_csr_addr = execute_io_out_csr_addr;
  assign issue_exec_rd_wen_0 = execute_io_out_rd_wen;
  assign issue_commit_csr_data = commit_io_csrfile_write_data;
  assign issue_exec_csr_data = execute_io_out_data2;
  assign issue_commit_rd_addr_0 = commit_io_regfile_write_rd_addr;
  assign issue_exec_rd_addr_0 = execute_io_out_rd_addr;
  assign execute_clock = clock;
  assign execute_reset = reset;
  assign execute_io__enable = execute_io__hshake & commit_io__hshake; // @[HikelCore.scala 96:48]
  assign execute_io__clear = ~fetch_io_hshake; // @[HikelCore.scala 99:29]
  assign execute_io__trap = trapctrl_io__do_trap | commit_io__mret; // @[HikelCore.scala 100:48]
  assign execute_io__alu_res = alu_io_res; // @[HikelCore.scala 67:16]
  assign execute_io__dread_bits_excp = io_dread_bits_excp; // @[HikelCore.scala 68:26]
  assign execute_io__dread_bits_misalign = io_dread_bits_misalign; // @[HikelCore.scala 68:26]
  assign execute_io__dread_bits_data = io_dread_bits_data; // @[HikelCore.scala 68:26]
  assign execute_io__dread_ready = io_dread_ready; // @[HikelCore.scala 68:26]
  assign execute_io__in_pc = issue_io_out_pc; // @[HikelCore.scala 45:23]
  assign execute_io__in_excp = issue_io_out_excp; // @[HikelCore.scala 45:23]
  assign execute_io__in_code = issue_io_out_code; // @[HikelCore.scala 45:23]
  assign execute_io__in_valid = issue_io_out_valid; // @[HikelCore.scala 45:23]
  assign execute_io__in_rs1_data = issue_io_out_rs1_data; // @[HikelCore.scala 45:23]
  assign execute_io__in_rs2_data = issue_io_out_rs2_data; // @[HikelCore.scala 45:23]
  assign execute_io__in_imm = issue_io_out_imm; // @[HikelCore.scala 45:23]
  assign execute_io__in_uop = issue_io_out_uop; // @[HikelCore.scala 45:23]
  assign execute_io__in_rd_addr = issue_io_out_rd_addr; // @[HikelCore.scala 45:23]
  assign execute_io__in_csr_addr = issue_io_out_csr_addr; // @[HikelCore.scala 45:23]
  assign execute_io__in_rd_wen = issue_io_out_rd_wen; // @[HikelCore.scala 45:23]
  assign execute_io__in_csr_use = issue_io_out_csr_use; // @[HikelCore.scala 45:23]
  assign execute_io__in_lsu_use = issue_io_out_lsu_use; // @[HikelCore.scala 45:23]
  assign execute_io__in_mret = issue_io_out_mret; // @[HikelCore.scala 45:23]
  assign commit_clock = clock;
  assign commit_reset = reset;
  assign commit_io__enable = commit_io__hshake; // @[HikelCore.scala 103:26]
  assign commit_io__clear = ~execute_io__hshake; // @[HikelCore.scala 106:28]
  assign commit_io__trap = trapctrl_io__do_trap | commit_io__mret; // @[HikelCore.scala 107:47]
  assign commit_io__dwrite_bits_excp = io_dwrite_bits_excp; // @[HikelCore.scala 72:26]
  assign commit_io__dwrite_bits_misalign = io_dwrite_bits_misalign; // @[HikelCore.scala 72:26]
  assign commit_io__dwrite_ready = io_dwrite_ready; // @[HikelCore.scala 72:26]
  assign commit_io__in_pc = execute_io__out_pc; // @[HikelCore.scala 46:22]
  assign commit_io__in_excp = execute_io__out_excp; // @[HikelCore.scala 46:22]
  assign commit_io__in_code = execute_io__out_code; // @[HikelCore.scala 46:22]
  assign commit_io__in_valid = execute_io__out_valid; // @[HikelCore.scala 46:22]
  assign commit_io__in_rd_addr = execute_io__out_rd_addr; // @[HikelCore.scala 46:22]
  assign commit_io__in_csr_addr = execute_io__out_csr_addr; // @[HikelCore.scala 46:22]
  assign commit_io__in_rd_wen = execute_io__out_rd_wen; // @[HikelCore.scala 46:22]
  assign commit_io__in_csr_use = execute_io__out_csr_use; // @[HikelCore.scala 46:22]
  assign commit_io__in_lsu_use = execute_io__out_lsu_use; // @[HikelCore.scala 46:22]
  assign commit_io__in_lsu_op = execute_io__out_lsu_op; // @[HikelCore.scala 46:22]
  assign commit_io__in_mret = execute_io__out_mret; // @[HikelCore.scala 46:22]
  assign commit_io__in_data1 = execute_io__out_data1; // @[HikelCore.scala 46:22]
  assign commit_io__in_data2 = execute_io__out_data2; // @[HikelCore.scala 46:22]
  assign fetch_io_change_pc_brcond_io_in_in0 = issue_io_brcond_in0; // @[HikelCore.scala 63:22]
  assign fetch_io_change_pc_brcond_io_in_in1 = issue_io_brcond_in1; // @[HikelCore.scala 63:22]
  assign fetch_io_change_pc_brcond_io_in_pc = issue_io_brcond_pc; // @[HikelCore.scala 63:22]
  assign fetch_io_change_pc_brcond_io_in_imm = issue_io_brcond_imm; // @[HikelCore.scala 63:22]
  assign fetch_io_change_pc_brcond_io_in_uop = issue_io_brcond_uop; // @[HikelCore.scala 63:22]
  assign fetch_io_change_pc_brcond_io_in_sel = issue_io_brcond_sel; // @[HikelCore.scala 63:22]
  assign regfile_clock = clock;
  assign regfile_io_read_0_addr = issue_io_regfile_read_0_addr; // @[HikelCore.scala 61:25]
  assign regfile_io_read_1_addr = issue_io_regfile_read_1_addr; // @[HikelCore.scala 61:25]
  assign regfile_io_write_rd_addr = commit_io__regfile_write_rd_addr; // @[HikelCore.scala 71:26]
  assign regfile_io_write_rd_data = commit_io__regfile_write_rd_data; // @[HikelCore.scala 71:26]
  assign regfile_io_write_rd_wen = commit_io__regfile_write_rd_wen; // @[HikelCore.scala 71:26]
  assign alu_io_in_op = execute_io__alu_in_op; // @[HikelCore.scala 67:16]
  assign alu_io_in_in0 = execute_io__alu_in_in0; // @[HikelCore.scala 67:16]
  assign alu_io_in_in1 = execute_io__alu_in_in1; // @[HikelCore.scala 67:16]
  assign trapctrl_io__excp_do_excp = commit_io__out_excp; // @[HikelCore.scala 128:41]
  assign trapctrl_io__excp_code = commit_io__out_code; // @[HikelCore.scala 129:41]
  assign trapctrl_io__inst_done = commit_io__out_valid & commit_io__hshake; // @[HikelCore.scala 130:64]
  assign trapctrl_mip_0 = csrfile_mip_0;
  assign trapctrl_mstatus_0 = csrfile_mstatus_0;
  assign trapctrl_mie_0 = csrfile_mie_0;
  assign csrfile_clock = clock;
  assign csrfile_reset = reset;
  assign csrfile_io_read_addr = issue_io_csrfile_read_addr; // @[HikelCore.scala 111:31]
  assign csrfile_io_write_addr = commit_io__csrfile_write_addr; // @[HikelCore.scala 112:33]
  assign csrfile_io_write_data = commit_io__csrfile_write_data; // @[HikelCore.scala 112:33]
  assign csrfile_io_write_wen = commit_io__csrfile_write_wen; // @[HikelCore.scala 112:33]
  assign csrfile_io_int_extern = io_int_extern;
  assign csrfile_io_do_trap = trapctrl_io_do_trap;
  assign csrfile_mcause_int = trapctrl_mcause_int_0;
  assign csrfile_io_int_soft = io_int_soft;
  assign csrfile_mcause_code = trapctrl_mcause_code_0;
  assign csrfile_minstret_en = commit_minstret_en_0;
  assign csrfile_io_int_timer = io_int_timer;
  assign csrfile_io_mret = commit_io_mret;
  assign csrfile_io_out_pc = commit_io_out_pc;
endmodule
module ysyx_210727_LsuReadArbiter(
  input  [63:0] io_iread_bits_addr,
  output        io_iread_bits_excp,
  output        io_iread_bits_misalign,
  output [63:0] io_iread_bits_data,
  output        io_iread_ready,
  input  [63:0] io_dread_bits_addr,
  input  [2:0]  io_dread_bits_op,
  output        io_dread_bits_excp,
  output        io_dread_bits_misalign,
  output [63:0] io_dread_bits_data,
  input         io_dread_valid,
  output        io_dread_ready,
  output [63:0] io_read_bits_addr,
  output [2:0]  io_read_bits_op,
  input         io_read_bits_excp,
  input         io_read_bits_misalign,
  input  [63:0] io_read_bits_data,
  input         io_read_ready
);
  assign io_iread_bits_excp = io_read_bits_excp; // @[Lsu.scala 164:49]
  assign io_iread_bits_misalign = io_read_bits_misalign; // @[Lsu.scala 160:32]
  assign io_iread_bits_data = io_read_bits_data; // @[Lsu.scala 157:33]
  assign io_iread_ready = ~io_dread_valid & io_read_ready; // @[Lsu.scala 149:32]
  assign io_dread_bits_excp = io_read_bits_excp & io_dread_valid; // @[Lsu.scala 163:49]
  assign io_dread_bits_misalign = io_read_bits_misalign; // @[Lsu.scala 159:32]
  assign io_dread_bits_data = io_read_bits_data; // @[Lsu.scala 156:33]
  assign io_dread_ready = io_read_ready; // @[Lsu.scala 148:24]
  assign io_read_bits_addr = io_dread_valid ? io_dread_bits_addr : io_iread_bits_addr; // @[Lsu.scala 151:33]
  assign io_read_bits_op = io_dread_valid ? io_dread_bits_op : 3'h2; // @[Lsu.scala 153:31]
endmodule
module ysyx_210727_Lsu(
  input  [63:0] io_iread_bits_addr,
  output        io_iread_bits_excp,
  output        io_iread_bits_misalign,
  output [63:0] io_iread_bits_data,
  output        io_iread_ready,
  input  [63:0] io_dread_bits_addr,
  input  [2:0]  io_dread_bits_op,
  output        io_dread_bits_excp,
  output        io_dread_bits_misalign,
  output [63:0] io_dread_bits_data,
  input         io_dread_valid,
  output        io_dread_ready,
  input  [63:0] io_dwrite_bits_addr,
  input  [2:0]  io_dwrite_bits_op,
  output        io_dwrite_bits_excp,
  output        io_dwrite_bits_misalign,
  input  [63:0] io_dwrite_bits_data,
  input         io_dwrite_valid,
  output        io_dwrite_ready,
  output [31:0] io_clint_read_bits_addr,
  input  [63:0] io_clint_read_bits_rdata,
  output [2:0]  io_clint_read_bits_op,
  output [31:0] io_clint_write_bits_addr,
  output [63:0] io_clint_write_bits_wdata,
  output [7:0]  io_clint_write_bits_wstrb,
  output        io_clint_write_valid,
  output [31:0] io_axi_read_bits_addr,
  input  [63:0] io_axi_read_bits_rdata,
  output [2:0]  io_axi_read_bits_op,
  input         io_axi_read_bits_excp,
  output        io_axi_read_valid,
  input         io_axi_read_ready,
  output [31:0] io_axi_write_bits_addr,
  output [63:0] io_axi_write_bits_wdata,
  output [7:0]  io_axi_write_bits_wstrb,
  output [2:0]  io_axi_write_bits_op,
  input         io_axi_write_bits_excp,
  output        io_axi_write_valid,
  input         io_axi_write_ready
);
  wire [63:0] arbiter_io_iread_bits_addr; // @[Lsu.scala 195:37]
  wire  arbiter_io_iread_bits_excp; // @[Lsu.scala 195:37]
  wire  arbiter_io_iread_bits_misalign; // @[Lsu.scala 195:37]
  wire [63:0] arbiter_io_iread_bits_data; // @[Lsu.scala 195:37]
  wire  arbiter_io_iread_ready; // @[Lsu.scala 195:37]
  wire [63:0] arbiter_io_dread_bits_addr; // @[Lsu.scala 195:37]
  wire [2:0] arbiter_io_dread_bits_op; // @[Lsu.scala 195:37]
  wire  arbiter_io_dread_bits_excp; // @[Lsu.scala 195:37]
  wire  arbiter_io_dread_bits_misalign; // @[Lsu.scala 195:37]
  wire [63:0] arbiter_io_dread_bits_data; // @[Lsu.scala 195:37]
  wire  arbiter_io_dread_valid; // @[Lsu.scala 195:37]
  wire  arbiter_io_dread_ready; // @[Lsu.scala 195:37]
  wire [63:0] arbiter_io_read_bits_addr; // @[Lsu.scala 195:37]
  wire [2:0] arbiter_io_read_bits_op; // @[Lsu.scala 195:37]
  wire  arbiter_io_read_bits_excp; // @[Lsu.scala 195:37]
  wire  arbiter_io_read_bits_misalign; // @[Lsu.scala 195:37]
  wire [63:0] arbiter_io_read_bits_data; // @[Lsu.scala 195:37]
  wire  arbiter_io_read_ready; // @[Lsu.scala 195:37]
  wire [2:0] read_bits_op = arbiter_io_read_bits_op; // @[Lsu.scala 193:24 Lsu.scala 198:22]
  wire [63:0] read_bits_addr = arbiter_io_read_bits_addr; // @[Lsu.scala 193:24 Lsu.scala 198:22]
  wire  _read_bits_misalign_T_4 = 2'h0 != read_bits_addr[1:0]; // @[Lsu.scala 92:41]
  wire  _read_bits_misalign_T_6 = 3'h0 != read_bits_addr[2:0]; // @[Lsu.scala 93:41]
  wire  _read_bits_misalign_T_10 = 2'h2 == read_bits_op[1:0] ? _read_bits_misalign_T_4 : 2'h1 == read_bits_op[1:0] &
    read_bits_addr[0]; // @[Mux.scala 80:57]
  wire  read_bits_misalign = 2'h3 == read_bits_op[1:0] ? _read_bits_misalign_T_6 : _read_bits_misalign_T_10; // @[Mux.scala 80:57]
  wire  _io_dwrite_bits_misalign_T_4 = 2'h0 != io_dwrite_bits_addr[1:0]; // @[Lsu.scala 92:41]
  wire  _io_dwrite_bits_misalign_T_6 = 3'h0 != io_dwrite_bits_addr[2:0]; // @[Lsu.scala 93:41]
  wire  _io_dwrite_bits_misalign_T_10 = 2'h2 == io_dwrite_bits_op[1:0] ? _io_dwrite_bits_misalign_T_4 : 2'h1 ==
    io_dwrite_bits_op[1:0] & io_dwrite_bits_addr[0]; // @[Mux.scala 80:57]
  wire  _io_dwrite_bits_misalign_T_12 = 2'h3 == io_dwrite_bits_op[1:0] ? _io_dwrite_bits_misalign_T_6 :
    _io_dwrite_bits_misalign_T_10; // @[Mux.scala 80:57]
  wire  ren = ~read_bits_misalign; // @[Lsu.scala 213:19]
  wire  _ren_clint_T_1 = 16'h200 == read_bits_addr[31:16]; // @[MemLayout.scala 14:38]
  wire  ren_clint = ren & _ren_clint_T_1; // @[Lsu.scala 214:29]
  wire  _ren_axi_T_2 = ~_ren_clint_T_1; // @[MemLayout.scala 18:17]
  wire  read_bits_data_signed = ~io_clint_read_bits_op[2]; // @[Lsu.scala 26:30]
  wire [1:0] read_bits_data_width = io_clint_read_bits_op[1:0]; // @[Lsu.scala 27:31]
  wire [2:0] read_bits_data_base = io_clint_read_bits_addr[2:0]; // @[Lsu.scala 28:32]
  wire [63:0] _read_bits_data_tmp_T_8 = 3'h1 == read_bits_data_base ? {{8'd0}, io_clint_read_bits_rdata[63:8]} :
    io_clint_read_bits_rdata; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_10 = 3'h2 == read_bits_data_base ? {{16'd0}, io_clint_read_bits_rdata[63:16]} :
    _read_bits_data_tmp_T_8; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_12 = 3'h3 == read_bits_data_base ? {{24'd0}, io_clint_read_bits_rdata[63:24]} :
    _read_bits_data_tmp_T_10; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_14 = 3'h4 == read_bits_data_base ? {{32'd0}, io_clint_read_bits_rdata[63:32]} :
    _read_bits_data_tmp_T_12; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_16 = 3'h5 == read_bits_data_base ? {{40'd0}, io_clint_read_bits_rdata[63:40]} :
    _read_bits_data_tmp_T_14; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_18 = 3'h6 == read_bits_data_base ? {{48'd0}, io_clint_read_bits_rdata[63:48]} :
    _read_bits_data_tmp_T_16; // @[Mux.scala 80:57]
  wire [63:0] read_bits_data_tmp = 3'h7 == read_bits_data_base ? {{56'd0}, io_clint_read_bits_rdata[63:56]} :
    _read_bits_data_tmp_T_18; // @[Mux.scala 80:57]
  wire  _read_bits_data_T_1 = read_bits_data_tmp[7] & read_bits_data_signed; // @[Lsu.scala 44:63]
  wire [55:0] read_bits_data_hi = _read_bits_data_T_1 ? 56'hffffffffffffff : 56'h0; // @[Bitwise.scala 72:12]
  wire [7:0] read_bits_data_lo = read_bits_data_tmp[7:0]; // @[Lsu.scala 44:77]
  wire [63:0] _read_bits_data_T_3 = {read_bits_data_hi,read_bits_data_lo}; // @[Cat.scala 30:58]
  wire  _read_bits_data_T_5 = read_bits_data_tmp[15] & read_bits_data_signed; // @[Lsu.scala 45:65]
  wire [47:0] read_bits_data_hi_1 = _read_bits_data_T_5 ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 72:12]
  wire [15:0] read_bits_data_lo_1 = read_bits_data_tmp[15:0]; // @[Lsu.scala 45:79]
  wire [63:0] _read_bits_data_T_7 = {read_bits_data_hi_1,read_bits_data_lo_1}; // @[Cat.scala 30:58]
  wire  _read_bits_data_T_9 = read_bits_data_tmp[31] & read_bits_data_signed; // @[Lsu.scala 46:65]
  wire [31:0] read_bits_data_hi_2 = _read_bits_data_T_9 ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] read_bits_data_lo_2 = read_bits_data_tmp[31:0]; // @[Lsu.scala 46:79]
  wire [63:0] _read_bits_data_T_11 = {read_bits_data_hi_2,read_bits_data_lo_2}; // @[Cat.scala 30:58]
  wire [63:0] _read_bits_data_T_13 = 2'h1 == read_bits_data_width ? _read_bits_data_T_7 : _read_bits_data_T_3; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_T_15 = 2'h2 == read_bits_data_width ? _read_bits_data_T_11 : _read_bits_data_T_13; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_T_17 = 2'h3 == read_bits_data_width ? read_bits_data_tmp : _read_bits_data_T_15; // @[Mux.scala 80:57]
  wire  read_bits_data_signed_1 = ~io_axi_read_bits_op[2]; // @[Lsu.scala 26:30]
  wire [1:0] read_bits_data_width_1 = io_axi_read_bits_op[1:0]; // @[Lsu.scala 27:31]
  wire [2:0] read_bits_data_base_1 = io_axi_read_bits_addr[2:0]; // @[Lsu.scala 28:32]
  wire [63:0] _read_bits_data_tmp_T_29 = 3'h1 == read_bits_data_base_1 ? {{8'd0}, io_axi_read_bits_rdata[63:8]} :
    io_axi_read_bits_rdata; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_31 = 3'h2 == read_bits_data_base_1 ? {{16'd0}, io_axi_read_bits_rdata[63:16]} :
    _read_bits_data_tmp_T_29; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_33 = 3'h3 == read_bits_data_base_1 ? {{24'd0}, io_axi_read_bits_rdata[63:24]} :
    _read_bits_data_tmp_T_31; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_35 = 3'h4 == read_bits_data_base_1 ? {{32'd0}, io_axi_read_bits_rdata[63:32]} :
    _read_bits_data_tmp_T_33; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_37 = 3'h5 == read_bits_data_base_1 ? {{40'd0}, io_axi_read_bits_rdata[63:40]} :
    _read_bits_data_tmp_T_35; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_tmp_T_39 = 3'h6 == read_bits_data_base_1 ? {{48'd0}, io_axi_read_bits_rdata[63:48]} :
    _read_bits_data_tmp_T_37; // @[Mux.scala 80:57]
  wire [63:0] read_bits_data_tmp_1 = 3'h7 == read_bits_data_base_1 ? {{56'd0}, io_axi_read_bits_rdata[63:56]} :
    _read_bits_data_tmp_T_39; // @[Mux.scala 80:57]
  wire  _read_bits_data_T_19 = read_bits_data_tmp_1[7] & read_bits_data_signed_1; // @[Lsu.scala 44:63]
  wire [55:0] read_bits_data_hi_3 = _read_bits_data_T_19 ? 56'hffffffffffffff : 56'h0; // @[Bitwise.scala 72:12]
  wire [7:0] read_bits_data_lo_3 = read_bits_data_tmp_1[7:0]; // @[Lsu.scala 44:77]
  wire [63:0] _read_bits_data_T_21 = {read_bits_data_hi_3,read_bits_data_lo_3}; // @[Cat.scala 30:58]
  wire  _read_bits_data_T_23 = read_bits_data_tmp_1[15] & read_bits_data_signed_1; // @[Lsu.scala 45:65]
  wire [47:0] read_bits_data_hi_4 = _read_bits_data_T_23 ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 72:12]
  wire [15:0] read_bits_data_lo_4 = read_bits_data_tmp_1[15:0]; // @[Lsu.scala 45:79]
  wire [63:0] _read_bits_data_T_25 = {read_bits_data_hi_4,read_bits_data_lo_4}; // @[Cat.scala 30:58]
  wire  _read_bits_data_T_27 = read_bits_data_tmp_1[31] & read_bits_data_signed_1; // @[Lsu.scala 46:65]
  wire [31:0] read_bits_data_hi_5 = _read_bits_data_T_27 ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] read_bits_data_lo_5 = read_bits_data_tmp_1[31:0]; // @[Lsu.scala 46:79]
  wire [63:0] _read_bits_data_T_29 = {read_bits_data_hi_5,read_bits_data_lo_5}; // @[Cat.scala 30:58]
  wire [63:0] _read_bits_data_T_31 = 2'h1 == read_bits_data_width_1 ? _read_bits_data_T_25 : _read_bits_data_T_21; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_T_33 = 2'h2 == read_bits_data_width_1 ? _read_bits_data_T_29 : _read_bits_data_T_31; // @[Mux.scala 80:57]
  wire [63:0] _read_bits_data_T_35 = 2'h3 == read_bits_data_width_1 ? read_bits_data_tmp_1 : _read_bits_data_T_33; // @[Mux.scala 80:57]
  wire  _read_bits_excp_T_13 = ren_clint ? 1'h0 : io_axi_read_bits_excp; // @[Lsu.scala 231:55]
  wire  wen = ~io_dwrite_bits_misalign & io_dwrite_valid; // @[Lsu.scala 235:40]
  wire  _wen_clint_T_1 = 16'h200 == io_dwrite_bits_addr[31:16]; // @[MemLayout.scala 14:38]
  wire  wen_clint = wen & _wen_clint_T_1; // @[Lsu.scala 236:29]
  wire  _wen_axi_T_2 = ~_wen_clint_T_1; // @[MemLayout.scala 18:17]
  wire [7:0] _io_clint_write_bits_wstrb_wstrb_tmp_T_2 = 2'h1 == io_dwrite_bits_op[1:0] ? 8'h3 : 8'h1; // @[Mux.scala 80:57]
  wire [7:0] _io_clint_write_bits_wstrb_wstrb_tmp_T_4 = 2'h2 == io_dwrite_bits_op[1:0] ? 8'hf :
    _io_clint_write_bits_wstrb_wstrb_tmp_T_2; // @[Mux.scala 80:57]
  wire [7:0] io_clint_write_bits_wstrb_wstrb_tmp = 2'h3 == io_dwrite_bits_op[1:0] ? 8'hff :
    _io_clint_write_bits_wstrb_wstrb_tmp_T_4; // @[Mux.scala 80:57]
  wire [14:0] _GEN_0 = {{7'd0}, io_clint_write_bits_wstrb_wstrb_tmp}; // @[Lsu.scala 115:29]
  wire [14:0] _io_clint_write_bits_wstrb_wstrb_T = _GEN_0 << io_dwrite_bits_addr[2:0]; // @[Lsu.scala 115:29]
  wire [71:0] _io_axi_write_bits_wdata_T = {io_dwrite_bits_data, 8'h0}; // @[Lsu.scala 126:43]
  wire [79:0] _io_axi_write_bits_wdata_T_1 = {io_dwrite_bits_data, 16'h0}; // @[Lsu.scala 127:43]
  wire [87:0] _io_axi_write_bits_wdata_T_2 = {io_dwrite_bits_data, 24'h0}; // @[Lsu.scala 128:43]
  wire [95:0] _io_axi_write_bits_wdata_T_3 = {io_dwrite_bits_data, 32'h0}; // @[Lsu.scala 129:43]
  wire [103:0] _io_axi_write_bits_wdata_T_4 = {io_dwrite_bits_data, 40'h0}; // @[Lsu.scala 130:43]
  wire [111:0] _io_axi_write_bits_wdata_T_5 = {io_dwrite_bits_data, 48'h0}; // @[Lsu.scala 131:43]
  wire [119:0] _io_axi_write_bits_wdata_T_6 = {io_dwrite_bits_data, 56'h0}; // @[Lsu.scala 132:43]
  wire [71:0] _io_axi_write_bits_wdata_T_8 = 3'h1 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T : {{8'd0},
    io_dwrite_bits_data}; // @[Mux.scala 80:57]
  wire [79:0] _io_axi_write_bits_wdata_T_10 = 3'h2 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T_1 : {{8
    'd0}, _io_axi_write_bits_wdata_T_8}; // @[Mux.scala 80:57]
  wire [87:0] _io_axi_write_bits_wdata_T_12 = 3'h3 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T_2 : {{8
    'd0}, _io_axi_write_bits_wdata_T_10}; // @[Mux.scala 80:57]
  wire [95:0] _io_axi_write_bits_wdata_T_14 = 3'h4 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T_3 : {{8
    'd0}, _io_axi_write_bits_wdata_T_12}; // @[Mux.scala 80:57]
  wire [103:0] _io_axi_write_bits_wdata_T_16 = 3'h5 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T_4 : {{8
    'd0}, _io_axi_write_bits_wdata_T_14}; // @[Mux.scala 80:57]
  wire [111:0] _io_axi_write_bits_wdata_T_18 = 3'h6 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T_5 : {{8
    'd0}, _io_axi_write_bits_wdata_T_16}; // @[Mux.scala 80:57]
  wire [119:0] _io_axi_write_bits_wdata_T_20 = 3'h7 == io_dwrite_bits_addr[2:0] ? _io_axi_write_bits_wdata_T_6 : {{8
    'd0}, _io_axi_write_bits_wdata_T_18}; // @[Mux.scala 80:57]
  wire  _io_dwrite_bits_excp_T_13 = wen_clint ? 1'h0 : io_axi_write_bits_excp; // @[Lsu.scala 255:57]
  wire  _io_dwrite_bits_excp_T_14 = _io_dwrite_bits_misalign_T_12 | _io_dwrite_bits_excp_T_13; // @[Lsu.scala 255:51]
  ysyx_210727_LsuReadArbiter arbiter ( // @[Lsu.scala 195:37]
    .io_iread_bits_addr(arbiter_io_iread_bits_addr),
    .io_iread_bits_excp(arbiter_io_iread_bits_excp),
    .io_iread_bits_misalign(arbiter_io_iread_bits_misalign),
    .io_iread_bits_data(arbiter_io_iread_bits_data),
    .io_iread_ready(arbiter_io_iread_ready),
    .io_dread_bits_addr(arbiter_io_dread_bits_addr),
    .io_dread_bits_op(arbiter_io_dread_bits_op),
    .io_dread_bits_excp(arbiter_io_dread_bits_excp),
    .io_dread_bits_misalign(arbiter_io_dread_bits_misalign),
    .io_dread_bits_data(arbiter_io_dread_bits_data),
    .io_dread_valid(arbiter_io_dread_valid),
    .io_dread_ready(arbiter_io_dread_ready),
    .io_read_bits_addr(arbiter_io_read_bits_addr),
    .io_read_bits_op(arbiter_io_read_bits_op),
    .io_read_bits_excp(arbiter_io_read_bits_excp),
    .io_read_bits_misalign(arbiter_io_read_bits_misalign),
    .io_read_bits_data(arbiter_io_read_bits_data),
    .io_read_ready(arbiter_io_read_ready)
  );
  assign io_iread_bits_excp = arbiter_io_iread_bits_excp; // @[Lsu.scala 196:34]
  assign io_iread_bits_misalign = arbiter_io_iread_bits_misalign; // @[Lsu.scala 196:34]
  assign io_iread_bits_data = arbiter_io_iread_bits_data; // @[Lsu.scala 196:34]
  assign io_iread_ready = arbiter_io_iread_ready; // @[Lsu.scala 196:34]
  assign io_dread_bits_excp = arbiter_io_dread_bits_excp; // @[Lsu.scala 197:34]
  assign io_dread_bits_misalign = arbiter_io_dread_bits_misalign; // @[Lsu.scala 197:34]
  assign io_dread_bits_data = arbiter_io_dread_bits_data; // @[Lsu.scala 197:34]
  assign io_dread_ready = arbiter_io_dread_ready; // @[Lsu.scala 197:34]
  assign io_dwrite_bits_excp = _io_dwrite_bits_excp_T_14 & io_dwrite_valid; // @[Lsu.scala 256:76]
  assign io_dwrite_bits_misalign = 2'h3 == io_dwrite_bits_op[1:0] ? _io_dwrite_bits_misalign_T_6 :
    _io_dwrite_bits_misalign_T_10; // @[Mux.scala 80:57]
  assign io_dwrite_ready = wen_clint | io_axi_write_ready; // @[Lsu.scala 254:27]
  assign io_clint_read_bits_addr = read_bits_addr[31:0]; // @[Lsu.scala 218:33]
  assign io_clint_read_bits_op = arbiter_io_read_bits_op; // @[Lsu.scala 193:24 Lsu.scala 198:22]
  assign io_clint_write_bits_addr = io_dwrite_bits_addr[31:0]; // @[Lsu.scala 240:34]
  assign io_clint_write_bits_wdata = io_dwrite_bits_data; // @[Lsu.scala 241:35]
  assign io_clint_write_bits_wstrb = _io_clint_write_bits_wstrb_wstrb_T[7:0]; // @[Lsu.scala 242:35]
  assign io_clint_write_valid = wen & _wen_clint_T_1; // @[Lsu.scala 236:29]
  assign io_axi_read_bits_addr = read_bits_addr[31:0]; // @[Lsu.scala 223:31]
  assign io_axi_read_bits_op = arbiter_io_read_bits_op; // @[Lsu.scala 193:24 Lsu.scala 198:22]
  assign io_axi_read_valid = ren & _ren_axi_T_2; // @[Lsu.scala 215:27]
  assign io_axi_write_bits_addr = io_dwrite_bits_addr[31:0]; // @[Lsu.scala 247:32]
  assign io_axi_write_bits_wdata = _io_axi_write_bits_wdata_T_20[63:0]; // @[Lsu.scala 248:33]
  assign io_axi_write_bits_wstrb = _io_clint_write_bits_wstrb_wstrb_T[7:0]; // @[Lsu.scala 249:33]
  assign io_axi_write_bits_op = io_dwrite_bits_op; // @[Lsu.scala 250:30]
  assign io_axi_write_valid = wen & _wen_axi_T_2; // @[Lsu.scala 237:27]
  assign arbiter_io_iread_bits_addr = io_iread_bits_addr; // @[Lsu.scala 196:34]
  assign arbiter_io_dread_bits_addr = io_dread_bits_addr; // @[Lsu.scala 197:34]
  assign arbiter_io_dread_bits_op = io_dread_bits_op; // @[Lsu.scala 197:34]
  assign arbiter_io_dread_valid = io_dread_valid; // @[Lsu.scala 197:34]
  assign arbiter_io_read_bits_excp = read_bits_misalign | _read_bits_excp_T_13; // @[Lsu.scala 231:49]
  assign arbiter_io_read_bits_misalign = 2'h3 == read_bits_op[1:0] ? _read_bits_misalign_T_6 : _read_bits_misalign_T_10; // @[Mux.scala 80:57]
  assign arbiter_io_read_bits_data = ren_clint ? _read_bits_data_T_17 : _read_bits_data_T_35; // @[Lsu.scala 229:30]
  assign arbiter_io_read_ready = ren_clint | io_axi_read_ready; // @[Lsu.scala 228:26]
endmodule
module ysyx_210727_Clint(
  input         clock,
  input         reset,
  input  [31:0] io_read_bits_addr,
  output [63:0] io_read_bits_rdata,
  input  [31:0] io_write_bits_addr,
  input  [63:0] io_write_bits_wdata,
  input  [7:0]  io_write_bits_wstrb,
  input         io_write_valid,
  output        io_do_timer_0
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] reg_mtimecmp_0; // @[Clint.scala 38:35]
  reg [63:0] reg_mtime; // @[Clint.scala 39:32]
  reg  reg_do_timer_0; // @[Clint.scala 40:35]
  wire [63:0] _reg_mtime_T_1 = reg_mtime + 64'h1; // @[Clint.scala 43:32]
  wire  _GEN_0 = reg_mtimecmp_0 == reg_mtime | reg_do_timer_0; // @[Clint.scala 45:54 Clint.scala 46:41 Clint.scala 40:35]
  wire [28:0] raddr = io_read_bits_addr[31:3]; // @[Clint.scala 63:39]
  wire  ren_mtimecmp_0 = raddr == 29'h400800; // @[Clint.scala 65:42]
  wire [63:0] _GEN_1 = ren_mtimecmp_0 ? reg_mtimecmp_0 : 64'h0; // @[Clint.scala 66:40 Clint.scala 67:44 Clint.scala 62:28]
  wire  ren_mtime = raddr == 29'h4017ff; // @[Clint.scala 70:28]
  wire [28:0] waddr = io_write_bits_addr[31:3]; // @[Clint.scala 80:40]
  wire  _wen_mtimecmp_0_T_2 = &io_write_bits_wstrb; // @[Clint.scala 83:53]
  wire  wen_mtimecmp_0 = io_write_valid & waddr == 29'h400800 & _wen_mtimecmp_0_T_2; // @[Clint.scala 82:80]
  assign io_read_bits_rdata = ren_mtime ? reg_mtime : _GEN_1; // @[Clint.scala 71:26 Clint.scala 72:36]
  assign io_do_timer_0 = reg_do_timer_0; // @[Clint.scala 53:33]
  always @(posedge clock) begin
    if (reset) begin // @[Clint.scala 38:35]
      reg_mtimecmp_0 <= 64'h0; // @[Clint.scala 38:35]
    end else if (wen_mtimecmp_0) begin // @[Clint.scala 84:40]
      reg_mtimecmp_0 <= io_write_bits_wdata; // @[Clint.scala 86:41]
    end
    if (reset) begin // @[Clint.scala 39:32]
      reg_mtime <= 64'h0; // @[Clint.scala 39:32]
    end else begin
      reg_mtime <= _reg_mtime_T_1; // @[Clint.scala 43:19]
    end
    if (reset) begin // @[Clint.scala 40:35]
      reg_do_timer_0 <= 1'h0; // @[Clint.scala 40:35]
    end else if (wen_mtimecmp_0) begin // @[Clint.scala 84:40]
      reg_do_timer_0 <= 1'h0; // @[Clint.scala 85:41]
    end else begin
      reg_do_timer_0 <= _GEN_0;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  reg_mtimecmp_0 = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  reg_mtime = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  reg_do_timer_0 = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_AxiRead(
  input         clock,
  input         reset,
  output [31:0] io_raddr_bits_araddr,
  output [2:0]  io_raddr_bits_arsize,
  output        io_raddr_valid,
  input         io_raddr_ready,
  input  [1:0]  io_rdata_bits_rresp,
  input  [63:0] io_rdata_bits_rdata,
  input         io_rdata_bits_rlast,
  input         io_rdata_valid,
  output        io_rdata_ready,
  input  [31:0] io_lsu_read_bits_addr,
  output [63:0] io_lsu_read_bits_rdata,
  input  [2:0]  io_lsu_read_bits_op,
  output        io_lsu_read_bits_excp,
  input         io_lsu_read_valid,
  output        io_lsu_read_ready
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_araddr; // @[AxiRead.scala 50:33]
  reg  reg_arvalid; // @[AxiRead.scala 51:34]
  reg  reg_rready; // @[AxiRead.scala 52:33]
  wire  _T_3 = io_raddr_valid & io_raddr_ready; // @[ReadyValid.scala 15:28]
  wire  _T_4 = io_rdata_valid & io_rdata_ready; // @[ReadyValid.scala 15:28]
  wire  _T_5 = _T_4 & io_rdata_bits_rlast; // @[AxiRead.scala 63:44]
  wire  _GEN_0 = _T_4 & io_rdata_bits_rlast ? 1'h0 : reg_rready; // @[AxiRead.scala 63:68 AxiRead.scala 64:36 AxiRead.scala 52:33]
  wire  _GEN_1 = _T_3 ? 1'h0 : reg_arvalid; // @[AxiRead.scala 59:45 AxiRead.scala 60:37 AxiRead.scala 51:34]
  wire  _GEN_2 = _T_3 | _GEN_0; // @[AxiRead.scala 59:45 AxiRead.scala 61:36]
  wire  _GEN_4 = ~(reg_arvalid | reg_rready) & io_lsu_read_valid | _GEN_1; // @[AxiRead.scala 54:74 AxiRead.scala 57:37]
  wire  _io_lsu_read_ready_T_2 = reg_araddr == io_lsu_read_bits_addr; // @[AxiRead.scala 72:36]
  assign io_raddr_bits_araddr = reg_araddr; // @[AxiRead.scala 75:33]
  assign io_raddr_bits_arsize = {{1'd0}, io_lsu_read_bits_op[1:0]}; // @[AxiRead.scala 86:60]
  assign io_raddr_valid = reg_arvalid; // @[AxiRead.scala 69:24]
  assign io_rdata_ready = reg_rready; // @[AxiRead.scala 70:24]
  assign io_lsu_read_bits_rdata = io_rdata_bits_rdata; // @[AxiRead.scala 90:32]
  assign io_lsu_read_bits_excp = 2'h0 != io_rdata_bits_rresp; // @[AxiRead.scala 91:48]
  assign io_lsu_read_ready = _T_5 & _io_lsu_read_ready_T_2; // @[AxiRead.scala 71:69]
  always @(posedge clock) begin
    if (reset) begin // @[AxiRead.scala 50:33]
      reg_araddr <= 32'h0; // @[AxiRead.scala 50:33]
    end else if (~(reg_arvalid | reg_rready) & io_lsu_read_valid) begin // @[AxiRead.scala 54:74]
      reg_araddr <= io_lsu_read_bits_addr; // @[AxiRead.scala 56:36]
    end
    if (reset) begin // @[AxiRead.scala 51:34]
      reg_arvalid <= 1'h0; // @[AxiRead.scala 51:34]
    end else begin
      reg_arvalid <= _GEN_4;
    end
    if (reset) begin // @[AxiRead.scala 52:33]
      reg_rready <= 1'h0; // @[AxiRead.scala 52:33]
    end else if (!(~(reg_arvalid | reg_rready) & io_lsu_read_valid)) begin // @[AxiRead.scala 54:74]
      reg_rready <= _GEN_2;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_araddr = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_arvalid = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  reg_rready = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_AxiWrite(
  input         clock,
  input         reset,
  output [31:0] io_waddr_bits_awaddr,
  output [2:0]  io_waddr_bits_awsize,
  output        io_waddr_valid,
  input         io_waddr_ready,
  output [63:0] io_wdata_bits_wdata,
  output [7:0]  io_wdata_bits_wstrb,
  output        io_wdata_valid,
  input         io_wdata_ready,
  input  [1:0]  io_wresp_bits_bresp,
  input         io_wresp_valid,
  output        io_wresp_ready,
  input  [31:0] io_lsu_write_bits_addr,
  input  [63:0] io_lsu_write_bits_wdata,
  input  [7:0]  io_lsu_write_bits_wstrb,
  input  [2:0]  io_lsu_write_bits_op,
  output        io_lsu_write_bits_excp,
  input         io_lsu_write_valid,
  output        io_lsu_write_ready
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  reg_aw_w_valid; // @[AxiWrite.scala 40:37]
  reg  reg_bready; // @[AxiWrite.scala 41:33]
  wire  _T_2 = ~(reg_aw_w_valid | reg_bready) & io_lsu_write_valid; // @[AxiWrite.scala 43:55]
  wire  _T_3 = io_waddr_valid & io_waddr_ready; // @[ReadyValid.scala 15:28]
  wire  _T_4 = io_wdata_valid & io_wdata_ready; // @[ReadyValid.scala 15:28]
  wire  _T_6 = io_wresp_valid & io_wresp_ready; // @[ReadyValid.scala 15:28]
  wire  _GEN_0 = _T_6 ? 1'h0 : reg_bready; // @[AxiWrite.scala 53:45 AxiWrite.scala 54:36 AxiWrite.scala 41:33]
  wire  _GEN_1 = _T_3 & _T_4 ? 1'h0 : reg_aw_w_valid; // @[AxiWrite.scala 49:64 AxiWrite.scala 50:40 AxiWrite.scala 40:37]
  wire  _GEN_2 = _T_3 & _T_4 | _GEN_0; // @[AxiWrite.scala 49:64 AxiWrite.scala 51:36]
  wire  _GEN_3 = _T_2 | _GEN_1; // @[AxiWrite.scala 45:17 AxiWrite.scala 46:40]
  assign io_waddr_bits_awaddr = io_lsu_write_bits_addr; // @[AxiWrite.scala 65:33]
  assign io_waddr_bits_awsize = {{1'd0}, io_lsu_write_bits_op[1:0]}; // @[AxiWrite.scala 76:61]
  assign io_waddr_valid = reg_aw_w_valid; // @[AxiWrite.scala 59:24]
  assign io_wdata_bits_wdata = io_lsu_write_bits_wdata; // @[AxiWrite.scala 80:29]
  assign io_wdata_bits_wstrb = io_lsu_write_bits_wstrb; // @[AxiWrite.scala 81:29]
  assign io_wdata_valid = reg_aw_w_valid; // @[AxiWrite.scala 60:24]
  assign io_wresp_ready = reg_bready; // @[AxiWrite.scala 61:24]
  assign io_lsu_write_bits_excp = 2'h0 != io_wresp_bits_bresp; // @[AxiWrite.scala 85:49]
  assign io_lsu_write_ready = io_wresp_valid & io_wresp_ready; // @[ReadyValid.scala 15:28]
  always @(posedge clock) begin
    if (reset) begin // @[AxiWrite.scala 40:37]
      reg_aw_w_valid <= 1'h0; // @[AxiWrite.scala 40:37]
    end else begin
      reg_aw_w_valid <= _GEN_3;
    end
    if (reset) begin // @[AxiWrite.scala 41:33]
      reg_bready <= 1'h0; // @[AxiWrite.scala 41:33]
    end else if (_T_2) begin // @[AxiWrite.scala 45:17]
      reg_bready <= 1'h0; // @[AxiWrite.scala 47:36]
    end else begin
      reg_bready <= _GEN_2;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_aw_w_valid = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  reg_bready = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_210727_AxiInterface(
  input         clock,
  input         reset,
  input  [31:0] io_read_bits_addr,
  output [63:0] io_read_bits_rdata,
  input  [2:0]  io_read_bits_op,
  output        io_read_bits_excp,
  input         io_read_valid,
  output        io_read_ready,
  input  [31:0] io_write_bits_addr,
  input  [63:0] io_write_bits_wdata,
  input  [7:0]  io_write_bits_wstrb,
  input  [2:0]  io_write_bits_op,
  output        io_write_bits_excp,
  input         io_write_valid,
  output        io_write_ready,
  output [31:0] io_axi_raddr_bits_araddr,
  output [2:0]  io_axi_raddr_bits_arsize,
  output        io_axi_raddr_valid,
  input         io_axi_raddr_ready,
  input  [1:0]  io_axi_rdata_bits_rresp,
  input  [63:0] io_axi_rdata_bits_rdata,
  input         io_axi_rdata_bits_rlast,
  input         io_axi_rdata_valid,
  output        io_axi_rdata_ready,
  output [31:0] io_axi_waddr_bits_awaddr,
  output [2:0]  io_axi_waddr_bits_awsize,
  output        io_axi_waddr_valid,
  input         io_axi_waddr_ready,
  output [63:0] io_axi_wdata_bits_wdata,
  output [7:0]  io_axi_wdata_bits_wstrb,
  output        io_axi_wdata_valid,
  input         io_axi_wdata_ready,
  input  [1:0]  io_axi_wresp_bits_bresp,
  input         io_axi_wresp_valid,
  output        io_axi_wresp_ready
);
  wire  axi_read_clock; // @[AxiInterface.scala 49:30]
  wire  axi_read_reset; // @[AxiInterface.scala 49:30]
  wire [31:0] axi_read_io_raddr_bits_araddr; // @[AxiInterface.scala 49:30]
  wire [2:0] axi_read_io_raddr_bits_arsize; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_raddr_valid; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_raddr_ready; // @[AxiInterface.scala 49:30]
  wire [1:0] axi_read_io_rdata_bits_rresp; // @[AxiInterface.scala 49:30]
  wire [63:0] axi_read_io_rdata_bits_rdata; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_rdata_bits_rlast; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_rdata_valid; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_rdata_ready; // @[AxiInterface.scala 49:30]
  wire [31:0] axi_read_io_lsu_read_bits_addr; // @[AxiInterface.scala 49:30]
  wire [63:0] axi_read_io_lsu_read_bits_rdata; // @[AxiInterface.scala 49:30]
  wire [2:0] axi_read_io_lsu_read_bits_op; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_lsu_read_bits_excp; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_lsu_read_valid; // @[AxiInterface.scala 49:30]
  wire  axi_read_io_lsu_read_ready; // @[AxiInterface.scala 49:30]
  wire  axi_write_clock; // @[AxiInterface.scala 56:31]
  wire  axi_write_reset; // @[AxiInterface.scala 56:31]
  wire [31:0] axi_write_io_waddr_bits_awaddr; // @[AxiInterface.scala 56:31]
  wire [2:0] axi_write_io_waddr_bits_awsize; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_waddr_valid; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_waddr_ready; // @[AxiInterface.scala 56:31]
  wire [63:0] axi_write_io_wdata_bits_wdata; // @[AxiInterface.scala 56:31]
  wire [7:0] axi_write_io_wdata_bits_wstrb; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_wdata_valid; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_wdata_ready; // @[AxiInterface.scala 56:31]
  wire [1:0] axi_write_io_wresp_bits_bresp; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_wresp_valid; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_wresp_ready; // @[AxiInterface.scala 56:31]
  wire [31:0] axi_write_io_lsu_write_bits_addr; // @[AxiInterface.scala 56:31]
  wire [63:0] axi_write_io_lsu_write_bits_wdata; // @[AxiInterface.scala 56:31]
  wire [7:0] axi_write_io_lsu_write_bits_wstrb; // @[AxiInterface.scala 56:31]
  wire [2:0] axi_write_io_lsu_write_bits_op; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_lsu_write_bits_excp; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_lsu_write_valid; // @[AxiInterface.scala 56:31]
  wire  axi_write_io_lsu_write_ready; // @[AxiInterface.scala 56:31]
  ysyx_210727_AxiRead axi_read ( // @[AxiInterface.scala 49:30]
    .clock(axi_read_clock),
    .reset(axi_read_reset),
    .io_raddr_bits_araddr(axi_read_io_raddr_bits_araddr),
    .io_raddr_bits_arsize(axi_read_io_raddr_bits_arsize),
    .io_raddr_valid(axi_read_io_raddr_valid),
    .io_raddr_ready(axi_read_io_raddr_ready),
    .io_rdata_bits_rresp(axi_read_io_rdata_bits_rresp),
    .io_rdata_bits_rdata(axi_read_io_rdata_bits_rdata),
    .io_rdata_bits_rlast(axi_read_io_rdata_bits_rlast),
    .io_rdata_valid(axi_read_io_rdata_valid),
    .io_rdata_ready(axi_read_io_rdata_ready),
    .io_lsu_read_bits_addr(axi_read_io_lsu_read_bits_addr),
    .io_lsu_read_bits_rdata(axi_read_io_lsu_read_bits_rdata),
    .io_lsu_read_bits_op(axi_read_io_lsu_read_bits_op),
    .io_lsu_read_bits_excp(axi_read_io_lsu_read_bits_excp),
    .io_lsu_read_valid(axi_read_io_lsu_read_valid),
    .io_lsu_read_ready(axi_read_io_lsu_read_ready)
  );
  ysyx_210727_AxiWrite axi_write ( // @[AxiInterface.scala 56:31]
    .clock(axi_write_clock),
    .reset(axi_write_reset),
    .io_waddr_bits_awaddr(axi_write_io_waddr_bits_awaddr),
    .io_waddr_bits_awsize(axi_write_io_waddr_bits_awsize),
    .io_waddr_valid(axi_write_io_waddr_valid),
    .io_waddr_ready(axi_write_io_waddr_ready),
    .io_wdata_bits_wdata(axi_write_io_wdata_bits_wdata),
    .io_wdata_bits_wstrb(axi_write_io_wdata_bits_wstrb),
    .io_wdata_valid(axi_write_io_wdata_valid),
    .io_wdata_ready(axi_write_io_wdata_ready),
    .io_wresp_bits_bresp(axi_write_io_wresp_bits_bresp),
    .io_wresp_valid(axi_write_io_wresp_valid),
    .io_wresp_ready(axi_write_io_wresp_ready),
    .io_lsu_write_bits_addr(axi_write_io_lsu_write_bits_addr),
    .io_lsu_write_bits_wdata(axi_write_io_lsu_write_bits_wdata),
    .io_lsu_write_bits_wstrb(axi_write_io_lsu_write_bits_wstrb),
    .io_lsu_write_bits_op(axi_write_io_lsu_write_bits_op),
    .io_lsu_write_bits_excp(axi_write_io_lsu_write_bits_excp),
    .io_lsu_write_valid(axi_write_io_lsu_write_valid),
    .io_lsu_write_ready(axi_write_io_lsu_write_ready)
  );
  assign io_read_bits_rdata = axi_read_io_lsu_read_bits_rdata; // @[AxiInterface.scala 51:17]
  assign io_read_bits_excp = axi_read_io_lsu_read_bits_excp; // @[AxiInterface.scala 51:17]
  assign io_read_ready = axi_read_io_lsu_read_ready; // @[AxiInterface.scala 51:17]
  assign io_write_bits_excp = axi_write_io_lsu_write_bits_excp; // @[AxiInterface.scala 58:18]
  assign io_write_ready = axi_write_io_lsu_write_ready; // @[AxiInterface.scala 58:18]
  assign io_axi_raddr_bits_araddr = axi_read_io_raddr_bits_araddr; // @[AxiInterface.scala 52:22]
  assign io_axi_raddr_bits_arsize = axi_read_io_raddr_bits_arsize; // @[AxiInterface.scala 52:22]
  assign io_axi_raddr_valid = axi_read_io_raddr_valid; // @[AxiInterface.scala 52:22]
  assign io_axi_rdata_ready = axi_read_io_rdata_ready; // @[AxiInterface.scala 53:22]
  assign io_axi_waddr_bits_awaddr = axi_write_io_waddr_bits_awaddr; // @[AxiInterface.scala 59:22]
  assign io_axi_waddr_bits_awsize = axi_write_io_waddr_bits_awsize; // @[AxiInterface.scala 59:22]
  assign io_axi_waddr_valid = axi_write_io_waddr_valid; // @[AxiInterface.scala 59:22]
  assign io_axi_wdata_bits_wdata = axi_write_io_wdata_bits_wdata; // @[AxiInterface.scala 60:22]
  assign io_axi_wdata_bits_wstrb = axi_write_io_wdata_bits_wstrb; // @[AxiInterface.scala 60:22]
  assign io_axi_wdata_valid = axi_write_io_wdata_valid; // @[AxiInterface.scala 60:22]
  assign io_axi_wresp_ready = axi_write_io_wresp_ready; // @[AxiInterface.scala 61:22]
  assign axi_read_clock = clock;
  assign axi_read_reset = reset;
  assign axi_read_io_raddr_ready = io_axi_raddr_ready; // @[AxiInterface.scala 52:22]
  assign axi_read_io_rdata_bits_rresp = io_axi_rdata_bits_rresp; // @[AxiInterface.scala 53:22]
  assign axi_read_io_rdata_bits_rdata = io_axi_rdata_bits_rdata; // @[AxiInterface.scala 53:22]
  assign axi_read_io_rdata_bits_rlast = io_axi_rdata_bits_rlast; // @[AxiInterface.scala 53:22]
  assign axi_read_io_rdata_valid = io_axi_rdata_valid; // @[AxiInterface.scala 53:22]
  assign axi_read_io_lsu_read_bits_addr = io_read_bits_addr; // @[AxiInterface.scala 51:17]
  assign axi_read_io_lsu_read_bits_op = io_read_bits_op; // @[AxiInterface.scala 51:17]
  assign axi_read_io_lsu_read_valid = io_read_valid; // @[AxiInterface.scala 51:17]
  assign axi_write_clock = clock;
  assign axi_write_reset = reset;
  assign axi_write_io_waddr_ready = io_axi_waddr_ready; // @[AxiInterface.scala 59:22]
  assign axi_write_io_wdata_ready = io_axi_wdata_ready; // @[AxiInterface.scala 60:22]
  assign axi_write_io_wresp_bits_bresp = io_axi_wresp_bits_bresp; // @[AxiInterface.scala 61:22]
  assign axi_write_io_wresp_valid = io_axi_wresp_valid; // @[AxiInterface.scala 61:22]
  assign axi_write_io_lsu_write_bits_addr = io_write_bits_addr; // @[AxiInterface.scala 58:18]
  assign axi_write_io_lsu_write_bits_wdata = io_write_bits_wdata; // @[AxiInterface.scala 58:18]
  assign axi_write_io_lsu_write_bits_wstrb = io_write_bits_wstrb; // @[AxiInterface.scala 58:18]
  assign axi_write_io_lsu_write_bits_op = io_write_bits_op; // @[AxiInterface.scala 58:18]
  assign axi_write_io_lsu_write_valid = io_write_valid; // @[AxiInterface.scala 58:18]
endmodule
module ysyx_210727(
  input         clock,
  input         reset,
  input         io_interrupt,
  input         io_master_awready,
  output        io_master_awvalid,
  output [31:0] io_master_awaddr,
  output [3:0]  io_master_awid,
  output [7:0]  io_master_awlen,
  output [2:0]  io_master_awsize,
  output [1:0]  io_master_awburst,
  input         io_master_wready,
  output        io_master_wvalid,
  output [63:0] io_master_wdata,
  output [7:0]  io_master_wstrb,
  output        io_master_wlast,
  output        io_master_bready,
  input         io_master_bvalid,
  input  [1:0]  io_master_bresp,
  input  [3:0]  io_master_bid,
  input         io_master_arready,
  output        io_master_arvalid,
  output [31:0] io_master_araddr,
  output [3:0]  io_master_arid,
  output [7:0]  io_master_arlen,
  output [2:0]  io_master_arsize,
  output [1:0]  io_master_arburst,
  output        io_master_rready,
  input         io_master_rvalid,
  input  [1:0]  io_master_rresp,
  input  [63:0] io_master_rdata,
  input         io_master_rlast,
  input  [3:0]  io_master_rid,
  output        io_slave_awready,
  input         io_slave_awvalid,
  input  [31:0] io_slave_awaddr,
  input  [3:0]  io_slave_awid,
  input  [7:0]  io_slave_awlen,
  input  [2:0]  io_slave_awsize,
  input  [1:0]  io_slave_awburst,
  output        io_slave_wready,
  input         io_slave_wvalid,
  input  [63:0] io_slave_wdata,
  input  [7:0]  io_slave_wstrb,
  input         io_slave_wlast,
  input         io_slave_bready,
  output        io_slave_bvalid,
  output [1:0]  io_slave_bresp,
  output [3:0]  io_slave_bid,
  output        io_slave_arready,
  input         io_slave_arvalid,
  input  [31:0] io_slave_araddr,
  input  [3:0]  io_slave_arid,
  input  [7:0]  io_slave_arlen,
  input  [2:0]  io_slave_arsize,
  input  [1:0]  io_slave_arburst,
  input         io_slave_rready,
  output        io_slave_rvalid,
  output [1:0]  io_slave_rresp,
  output [63:0] io_slave_rdata,
  output        io_slave_rlast,
  output [3:0]  io_slave_rid
);
  wire  hart0_clock; // @[SocTop.scala 67:27]
  wire  hart0_reset; // @[SocTop.scala 67:27]
  wire [63:0] hart0_io_iread_bits_addr; // @[SocTop.scala 67:27]
  wire  hart0_io_iread_bits_excp; // @[SocTop.scala 67:27]
  wire  hart0_io_iread_bits_misalign; // @[SocTop.scala 67:27]
  wire [63:0] hart0_io_iread_bits_data; // @[SocTop.scala 67:27]
  wire  hart0_io_iread_ready; // @[SocTop.scala 67:27]
  wire [63:0] hart0_io_dread_bits_addr; // @[SocTop.scala 67:27]
  wire [2:0] hart0_io_dread_bits_op; // @[SocTop.scala 67:27]
  wire  hart0_io_dread_bits_excp; // @[SocTop.scala 67:27]
  wire  hart0_io_dread_bits_misalign; // @[SocTop.scala 67:27]
  wire [63:0] hart0_io_dread_bits_data; // @[SocTop.scala 67:27]
  wire  hart0_io_dread_valid; // @[SocTop.scala 67:27]
  wire  hart0_io_dread_ready; // @[SocTop.scala 67:27]
  wire [63:0] hart0_io_dwrite_bits_addr; // @[SocTop.scala 67:27]
  wire [2:0] hart0_io_dwrite_bits_op; // @[SocTop.scala 67:27]
  wire  hart0_io_dwrite_bits_excp; // @[SocTop.scala 67:27]
  wire  hart0_io_dwrite_bits_misalign; // @[SocTop.scala 67:27]
  wire [63:0] hart0_io_dwrite_bits_data; // @[SocTop.scala 67:27]
  wire  hart0_io_dwrite_valid; // @[SocTop.scala 67:27]
  wire  hart0_io_dwrite_ready; // @[SocTop.scala 67:27]
  wire  hart0_io_int_soft; // @[SocTop.scala 67:27]
  wire  hart0_io_int_timer; // @[SocTop.scala 67:27]
  wire  hart0_io_int_extern; // @[SocTop.scala 67:27]
  wire [63:0] lsu_io_iread_bits_addr; // @[SocTop.scala 68:25]
  wire  lsu_io_iread_bits_excp; // @[SocTop.scala 68:25]
  wire  lsu_io_iread_bits_misalign; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_iread_bits_data; // @[SocTop.scala 68:25]
  wire  lsu_io_iread_ready; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_dread_bits_addr; // @[SocTop.scala 68:25]
  wire [2:0] lsu_io_dread_bits_op; // @[SocTop.scala 68:25]
  wire  lsu_io_dread_bits_excp; // @[SocTop.scala 68:25]
  wire  lsu_io_dread_bits_misalign; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_dread_bits_data; // @[SocTop.scala 68:25]
  wire  lsu_io_dread_valid; // @[SocTop.scala 68:25]
  wire  lsu_io_dread_ready; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_dwrite_bits_addr; // @[SocTop.scala 68:25]
  wire [2:0] lsu_io_dwrite_bits_op; // @[SocTop.scala 68:25]
  wire  lsu_io_dwrite_bits_excp; // @[SocTop.scala 68:25]
  wire  lsu_io_dwrite_bits_misalign; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_dwrite_bits_data; // @[SocTop.scala 68:25]
  wire  lsu_io_dwrite_valid; // @[SocTop.scala 68:25]
  wire  lsu_io_dwrite_ready; // @[SocTop.scala 68:25]
  wire [31:0] lsu_io_clint_read_bits_addr; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_clint_read_bits_rdata; // @[SocTop.scala 68:25]
  wire [2:0] lsu_io_clint_read_bits_op; // @[SocTop.scala 68:25]
  wire [31:0] lsu_io_clint_write_bits_addr; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_clint_write_bits_wdata; // @[SocTop.scala 68:25]
  wire [7:0] lsu_io_clint_write_bits_wstrb; // @[SocTop.scala 68:25]
  wire  lsu_io_clint_write_valid; // @[SocTop.scala 68:25]
  wire [31:0] lsu_io_axi_read_bits_addr; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_axi_read_bits_rdata; // @[SocTop.scala 68:25]
  wire [2:0] lsu_io_axi_read_bits_op; // @[SocTop.scala 68:25]
  wire  lsu_io_axi_read_bits_excp; // @[SocTop.scala 68:25]
  wire  lsu_io_axi_read_valid; // @[SocTop.scala 68:25]
  wire  lsu_io_axi_read_ready; // @[SocTop.scala 68:25]
  wire [31:0] lsu_io_axi_write_bits_addr; // @[SocTop.scala 68:25]
  wire [63:0] lsu_io_axi_write_bits_wdata; // @[SocTop.scala 68:25]
  wire [7:0] lsu_io_axi_write_bits_wstrb; // @[SocTop.scala 68:25]
  wire [2:0] lsu_io_axi_write_bits_op; // @[SocTop.scala 68:25]
  wire  lsu_io_axi_write_bits_excp; // @[SocTop.scala 68:25]
  wire  lsu_io_axi_write_valid; // @[SocTop.scala 68:25]
  wire  lsu_io_axi_write_ready; // @[SocTop.scala 68:25]
  wire  clint_clock; // @[SocTop.scala 80:32]
  wire  clint_reset; // @[SocTop.scala 80:32]
  wire [31:0] clint_io_read_bits_addr; // @[SocTop.scala 80:32]
  wire [63:0] clint_io_read_bits_rdata; // @[SocTop.scala 80:32]
  wire [31:0] clint_io_write_bits_addr; // @[SocTop.scala 80:32]
  wire [63:0] clint_io_write_bits_wdata; // @[SocTop.scala 80:32]
  wire [7:0] clint_io_write_bits_wstrb; // @[SocTop.scala 80:32]
  wire  clint_io_write_valid; // @[SocTop.scala 80:32]
  wire  clint_io_do_timer_0; // @[SocTop.scala 80:32]
  wire  axi_interface_clock; // @[SocTop.scala 83:35]
  wire  axi_interface_reset; // @[SocTop.scala 83:35]
  wire [31:0] axi_interface_io_read_bits_addr; // @[SocTop.scala 83:35]
  wire [63:0] axi_interface_io_read_bits_rdata; // @[SocTop.scala 83:35]
  wire [2:0] axi_interface_io_read_bits_op; // @[SocTop.scala 83:35]
  wire  axi_interface_io_read_bits_excp; // @[SocTop.scala 83:35]
  wire  axi_interface_io_read_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_read_ready; // @[SocTop.scala 83:35]
  wire [31:0] axi_interface_io_write_bits_addr; // @[SocTop.scala 83:35]
  wire [63:0] axi_interface_io_write_bits_wdata; // @[SocTop.scala 83:35]
  wire [7:0] axi_interface_io_write_bits_wstrb; // @[SocTop.scala 83:35]
  wire [2:0] axi_interface_io_write_bits_op; // @[SocTop.scala 83:35]
  wire  axi_interface_io_write_bits_excp; // @[SocTop.scala 83:35]
  wire  axi_interface_io_write_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_write_ready; // @[SocTop.scala 83:35]
  wire [31:0] axi_interface_io_axi_raddr_bits_araddr; // @[SocTop.scala 83:35]
  wire [2:0] axi_interface_io_axi_raddr_bits_arsize; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_raddr_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_raddr_ready; // @[SocTop.scala 83:35]
  wire [1:0] axi_interface_io_axi_rdata_bits_rresp; // @[SocTop.scala 83:35]
  wire [63:0] axi_interface_io_axi_rdata_bits_rdata; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_rdata_bits_rlast; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_rdata_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_rdata_ready; // @[SocTop.scala 83:35]
  wire [31:0] axi_interface_io_axi_waddr_bits_awaddr; // @[SocTop.scala 83:35]
  wire [2:0] axi_interface_io_axi_waddr_bits_awsize; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_waddr_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_waddr_ready; // @[SocTop.scala 83:35]
  wire [63:0] axi_interface_io_axi_wdata_bits_wdata; // @[SocTop.scala 83:35]
  wire [7:0] axi_interface_io_axi_wdata_bits_wstrb; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_wdata_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_wdata_ready; // @[SocTop.scala 83:35]
  wire [1:0] axi_interface_io_axi_wresp_bits_bresp; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_wresp_valid; // @[SocTop.scala 83:35]
  wire  axi_interface_io_axi_wresp_ready; // @[SocTop.scala 83:35]
  ysyx_210727_HikelCore hart0 ( // @[SocTop.scala 67:27]
    .clock(hart0_clock),
    .reset(hart0_reset),
    .io_iread_bits_addr(hart0_io_iread_bits_addr),
    .io_iread_bits_excp(hart0_io_iread_bits_excp),
    .io_iread_bits_misalign(hart0_io_iread_bits_misalign),
    .io_iread_bits_data(hart0_io_iread_bits_data),
    .io_iread_ready(hart0_io_iread_ready),
    .io_dread_bits_addr(hart0_io_dread_bits_addr),
    .io_dread_bits_op(hart0_io_dread_bits_op),
    .io_dread_bits_excp(hart0_io_dread_bits_excp),
    .io_dread_bits_misalign(hart0_io_dread_bits_misalign),
    .io_dread_bits_data(hart0_io_dread_bits_data),
    .io_dread_valid(hart0_io_dread_valid),
    .io_dread_ready(hart0_io_dread_ready),
    .io_dwrite_bits_addr(hart0_io_dwrite_bits_addr),
    .io_dwrite_bits_op(hart0_io_dwrite_bits_op),
    .io_dwrite_bits_excp(hart0_io_dwrite_bits_excp),
    .io_dwrite_bits_misalign(hart0_io_dwrite_bits_misalign),
    .io_dwrite_bits_data(hart0_io_dwrite_bits_data),
    .io_dwrite_valid(hart0_io_dwrite_valid),
    .io_dwrite_ready(hart0_io_dwrite_ready),
    .io_int_soft(hart0_io_int_soft),
    .io_int_timer(hart0_io_int_timer),
    .io_int_extern(hart0_io_int_extern)
  );
  ysyx_210727_Lsu lsu ( // @[SocTop.scala 68:25]
    .io_iread_bits_addr(lsu_io_iread_bits_addr),
    .io_iread_bits_excp(lsu_io_iread_bits_excp),
    .io_iread_bits_misalign(lsu_io_iread_bits_misalign),
    .io_iread_bits_data(lsu_io_iread_bits_data),
    .io_iread_ready(lsu_io_iread_ready),
    .io_dread_bits_addr(lsu_io_dread_bits_addr),
    .io_dread_bits_op(lsu_io_dread_bits_op),
    .io_dread_bits_excp(lsu_io_dread_bits_excp),
    .io_dread_bits_misalign(lsu_io_dread_bits_misalign),
    .io_dread_bits_data(lsu_io_dread_bits_data),
    .io_dread_valid(lsu_io_dread_valid),
    .io_dread_ready(lsu_io_dread_ready),
    .io_dwrite_bits_addr(lsu_io_dwrite_bits_addr),
    .io_dwrite_bits_op(lsu_io_dwrite_bits_op),
    .io_dwrite_bits_excp(lsu_io_dwrite_bits_excp),
    .io_dwrite_bits_misalign(lsu_io_dwrite_bits_misalign),
    .io_dwrite_bits_data(lsu_io_dwrite_bits_data),
    .io_dwrite_valid(lsu_io_dwrite_valid),
    .io_dwrite_ready(lsu_io_dwrite_ready),
    .io_clint_read_bits_addr(lsu_io_clint_read_bits_addr),
    .io_clint_read_bits_rdata(lsu_io_clint_read_bits_rdata),
    .io_clint_read_bits_op(lsu_io_clint_read_bits_op),
    .io_clint_write_bits_addr(lsu_io_clint_write_bits_addr),
    .io_clint_write_bits_wdata(lsu_io_clint_write_bits_wdata),
    .io_clint_write_bits_wstrb(lsu_io_clint_write_bits_wstrb),
    .io_clint_write_valid(lsu_io_clint_write_valid),
    .io_axi_read_bits_addr(lsu_io_axi_read_bits_addr),
    .io_axi_read_bits_rdata(lsu_io_axi_read_bits_rdata),
    .io_axi_read_bits_op(lsu_io_axi_read_bits_op),
    .io_axi_read_bits_excp(lsu_io_axi_read_bits_excp),
    .io_axi_read_valid(lsu_io_axi_read_valid),
    .io_axi_read_ready(lsu_io_axi_read_ready),
    .io_axi_write_bits_addr(lsu_io_axi_write_bits_addr),
    .io_axi_write_bits_wdata(lsu_io_axi_write_bits_wdata),
    .io_axi_write_bits_wstrb(lsu_io_axi_write_bits_wstrb),
    .io_axi_write_bits_op(lsu_io_axi_write_bits_op),
    .io_axi_write_bits_excp(lsu_io_axi_write_bits_excp),
    .io_axi_write_valid(lsu_io_axi_write_valid),
    .io_axi_write_ready(lsu_io_axi_write_ready)
  );
  ysyx_210727_Clint clint ( // @[SocTop.scala 80:32]
    .clock(clint_clock),
    .reset(clint_reset),
    .io_read_bits_addr(clint_io_read_bits_addr),
    .io_read_bits_rdata(clint_io_read_bits_rdata),
    .io_write_bits_addr(clint_io_write_bits_addr),
    .io_write_bits_wdata(clint_io_write_bits_wdata),
    .io_write_bits_wstrb(clint_io_write_bits_wstrb),
    .io_write_valid(clint_io_write_valid),
    .io_do_timer_0(clint_io_do_timer_0)
  );
  ysyx_210727_AxiInterface axi_interface ( // @[SocTop.scala 83:35]
    .clock(axi_interface_clock),
    .reset(axi_interface_reset),
    .io_read_bits_addr(axi_interface_io_read_bits_addr),
    .io_read_bits_rdata(axi_interface_io_read_bits_rdata),
    .io_read_bits_op(axi_interface_io_read_bits_op),
    .io_read_bits_excp(axi_interface_io_read_bits_excp),
    .io_read_valid(axi_interface_io_read_valid),
    .io_read_ready(axi_interface_io_read_ready),
    .io_write_bits_addr(axi_interface_io_write_bits_addr),
    .io_write_bits_wdata(axi_interface_io_write_bits_wdata),
    .io_write_bits_wstrb(axi_interface_io_write_bits_wstrb),
    .io_write_bits_op(axi_interface_io_write_bits_op),
    .io_write_bits_excp(axi_interface_io_write_bits_excp),
    .io_write_valid(axi_interface_io_write_valid),
    .io_write_ready(axi_interface_io_write_ready),
    .io_axi_raddr_bits_araddr(axi_interface_io_axi_raddr_bits_araddr),
    .io_axi_raddr_bits_arsize(axi_interface_io_axi_raddr_bits_arsize),
    .io_axi_raddr_valid(axi_interface_io_axi_raddr_valid),
    .io_axi_raddr_ready(axi_interface_io_axi_raddr_ready),
    .io_axi_rdata_bits_rresp(axi_interface_io_axi_rdata_bits_rresp),
    .io_axi_rdata_bits_rdata(axi_interface_io_axi_rdata_bits_rdata),
    .io_axi_rdata_bits_rlast(axi_interface_io_axi_rdata_bits_rlast),
    .io_axi_rdata_valid(axi_interface_io_axi_rdata_valid),
    .io_axi_rdata_ready(axi_interface_io_axi_rdata_ready),
    .io_axi_waddr_bits_awaddr(axi_interface_io_axi_waddr_bits_awaddr),
    .io_axi_waddr_bits_awsize(axi_interface_io_axi_waddr_bits_awsize),
    .io_axi_waddr_valid(axi_interface_io_axi_waddr_valid),
    .io_axi_waddr_ready(axi_interface_io_axi_waddr_ready),
    .io_axi_wdata_bits_wdata(axi_interface_io_axi_wdata_bits_wdata),
    .io_axi_wdata_bits_wstrb(axi_interface_io_axi_wdata_bits_wstrb),
    .io_axi_wdata_valid(axi_interface_io_axi_wdata_valid),
    .io_axi_wdata_ready(axi_interface_io_axi_wdata_ready),
    .io_axi_wresp_bits_bresp(axi_interface_io_axi_wresp_bits_bresp),
    .io_axi_wresp_valid(axi_interface_io_axi_wresp_valid),
    .io_axi_wresp_ready(axi_interface_io_axi_wresp_ready)
  );
  assign io_master_awvalid = axi_interface_io_axi_waddr_valid; // @[SocTop.scala 92:41]
  assign io_master_awaddr = axi_interface_io_axi_waddr_bits_awaddr; // @[SocTop.scala 93:41]
  assign io_master_awid = 4'h0; // @[SocTop.scala 94:41]
  assign io_master_awlen = 8'h0; // @[SocTop.scala 95:41]
  assign io_master_awsize = axi_interface_io_axi_waddr_bits_awsize; // @[SocTop.scala 96:41]
  assign io_master_awburst = 2'h1; // @[SocTop.scala 97:41]
  assign io_master_wvalid = axi_interface_io_axi_wdata_valid; // @[SocTop.scala 101:41]
  assign io_master_wdata = axi_interface_io_axi_wdata_bits_wdata; // @[SocTop.scala 102:41]
  assign io_master_wstrb = axi_interface_io_axi_wdata_bits_wstrb; // @[SocTop.scala 103:41]
  assign io_master_wlast = 1'h1; // @[SocTop.scala 104:41]
  assign io_master_bready = axi_interface_io_axi_wresp_ready; // @[SocTop.scala 107:34]
  assign io_master_arvalid = axi_interface_io_axi_raddr_valid; // @[SocTop.scala 114:41]
  assign io_master_araddr = axi_interface_io_axi_raddr_bits_araddr; // @[SocTop.scala 115:41]
  assign io_master_arid = 4'h0; // @[SocTop.scala 116:41]
  assign io_master_arlen = 8'h0; // @[SocTop.scala 117:41]
  assign io_master_arsize = axi_interface_io_axi_raddr_bits_arsize; // @[SocTop.scala 118:41]
  assign io_master_arburst = 2'h1; // @[SocTop.scala 119:41]
  assign io_master_rready = axi_interface_io_axi_rdata_ready; // @[SocTop.scala 122:34]
  assign io_slave_awready = 1'h0; // @[SocTop.scala 132:41]
  assign io_slave_wready = 1'h0; // @[SocTop.scala 135:41]
  assign io_slave_bvalid = 1'h0; // @[SocTop.scala 138:41]
  assign io_slave_bresp = 2'h0; // @[SocTop.scala 139:41]
  assign io_slave_bid = 4'h0; // @[SocTop.scala 140:41]
  assign io_slave_arready = 1'h0; // @[SocTop.scala 143:41]
  assign io_slave_rvalid = 1'h0; // @[SocTop.scala 146:41]
  assign io_slave_rresp = 2'h0; // @[SocTop.scala 147:41]
  assign io_slave_rdata = 64'h0; // @[SocTop.scala 148:41]
  assign io_slave_rlast = 1'h0; // @[SocTop.scala 149:41]
  assign io_slave_rid = 4'h0; // @[SocTop.scala 150:41]
  assign hart0_clock = clock;
  assign hart0_reset = reset;
  assign hart0_io_iread_bits_excp = lsu_io_iread_bits_excp; // @[SocTop.scala 76:33]
  assign hart0_io_iread_bits_misalign = lsu_io_iread_bits_misalign; // @[SocTop.scala 76:33]
  assign hart0_io_iread_bits_data = lsu_io_iread_bits_data; // @[SocTop.scala 76:33]
  assign hart0_io_iread_ready = lsu_io_iread_ready; // @[SocTop.scala 76:33]
  assign hart0_io_dread_bits_excp = lsu_io_dread_bits_excp; // @[SocTop.scala 77:33]
  assign hart0_io_dread_bits_misalign = lsu_io_dread_bits_misalign; // @[SocTop.scala 77:33]
  assign hart0_io_dread_bits_data = lsu_io_dread_bits_data; // @[SocTop.scala 77:33]
  assign hart0_io_dread_ready = lsu_io_dread_ready; // @[SocTop.scala 77:33]
  assign hart0_io_dwrite_bits_excp = lsu_io_dwrite_bits_excp; // @[SocTop.scala 78:33]
  assign hart0_io_dwrite_bits_misalign = lsu_io_dwrite_bits_misalign; // @[SocTop.scala 78:33]
  assign hart0_io_dwrite_ready = lsu_io_dwrite_ready; // @[SocTop.scala 78:33]
  assign hart0_io_int_soft = 1'h0; // @[SocTop.scala 72:41]
  assign hart0_io_int_timer = clint_io_do_timer_0; // @[SocTop.scala 71:41]
  assign hart0_io_int_extern = io_interrupt; // @[SocTop.scala 73:33]
  assign lsu_io_iread_bits_addr = hart0_io_iread_bits_addr; // @[SocTop.scala 76:33]
  assign lsu_io_dread_bits_addr = hart0_io_dread_bits_addr; // @[SocTop.scala 77:33]
  assign lsu_io_dread_bits_op = hart0_io_dread_bits_op; // @[SocTop.scala 77:33]
  assign lsu_io_dread_valid = hart0_io_dread_valid; // @[SocTop.scala 77:33]
  assign lsu_io_dwrite_bits_addr = hart0_io_dwrite_bits_addr; // @[SocTop.scala 78:33]
  assign lsu_io_dwrite_bits_op = hart0_io_dwrite_bits_op; // @[SocTop.scala 78:33]
  assign lsu_io_dwrite_bits_data = hart0_io_dwrite_bits_data; // @[SocTop.scala 78:33]
  assign lsu_io_dwrite_valid = hart0_io_dwrite_valid; // @[SocTop.scala 78:33]
  assign lsu_io_clint_read_bits_rdata = clint_io_read_bits_rdata; // @[SocTop.scala 81:30]
  assign lsu_io_axi_read_bits_rdata = axi_interface_io_read_bits_rdata; // @[SocTop.scala 85:41]
  assign lsu_io_axi_read_bits_excp = axi_interface_io_read_bits_excp; // @[SocTop.scala 85:41]
  assign lsu_io_axi_read_ready = axi_interface_io_read_ready; // @[SocTop.scala 85:41]
  assign lsu_io_axi_write_bits_excp = axi_interface_io_write_bits_excp; // @[SocTop.scala 86:41]
  assign lsu_io_axi_write_ready = axi_interface_io_write_ready; // @[SocTop.scala 86:41]
  assign clint_clock = clock;
  assign clint_reset = reset;
  assign clint_io_read_bits_addr = lsu_io_clint_read_bits_addr; // @[SocTop.scala 81:30]
  assign clint_io_write_bits_addr = lsu_io_clint_write_bits_addr; // @[SocTop.scala 81:30]
  assign clint_io_write_bits_wdata = lsu_io_clint_write_bits_wdata; // @[SocTop.scala 81:30]
  assign clint_io_write_bits_wstrb = lsu_io_clint_write_bits_wstrb; // @[SocTop.scala 81:30]
  assign clint_io_write_valid = lsu_io_clint_write_valid; // @[SocTop.scala 81:30]
  assign axi_interface_clock = clock;
  assign axi_interface_reset = reset;
  assign axi_interface_io_read_bits_addr = lsu_io_axi_read_bits_addr; // @[SocTop.scala 85:41]
  assign axi_interface_io_read_bits_op = lsu_io_axi_read_bits_op; // @[SocTop.scala 85:41]
  assign axi_interface_io_read_valid = lsu_io_axi_read_valid; // @[SocTop.scala 85:41]
  assign axi_interface_io_write_bits_addr = lsu_io_axi_write_bits_addr; // @[SocTop.scala 86:41]
  assign axi_interface_io_write_bits_wdata = lsu_io_axi_write_bits_wdata; // @[SocTop.scala 86:41]
  assign axi_interface_io_write_bits_wstrb = lsu_io_axi_write_bits_wstrb; // @[SocTop.scala 86:41]
  assign axi_interface_io_write_bits_op = lsu_io_axi_write_bits_op; // @[SocTop.scala 86:41]
  assign axi_interface_io_write_valid = lsu_io_axi_write_valid; // @[SocTop.scala 86:41]
  assign axi_interface_io_axi_raddr_ready = io_master_arready; // @[SocTop.scala 113:50]
  assign axi_interface_io_axi_rdata_bits_rresp = io_master_rresp; // @[SocTop.scala 124:57]
  assign axi_interface_io_axi_rdata_bits_rdata = io_master_rdata; // @[SocTop.scala 125:57]
  assign axi_interface_io_axi_rdata_bits_rlast = io_master_rlast; // @[SocTop.scala 126:57]
  assign axi_interface_io_axi_rdata_valid = io_master_rvalid; // @[SocTop.scala 123:65]
  assign axi_interface_io_axi_waddr_ready = io_master_awready; // @[SocTop.scala 91:50]
  assign axi_interface_io_axi_wdata_ready = io_master_wready; // @[SocTop.scala 100:50]
  assign axi_interface_io_axi_wresp_bits_bresp = io_master_bresp; // @[SocTop.scala 109:57]
  assign axi_interface_io_axi_wresp_valid = io_master_bvalid; // @[SocTop.scala 108:65]
endmodule
