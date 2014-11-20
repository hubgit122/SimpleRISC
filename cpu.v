`timescale 1ns/10ps
module cpu(clock,resetn);
input       clock;
input       resetn;

wire [17:0] brbus;
wire [15:0] inst;
wire [2:0]  ex_dest,mem_dest,wb_dest;
wire [19:0] wbbus;
wire [55:0] idbus;
wire [39:0] exbus;
wire [39:0] membus;

fetch_module fetch(.clock(clock),.resetn(resetn),.brbus(brbus),.inst(inst));

decode_module decode(.clock(clock),.resetn(resetn),.inst(inst),
                     .ex_dest(ex_dest),.mem_dest(mem_dest),.wb_dest(wb_dest),
                     .wbbus(wbbus),.brbus(brbus),.idbus(idbus));

alu_module alu(.clock(clock),.resetn(resetn),
               .idbus(idbus),.exbus(exbus),.ex_dest(ex_dest));

mem_module mem(.clock(clock),.resetn(resetn),
               .exbus(exbus),.membus(membus),.mem_dest(mem_dest));

wb_module wb(.clock(clock),.resetn(resetn),
             .membus(membus),.wbbus(wbbus),.wb_dest(wb_dest));
endmodule
