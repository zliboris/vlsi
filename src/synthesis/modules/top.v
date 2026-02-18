module top #(
    parameter DIVISOR = 50000000,
    parameter FILE_NAME = "mem_init.mif",
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 16
) (
    input clk,
    input [1:0] kbd,
    input [2:0] btn,
    input [9:0] sw,
    output [13:0] mnt,
    output [9:0] led,
    output [27:0] ssd
);

// promena da odgovara portovima u topu jer su odlucili da nece da bude isto

wire rst_n = sw[9];
wire [27:0] hex = ssd;

// Wires for connecting

//inputs and outputs

wire [3:0] in = sw[3:0];
wire [6:0] ssd1_out;
wire [6:0] ssd2_out;
wire [6:0] ssd3_out;
wire [6:0] ssd4_out;


// Internal wires

wire clk_divided;

wire cpu_we;
wire [ADDR_WIDTH-1:0] cpu_addr;
wire [DATA_WIDTH-1:0] cpu_data;
wire [DATA_WIDTH-1:0] memory_out;
wire [DATA_WIDTH-1:0] cpu_out;

wire [ADDR_WIDTH-1:0] cpu_sp;
wire [ADDR_WIDTH-1:0] cpu_pc;

wire [3:0] bcd1_ones;
wire [3:0] bcd1_tens;

wire [3:0] bcd2_ones;
wire [3:0] bcd2_tens;

wire [15:0] ps2_code;
wire ps2_control;

wire cpu_status;
wire cpu_control;
wire [3:0] cpu_num;

wire [23:0] vga_code;

assign ssd = {ssd4_out, ssd3_out, ssd2_out, ssd1_out};
assign led[4:0] = cpu_out[4:0];
assign led[5] = cpu_status;
assign led[6] = ps2_control;
assign led[7] = cpu_control;
// ---------------------------------------------------
// Module Instantiations

clk_div #(
    .DIVISOR(DIVISOR)
) clk_div_inst (
    .clk(clk),
    .rst_n(rst_n),
    .out(clk_divided)
);

memory #(
    .FILE_NAME(FILE_NAME),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) memory_inst (
    .clk(clk_divided),
    .we(cpu_we),
    .addr(cpu_addr),
    .data(cpu_data),
    .out(memory_out)
);

cpu #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) cpu_inst (
    .clk(clk_divided),
    .rst_n(rst_n),
    .mem(memory_out),
    .in({{DATA_WIDTH-4{1'b0}}, cpu_num}),
    .status(cpu_status),
    .control(cpu_control),
    .we(cpu_we),
    .addr(cpu_addr),
    .data(cpu_data),
    .out(cpu_out),
    .pc(cpu_pc),
    .sp(cpu_sp)
);

bcd bcd1_inst (
    .in(cpu_pc),
    .ones(bcd1_ones),
    .tens(bcd1_tens)
);

bcd bcd2_inst (
    .in(cpu_sp),
    .ones(bcd2_ones),
    .tens(bcd2_tens)
);

ssd ssd1_inst (
    .in(bcd1_ones),
    .out(ssd1_out)
);

ssd ssd2_inst (
    .in(bcd1_tens),
    .out(ssd2_out)
);

ssd ssd3_inst (
    .in(bcd2_ones),
    .out(ssd3_out)
);

ssd ssd4_inst (
    .in(bcd2_tens),
    .out(ssd4_out)
);

ps2 ps2_inst (
    .rst_n(rst_n),
    .ps2_clk(kbd[0]),
    .ps2_data(kbd[1]),
    .control(ps2_control),
    .clk(clk),
    .clk_devided(clk_divided),
    .code(ps2_code)
);

scan_codes scan_codes_inst(
    .clk(clk_divided),
    .rst_n(rst_n),
    .code(ps2_code),
    .status(cpu_status),
    .ps2_control(ps2_control),
    .control(cpu_control),
    .num(cpu_num)
);


color_codes color_codes_inst (
    .num(cpu_out[5:0]),
    .code(vga_code)
);

vga vga_inst (
    .clk(clk),
    .rst_n(rst_n),
    .code(vga_code),
    .red(mnt[11:8]),
    .green(mnt[7:4]),
    .blue(mnt[3:0]),
    .hsync(mnt[13]),
    .vsync(mnt[12])
);

endmodule