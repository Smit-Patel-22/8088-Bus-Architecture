 interface Intel8088Pins (input logic CLK,RESET);
bit MNMX;
bit TEST;
bit READY;
bit NMI;
bit INTR;
bit HOLD;
wire logic [7:0] AD;
 logic [19:8] A;
 logic IOM;
 logic WR;
 logic RD;
 logic SSO;
 logic INTA;
 logic ALE;
 logic DTR;
 logic DEN;
 logic HLDA;
 logic OE;
logic [19:0] Address;
wire[7:0] Data;

    modport Processor (
              input CLK,
              input MNMX,
              input RESET,
              input TEST,
    	      input READY,
    	      input NMI,
    	      input INTR,
    	      input HOLD,
              inout AD,
              output A,
              output HLDA,
              output IOM,
              output WR,
              output RD,
              output SSO,
              output INTA,
              output ALE,
              output DTR,
              output DEN
    );

 modport Peripheral (input CLK, output IOM,input RD, input WR, input RESET, input DEN, input ALE, output OE);
  endinterface

