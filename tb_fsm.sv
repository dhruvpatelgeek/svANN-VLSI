module tb_fsm();

logic clk;
logic [7:0]XOR_1;
logic [7:0]XOR_2;
logic [7:0]XOR_ans;
logic test;
logic train;

hardware_neural_net_fsm H1(
 .clk(clk),
 .XOR_1(XOR_1),
 .XOR_2(XOR_2),
 .XOR_ans(XOR_ans),
 .test(1'b1),
 .train(1'b0) 
 );
initial forever begin
    clk=1'b1;
    #5;
    clk=1'b0;
    #5;
end

initial begin
    XOR_1=8'b1;
    XOR_2=8'b1;
    #600;
    $stop;
end
endmodule