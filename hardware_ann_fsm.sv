module FSM_test(
    input logic clk,
    input logic [11:0] ready,
    output logic [16:0] en,
    input logic rst,
    input logic test
);

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

assign rdy_1a1=ready[11];
assign rdy_1a2=ready[10];
assign rdy_1a3=ready[9];
assign rdy_1b1=ready[8];
assign rdy_1b2=ready[7];
assign rdy_1b3=ready[6];
assign rdy_1c1=ready[5];
assign rdy_1c2=ready[4];
assign rdy_1c3=ready[3];
assign rdy_act_l1a=ready[2];
assign rdy_act_l1b=ready[1];
assign rdy_act_l3a=ready[0];

assign en[0]=load_l1a;
assign en[1]=load_l1b;
assign en[2]=load_l2a;
assign en[3]=load_l2b;
assign en[4]=load_l3a;

assign en[5]=en_1a1;
assign en[6]=en_1a2;
assign en[7]=en_1a3;
assign en[8]=en_1b1;
assign en[9]=en_1b2;
assign en[10]=en_1b3;
assign en[11]=en_1c1;
assign en[12]=en_1c2;
assign en[13]=en_1c3;

assign en[14]=en_active_l1a;
assign en[15]=en_active_l1b;
assign en[16]=en_active_l3c;

`define halt 6'd0

`define rst 6'd1

`define layer_1_init 6'd2
`define layer_1_act 6'd3
`define layer_1_vdff 6'd4

`define layer_2_init 6'd5
`define layer_2_act 6'd6
`define layer_2_vdff 6'd7

`define layer_3_init 6'd8
`define layer_3_act 6'd9
`define layer_3_vdff 6'd10

`define done 6'd11

logic [5:0] curr_state,next_state;
logic [5:0] next;

always @(posedge clk) begin
    casex({curr_state})
    `halt: if ( test===1'b1 ) begin
         next=`layer_1_init;
    end else begin
        next=`halt;
    end
    `rst: if ( rst==1'b0 ) begin
        next=`halt;
    end else begin
        next=`rst;
    end
    `layer_1_init: if (( ((rdy_1a1)&&(rdy_1a2)&&(rdy_1a3))==1'b1 )&&( ((rdy_1b1)&&(rdy_1b2)&&(rdy_1b3))==1'b1 )) begin
        next=`layer_1_act;
    end else begin
        next=`layer_1_init;
    end
    `layer_1_act: if (( ((rdy_1a1)&&(rdy_1a2)&&(rdy_1a3))==1'b1 )&&( ((rdy_1b1)&&(rdy_1b2)&&(rdy_1b3))==1'b1 )) begin
        next=`layer_1_vdff;
    end else begin
        next=`layer_1_act;
    end

    `layer_1_vdff: if ( ((rdy_1c1)&&(rdy_1c2)&&(rdy_1c3))==1'b1) begin
        next=`layer_3_init;
    end else begin
        next=`layer_1_vdff;
    end
    
    `layer_3_init: if ( ((rdy_1c1)&&(rdy_1c2)&&(rdy_1c3))==1'b1) begin
        next=`layer_3_act;
    end else begin
        next=`layer_3_init;
    end

    `layer_3_act: if ( ((rdy_1c1)&&(rdy_1c2)&&(rdy_1c3))==1'b1) begin
        next=`layer_3_vdff;
    end else begin
        next=`layer_3_act;
    end
    `layer_3_vdff: if(test==1'b1) begin
        next=`layer_1_init;
        end else begin
            next=`halt;
        end
        default: next=`rst;        
    endcase
end

assign next_state=next;

vDFF #(6) FSM_VDFF(
    .clk(clk),
    .load(1'b1),
    .out(curr_state),
    .in(next_state)
);

always @(posedge clk) begin
    casex({curr_state}) 
    `halt : begin 
            load_l1a     =1'b1;
            load_l1b     =1'b1;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b0;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;
            en_active_l1a=1'b0;
            en_active_l1b=1'b0;
            en_active_l3c=1'b0;
    end
    `rst :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b0;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;
            en_active_l1a=1'b0;
            en_active_l1b=1'b0;
            en_active_l3c=1'b0;
    end
    `layer_1_init :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b0;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;
            en_active_l1a=1'b0;
            en_active_l1b=1'b0;
            en_active_l3c=1'b0;
    end

    `layer_1_act  :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b0;

            en_1a1       =1'b1;
            en_1a2       =1'b1;
            en_1a3       =1'b1;
            en_1b1       =1'b1;
            en_1b2       =1'b1;
            en_1b3       =1'b1;

            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;

            en_active_l1a=1'b0;
            en_active_l1b=1'b0;

            en_active_l3c=1'b0;
    end
     `layer_1_vdff :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b0;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;
            en_active_l1a=1'b1;
            en_active_l1b=1'b1;
            en_active_l3c=1'b0;
    end

    `layer_3_init :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b1;
            load_l2b     =1'b1;
            load_l3a     =1'b0;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;
            en_active_l1a=1'b0;
            en_active_l1b=1'b0;
            en_active_l3c=1'b0;
    end
    `layer_3_act  :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b0;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b1;
            en_1c2       =1'b1;
            en_1c3       =1'b1;
            en_active_l1a=1'b0;
            en_active_l1b=1'b0;
            en_active_l3c=1'b0;
    end

    `layer_3_vdff :begin 
            load_l1a     =1'b0;
            load_l1b     =1'b0;
            load_l2a     =1'b0;
            load_l2b     =1'b0;
            load_l3a     =1'b1;
            en_1a1       =1'b0;
            en_1a2       =1'b0;
            en_1a3       =1'b0;
            en_1b1       =1'b0;
            en_1b2       =1'b0;
            en_1b3       =1'b0;
            en_1c1       =1'b0;
            en_1c2       =1'b0;
            en_1c3       =1'b0;
            en_active_l1a=1'b0;
            en_active_l1b=1'b0;
            en_active_l3c=1'b1;
    end
    
endcase
end

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
neuron_ff  #(8) l3a(.clk(clk), .load(load_l3a), .in(in_l3a), .out(XOR_ans)); 

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

module neuron_ff(clk, load, in, out); 
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

`define rdy 4'd2
`define procressing 4'd3



always_ff@(posedge clk)

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

module active(a,b,c,out,rdy,en);
input[7:0] a,b,c;
output [7:0] out;
output rdy;
input en;


assign out= a+b+c;
assign rdy=1'b1;


// will improve;
endmodule

