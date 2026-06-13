//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  pipeline_reg.sv
// Desc:    Generic parameterized pipeline register
//          Supports stall and flush control
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module pipeline_reg #(
    parameter WIDTH = 32
)(
    input  logic             clk,
    input  logic             rst,
    input  logic             stall,
    input  logic             flush,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    always_ff @(posedge clk) begin
        if (rst || flush)
            q <= '0;
        else if (!stall)
            q <= d;
    end

endmodule
