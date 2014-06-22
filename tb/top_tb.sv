import risc16::*;

module top_tb;

bit clk;
bit rst;

initial
  begin
    forever
      begin
        #5 clk = !clk;
      end
  end


default clocking cb @( posedge clk );
endclocking;

bit execute_en;

initial
  begin
    repeat ( 20 ) @cb;

    rst = 1'b0;
    #3;
    rst = 1'b1;
    #3;
    rst = 1'b0;
    
    @cb;
    execute_en = 1'b1;

    repeat ( 45 ) @cb;
    $stop();
  end


bit [15:0][15:0] instr;

initial
  begin
    #1;
    $readmemb("t.bin", ct.s_if.instr_ram.ram );
    $display("Loaded instructions");
  end


cpu_top ct(
  .clk_i                                  ( clk             ),
  .rst_i                                  ( rst             ),
  .execute_en_i                           ( execute_en      )

);

endmodule
