// ============================
// HDLBits - More Verilog Features
// Day 4 - 24 May 2026
// Q1 - RTL Mastery
// ============================

// 1. Minimum of 4 numbers - ternary operator tree
module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min
);
    wire [7:0] ab_min, cd_min;

    assign ab_min = (a < b) ? a : b;
    assign cd_min = (c < d) ? c : d;
    assign min    = (ab_min < cd_min) ? ab_min : cd_min;
endmodule

// ============================
// 2. Parity bit - reduction XOR
module top_module (
    input [7:0] in,
    output parity
);
    assign parity = ^in;
endmodule

// ============================
// 3. 100-input gates - reduction operators
module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;
endmodule

// ============================
// 4. 100-bit vector reversal - for loop in always block
module top_module( 
    input [99:0] in,
    output reg [99:0] out
);
    integer i;

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            out[i] = in[99 - i];
        end
    end
endmodule

// ============================
// 5. Population count - accumulator with for loop
module top_module( 
    input [254:0] in,
    output reg [7:0] out
);
    integer i;

    always @(*) begin
        out = 8'd0;
        for (i = 0; i < 255; i = i + 1) begin
            out = out + in[i];
        end
    end
endmodule

// ============================
// 6. 100-bit ripple carry adder - for loop with full adder logic
module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum
);
    integer i;

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 0) begin
                sum[i]  = a[i] ^ b[i] ^ cin;
                cout[i] = (a[i] & b[i]) | (cin & (a[i] ^ b[i]));
            end else begin
                sum[i]  = a[i] ^ b[i] ^ cout[i-1];
                cout[i] = (a[i] & b[i]) | (cout[i-1] & (a[i] ^ b[i]));
            end
        end
    end
endmodule

// ============================
// 7. 100-digit BCD ripple carry adder - generate + indexed part select
module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum
);
    wire [99:0] carry;

    genvar i;

    generate
        for (i = 0; i < 100; i = i + 1) begin : bcd_chain
            bcd_fadd digit (
                .a(a[4*i+3 : 4*i]),
                .b(b[4*i+3 : 4*i]),
                .cin(i == 0 ? cin : carry[i-1]),
                .sum(sum[4*i+3 : 4*i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[99];
endmodule
