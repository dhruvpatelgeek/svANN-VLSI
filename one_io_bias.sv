module one_io_bias(
 clk,
 in,
 enable,
 ready,
 biased_out,
 biased_val);

input logic [7:0] in,biased_val;
input logic enable;
input logic clk;
output logic ready;
output logic [7:0] biased_out;

logic [3:0] curr_state,next_state;
logic [3:0] next;
logic update;
logic [7:0]mult_val;

//state machine states
`define halt 4'd1
`define rdy 4'd2
`define procressing 4'd3
`define done 4'd4


always_ff@(posedge clk or posedge enable)

begin
casex({curr_state})
`rdy: if ( enable==1'b1 ) begin
    next=`procressing;
end else begin
    next=`rdy;
end

`procressing: if ( enable!==1'b1 ) begin
    next=`rdy;
end else begin
    next=`procressing;
end

default: next=`rdy;
endcase
end

always_comb 
begin

if(curr_state==`rdy) begin
ready=1'b1; 
end else begin 
ready=1'b0;
end

if(curr_state==`procressing) begin
update=1'b1; 
end else begin 
update=1'b0;
end

end

assign next_state=next[3:0];
assign mult_val=biased_val*in;

vDFF #(4) FSM_VDFF(
    .clk(clk),
    .load(1'b1),
    .out(curr_state),
    .in(next_state)
);

vDFF #(8) UPDATE_VDFF(
    .clk(update),
    .load(1'b1),
    .out(biased_out),
    .in(mult_val)
);

endmodule 

module vDFF(clk, load, in, out); // program counter
  parameter n = 9;  // width
  input clk, load;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;
  wire [n-1:0] next_out;

  assign next_out = (load ? in : out);

  always @(posedge clk)
    out = next_out;
endmodule 