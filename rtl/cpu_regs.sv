import risc16::*;

module cpu_regs(
  input                                clk_i,
  input                                rst_i,
  
  input wb_task_t                      task_i,
  
  input           [REG_ADDR_WIDTH-1:0] rd_addr_i [1:0],
  output logic    [REG_DATA_WIDTH-1:0] rd_data_o [1:0]

);
localparam REGS_CNT = 2 ** REG_ADDR_WIDTH;

logic [REGS_CNT-1:0][REG_DATA_WIDTH-1:0] regs = '0;

always_ff @( posedge clk_i or posedge rst_i )
  if( rst_i )
    regs <= '0;
  else
    if( task_i.wr_en )
      begin
        regs[ task_i.reg_addr ] <= task_i.wr_data;
      end

always_comb
  begin
    for( int i = 0; i < 2; i++ )
      begin
        rd_data_o[i] = regs[ rd_addr_i[i] ];
      end
  end

clocking cb @( posedge clk_i );
endclocking

initial
  begin
    forever
      begin
        @cb;
        if( task_i.wr_en )
          begin
            $display("%t | WR: R%1d %4x", $time(), task_i.reg_addr, task_i.wr_data );
          end
      end
  end


endmodule
