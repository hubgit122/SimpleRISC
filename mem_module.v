`timescale 1ns/10ps
module mem_module(clock,resetn,exbus,membus,mem_dest);
input           clock;
input           resetn;
input   [39:0]  exbus;
output  [39:0]  membus;
output  [2:0]   mem_dest;

wire            exbus_valid;
wire    [3:0]   exbus_op;
wire    [2:0]   exbus_dest;
wire    [15:0]  exbus_exresult;
wire    [15:0]  exbus_stvalue;

wire    [15:0]  membus_memresult;

reg     [39:0]  membus_reg;

always@(posedge clock or negedge resetn)
if(!resetn)
    membus_reg <= 0;
else
    membus_reg <= {exbus_valid, exbus_op, exbus_dest, exbus_exresult, membus_memresult};

ram ram_inst(
.clock  (clock),
.wen    (exbus_op == 4'b1011),
.win    (exbus_stvalue),
.raddr  (exbus_exresult>>1),
.waddr  (exbus_exresult>>1),
.rout   (membus_memresult)
);

assign exbus_valid=exbus[39];
assign exbus_op=exbus[38:35];
assign exbus_dest=exbus[34:32];
assign exbus_exresult=exbus[31:16];
assign exbus_stvalue=exbus[15:0];
assign membus = membus_reg;
assign mem_dest = exbus_dest;
endmodule