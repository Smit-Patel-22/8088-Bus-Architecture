module MemoryModule #(parameter DATA_WIDTH = 8,
                      parameter ADDRESS_WIDTH = 20)
                      (input logic clk,
                       input logic rst,
                       input logic [DATA_WIDTH-1:0] wr_data,
                       input logic [ADDRESS_WIDTH-1:0] wr_addr,
                       input logic wr_en,
                       output logic [DATA_WIDTH-1:0] rd_data,
                       input logic [ADDRESS_WIDTH-1:0] rd_addr,
                       input logic rd_en);

  // Calculate the depth of the memory based on the ADDRESS_WIDTH
  localparam MEM_DEPTH = 2 ** ADDRESS_WIDTH;

  // Declare the memory array
  logic [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];

  // Write operation
  always_ff @(posedge clk or posedge rst)
    if (rst)
      memory <= '0;
    else if (wr_en)
      memory[wr_addr] <= wr_data;

  // Read operation
  always_comb begin
    if (rd_en)
      rd_data = memory[rd_addr];
    else
      rd_data = '0;
  end

endmodule
