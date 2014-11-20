`timescale 1ns/10ps
module regfile(clock,raddr1,rout1,raddr2,rout2,wen, waddr,win);
input           clock;
input           wen;
input   [15:0]  win;
input   [2:0]   raddr1,raddr2;
input   [2:0]   waddr;
output  [15:0]  rout1,rout2;

reg     [15:0]  ram[7:0];

assign rout1 = raddr1 ? ram[raddr1] : 16'd0;
assign rout2 = raddr2 ? ram[raddr2] : 16'd0;

always @(posedge clock)
begin
    ram[0]<=16'b0;
    if (wen)
    begin
        if(waddr!=0)
        begin
            ram[waddr]<= win;
        end
    end
end
endmodule
