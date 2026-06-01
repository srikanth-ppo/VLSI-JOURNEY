// ============================
// HDLBits - FSM and Sequential
// Day 12 - 01 Jun 2026
// Q1 - RTL Mastery
// ============================

// 1. One-hot FSM - Y2 and Y4 by inspection
module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);
    // Y2 = B: incoming from A(w=1)
    assign Y2 = y[1] & w;

    // Y4 = D: incoming from B,C,E,F all on w=1
    assign Y4 = (y[2] & w) | (y[3] & w) |
                (y[5] & w) | (y[6] & w);
endmodule

// ============================
// 2. Full FSM implementation - 6 states
module top_module (
    input clk,
    input reset,
    input w,
    output z
);
    parameter A=3'd0, B=3'd1, C=3'd2,
              D=3'd3, E=3'd4, F=3'd5;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : C;
            F: next_state = w ? D : F;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A;
        else       state <= next_state;
    end

    assign z = (state == E) | (state == F);
endmodule

// ============================
// 3. FSM - another 6-state implementation
module top_module (
    input clk,
    input reset,
    input w,
    output z
);
    parameter A=3'd0, B=3'd1, C=3'd2,
              D=3'd3, E=3'd4, F=3'd5;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : C;
            F: next_state = w ? D : F;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A;
        else       state <= next_state;
    end

    assign z = (state == E) | (state == F);
endmodule

// ============================
// 4. One-hot FSM - Y1 and Y3 by inspection
module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // Y1 = B: incoming from A(w=1)
    assign Y1 = y[0] & w;

    // Y3 = D: incoming from B,C,E,F all on w=0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);
endmodule

// ============================
// 5. Priority arbiter FSM
module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);
    parameter A=2'd0, B=2'd1, C=2'd2, D=2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: begin
                if (r[1])      next_state = B;
                else if (r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else           next_state = A;
            end
            B: next_state = r[1] ? B : A;
            C: next_state = r[2] ? C : A;
            D: next_state = r[3] ? D : A;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (~resetn) state <= A;
        else         state <= next_state;
    end

    assign g[1] = (state == B);
    assign g[2] = (state == C);
    assign g[3] = (state == D);
endmodule

// ============================
// 6. Motor controller FSM
module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    parameter A=4'd0, B=4'd1, C=4'd2, D=4'd3,
              E=4'd4, F=4'd5, G=4'd6,
              H=4'd7, I=4'd8;
    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = B;
            B: next_state = C;
            C: next_state = x ? D : C;
            D: next_state = x ? D : E;
            E: next_state = x ? F : C;
            F: next_state = y ? H : G;
            G: next_state = y ? H : I;
            H: next_state = H;
            I: next_state = I;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (~resetn) state <= A;
        else         state <= next_state;
    end

    assign f = (state == B);
    assign g = (state == F) | (state == G) | (state == H);
endmodule

// ============================
// 7. UART with parity - complete solution
module top_module(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);
    parameter IDLE=4'd0, B0=4'd1, B1=4'd2, B2=4'd3,
              B3=4'd4, B4=4'd5, B5=4'd6, B6=4'd7,
              B7=4'd8, PAR=4'd9, STOP=4'd10,
              WAIT=4'd11, DONE=4'd12;

    reg [3:0] state, next;
    wire odd;

    always @(*) begin
        case(state)
            IDLE: next = in ? IDLE : B0;
            B0:   next = B1;
            B1:   next = B2;
            B2:   next = B3;
            B3:   next = B4;
            B4:   next = B5;
            B5:   next = B6;
            B6:   next = B7;
            B7:   next = PAR;
            PAR:  next = STOP;
            STOP: next = in ? (odd ? DONE : IDLE) : WAIT;
            WAIT: next = in ? IDLE : WAIT;
            DONE: next = in ? IDLE : B0;
            default: next = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else       state <= next;
    end

    always @(posedge clk) begin
        case(state)
            B0: out_byte[0] <= in;
            B1: out_byte[1] <= in;
            B2: out_byte[2] <= in;
            B3: out_byte[3] <= in;
            B4: out_byte[4] <= in;
            B5: out_byte[5] <= in;
            B6: out_byte[6] <= in;
            B7: out_byte[7] <= in;
        endcase
    end

    assign done = (state == DONE);

    wire rst_par;
    assign rst_par = (state==IDLE)||(state==WAIT)||(state==DONE)||reset;

    parity u_par (.clk(clk), .reset(rst_par), .in(in), .odd(odd));
endmodule

// ============================
// 8. Circuit simplification - mt2015_q4
module top_module (
    input x,
    input y,
    output z
);
    assign z = x | ~y;
endmodule
