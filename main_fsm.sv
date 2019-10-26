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
        next=layer_1_init;
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