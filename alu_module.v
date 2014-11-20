`timescale 1ns/10ps
module alu_module(clock,resetn,idbus,exbus,ex_dest);
input           clock;
input           resetn;
input   [55:0]  idbus;
output  [39:0]  exbus;
output  [2:0]   ex_dest;

wire            idbus_valid;
wire [3:0]      idbus_op;
wire [2:0]      idbus_dest;
wire [15:0]     idbus_value1;
wire [15:0]     idbus_value2;
wire [15:0]     idbus_stvalue;

reg  [15:0]     exbus_exresult;

reg  [39:0]     exbus_reg;

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

assign idbus_valid      = idbus[55];
assign idbus_op         = idbus[54:51];
assign idbus_dest       = idbus[50:48];
assign idbus_value1     = idbus[47:32];
assign idbus_value2     = idbus[31:16];
assign idbus_stvalue    = idbus[15:0];
assign ex_dest          = idbus_dest;

always@(posedge clock or negedge resetn)
if(!resetn)
    exbus_reg <= 0;
else
    exbus_reg <= {idbus_valid, idbus_op, idbus_dest, exbus_exresult, idbus_stvalue};

always@( * )
begin
    case(idbus_op)
        ADD, ADDI, LD, ST:
              exbus_exresult = idbus_value1 + idbus_value2;
        SUB : exbus_exresult = idbus_value1 - idbus_value2;
        AND : exbus_exresult = idbus_value1 & idbus_value2;
        OR  : exbus_exresult = idbus_value1 | idbus_value2;
        NOT : exbus_exresult = ~idbus_value1;
        SL  : exbus_exresult = idbus_value1 << idbus_value2;
        SR  : exbus_exresult = idbus_value1 >> idbus_value2;
        SRU : exbus_exresult = idbus_value2>=16 ? {16{idbus_value1[15]}} : ({{15{idbus_value1[15]}}, idbus_value1} >> idbus_value2);
        default: exbus_exresult = 'dx;
    endcase
end

assign exbus = exbus_reg;
endmodule