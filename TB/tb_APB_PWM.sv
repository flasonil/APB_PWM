`timescale 1ns/1ps
//1. SCRITTURA DEI REGISTRI
//2. GENERAZIONE DEGLI IMPULSI
module testbench ();

  logic         PCLK;
  logic         PRESETn;
  logic [31:0]  PADDR;
  logic         PSEL;
  logic         PENABLE;
  logic         PWRITE;
  logic [31:0]  PWDATA;

  logic [31:0]  PRDATA;
  logic         PREADY;
  logic		PSLAVEERR;
  logic	[7:0]	PWM;

  APB_PWM DUT(.PCLK(PCLK), .PRESETn(PRESETn), .PADDR(PADDR), .PSEL(PSEL), .PENABLE(PENABLE), .PWRITE(PWRITE), .PWDATA(PWDATA), .PRDATA(PRDATA), .PREADY(PREADY), .PSLAVEERR(PSLAVEERR), .PWM(PWM));

  always
    begin
      #5 PCLK = !PCLK;
    end

    initial
      begin
        PCLK = 0;
        PRESETn = 0;

        @(negedge PCLK);

        PRESETn = 1;

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        PADDR = 32'b00000000000000000000000000000100;  //PULSE
        PWRITE = 1;
        PSEL = 1;
        PWDATA = 32'b00000000000000000000000000000100; //PULSE = 4

        @(negedge PCLK);

        PENABLE = 1;

        @(negedge PCLK);

        PADDR = 32'b00000000000000000000000000000000;   //PERIOD
        PENABLE = 0;
        PWDATA = 32'b00000000000000000000000000001000;  //PERIOD = 8

        @(negedge PCLK);

        PENABLE = 1;

        @(negedge PCLK);

        PADDR = 32'b00000000000000000000000000001000;   //SIZE
        PENABLE = 0;
        PWDATA = 32'b00000000000000000000000000000111;  //SIZE = 2

        @(negedge PCLK);

        PENABLE = 1;

        @(negedge PCLK);

        PADDR = 32'b00000000000000000000000000001100;   //ENABLE
        PENABLE = 0;
        PWDATA = 32'b00000000000000000000000000000001;  //ENABLE = 1

        @(negedge PCLK);

        PENABLE = 1;

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);

        @(negedge PCLK);
        $stop;

      end
endmodule
