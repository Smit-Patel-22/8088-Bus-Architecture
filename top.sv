module top;
logic RESET = '0;
logic CLK = '0;
logic CS0,CS1,CS2,CS3;
logic [19:0] Address;
wire [7:0]  Data;


Intel8088Pins i(CLK,RESET);
Intel8088 Pre(i.Processor);
 

IO_Module #(8,20,1'b0) m1(.i(i.Peripheral), .CS(CS0), .Address(Address), .Data(Data));
IO_Module #(8,20,1'b0) m2(.i(i.Peripheral), .CS(CS1), .Address(Address), .Data(Data));
IO_Module #(8,16,1'b1) IO1(.i(i.Peripheral), .CS(CS2), .Address(Address), .Data(Data));
IO_Module #(8,16,1'b1) IO2(.i(i.Peripheral), .CS(CS3), .Address(Address), .Data(Data));

initial begin
    i.MNMX = '1;
    i.TEST = '1;
    i.READY = '1;
    i.NMI = '0;
    i.INTR = '0;
    i.HOLD = '0;
end

  // Latch to latch bus address
  always_latch
  begin
    if (i.ALE)
      Address <= {i.A, i.AD};
  end

  // Transceiver
  assign Data = (i.DTR & ~i.DEN) ? i.AD : 'z;
  assign i.AD = (~i.DTR & ~i.DEN) ? Data : 'z;

  // Address decoding logic
  always_comb
  begin
    CS0 = ~Address[19] && !i.IOM;                  
    CS1 = Address[19] && !i.IOM;
    CS2 = Address[15] && i.IOM;                      
    CS3 = ~Address[15] && i.IOM;                            
  end

  // Clock generation
  always #50 CLK = ~CLK;

  // Initial block
  initial
  begin
    $dumpfile("dump.vcd"); $dumpvars;

    repeat (2) @(posedge CLK);
    RESET = '1;
    repeat (5) @(posedge CLK);
    RESET = '0;

    repeat(10000) @(posedge CLK);
    $finish();
  end
endmodule

