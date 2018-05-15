module APB_PWM
(
  input logic         PCLK,
  input logic         PRESETn,
  input logic [31:0]  PADDR,
  input logic         PSEL,
  input logic         PENABLE,
  input logic         PWRITE,
  input logic [31:0]  PWDATA,

  output logic        PREADY,
  output logic [31:0] PRDATA,
  output logic        PSLAVEERR,

  output logic [7:0]  PWM
);

logic [31:0] period, pulse, enable, size;
logic en0, en1, en2, en3;

always_ff@ (posedge PCLK)                               	//REGISTER PERIOD
begin
 	if(!PRESETn)
    		period <= 32'd0;
  	else if(PRESETn && en0) begin                         	//WRITE REGISTER
    		period <= PWDATA;
    		PREADY <= 1'b1;
  	end
  	else if(PRESETn && !PWRITE && PSEL && PENABLE) begin  	//READ REGISTER
    		PRDATA <= period;
    		PREADY <= 1'b1;
  	end
end

always_ff@ (posedge PCLK)                               	//REGISTER PULSE
begin
  	if(!PRESETn)
    		pulse <= 32'd0;
  	else if(PRESETn && en1) begin                         	//WRITE REGISTER
    		pulse = PWDATA;
    		PREADY <= 1'b1;
  	end
  	else if(PRESETn && !PWRITE && PSEL && PENABLE) begin  	//READ REGISTER
    		PRDATA <= pulse;
    		PREADY <= 1'b1;
  	end
end

always_ff@ (posedge PCLK)                               	//REGISTER SIZE
begin
  	if(!PRESETn)
    		size <= 32'd0;
  	else if(PRESETn && en2) begin                         	//WRITE REGISTER
    		size <= {24'd0, PWDATA[7:0]};
    		PREADY <= 1'b1;
  	end
  	else if(PRESETn && !PWRITE && PSEL && PENABLE) begin  	//READ REGISTER
    		PRDATA <= size;
    		PREADY <= 1'b1;
  end
end

always_ff@ (posedge PCLK)                               	//REGISTER ENABLE
begin
  	if(!PRESETn)
    		enable <= 32'd0;
  	else if(PRESETn && en3) begin                         	//WRITE REGISTER
    		enable <= {31'd0, PWDATA[0]};
    		PREADY <= 1'b1;
  	end
  	else if(PRESETn && !PWRITE && PSEL && PENABLE) begin  	//READ REGISTER
    		PRDATA <= enable;
    		PREADY <= 1'b1;
  	end
end

always@ (PSEL or PENABLE or PADDR or PWRITE)
begin
  	en0 = 1'b0;
  	en1 = 1'b0;
  	en2 = 1'b0;
  	en3 = 1'b0;
	PSLAVEERR = 1'b0;
  	case(PADDR[3:0])
    	4'b0000:
      	if(PENABLE && PWRITE)
        	en0 = 1'b1;
    	4'b0100:
      	if(PENABLE && PWRITE)
        	en1 = 1'b1;
      
    	4'b1000:
    	if(PENABLE && PWRITE)
        	en2 = 1'b1;

    	4'b1100:
      	if(PENABLE && PWRITE)
        	en3 = 1'b1;

  	endcase
end

PWM pwm(.PCLK(PCLK), .PRESETn(PRESETn), .period(period), .pulse(pulse), .size(size), .enable(enable), .PWM(PWM));

/*always_ff@ (posedge PCLK)
begin
	if(!PRESETN || count == 32'b11111111111111111111111111111111 || count == period)
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
end*/
endmodule
