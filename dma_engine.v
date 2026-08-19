
module dma_engine (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [31:0] src_addr,
    input wire [31:0] dst_addr,
    input wire [31:0] length,
    output wire busy,
    output reg done,
    output reg error,
    output reg interrupt
);

wire [31:0] current_src_addr;
wire [31:0] current_dst_addr;
wire read_req;
wire write_req;
wire transfer_done;
wire transfer_active;
wire [31:0] read_data;
wire mem_done;
wire [31:0] mem_read_data;
reg [31:0] write_data;

dma_fsm dma_ctrl (
    .clk(clk),
    .rst(rst),
    .start_transfer(start),
    .src_addr_init(src_addr),
    .dst_addr_init(dst_addr),
    .length_init(length),
    .bus_op_done(mem_done),
    .current_src_addr(current_src_addr),
    .current_dst_addr(current_dst_addr),
    .bus_read_req(read_req),
    .bus_write_req(write_req),
    .transfer_done(transfer_done),
    .transfer_active(transfer_active),
    .read_data_buffer(mem_read_data)
);

memory mem (
    .clk(clk),
    .read_en(read_req),
    .write_en(write_req),
    .addr(read_req ? current_src_addr :
                    current_dst_addr),
    .write_data(write_data),
    .read_data(mem_read_data),
    .op_done(mem_done)
);

always @(posedge clk or negedge rst) begin
    if (!rst)
        write_data <= 32'b0;
    else if (read_req)
        write_data <= mem_read_data;
end

assign busy = transfer_active;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        done      <= 1'b0;
        error     <= 1'b0;
        interrupt <= 1'b0;
    end
    else begin
        done      <= 1'b0;
        interrupt <= 1'b0;
        if (transfer_done) begin
            done      <= 1'b1;
            interrupt <= 1'b1;
        end
    end
end

endmodule

