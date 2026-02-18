module clk_div #(
    parameter DIVISOR = 50000000
) (
    input clk,
    input rst_n,
    output reg out = 0
);

integer counter = 0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        out <= 1'b0;
    end
    else if (counter >= DIVISOR / 2 - 1) begin
        counter <= 0;
        out <= ~out;
    end
    else begin
        counter <= counter + 1;
    end
end

endmodule
