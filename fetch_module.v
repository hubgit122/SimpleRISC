`timescale 1ns/10ps
module fetch_module(clock,resetn,brbus,inst);
input           clock;
input           resetn;
input   [17:0]  brbus;
output  [15:0]  inst;

reg  [15:0]     pc;
reg  [15:0]     inst_reg;
wire [15:0]     inst_;
wire            brbus_valid;
wire            brbus_taken;
wire [15:0]     brbus_offset;

assign brbus_valid = brbus[17];
assign brbus_taken = brbus[16];
assign brbus_offset= brbus[15:0];
assign inst = inst_reg;

ram inst_mem(
.clock  (clock),
.wen    (0),
.win    (0),
.raddr  (pc>>1),
.waddr  (0),
.rout   (inst_)
);

always@(posedge clock or negedge resetn)
if(!resetn)
    inst_reg <= 0;
else if(brbus_valid)
    inst_reg <= inst_;

always@(posedge clock or negedge resetn)
if(!resetn)
    pc <= 0;
else if(brbus_valid)
    pc <= brbus_taken? pc + brbus_offset : pc +2;
endmodule
