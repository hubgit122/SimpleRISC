`timescale 1ns/10ps
module system;

reg clock,resetn;

cpu cpu00(.clock(clock),.resetn(resetn));

initial
    clock<=1'b0;

always #20
	clock<=~clock;

initial
begin
    #0 resetn<=1'b0;
    #70 resetn<=1'b1;
end
endmodule
