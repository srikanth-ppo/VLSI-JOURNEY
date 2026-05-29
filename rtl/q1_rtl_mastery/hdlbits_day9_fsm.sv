// ============================
// HDLBits - Finite State Machines
// Day 9 - 29 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Moore FSM - 2 states, async reset to B
module top_module(
    input clk,
    input areset,
    input in,
    output out
);
    parameter A=0, B=1;
    reg state, next_state;

    always @(*) begin
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= B;
        else        state <= next_state;
    end

    assign out = (state == B);
endmodule

// ============================
// 2. Moore FSM - 2 states, sync reset to B
module top_module(clk, reset, in, out);
    input clk, reset, in;
    output reg out;

    parameter A=0, B=1;
    reg present_state, next_state;

    always @(*) begin
        case (present_state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) present_state <= B;
        else       present_state <= next_state;
    end

    always @(*) begin
        case (present_state)
            A: out = 0;
            B: out = 1;
        endcase
    end
endmodule

// ============================
// 3. JK FSM - async reset to OFF
module top_module(
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    parameter OFF=0, ON=1;
    reg state, next_state;

    always @(*) begin
        case (state)
            OFF: next_state = j ? ON  : OFF;
            ON:  next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= OFF;
        else        state <= next_state;
    end

    assign out = (state == ON);
endmodule

// ============================
// 4. JK FSM - sync reset to OFF
module top_module(
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    parameter OFF=0, ON=1;
    reg state, next_state;

    always @(*) begin
        case (state)
            OFF: next_state = j ? ON  : OFF;
            ON:  next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= OFF;
        else       state <= next_state;
    end

    assign out = (state == ON);
endmodule

// ============================
// 5. FSM combinational only - next state + output
module top_module(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;

    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    always @(*) begin
        case (state)
            A: out = 0;
            B: out = 0;
            C: out = 0;
            D: out = 1;
        endcase
    end
endmodule

// ============================
// 6. One-hot FSM - by inspection
module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);
    parameter A=0, B=1, C=2, D=3;

    assign next_state[A] = (state[A] & ~in) | (state[C] & ~in);
    assign next_state[B] = (state[A] &  in) | (state[B] &  in) | (state[D] & in);
    assign next_state[C] = (state[B] & ~in) | (state[D] & ~in);
    assign next_state[D] = (state[C] &  in);

    assign out = state[D];
endmodule

// ============================
// 7. Full FSM - 4 states, async reset to A
module top_module(
    input clk,
    input in,
    input areset,
    output out
);
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else        state <= next_state;
    end

    assign out = (state == D);
endmodule

// ============================
// 8. Full FSM - 4 states, sync reset to A
module top_module(
    input clk,
    input in,
    input reset,
    output out
);
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A;
        else       state <= next_state;
    end

    assign out = (state == D);
endmodule

// ============================
// 9. Water reservoir FSM
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
);
    parameter A3=3'd0, A2=3'd1, A1=3'd2, A0=3'd3,
              B2=3'd4, B1=3'd5;

    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            A3: next_state = (s==3'b111) ? A3 :
                             (s==3'b011) ? B2 :
                             (s==3'b001) ? B1 : A0;
            A2: next_state = (s==3'b111) ? A3 :
                             (s==3'b011) ? A2 :
                             (s==3'b001) ? B1 : A0;
            A1: next_state = (s==3'b111) ? A3 :
                             (s==3'b011) ? A2 :
                             (s==3'b001) ? A1 : A0;
            A0: next_state = (s==3'b111) ? A3 :
                             (s==3'b011) ? A2 :
                             (s==3'b001) ? A1 : A0;
            B2: next_state = (s==3'b111) ? A3 :
                             (s==3'b011) ? B2 :
                             (s==3'b001) ? B1 : A0;
            B1: next_state = (s==3'b111) ? A3 :
                             (s==3'b011) ? A2 :
                             (s==3'b001) ? B1 : A0;
            default: next_state = A0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A0;
        else       state <= next_state;
    end

    assign fr3 = (state == A0);
    assign fr2 = (state == A0) | (state == A1) | (state == B1);
    assign fr1 = (state != A3);
    assign dfr = (state == A0) | (state == B1) | (state == B2);
endmodule
