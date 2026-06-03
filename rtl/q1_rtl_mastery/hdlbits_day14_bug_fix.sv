# Day 14 — Bug Fixing Section (03 June 2026)

## Q1 - RTL Mastery | HDLBits Bug Fixing Problems

// ============================
// 1. Bugs_mux2
module top_module (
input sel,
input [7:0] a,
input [7:0] b,
output [7:0] out
);

```
assign out = (~sel & a) | (sel & b);
```

endmodule

// ============================
// 2. Bugs_mux4
module top_module (
input [1:0] sel,
input [7:0] a,
input [7:0] b,
input [7:0] c,
input [7:0] d,
output [7:0] out
);

```
wire [7:0] mux0_out, mux1_out;

mux2 u0 (sel[0], a, b, mux0_out);
mux2 u1 (sel[0], c, d, mux1_out);
mux2 u2 (sel[1], mux0_out, mux1_out, out);
```

endmodule

// ============================
// 3. Bugs_addsubz
module top_module (
input do_sub,
input [7:0] a,
input [7:0] b,
output reg [7:0] out,
output reg result_is_zero
);

```
always @(*) begin
    if (do_sub)
        out = a - b;
    else
        out = a + b;

    result_is_zero = (out == 8'b0);
end
```

endmodule

// ============================
// 4. Bugs_case
module top_module (
input [7:0] code,
output reg [3:0] out,
output reg valid
);

```
always @(*) begin
    valid = 1'b1;

    case (code)
        8'h45: out = 4'd0;
        8'h16: out = 4'd1;
        8'h1e: out = 4'd2;
        8'h26: out = 4'd3;
        8'h25: out = 4'd4;
        8'h2e: out = 4'd5;
        8'h36: out = 4'd6;
        8'h3d: out = 4'd7;
        8'h3e: out = 4'd8;
        8'h46: out = 4'd9;

        default: begin
            valid = 1'b0;
            out = 4'd0;
        end
    endcase
end
```

endmodule
