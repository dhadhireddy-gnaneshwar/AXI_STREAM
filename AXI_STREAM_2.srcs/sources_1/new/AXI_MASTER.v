module axi_stream_master(aclk,areset,tdata,tvalid,tready,tstrb,tkeep,indata,in_valid,tlast,mode);
  input aclk,areset,tready;   //input clock,reset,tready signal
  output reg [31:0] tdata;    //32-bit tdata
  input [31:0]indata;         //32-bit indata
  input in_valid;             //1-bit in_valid
  output reg tvalid;          //tvalid signal
  output reg [3:0] tkeep,tstrb;//4-bit tkeep(Byte qualifier, Specifices which bytes of                                 tdata is valid) and tsrobe(usaully keep as tkeep)
  output reg tlast;            //identifies last word of the data
  input [1:0]mode;             //2-bit mode signalling for controlling the data
  integer i;
  
  //FSM STATES
  parameter IDLE = 2'b00;      //IDLE STATE: waiting for the bvalid input
  parameter TRANSFER = 2'b01;  // TRANSFER STATE : sending the data
  
  //Operation modes
  parameter mode0 = 2'b00;     //mode0 : send the data as-it is
  parameter mode1 = 2'b01;     //mode1 : reverse byte order
  parameter mode2 = 2'b10;     //mode2 : add constant
  
  reg [31:0] data_buffer;      //data_buffer to hold the  data before sending
  reg [1:0] state = IDLE;      //fsm register
 
  
  always@(posedge aclk)
    begin
      if(!areset)             //clear all outputs and reset state
        begin
          tvalid = 0;
        end
      else
         begin
           case(state)
             IDLE : begin
               if(in_valid)   //if in_valid is high store the data into the buffer &                                   move to the transfer state
                 begin
                	 state <= TRANSFER;
                 	data_buffer <= indata;
                 end
               else           
                 state <= IDLE;
                 tlast = 0;
             end
             
             TRANSFER : begin
               tvalid = 1;            //assert tvalid to indicate data is ready
               if(tvalid && tready)   //if tvalid and tready or high then the data                                             transfer takes place
                    begin 
                      tkeep  <= 4'b1101; //bytes 0,2,3 are valid
                      tstrb <= 4'b1111;  //all four bytes of strobe are active
                      tlast <= 1;        // assert last word is 1
                      state <= IDLE;
                      case(mode)     
                      mode0 :  begin       //send data directly
                      tdata <= data_buffer;
                      
                    end
                       mode1 : begin       //reverse byte order
                         for(i=0;i<=3;i=i+1)
                           begin
                             if(tvalid && tready)
                               tdata[i*8 +: 8] = data_buffer[(32- 8 - i*8) +: 8];
                           end
                       end
                       mode2 : begin       //adding constant
                          tdata <= data_buffer + 32'habc;
                       end
                     endcase
                    end
                  else
                    state <= TRANSFER;
                end
           endcase
         end
    end
endmodule

           
            
               
                  
                        
                 
                 
                 