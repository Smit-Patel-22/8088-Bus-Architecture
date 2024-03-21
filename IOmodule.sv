module IO_Module #(parameter DATA_WIDTH,
            	     parameter ADDRESS_WIDTH,
                   parameter valid,
                   parameter FILENAME = "Data.hex") 
				          (
				          Intel8088Pins.Peripheral i,
    				      input logic CS,
                  input logic IOM,
				          input logic [ADDRESS_WIDTH-1:0] Address,
                  inout logic [DATA_WIDTH-1:0] Data,
                  output logic OE
					        );
 
  localparam DEPTH = 1<<ADDRESS_WIDTH;
  logic [7:0] data_in;
  logic LoadAddress;
  logic Write;
  logic [19:0] address_reg;
  logic [DATA_WIDTH-1:0] M [0:DEPTH-1];
  

  localparam T1 = 5'b10000, T2 = 5'b01000, T3R = 5'b00100, T3W = 5'b00010, T4 = 5'b00001;
  reg [4:0] State, NextState;
  
  always_ff @(posedge i.CLK or posedge i.RESET) begin
    if (i.RESET) State <= T1;
    else State <= NextState;
  end

  always_comb begin
    NextState = State;
    unique case (State)
        T1: if (CS && i.ALE && IOM == valid) NextState = T2;
            else NextState = T1;

        T2: if (!i.RD) NextState = T3R;
            else if (!i.WR) NextState = T3W;

        T3R: NextState = T4;

        T3W: NextState = T4;
             
        T4: NextState = T1;
    endcase
  end

  always_comb 
  begin
    {OE,LoadAddress} = 0;
     unique case (State)
      T2: begin
        LoadAddress = 1;
      end

      T3R: begin
        OE = 1;
        data_in <= M[address_reg];
      end

      T3W: begin
        OE = 0;
        Write = 1;
        M[address_reg] <= Data;
      end

      T4: begin
        OE = 'z;
      end
    endcase
  end

initial begin
$readmemh(FILENAME,M);
end

  //address register logic
  always_ff @(posedge i.CLK)begin
    if (LoadAddress) address_reg = Address;
  end

assign Data = (OE) ? data_in : 'z;
endmodule
