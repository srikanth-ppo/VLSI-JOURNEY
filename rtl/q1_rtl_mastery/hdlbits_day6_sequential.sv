// ============================
// HDLBits - Sequential Logic
// Latches and Flip Flops
// Day 6 - 26 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Single D flip flop
module top_module (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk)
        q <= d;
endmodule

// ============================
// 2. 8-bit register
module top_module (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk)
        q <= d;
endmodule

// ============================
// 3. 8-bit register with synchronous reset
module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule

// ============================
// 4. 8-bit register - negedge + reset to 0x34
module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
        else
            q <= d;
    end
endmodule

// ============================
// 5. 8-bit register with async reset
module top_module (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule

// ============================
// 6. 16-bit register with byte enable and active-low reset
module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (~resetn)
            q <= 16'b0;
        else begin
            if (byteena[1]) q[15:8] <= d[15:8];
            if (byteena[0]) q[7:0]  <= d[7:0];
        end
    end
endmodule

// ============================
// 7. D latch
module top_module (
    input d,
    input ena,
    output reg q
);
    always @(*) begin
        if (ena)
            q = d;
    end
endmodule

// ============================
// 8. DFF with async reset
module top_module (
    input clk,
    input d,
    input ar,
    output reg q
);
    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// ============================
// 9. DFF with sync reset
module top_module (
    input clk,
    input d,
    input r,
    output reg q
);
    always @(posedge clk) begin
        if (r)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// ============================
// 10. DFF with OR feedback
module top_module (
    input clk,
    input in,
    output reg out
);
    always @(posedge clk)
        out <= in | out;
endmodule

// ============================
// 11. DFF with XOR feedback
module top_module (
    input clk,
    input in,
    output reg out
);
    always @(posedge clk)
        out <= in ^ out;
endmodule

// ============================
// 12. Shift register stage with mux - parallel load
module top_module (
    input clk,
    input L,
    input r_in,
    input q_in,
    output reg Q
);
    always @(posedge clk)
        Q <= L ? r_in : q_in;
endmodule

// ============================
// 13. Universal shift register stage - 3 modes
module top_module (
    input clk,
    input w, R, E, L,
    output reg Q
);
    always @(posedge clk)
        Q <= L ? R : (E ? w : Q);
endmodule

// ============================
// 14. FSM from circuit - 3 DFFs with feedback
module top_module (
    input clk,
    input x,
    output z
);
    reg Q1, Q2, Q3;

    always @(posedge clk) begin
        Q1 <= x ^ Q1;
        Q2 <= x & ~Q2;
        Q3 <= x | ~Q3;
    end

    assign z = ~(Q1 | Q2 | Q3);
endmodule

// ============================
// 15. JK flip flop using D flip flop
module top_module (
    input clk,
    input j,
    input k,
    output reg Q
);
    always @(posedge clk)
        Q <= (j & ~Q) | (~k & Q);
endmodule

// ============================
// 16. Positive edge detector - 8 bit
module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    reg [7:0] prev;

    always @(posedge clk) begin
        prev  <= in;
        pedge <= in & ~prev;
    end
endmodule

// ============================
// 17. Any edge detector - 8 bit
module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev;

    always @(posedge clk) begin
        prev    <= in;
        anyedge <= in ^ prev;
    end
endmodule

// ============================
// 18. Capture 1to0 transition - sticky SR register
module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);
    reg [31:0] prev;

    always @(posedge clk) begin
        prev <= in;
        if (reset)
            out <= 32'b0;
        else
            out <= out | (prev & ~in);
    end
endmodule

// ============================
// 19. Dual edge triggered flip flop emulation
module top_module (
    input clk,
    input d,
    output q
);
    reg p, n;

    always @(posedge clk) p <= d;
    always @(negedge clk) n <= d;

    assign q = clk ? p : n;
endmodule
