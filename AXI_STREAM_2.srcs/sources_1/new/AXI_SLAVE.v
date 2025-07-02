`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  Tharun Kumer U
// 
// Create Date: 08.05.2025 16:44:48
// Design Name: 
// Module Name: AXI_S_SLAVE
// Project Name: AXI_STREAM
// Target Devices: Artix 7 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_stream_slave(aclk,areset,tdata,tstrb,tkeep,tready,tvalid,tlast,out_data);
  input aclk,areset;            //clock and reset input
   output reg tready;           //slave ready signal to accept the data
  input [3:0] tstrb, tkeep;     //strobe indicates which bytes are valid and tkeep                                       indicates valid bytes of tdata
  input [31:0] tdata;           //32-bit data from AXI stream master
  input tlast;                  //last signal indicating last byte of the data
  input tvalid;                 //valid signal indiacting tdata is valid
  output [31:0] out_data;
  integer i;
  
  //fsm states
  parameter IDLE = 2'b00;      //IDLE state : waiting for the data
  parameter TRANSFER = 2'b01;  //TRANSFER state : reading and storing of data
  assign out_data = !areset ? 0 : rd_data;
  
  reg [1:0] state = IDLE;     //fsm register
  reg [31:0]rd_data;          //register to hold the received data
  
  always@(posedge aclk)
    begin
      if(!areset)              //clears the output and set IDLE state
        begin
          tready = 0;
        end
      else
        begin
          case(state)
            IDLE : begin
              tready = 0;      //not ready to receive data
              rd_data <= 0;
              if(tvalid)       //if master has valid data
                state <= TRANSFER; //moe to transfer state
              else
                state <= IDLE;
            end
            
            TRANSFER : begin
              tready = 1;      //indicates ready to receive data
              if(tready && tvalid)  //if both tready and tvalid is high then                                                 transmission of data happens
                  begin
                    for(i=0;i<=3; i=i+1)
                      begin
                        if(tkeep[i] && tstrb[i])
                          rd_data[i*8 +: 8] <= tdata[i*8 +: 8];
                      end
                    if(tlast)    //if last move to IDLE state else stay in current                                        state
                      state <= IDLE;
                    else
                      state <= TRANSFER;
                  end
            end
          endcase
        end
    end
endmodule
                      
                  
              
                
                