module IO_Module #(parameter DATA_WIDTH = 8,
                    parameter ADDRESS_WIDTH = 16)
                    (input logic clk,
                     input logic rst,
                     input logic [ADDRESS_WIDTH-1:0] io_addr,
                     input logic [DATA_WIDTH-1:0] in_data,
                     output logic [DATA_WIDTH-1:0] out_data,
                     input logic rd_n,
                     input logic wr_n,
                     output logic int_n);

  localparam DEVICE1_ADDR_START = 16'hFF00;
  localparam DEVICE1_ADDR_END   = 16'hFF0F;

  localparam DEVICE2_ADDR_START = 16'h1C00;
  localparam DEVICE2_ADDR_END   = 16'h1D00;

  logic [DATA_WIDTH-1:0] device1_register;
  logic [DATA_WIDTH-1:0] device2_register;

  always_ff @(posedge clk or posedge rst)
    if (rst) begin
      device1_register <= '0;
      device2_register <= '0;
    end
    else begin
      if (wr_n == 0 && rd_n == 0 && io_addr >= DEVICE1_ADDR_START && io_addr <= DEVICE1_ADDR_END)
        device1_register <= in_data;
      else if (wr_n == 0 && rd_n == 0 && io_addr >= DEVICE2_ADDR_START && io_addr <= DEVICE2_ADDR_END)
        device2_register <= in_data;
    end

  assign out_data = (rd_n == 0 && io_addr >= DEVICE1_ADDR_START && io_addr <= DEVICE1_ADDR_END) ? device1_register :
                   (rd_n == 0 && io_addr >= DEVICE2_ADDR_START && io_addr <= DEVICE2_ADDR_END) ? device2_register :
                   'z;

  assign int_n = 1;

endmodule
