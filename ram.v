`timescale 1ns/10ps
module ram(clock,raddr,rout,wen,waddr,win);
input           clock;
input           wen;
input   [15:0]  win;
input   [11:0]  raddr;
input   [11:0]  waddr;
output  [15:0]  rout;

reg [15:0] ram[4095:0];

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

integer i;
initial
begin
//
//Loop:   LW    R1, 0(R2) ; 从地址 0+R2 处读入 R1
//        ADDI  R2, R2, #2 ; R2＝R2+2
//        ADDI  R1, R1, #14 ; R1= R1+4
//        SUB   R4, R3, R2 ; R4=R3-R2
//        SW    0(R2), R1 ; 将 R1 存入地址 R2-2 处
//        BNEZ  R4, Loop ; R4 不等于 0 时跳转到 Loop
    ram[0] = {ADDI, 3'd2, 3'd0, 6'd20};
    ram[1] = {ADDI, 3'd3, 3'd0, 6'd30};
/**/ram[2] = {LD, 3'd1, 3'd2, 6'd0};
    ram[3] = {ADDI, 3'd2, 3'd2, 6'd2};
    ram[4] = {ADDI, 3'd1, 3'd1, 6'd14};
    ram[5] = {SUB, 3'd4, 3'd3, 3'd2, 3'd0};
    ram[6] = {ST, 3'd1, 3'd2, -6'd2};
    ram[7] = {BR, 3'd3, 3'd4, -6'd12};
    ram[8] = {16'd0};
    ram[9] = {16'd0};

    for(i=10; i<100; i=i+1)
        ram[i] = i;
end

assign rout = ram[raddr];

always @(posedge clock)
begin
    if (wen)
    begin
        ram[waddr] = win;
    end
end
endmodule
