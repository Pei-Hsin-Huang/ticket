 module vending_machine( clk, reset, howManyTicket, origin, destination, money,
                        costOfTicket, moneyToPay, totalMoney );
   
  output reg[6:0] costOfTicket, moneyToPay;
  output reg[6:0] totalMoney;
  
  input clk, reset;
  input [2:0] howManyTicket;
  input [2:0] origin, destination;
  input [5:0] money;
  
  // station
  parameter S1 = 3'd1;
  parameter S2 = 3'd2;
  parameter S3 = 3'd3;
  parameter S4 = 3'd4;
  parameter S5 = 3'd5;
  
  // state
  parameter state0 = 2'd0;
  parameter state1 = 2'd1;
  parameter state2 = 2'd2;
  parameter state3 = 2'd3;
  
  reg [1:0] state;
  reg [1:0] next_state;

  reg [2:0] state_gap, state_gap_abs;
  reg stay0, stay1, stay2;
  
  
  always @(posedge clk) begin
    if (reset) begin
      state = state3;

    end 
    else begin
      state = next_state;
    end
  end

  always @(posedge clk) begin
    begin
      case (state)
        state0: begin
          totalMoney = 0;
          moneyToPay = 0;
          if ( (origin > 0) && (origin < 6) ) begin
            if ( (destination > 0) && (destination < 6) ) begin
              stay0 = 0;
              state_gap = destination - origin;
              state_gap_abs = state_gap[2] ? ~state_gap + 1 : state_gap;
              costOfTicket = ( state_gap_abs + 1 ) * 5;
            end
            else begin
              stay0 = 1;
              $display( "destination should be 1-5" );
            end    
          end
          else begin
            stay0 = 1;
            $display( $time, " orgin should be 1-5, your orgin: %d", origin );
          end        
        end
        state1: begin
          stay1 = 0;
          if ( (howManyTicket > 0) && (howManyTicket < 6) ) begin   
            moneyToPay = costOfTicket * howManyTicket;
          end
          else begin
            stay1 = 1;
            $display( "ticket should be 1-5" );
          end
        end
        state2: begin
          stay2 = 0;
          if (totalMoney < moneyToPay) begin
            totalMoney = totalMoney + money;
            if (totalMoney >= moneyToPay) begin
              stay2 = 0;     
              $display( "already paid %d dollars", totalMoney );
            end
            else begin
              stay2 = 1;
              $display( "already paid %d dollars, still need to pay %d dollars", totalMoney, moneyToPay-totalMoney );
            end
          end
          
        end 
        state3: begin
          if (reset==0) begin
            $display( "exchange %d dollars, Output %d tickets", totalMoney-moneyToPay, howManyTicket );
          end
          else begin
            if (totalMoney > 0) begin
              $display( "exchange %d dollars", totalMoney );
            end
            
          end
          stay0 = 0;
          stay1 = 0;
        end
      endcase
    end
  end
  
  
  always @(state or stay0 or stay1 or reset or stay2 or totalMoney) begin
    begin
      case (state)
        
        state0: begin
          if (stay0==0) begin
            next_state = state1;
          end 
          else begin
            next_state = state0;
          end
        end
        
        state1: begin
          if (stay1==0) begin
            next_state = state2;
          end 
          else begin
            next_state = state1;
          end
        end
        
        state2: begin
          if (stay2==0) begin
            next_state = state3;
          end 
          else begin
            next_state = state2;
          end
        end
        
        state3: begin
          next_state = state0;
        end
        
      endcase
    end
  end
  
endmodule

  
      
  
      
  
