module vga (
    input clk,
    input rst_n,
    input [23:0] code,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hsync,
    output vsync
);

    integer x = 0;
    integer y = 0;

    assign red = (x < 800 && y < 600) ? (x < 400 ? code[23:20] : code[11:8]) : 4'b0;
    assign green = (x < 800 && y < 600) ? (x < 400 ? code[19:16] : code[7:4]) : 4'b0;
    assign blue = (x < 800 && y < 600) ? (x < 400 ? code[15:12] : code[3:0]) : 4'b0;
    assign hsync = (x > 855 && x < 975) ? 1'b1 : 1'b0;
    assign vsync = (y > 636 && y < 642) ? 1'b1 : 1'b0;

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x <= 0;
            y <= 0;
        end else begin
            if(x < 1039) begin
                x <= x + 1;
            end 
            if(x == 1039) begin
                y <= y + 1;
                x <= 0;
            end
            if(x == 1039 && y == 665) begin
                y <= 0;
                x <= 0;
            end
        end
    end

endmodule