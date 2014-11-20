
`timescale 1ns/10ps
module wb_module(clock,resetn,membus,wbbus,wb_dest);
input           clock;
input           resetn;
input   [39:0]  membus;
output  [19:0]  wbbus;
output  [2:0]   wb_dest;

wire            membus_valid;
wire [3:0]      membus_op;
wire [2:0]      membus_dest;
wire [15:0]     membus_exresult;
wire [15:0]     membus_memresult;
wire            wbbus_valid;
wire [2:0]      wbbus_dest;
wire [15:0]     wbbus_value;

assign membus_valid     = membus[39];
assign membus_op        = membus[38:35];
assign membus_dest      = membus[34:32];
assign membus_exresult  = membus[31:16];
assign membus_memresult = membus[15:0];

assign wbbus_valid = !membus_op[3] && (|membus_op[2:0]) || membus_op[3] &&!membus_op[2]&&!membus_op[1] || !membus_op[2]&&membus_op[1]&&~membus_op[0];
assign wbbus_dest = membus_dest;        // 如果是写寄存器, 不应该阻塞流水线.
assign wbbus_value = membus_op[3]&membus_op[1] ? membus_memresult: membus_exresult;

assign wb_dest = wbbus_dest;

assign wbbus[19]        = wbbus_valid;
assign wbbus[18:16]     = wbbus_dest;
assign wbbus[15:0]      = wbbus_value;
endmodule