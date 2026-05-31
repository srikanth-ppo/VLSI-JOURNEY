// ============================
// HDLBits - More FSM Problems
// Day 11 - 31 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Mealy FSM - sequence "101" detector with overlap
module top_module (
    input clk,
    input aresetn,
    input x,
    output z
);
    parameter S0=2'd0, S1=2'd1, S2=2'd2;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
        endcase
    end

    always @(posedge clk or negedge aresetn) begin
        if (~aresetn) state <= S0;
        else          state <= next_state;
    end

    assign z = (state == S2) & x;
endmodule

// ============================
// 2. Moore FSM - serial 2's complementer
module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    parameter A=2'd0, B=2'd1, C=2'd2;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = x ? C : B;
            C: next_state = x ? C : B;
            default: next_state = A;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else        state <= next_state;
    end

    assign z = (state == B);
endmodule

// ============================
// 3. Mealy FSM - serial 2's complementer one-hot
module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= 2'b01;
        else begin
            state[0] <= state[0] & ~x;
            state[1] <= (state[0] & x) | state[1];
        end
    end

    assign z = (state[0] & x) | (state[1] & ~x);
endmodule

// ============================
// 4. FSM - count exactly two w=1s in 3 cycles
module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output z
);
    parameter A=3'd0, B0=3'd1, B1=3'd2,
              C0=3'd3, C1=3'd4,
              D0=3'd5, D1=3'd6, D2=3'd7;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            A:  next_state = s ? B0 : A;
            B0: next_state = w ? C1 : C0;
            B1: next_state = w ? C1 : C0;
            C0: next_state = w ? D1 : D0;
            C1: next_state = w ? D2 : D1;
            D0: next_state = w ? B0 : B0;
            D1: next_state = w ? B1 : B0;
            D2: next_state = w ? B0 : B1;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A;
        else       state <= next_state;
    end

    assign z = (state == B1);
endmodule

// ============================
// 5. FSM - state assigned table implementation
module top_module (
    input clk,
    input reset,
    input x,
    output z
);
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= 3'b000;
        else       state <= next_state;
    end

    assign z = (state == 3'b011) | (state == 3'b100);
endmodule

// ============================
// 6. FSM - combinational Y[0] and z from state table
module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    assign Y0 = (~y[2] & ~y[1] & ~y[0] &  x) |
                (~y[2] & ~y[1] &  y[0] & ~x) |
                (~y[2] &  y[1] & ~y[0] &  x) |
                (~y[2] &  y[1] &  y[0] & ~x) |
                ( y[2] & ~y[1] & ~y[0] & ~x);

    assign z = (y == 3'b011) | (y == 3'b100);
endmodule

// ============================
// 7. FSM - next state Y2 by inspection
module top_module (
    input [3:1] y,
    input w,
    output Y2
);
    assign Y2 = (y == 3'b001) | (y == 3'b101) |
                (w & (y == 3'b010)) | (w & (y == 3'b100));
endmodule
