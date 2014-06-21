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

initial
  begin
    rst = 1'b0;
    #3;
    rst = 1'b1;
    #3;
    rst = 1'b0;
  end

cpu_top ct(
  .clk_i                                  ( clk             ),
  .rst_i                                  ( rst             )

);

endmodule
