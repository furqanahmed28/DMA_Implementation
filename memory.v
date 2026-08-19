
module memory (
    input wire clk,
    input wire read_en,
    input wire write_en,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output reg [31:0] read_data,
    output reg op_done
);
reg [31:0] mem [0:255];
always @(posedge clk) begin
    op_done <= 0;
    if (read_en) begin
        read_data <= mem[addr[9:2]];
        op_done <= 1;
    end
    if (write_en) begin
        mem[addr[9:2]] <= write_data;
        op_done <= 1;
    end
end
endmodule
