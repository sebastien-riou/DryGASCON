``
set configurations { {} {ACC_PIPE} {ACC_PIPE MIX_SHIFT_REG} }

::tgpp::renameOutput ""
foreach conf $configurations {
    ::tgpp::off all
    set c [list drygascon128]
    if {"" != $conf} {
        set c [concat $c $conf]
    }
    set name [join $c "_"].v
    #puts $name
    ::tgpp::on "$name"
``
//Configuration flags: "`$conf`"

`backtick`timescale 1ns / 1ps
`backtick`default_nettype none

``
set ACC_PIPE 0

set MIX_SHIFT_REG 0

set MIX_PIPE_IDX 0
set MIX_PIPE_XW 0
set MIX_PIPE_OUT 0

set CORE_PIPE 0

foreach a $conf {
    set $a 1
}

set MIX_PIPE [expr $MIX_PIPE_IDX | $MIX_PIPE_XW | $MIX_PIPE_OUT]

set CORE_PIPE_S0 $CORE_PIPE
if {$MIX_PIPE && $CORE_PIPE} {
    error "can't pipe both MIX and CORE"
}
set PIPE [expr $MIX_PIPE || $CORE_PIPE]
if {$PIPE && $MIX_SHIFT_REG} {
    error "can't pipe and use shift reg for MIX"
}
``

module birotr(
    input wire [64-1:0] din,
    input wire [ 6-1:0] shift,
    output reg [64-1:0] out
    );
wire [32-1:0] i0 = din[0*32+:32];
wire [32-1:0] i1 = din[1*32+:32];
wire [ 6-1:0] shift2 = shift>>1;
wire [ 6-1:0] shift3 = (shift2 + 1'b1) % 6'd32;
always @* begin
    if(shift & 1'b1) begin
        out[ 0+:32] = (i1>>shift2) | (i1 << (6'd32-shift2));
        out[32+:32] = (i0>>shift3) | (i0 << (6'd32-shift3));
    end else begin
        out[ 0+:32] = (i0>>shift2) | (i0 << (6'd32-shift2));
        out[32+:32] = (i1>>shift2) | (i1 << (6'd32-shift2));
    end
end
endmodule

module gascon5_round(
``if {$CORE_PIPE} {``
    input wire clk,
    input wire clk_en,
``}``
    input wire [320-1:0] din,
    input wire [4-1:0] round,
    output reg [320-1:0] out
    );
wire [5*6-1:0] rot_lut0 = {6'd07,6'd10,6'd01,6'd61,6'd19};
wire [5*6-1:0] rot_lut1 = {6'd40,6'd17,6'd06,6'd38,6'd28};
``
set rot_lut0 {6'd19 6'd61 6'd01 6'd10 6'd07}
set rot_lut1 {6'd28 6'd38 6'd06 6'd17 6'd40}
``
reg [7:0] round_constant;
always @* round_constant = (((4'hf - round)<<4) | round);
reg [320-1:0] add_constant_out;
always @* add_constant_out = din ^ {{5*64-8-2*64{1'b0}},round_constant,{2*64{1'b0}}};

reg [320-1:0] sbox_stage0;
``if {$CORE_PIPE_S0} {
    proc := {} {return "<="}
``
always @(posedge clk) if(clk_en) begin
``} else {
    proc := {} {return "="}
``
always @* begin
``}``
    sbox_stage0 `:=` add_constant_out;
``
set mid 2
set cwords 5
for {set i 0} {$i <= $mid} {incr i} {
    set d [expr 2*$i]
    set s [expr ($cwords + $d - 1) % $cwords]
``
    sbox_stage0[`$d`*64+:64] `:=`  add_constant_out[`$d`*64+:64] ^ add_constant_out[`$s`*64+:64];
``}``
end

reg [320-1:0] t;
always @* begin
``for {set i 0} {$i < $cwords} {incr i} {
    set s [expr ($i + 1) % $cwords]
``
    t[`$i`*64+:64] =  (~sbox_stage0[`$i`*64+:64]) & sbox_stage0[`$s`*64+:64];
``}``
end

reg [320-1:0] sbox_stage1;
always @* begin
``for {set i 0} {$i < $cwords} {incr i} {
    set s [expr ($i + 1) % $cwords]
``
    sbox_stage1[`$i`*64+:64] =  sbox_stage0[`$i`*64+:64] ^ t[`$s`*64+:64];
``}``
end

reg [320-1:0] sbox_stage2;
always @* begin
    sbox_stage2 = sbox_stage1;
``
for {set i 0} {$i <= $mid} {incr i} {
    set s [expr 2*$i]
    set d [expr ($s + 1) % $cwords]
``
    sbox_stage2[`$d`*64+:64] =  sbox_stage1[`$d`*64+:64] ^ sbox_stage1[`$s`*64+:64];
``}``
end

reg [320-1:0] sbox_stage3;
always @* begin
    sbox_stage3 = sbox_stage2;
    sbox_stage3[`$mid`*64+:64] = ~sbox_stage2[`$mid`*64+:64];
end

wire [320-1:0] lin_layer_r0;
wire [320-1:0] lin_layer_r1;
``for {set i 0} {$i < $cwords} {incr i} {
    set r0 [lindex $rot_lut0 $i]
    set r1 [lindex $rot_lut1 $i]
``
birotr u_birotr0`$i`(.out(lin_layer_r0[`$i`*64+:64]), .din(sbox_stage3[`$i`*64+:64]), .shift(`$r0`));
birotr u_birotr1`$i`(.out(lin_layer_r1[`$i`*64+:64]), .din(sbox_stage3[`$i`*64+:64]), .shift(`$r1`));
``}``

reg [320-1:0] lin_layer;
always @* begin
``for {set i 0} {$i < $cwords} {incr i} {``
    lin_layer[`$i`*64+:64] =  sbox_stage3[`$i`*64+:64] ^ lin_layer_r0[`$i`*64+:64] ^ lin_layer_r1[`$i`*64+:64];
``}``
end

always @* out = lin_layer;
endmodule


module mixsx32(
``if {$MIX_PIPE} {``
    input wire clk,
    input wire clk_en,
``}``
    input wire [320-1:0] c,
    input wire [128-1:0] x,
    input wire [10-1:0] d,
    output reg [320-1:0] out
    );
``for {set j 0} {$j<5} {incr j} {``
reg [2-1:0] idx`$j`;
reg [32-1:0] xw`$j`;
``  if {$MIX_PIPE_IDX} {``
always @(posedge clk) if(clk_en) idx`$j` <= d[`$j`*2+:2];
``  } else {``
always @* idx`$j` = d[`$j`*2+:2];
``  }``
``  if {$MIX_PIPE_XW} {``
always @(posedge clk) if(clk_en) xw`$j` <= x[idx`$j`*32+:32];
``  } else {``
always @* xw`$j` = x[idx`$j`*32+:32];
``  }``
``  if {$MIX_PIPE_OUT} {``
always @(posedge clk) if(clk_en) out[`$j`*64+:64] <= c[`$j`*64+:64] ^ {{32{1'b0}},xw`$j`};
``  } else {``
always @* out[`$j`*64+:64] = c[`$j`*64+:64] ^ {{32{1'b0}},xw`$j`};
``  }``
``}``
endmodule

``if {0} {

module gascon5_round(
    input [320-1:0] din,
    input [4-1:0] round,
    output reg [320-1:0] out
    );
wire [5*6-1:0] rot_lut0 = {6'd07,6'd10,6'd01,6'd61,6'd19};
wire [5*6-1:0] rot_lut1 = {6'd40,6'd17,6'd06,6'd38,6'd28};

always @* begin: ROUND
    reg [4-1:0] r;
    integer i;
    integer mid;
    integer cwords;
    integer d;
    integer s;
    reg [64-1:0] wi;
    reg [64-1:0] ws;
    reg [320-1:0] t;
    reg [320-1:0] c;
    integer dummy;

    c = din;
    mid = 2;
    cwords = 5;
    //$display("i: %x",c);
    //add constant
    r = round;
    c[mid*64+:64] = c[mid*64+:64] ^ (((4'hf - r)<<4) | r);
    //$display("c mid: %x, r=%x",c[mid*64+:64],r);
    //$display("c: %x",c);
    //sbox
    for(i=0;i<=2;i=i+1'b1) begin
        d = 2*i;
        s = (cwords + d - 1'b1) % cwords;
        c[d*64+:64] = c[d*64+:64] ^ c[s*64+:64];
    end

    for(i=0;i<cwords;i=i+1'b1) begin
        s = (i+1) % cwords;
        wi = c[i*64+:64];
        ws = c[s*64+:64];
        t[i*64+:64] = (~wi) & ws;
    end

    for(i=0;i<cwords;i=i+1'b1) begin
        s = (i+1) % cwords;
        c[i*64+:64] = c[i*64+:64] ^ t[s*64+:64];
    end

    for(i=0;i<=2;i=i+1'b1) begin
        s = 2*i;
        d = (s + 1'b1) % cwords;
        c[d*64+:64] = c[d*64+:64] ^ c[s*64+:64];
    end
    c[mid*64+:64] = ~c[mid*64+:64];
    //$display("c: %x",c);

    //linlayer
    for(i=0;i<3'd5;i=i+1'b1) begin
        c[i*64+:64] = c[i*64+:64] ^ birotr(c[i*64+:64],rot_lut0[i*6+:6]) ^ birotr(c[i*64+:64],rot_lut1[i*6+:6]);
    end

    //$display("c: %x",c);
    //$display("c: ");dummy=print_words64(c);
    out = c;
end
endmodule


module mixsx32_1(
    input wire [320-1:0] c,
    input wire [128-1:0] x,
    input wire [10-1:0] d,
    output reg [320-1:0] out
    );
always @* begin: MIX
    reg [320-1:0] co;
    reg [2-1:0] idx;
    reg [32-1:0] xw;
    integer j;
    co = c;
    for(j=0;j<5;j=j+1) begin
        idx = d[j*2+:2];
        xw = x[idx*32+:32];
        co[j*2*32+:32] = co[j*2*32+:32] ^ xw;
    end
    out = co;
end
endmodule
}
``

module accumulate(
    input wire [256-1:0] din,
    input wire [128-1:0] r,
    output reg [128-1:0] out
    );
always @* out = r ^ din[0+:128] ^ {din[128+:32],din[128+32+:96]};
endmodule



//F and G
module drygascon128(
    input wire clk,
    input wire clk_en,
    input wire rst,
    input wire [31:0] din,
    input wire [3:0] ds,
    input wire wr_i,
    input wire wr_c,
    input wire wr_x,
    input wire [3:0] rounds,
    input wire start,
    input wire rd_r,
    input wire rd_c,
    output reg [31:0] dout,
    output reg idle
    );

localparam C_QWORDS = 5;
localparam X_QWORDS = 2;
localparam R_QWORDS = 2;
localparam CIDX_WIDTH = 3;//log2(X_QWORDS)
localparam XIDX_WIDTH = 2;//log2(X_QWORDS*2)

localparam C_DWORDS = C_QWORDS * 2;
localparam C_WIDTH = C_QWORDS * 64;
localparam X_DWORDS = X_QWORDS * 2;
localparam X_WIDTH = X_QWORDS * 64;
localparam R_DWORDS = R_QWORDS*2;
localparam R_WIDTH = R_QWORDS*64;

reg [C_WIDTH-1:0] c;
reg [X_WIDTH-1:0] x;
reg [R_WIDTH-1:0] r;

reg absorb;
reg [3:0] cnt;

always @(posedge clk) begin
    if(clk_en) begin
        case(1'b1)
        rd_c: dout <= c[cnt*32+:32];
        rd_r: dout <= r[cnt*32+:32];
        default: dout <= {32{1'b0}};
        endcase
    end
end

localparam D_WIDTH = C_QWORDS*XIDX_WIDTH;
localparam MIX_ROUNDS = (R_WIDTH+4+D_WIDTH-1)/D_WIDTH;
reg [D_WIDTH-1:0] d;
wire [C_WIDTH-1:0] mixsx32_out;
reg [C_WIDTH-1:0] core_in;
reg [3:0] core_round;
wire [C_WIDTH-1:0] core_out;
wire [128-1:0] accu_out;

``if {0==$MIX_SHIFT_REG} {``
localparam MIX_I_PAD = D_WIDTH*MIX_ROUNDS - R_WIDTH+4;
reg [D_WIDTH*MIX_ROUNDS-1:0] mix_i;
always @* mix_i = {{MIX_I_PAD{1'b0}},ds,r};
always @* d = mix_i[cnt*D_WIDTH+:D_WIDTH];
``}``
``if {$MIX_PIPE} {``
mixsx32 u_mixsx32(.clk(clk), .clk_en(clk_en), .out(mixsx32_out), .c(c), .x(x), .d(d));
``} else {``
mixsx32 u_mixsx32(.out(mixsx32_out), .c(c), .x(x), .d(d));
``}``
always @* core_in = absorb ? mixsx32_out : c;
always @* core_round = absorb ? {4{1'b0}} : cnt;
``if {$CORE_PIPE} {``
gascon5_round u_gascon5_round(.clk(clk), .clk_en(clk_en), .out(core_out), .din(core_in), .round(core_round));
``} else {``
gascon5_round u_gascon5_round(.out(core_out), .din(core_in), .round(core_round));
``}``
``if {$CORE_PIPE || $MIX_PIPE} {``
reg pipe_out_valid;
``}``
``if {$ACC_PIPE} {``
accumulate u_accumulate(.out(accu_out), .din(c[0+:256]), .r(r));
``} else {``
accumulate u_accumulate(.out(accu_out), .din(core_out[0+:256]), .r(r));
``}``

localparam STATE_WIDTH = 2;
localparam STATE_IDLE = 2'b00;
localparam STATE_MIX_ENTRY = 2'b01;
localparam STATE_G_ENTRY = 2'b10;
``if {$ACC_PIPE} {``
localparam STATE_G_EXIT = 2'b11;
``}``
reg [STATE_WIDTH-1:0] state;

always @(posedge clk) begin
    if(clk_en) begin
        if(rst) begin
            state <= STATE_IDLE;
            absorb <= 1'b0;
            cnt <= {4{1'b0}};
            idle <= 1'b1;
``if {$PIPE} {``
            pipe_out_valid <= 1'b0;
``}``
        end else begin
            case(state)
            STATE_IDLE: begin
                if(wr_i) begin
                    r[cnt*32+:32] <= din;
                    absorb <= 1'b1;
                end
                if(wr_c) begin
                    c[cnt*32+:32] <= din;
                end
                if(wr_x) begin
                    x <= {din,x[32+:X_WIDTH-32]};
                end
                case(1'b1)
                wr_c,rd_c: cnt <= (cnt + 1'b1) % C_DWORDS;
                wr_x:      cnt <= (cnt + 1'b1) % X_DWORDS;
                wr_i,rd_r: cnt <= (cnt + 1'b1) % R_DWORDS;
                endcase
                if(start) begin
                    if(absorb) begin
                        state <= STATE_MIX_ENTRY;
``if {$MIX_SHIFT_REG} {``
                        d <= r[0+:D_WIDTH];
                        r <= {{D_WIDTH-4{1'b0}},ds,r[D_WIDTH+:R_WIDTH-D_WIDTH]};
``}``
                    end else begin
                        r <= {R_WIDTH{1'b0}};
                        state <= STATE_G_ENTRY;
                    end
                    cnt <= {4{1'b0}};
                    idle <= 1'b0;
``if {$PIPE} {``
                    pipe_out_valid <= 1'b0;
``}``
                end
            end
            STATE_MIX_ENTRY: begin
``if {$PIPE} {``
                pipe_out_valid <= ~pipe_out_valid;
                if(pipe_out_valid) begin
``}``
``if {$MIX_SHIFT_REG} {``
                d <= r[0+:D_WIDTH];
                r <= {{D_WIDTH{1'b0}},r[D_WIDTH+:R_WIDTH-D_WIDTH]};
``}``
                c <= core_out;
                if(MIX_ROUNDS-2==cnt) begin
                    r <= {R_WIDTH{1'b0}};
                    cnt <= cnt +1'b1;//to get last chunk
                    state <= STATE_G_ENTRY;//let absorb for the first round to consume last chunk
                end else begin
                    cnt <= cnt +1'b1;
                end
``if {$PIPE} {``
                end
``}``
            end
            STATE_G_ENTRY: begin
``if {$MIX_PIPE} {``
                pipe_out_valid <= 1'b1;
``}``
``if {$CORE_PIPE} {``
                pipe_out_valid <= ~pipe_out_valid;
``}``
``if {$PIPE} {``
                if(pipe_out_valid) begin
``}``
                //$display("round = %d",core_round);
                //$display("core_in:  %X",int_to_le(core_in));
                //$display("core_out: %X",int_to_le(core_out));
                //$display("accu_out: %X",int128_to_le(accu_out));
                absorb <= 1'b0;
                c <= core_out;
``if {$ACC_PIPE} {``
                if(!absorb && (cnt >= 1)) r <= accu_out;
``} else {``
                r <= accu_out;
``}``
                if(rounds-1==cnt) begin
                    cnt <= {4{1'b0}};
``if {$ACC_PIPE} {``
                    state <= STATE_G_EXIT;
``} else {``
                    state <= STATE_IDLE;
                    idle <= 1'b1;
``}``
                end else begin
                    cnt <= absorb ? {{3{1'b0}},1'b1} : cnt +1'b1;
                end
``if {$PIPE} {``
                end
``}``
            end
``if {$ACC_PIPE} {``
            STATE_G_EXIT: begin
                r <= accu_out;
                state <= STATE_IDLE;
                idle <= 1'b1;
            end
``}``
            default: begin
            end
            endcase
        end
    end
end

endmodule
`backtick`default_nettype wire
``}``
