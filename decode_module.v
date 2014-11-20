`timescale 1ns/10ps
module decode_module(clock,resetn,inst,ex_dest,mem_dest,wb_dest,wbbus,brbus,idbus);
input           clock;
input           resetn;
input   [15:0]  inst;
input   [2:0]   ex_dest,mem_dest,wb_dest;
input   [19:0]  wbbus;
output  [55:0]  idbus;
output  [17:0]  brbus;

parameter NOP = 4'd0;
parameter ADD = 4'd1;
parameter SUB = 4'd2;
parameter AND = 4'd3;
parameter OR  = 4'd4;
parameter NOT = 4'd5;
parameter SL  = 4'd6;
parameter SR  = 4'd7;
parameter SRU = 4'd8;
parameter ADDI= 4'd9;
parameter LD  = 4'd10;
parameter ST  = 4'd11;
parameter BR  = 4'd12;

wire        wbbus_valid;
wire [2:0]  wbbus_dest;
wire [15:0] wbbus_value;
wire        idbus_valid;
wire [3:0]  idbus_op;
wire [2:0]  idbus_dest;
wire [15:0] idbus_value1;
wire [15:0] idbus_value2;
wire [15:0] idbus_stvalue;

wire        brbus_valid;
wire        brbus_taken;
wire [15:0] brbus_offset;

wire        valid;
wire [3:0]  op;
wire [2:0]  src1;
wire [2:0]  src2;
wire [2:0]  dep2;
wire [2:0]  dest;
wire [5:0]  imm;
wire [9:0]  eimm;
wire [15:0] rout1,rout2;
reg  [55:0] idbus_reg;

assign eimm             = {10{imm[5]}};
assign op               = inst[15:12];
assign dest             = inst[11:9];
assign src1             = inst[8:6];
assign src2             = inst[5:3];
assign dep2             = op == ST ? dest : src2;
assign imm              = inst[5:0];
assign valid            = !((ex_dest && ((ex_dest == src1) || (op != NOT && op<=SRU || op==ST) && (ex_dest == dep2))) ||
                          (mem_dest && ((mem_dest == src1) || (op != NOT && op<=SRU || op==ST) && (mem_dest == dep2))) ||
                          (wb_dest && ((wb_dest == src1) || (op != NOT && op<=SRU || op==ST) && (wb_dest == dep2))));

assign idbus_op         = valid ? op : 0;
assign idbus_dest       = valid ? ((op == BR || op == ST) ? 3'd0 : dest) : 0;
assign idbus_value1     = rout1;
assign idbus_value2     = (op[3] && (|op[2:0])) ? {eimm, imm} : rout2;
assign idbus_valid      = 1;
assign idbus_stvalue    = rout2;

assign wbbus_valid      = wbbus[19];
assign wbbus_dest       = wbbus[18:16];
assign wbbus_value      = wbbus[15:0];

always@(posedge clock or negedge resetn)
if(!resetn)
    idbus_reg <= 0;
else
    idbus_reg <= {idbus_valid, idbus_op, idbus_dest, idbus_value1, idbus_value2, rout2};

assign brbus_valid = valid;
assign brbus_taken = (idbus_op == BR) & ((dest == 3'b0/*BZ*/) ? (rout1 == 16'd0) : (dest == 3'b11/*BNZ*/) ? (|rout1) : ((dest == 3'b1/*BGT*/) ^ rout1[15]));
assign brbus_offset = {eimm, imm};

regfile regs(
.clock(clock),
.wen(wbbus_valid),
.win(wbbus_value),
.raddr1(src1),
.raddr2(dep2),
.waddr(wbbus_dest),
.rout1(rout1),
.rout2(rout2)
);

assign brbus[17]=brbus_valid;
assign brbus[16]=brbus_taken;
assign brbus[15:0]=brbus_offset;

assign idbus = idbus_reg;
endmodule
