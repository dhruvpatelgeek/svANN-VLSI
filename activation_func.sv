module active(a,b,c,out,rdy,en);
input[7:0] a,b,c;
output [7:0] out;
output rdy;
input en;

assign out= (en) ? a+b+c:8'b0;
assign rdy=1'b1;
// will improve;
endmodule