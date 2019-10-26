module one_io_bias_tb();
logic  clk;
logic [7:0] in;
logic  enable;
logic  ready;
logic [7:0] biased_out;
logic  [7:0] biased_val;

one_io_bias b1(
 .clk(clk),
 .in(in),
 .enable(enable),
 .ready(ready),
 .biased_out(biased_out),
 .biased_val(biased_val)
);

initial forever begin
   clk =1'b1;
   #5;
   clk=1'b0; 
   #5;
end

initial begin
    #5;
    enable=1'b0;
    #30;
    in=8'd5;
    biased_val=8'd5;
    #15;
    enable=1'b1;
    #15;
    enable=1'b0;
    #100;
    $stop;
end

endmodule