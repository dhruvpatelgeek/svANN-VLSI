module hardware_neural_net_fsm(
 input logic clk,
 input logic [7:0] XOR_1,
 input logic [7:0] XOR_2,
 output logic XOR_ans,

 input logic test,
 input logic train
 );

 logic [11:0] ready;
 logic [16:0] en;
//bus design


logic [7:0] in_l1a;
logic [7:0] in_l1b;
logic [7:0] in_l2a;
logic [7:0] in_l2b;
logic [7:0] in_l3a;
logic [7:0] out_l1a;
logic [7:0] out_l1b;
logic [7:0] out_l2a;
logic [7:0] out_l2b;
logic [7:0] out_l3a;
logic [7:0] out_bias_1;
logic [7:0] out_bias_2;


//input bus decoder
logic load_l1a;
logic load_l1b;
logic load_l2a;
logic load_l2b;
logic load_l3a;

logic en_1a1;
logic en_1a2;
logic en_1a3;
logic en_1b1;
logic en_1b2;
logic en_1b3;
logic en_1c1;
logic en_1c2;
logic en_1c3;

logic en_active_l1a;
logic en_active_l1b;
logic en_active_l3c;

assign load_l1a=en[0];
assign load_l1b=en[1];
assign load_l2a=en[2];
assign load_l2b=en[3];
assign load_l3a=en[4];
assign en_1a1=en[5];
assign en_1a2=en[6];
assign en_1a3=en[7];
assign en_1b1=en[8];
assign en_1b2=en[9];
assign en_1b3=en[10];
assign en_1c1=en[11];
assign en_1c2=en[12];
assign en_1c3=en[13];
assign en_active_l1a=en[14];
assign en_active_l1b=en[15];
assign en_active_l3c=en[16];
//biased outputs
logic [7:0] biased_1a1;
logic [7:0] biased_1a2;
logic [7:0] biased_1a3;
logic [7:0] biased_1b1;
logic [7:0] biased_1b2;
logic [7:0] biased_1b3;
logic [7:0] biased_1c1;
logic [7:0] biased_1c2;
logic [7:0] biased_1c3;

//output bus design
logic rdy_1a1;
logic rdy_1a2;
logic rdy_1a3;
logic rdy_1b1;
logic rdy_1b2;
logic rdy_1b3;
logic rdy_1c1;
logic rdy_1c2;
logic rdy_1c3;
logic rdy_act_l1a;
logic rdy_act_l1b;
logic rdy_act_l3a;

assign ready={rdy_1a1,rdy_1a2,rdy_1a3,rdy_1b1,rdy_1b2,rdy_1b3,rdy_1c1,rdy_1c2,rdy_1c3,rdy_act_l1a,rdy_act_l1b,rdy_act_l3a};

neuron_ff  #(8) l1a(.clk(clk), .load(load_l1a), .in(XOR_1),  .out(out_l1a)); 
neuron_ff  #(8) l1b(.clk(clk), .load(load_l1b), .in(XOR_2),  .out(out_l1b)); 
neuron_ff  #(8) l2a(.clk(clk), .load(load_l2a), .in(in_l2a), .out(out_l2a)); 
neuron_ff  #(8) l2b(.clk(clk), .load(load_l2b), .in(in_l2b), .out(out_l2b)); 
neuron_ff  #(8) l3a(.clk(clk), .load(load_l3a), .in(in_l3a),.out(XOR_ans)); 

neuron_ff  #(8) bias_l1(.clk(clk), .load(1'b1), .in(8'b1), .out(out_bias_1)); 
neuron_ff  #(8) bias_l2(.clk(clk), .load(1'b1), .in(8'b1), .out(out_bias_2)); 


one_io_bias layer_1a1(.clk(clk),.in(out_l1a),   .enable(en_1a1),.ready(rdy_1a1),.biased_out(biased_1a1),.biased_val(1'b1));
one_io_bias layer_1a2(.clk(clk),.in(out_l1b),   .enable(en_1a2),.ready(rdy_1a2),.biased_out(biased_1a2),.biased_val(1'b1));
one_io_bias layer_1a3(.clk(clk),.in(out_bias_1),.enable(en_1a3),.ready(rdy_1a3),.biased_out(biased_1a3),.biased_val(1'b1));
one_io_bias layer_1b1(.clk(clk),.in(out_l1a),   .enable(en_1b1),.ready(rdy_1b1),.biased_out(biased_1b1),.biased_val(1'b1));
one_io_bias layer_1b2(.clk(clk),.in(out_l1b),   .enable(en_1b2),.ready(rdy_1b2),.biased_out(biased_1b2),.biased_val(1'b1));
one_io_bias layer_1b3(.clk(clk),.in(out_bias_1),.enable(en_1b3),.ready(rdy_1b3),.biased_out(biased_1b3),.biased_val(1'b1));
one_io_bias layer_1c1(.clk(clk),.in(out_l2a),   .enable(en_1c1),.ready(rdy_1c1),.biased_out(biased_1c1),.biased_val(1'b1));
one_io_bias layer_1c2(.clk(clk),.in(out_l2b),   .enable(en_1c2),.ready(rdy_1c2),.biased_out(biased_1c2),.biased_val(1'b1));
one_io_bias layer_1c3(.clk(clk),.in(out_bias_2),.enable(en_1c3),.ready(rdy_1c3),.biased_out(biased_1c3),.biased_val(1'b1));



active active_l1a(.a(biased_1a1),.b(biased_1a2),.c(biased_1a3),.out(in_l2a),.rdy(rdy_act_l1a),.en(en_active_l1a));
active active_l1b(.a(biased_1b1),.b(biased_1b2),.c(biased_1b3),.out(in_l2b),.rdy(rdy_act_l1b),.en(en_active_l1b));
active active_l3a(.a(biased_1c1),.b(biased_1c2),.c(biased_1c3),.out(in_l3a),.rdy(rdy_act_l3a),.en(en_active_l3c));


FSM_test  ANN_feed_forward_MAIN_FSM(
    .clk(clk),
    .ready(ready),
    .en(en),
    .rst(1'b0),
    .test(test)
);



endmodule

