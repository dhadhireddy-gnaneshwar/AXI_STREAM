module axi_stream(aclk,areset,tvalid,indata,in_valid,mode,tdata,tkeep,tstrb,tready,tlast,t_s_outdata);
  input aclk,areset;      //clock and reset signal
  input [1:0]mode;        //mode signal for master operation
  output wire [31:0] tdata,t_s_outdata;      //32-bit data bus for master to slave
  input [31:0] indata;    //2-bit input data to master
  input in_valid;         //input in_valid signal for master
  output  tvalid;         //input tvalid signal for slave
  output wire [3:0] tkeep,tstrb; //strobe and tkeep signal
  output wire tready;            //ready signal from slave to master
  output wire tlast;             //last transfer indicator
  
  
//instantiation of axi_stream_master
  axi_stream_master inst0(.aclk(aclk),.areset(areset),.tdata(tdata),.tvalid(tvalid),.tstrb(tstrb),.tkeep(tkeep),.indata(indata),
  .in_valid(in_valid),.tready(tready),.tlast(tlast),.mode(mode));

//instantiation of axi_stream_slave  
  axi_stream_slave inst1(.aclk(aclk),.areset(areset),.tdata(tdata),.tvalid(tvalid),.tstrb(tstrb),.tkeep(tkeep),.tready(tready),.tlast(tlast),.out_data(t_s_outdata));
  
endmodule