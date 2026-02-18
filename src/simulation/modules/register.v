module register(
    input clk,
    input rst_n,
    input cl,
    input ld,
    input [3:0] in,
    input inc,
    input dec,
    input sr,
    input ir,
    input sl,
    input il,
    output [3:0] out
);

reg [3:0] r_out = 0;
assign out = r_out;

always @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        r_out <= 4'b0000;
    end
    else if(cl) begin
        r_out <= 4'b0000;
    end
    else if(ld) begin
        r_out <= in;
    end
    else if(inc) begin
        r_out <= r_out + 4'b0001;
    end
    else if(dec) begin
        r_out <= r_out - 4'b0001;
    end
    else if(sr) begin
        r_out <= {ir, r_out[3:1]};
    end
    else if(sl) begin
        r_out <= {r_out[2:0], il};
    end

end

endmodule