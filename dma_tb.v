
`timescale 1ns/1ps

module dma_fsm_tb;

reg clk, rst;
reg start_transfer;
reg [31:0] src_addr_init, dst_addr_init, length_init;
reg bus_op_done;
reg [31:0] read_data_buffer;

wire [31:0] current_src_addr, current_dst_addr;
wire bus_read_req, bus_write_req;
wire transfer_done, transfer_active;

dma_fsm dut (.*);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 0;
    start_transfer = 0;
    bus_op_done = 0;
    src_addr_init = 32'h1000;
    dst_addr_init = 32'h2000;
    length_init = 2;
    read_data_buffer = 32'hAAAA_BBBB;

    #10;
    rst = 1;
    // Start transfer
    #10;
    start_transfer = 1;
    #10;
    start_transfer = 0;
    // Read complete
    #20;
    bus_op_done = 1;
    #10;
    bus_op_done = 0;
    // Write complete
    #20;
    bus_op_done = 1;
    #10;
    bus_op_done = 0;
    // Second read complete
    #20;
    bus_op_done = 1;
    #10;
    bus_op_done = 0;
    // Second write complete
    #20;
    bus_op_done = 1;

    #10;
    bus_op_done = 0;

    #30;
    $finish;
end

initial begin
    $monitor("T=%0t | state=%0d | read=%b write=%b done=%b active=%b | SRC=%h DST=%h",
             $time, dut.state, bus_read_req, bus_write_req,
             transfer_done, transfer_active,
             current_src_addr, current_dst_addr);
end

endmodule
