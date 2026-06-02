// ============================
// HDLBits - FSM Sequential Section
// Day 13 - 02 June 2026
// Q1 - RTL Mastery
// ============================

// 1. Mod-1000 Counter
module top_module (
input clk,
input reset,
output reg [9:0] q
);

always @(posedge clk) begin
if (reset)
q <= 10'd0;
else if (q == 10'd999)
q <= 10'd0;
else
q <= q + 10'd1;
end

endmodule

// ============================
// 2. Shift Register + Down Counter
module top_module (
input clk,
input shift_ena,
input count_ena,
input data,
output reg [3:0] q
);

always @(posedge clk) begin
if (shift_ena)
q <= {q[2:0], data};
else if (count_ena)
q <= q - 1'b1;
end

endmodule

// ============================
// 3. 1101 Sequence Detector FSM
module top_module (
input clk,
input reset,
input data,
output start_shifting
);

reg [2:0] state;

parameter A = 3'd0,
B = 3'd1,
C = 3'd2,
D = 3'd3,
E = 3'd4;

always @(posedge clk) begin
if (reset)
state <= A;
else begin
case (state)
A: state <= data ? B : A;
B: state <= data ? C : A;
C: state <= data ? C : D;
D: state <= data ? E : A;
E: state <= E;
default: state <= A;
endcase
end
end

assign start_shifting = (state == E);

endmodule

// ============================
// 4. FSM Shift Enable Logic
module top_module (
input clk,
input reset,
output shift_ena
);

reg [2:0] count;

always @(posedge clk) begin
if (reset)
count <= 3'd0;
else if (count < 3'd4)
count <= count + 1'b1;
end

assign shift_ena = (count < 3'd4);

endmodule

// ============================
// 5. Combined Timer FSM
module top_module (
input clk,
input reset,
input data,
output shift_ena,
output counting,
input done_counting,
output done,
input ack
);

reg [3:0] state;

parameter S      = 4'd0,
S1     = 4'd1,
S11    = 4'd2,
S110   = 4'd3,
B0     = 4'd4,
B1     = 4'd5,
B2     = 4'd6,
B3     = 4'd7,
COUNT  = 4'd8,
WAIT   = 4'd9;

always @(posedge clk) begin
if (reset)
state <= S;
else begin
case (state)
S:    state <= data ? S1 : S;
S1:   state <= data ? S11 : S;
S11:  state <= data ? S11 : S110;
S110: state <= data ? B0 : S;
B0:   state <= B1;
B1:   state <= B2;
B2:   state <= B3;
B3:   state <= COUNT;
COUNT: state <= done_counting ? WAIT : COUNT;
WAIT: state <= ack ? S : WAIT;
default: state <= S;
endcase
end
end

assign shift_ena = (state == B0) || (state == B1) ||
(state == B2) || (state == B3);

assign counting = (state == COUNT);

assign done = (state == WAIT);

endmodule

// ============================
// 6. Full Timer System
module top_module (
input clk,
input reset,
input data,
output [3:0] count,
output counting,
output done,
input ack
);

parameter S      = 4'd0,
S1     = 4'd1,
S11    = 4'd2,
S110   = 4'd3,
B0     = 4'd4,
B1     = 4'd5,
B2     = 4'd6,
B3     = 4'd7,
COUNT  = 4'd8,
WAIT   = 4'd9;

reg [3:0] state;
reg [3:0] delay;
reg [9:0] cnt1000;
reg [3:0] count_reg;

always @(posedge clk) begin
if (reset)
state <= S;
else begin
case (state)
S:    state <= data ? S1 : S;
S1:   state <= data ? S11 : S;
S11:  state <= data ? S11 : S110;
S110: state <= data ? B0 : S;
B0:   state <= B1;
B1:   state <= B2;
B2:   state <= B3;
B3:   state <= COUNT;

```
        COUNT: begin
            if ((cnt1000 == 10'd999) && (count_reg == 4'd0))
                state <= WAIT;
            else
                state <= COUNT;
        end

        WAIT: state <= ack ? S : WAIT;

        default: state <= S;
    endcase
end
```

end

always @(posedge clk) begin
if (reset)
delay <= 4'd0;
else begin
case (state)
B0, B1, B2, B3:
delay <= {delay[2:0], data};
endcase
end
end

always @(posedge clk) begin
if (reset) begin
cnt1000 <= 10'd0;
count_reg <= 4'd0;
end
else if (state == B3) begin
cnt1000 <= 10'd0;
count_reg <= {delay[2:0], data};
end
else if (state == COUNT) begin
if (cnt1000 == 10'd999) begin
cnt1000 <= 10'd0;

```
        if (count_reg != 4'd0)
            count_reg <= count_reg - 1'b1;
    end
    else begin
        cnt1000 <= cnt1000 + 1'b1;
    end
end
```

end

assign counting = (state == COUNT);
assign done = (state == WAIT);
assign count = count_reg;

endmodule

// ============================
// 7. One-Hot FSM Logic
module top_module(
input d,
input done_counting,
input ack,
input [9:0] state,
output B3_next,
output S_next,
output S1_next,
output Count_next,
output Wait_next,
output done,
output counting,
output shift_ena
);

parameter S=0, S1=1, S11=2, S110=3,
B0=4, B1=5, B2=6, B3=7,
Count=8, Wait=9;

assign B3_next = state[B2];

assign S_next = (state[S] & ~d) |
(state[S1] & ~d) |
(state[S110] & ~d) |
(state[Wait] & ack);

assign S1_next = (state[S] & d);

assign Count_next = state[B3] |
(state[Count] & ~done_counting);

assign Wait_next = (state[Count] & done_counting) |
(state[Wait] & ~ack);

assign done = state[Wait];

assign counting = state[Count];

assign shift_ena = state[B0] |
state[B1] |
state[B2] |
state[B3];

endmodule

// ============================
// Topics Practiced Today
// - FSM Design
// - Sequence Detection
// - Counters
// - Shift Registers
// - One-Hot Encoding
// - Sequential Logic
// - Timer Design
// - Datapath + Control Path
// ============================
