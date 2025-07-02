create_clock -period 10.000 -name Aclk -waveform {0.000 5.000} [list a [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]]
