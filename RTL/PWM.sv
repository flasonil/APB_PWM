module PWM
(
  input logic		PCLK,
  input logic		PRESETn,
  input logic [31:0]	period,
  input logic [31:0]	pulse,
  input logic [31:0]	size,
  input logic [31:0]	enable,

  output logic [7:0]  PWM
);

logic [31:0]	count;

always_ff@ (posedge PCLK)
begin
	if(!PRESETn || count == period)
		count = 32'd0;
	else if(enable[0])
      		count ++;
end

always@ (pulse or enable or count)
begin
	if(count >= pulse || !enable[0])
		PWM <= 8'd0;
	else if(count < pulse && enable[0])
		PWM = size[7:0] * 8'b00000001;
end

endmodule
