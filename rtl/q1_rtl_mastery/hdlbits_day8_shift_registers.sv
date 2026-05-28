// ============================
// HDLBits - Shift Registers
// Day 8 - 28 May 2026
// Q1 - RTL Mastery
// ============================

// 1. 4-bit shift register with async reset, load, enable
module top_module(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);
    always @(posedge clk or posedge areset) begin
        if (areset)     q <= 4'b0;
        else if (load)  q <= data;
        else if (ena)   q <= {1'b0, q[3:1]};
    end
endmodule

// ============================
// 2. 100-bit rotator - left/right
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);
    always @(posedge clk) begin
        if (load) q <= data;
        else begin
            case (ena)
                2'b01: q <= {q[0],   q[99:1]};   // rotate right
                2'b10: q <= {q[98:0], q[99]};    // rotate left
                default: q <= q;
            endcase
        end
    end
endmodule

// ============================
// 3. 64-bit arithmetic shift register
module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);
    always @(posedge clk) begin
        if (load) q <= data;
        else if (ena) begin
            case (amount)
                2'b00: q <= {q[62:0], 1'b0};           // left 1
                2'b01: q <= {q[55:0], 8'b0};           // left 8
                2'b10: q <= {q[63], q[63:1]};          // arith right 1
                2'b11: q <= {{8{q[63]}}, q[63:8]};     // arith right 8
            endcase
        end
    end
endmodule

// ============================
// 4. 5-bit Galois LFSR (taps at 5,3)
module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);
    always @(posedge clk) begin
        if (reset) q <= 5'h1;
        else begin
            q[4] <= q[0];
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule

// ============================
// 5. 3-bit LFSR with parallel load (DE1-SoC)
module top_module (
    input [2:0] SW,
    input [1:0] KEY,
    output [2:0] LEDR
);
    wire clk = KEY[0];
    wire L   = KEY[1];
    wire [2:0] Q;

    mux_dff stage0 (.clk(clk), .L(L), .r_in(SW[0]), .q_in(Q[2]),          .Q(Q[0]));
    mux_dff stage1 (.clk(clk), .L(L), .r_in(SW[1]), .q_in(Q[0]),          .Q(Q[1]));
    mux_dff stage2 (.clk(clk), .L(L), .r_in(SW[2]), .q_in(Q[1] ^ Q[2]),   .Q(Q[2]));

    assign LEDR = Q;
endmodule

module mux_dff (
    input clk, L, r_in, q_in,
    output reg Q
);
    always @(posedge clk)
        Q <= L ? r_in : q_in;
endmodule

// ============================
// 6. 32-bit Galois LFSR (taps at 32,22,2,1)
module top_module(
    input clk,
    input reset,
    output reg [31:0] q
);
    always @(posedge clk) begin
        if (reset) q <= 32'h1;
        else begin
            q[31] <= q[0];
            q[30] <= q[31];
            q[29] <= q[30];
            q[28] <= q[29];
            q[27] <= q[28];
            q[26] <= q[27];
            q[25] <= q[26];
            q[24] <= q[25];
            q[23] <= q[24];
            q[22] <= q[23];
            q[21] <= q[22] ^ q[0];
            q[20] <= q[21];
            q[19] <= q[20];
            q[18] <= q[19];
            q[17] <= q[18];
            q[16] <= q[17];
            q[15] <= q[16];
            q[14] <= q[15];
            q[13] <= q[14];
            q[12] <= q[13];
            q[11] <= q[12];
            q[10] <= q[11];
            q[9]  <= q[10];
            q[8]  <= q[9];
            q[7]  <= q[8];
            q[6]  <= q[7];
            q[5]  <= q[6];
            q[4]  <= q[5];
            q[3]  <= q[4];
            q[2]  <= q[3];
            q[1]  <= q[2] ^ q[0];
            q[0]  <= q[1] ^ q[0];
        end
    end
endmodule

// ============================
// 7. 4-bit shift register - active low reset
module top_module (
    input clk,
    input resetn,
    input in,
    output out
);
    reg [3:0] shift;

    always @(posedge clk) begin
        if (~resetn) shift <= 4'b0;
        else         shift <= {shift[2:0], in};
    end

    assign out = shift[3];
endmodule

// ============================
// 8. Universal shift register - 4 stages (DE2)
module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
);
    wire clk = KEY[0];
    wire E   = KEY[1];
    wire L   = KEY[2];
    wire w   = KEY[3];
    wire [3:0] Q;

    MUXDFF stage3 (.clk(clk), .E(E), .L(L), .w(w),    .R(SW[3]), .Q(Q[3]));
    MUXDFF stage2 (.clk(clk), .E(E), .L(L), .w(Q[3]), .R(SW[2]), .Q(Q[2]));
    MUXDFF stage1 (.clk(clk), .E(E), .L(L), .w(Q[2]), .R(SW[1]), .Q(Q[1]));
    MUXDFF stage0 (.clk(clk), .E(E), .L(L), .w(Q[1]), .R(SW[0]), .Q(Q[0]));

    assign LEDR = Q;
endmodule

module MUXDFF (
    input clk, E, L, w, R,
    output reg Q
);
    always @(posedge clk)
        Q <= L ? R : (E ? w : Q);
endmodule

// ============================
// 9. 3-input LUT using shift register
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z
);
    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    assign Z = Q[{A, B, C}];
endmodule

// ============================
// 10. Rule 90 cellular automaton - 512 cells
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    always @(posedge clk) begin
        if (load) q <= data;
        else      q <= {q[510:0], 1'b0} ^ {1'b0, q[511:1]};
    end
endmodule

// ============================
// 11. Rule 110 cellular automaton - 512 cells
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] L = {1'b0, q[511:1]};
    wire [511:0] R = {q[510:0], 1'b0};

    always @(posedge clk) begin
        if (load) q <= data;
        else
            q <= (~L & ~q & R) |
                 (~L &  q & ~R) |
                 (~L &  q &  R) |
                 ( L & ~q &  R) |
                 ( L &  q & ~R);
    end
endmodule

// ============================
// 12. Conway's Game of Life - 16x16 toroid
module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    integer i;
    reg [3:0] count;
    reg [255:0] next;

    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            integer row, col, r1, r_1, c1, c_1;
            row = i / 16;
            col = i % 16;
            r1  = ((row + 1)  % 16) * 16;
            r_1 = ((row + 15) % 16) * 16;
            c1  = (col + 1)  % 16;
            c_1 = (col + 15) % 16;

            count = q[r_1 + c_1] + q[r_1 + col] + q[r_1 + c1] +
                    q[row*16 + c_1]              + q[row*16 + c1] +
                    q[r1  + c_1] + q[r1  + col] + q[r1  + c1];

            case (count)
                4'd2:    next[i] = q[i];
                4'd3:    next[i] = 1;
                default: next[i] = 0;
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) q <= data;
        else      q <= next;
    end
endmodule
