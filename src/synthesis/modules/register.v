module register #(
    parameter DATA_WIDTH = 16,
    parameter INIT_VALUE = 0
) (
    input clk,
    input rst_n,
    input cl,
    input ld,
    input [DATA_WIDTH-1:0] in,
    input inc,
    input dec,
    input sr,
    input ir,
    input sl,
    input il,
    output [DATA_WIDTH-1:0] out
);

reg [DATA_WIDTH-1:0] r_out = INIT_VALUE;
assign out = r_out;

always @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        r_out <= INIT_VALUE; 
    end
    else if(cl) begin
        r_out <= {DATA_WIDTH{1'b0}};
    end
    else if(ld) begin
        r_out <= in;
    end
    else if(inc) begin
        r_out <= r_out + 1;
    end
    else if(dec) begin
        r_out <= r_out - 1;
    end
    else if(sr) begin
        r_out <= {ir, r_out[DATA_WIDTH-1:1]};
    end
    else if(sl) begin
        r_out <= {r_out[DATA_WIDTH-2:0], il};
    end

end

endmodule
