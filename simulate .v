module stimulus;
  
reg clk,reset;

wire [6:0] costOfTicket, moneyToPay;
wire [6:0] totalMoney;
  
reg [2:0] howManyTicket;
reg [2:0] origin, destination;
reg [5:0] money;

vending_machine vm( clk, reset, howManyTicket, origin, destination, money,
                    costOfTicket, moneyToPay, totalMoney );

initial clk = 1'b0;
always #5 clk = ~clk;

initial
begin
  reset = 1;  
  #10 reset = 0;
  origin = 2 ;  
  destination = 6 ;
  #10 reset = 1;
  #10 reset = 0;
  origin = 2 ;
  destination = 5 ;
  #10 howManyTicket = 2 ;

  #10 reset = 1;
  #10 reset = 0;
  origin = 4 ;  
  destination = 1 ;
  #10 howManyTicket = 2 ;
  #10 money = 10 ;
  #10 money = 5 ;
  #10 money = 1 ;
  #10 money = 10 ;
  #10 money = 10 ;
  #10 money = 10 ;
  
 
end
endmodule