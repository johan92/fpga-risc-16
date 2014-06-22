import risc16::*;

module stage_MEM(
  input             clk_i,
  input             rst_i,

  input  mem_task_t task_i,
  
  output wb_task_t  task_o

);

logic [MEM_DATA_WIDTH-1:0] read_data;

mem_task_t                 mem_task_d1;

always_ff @( posedge clk_i or posedge rst_i )
  if( rst_i )
    mem_task_d1 <= '0;
  else
    mem_task_d1 <= task_i;

always_comb
  begin
    task_o.wr_data      = mem_task_d1.id_res.wb_mem_data_sel ? ( read_data ) : ( mem_task_d1.alu_res );
    task_o.reg_addr     = mem_task_d1.id_res.wb_reg_addr;
    task_o.wr_en        = mem_task_d1.id_res.wb_wr_en;
  end

dp_ram 
#
(
  .DATA_WIDTH                             ( MEM_DATA_WIDTH        ), 
  .ADDR_WIDTH                             ( MEM_ADDR_WIDTH        )

) data_mem (
  .clk                                    ( clk_i                 ),

  .data                                   ( task_i.id_res.mem_wr_data    ),
  .write_addr                             ( task_i.alu_res        ),
  .we                                     ( task_i.id_res.mem_wr_en      ),

  .read_addr                              ( task_i.alu_res        ),

  .q                                      ( read_data             )
);

endmodule
