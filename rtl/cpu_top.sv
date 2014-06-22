import risc16::*;
import alu::*;

module cpu_top(
  input clk_i,
  input rst_i,

  input execute_en_i
);

inst_t                      instr_w;

ex_task_t                   ex_task_w;
mem_task_t                  mem_task_w;
wb_task_t                   wb_task_w;
logic                       pipeline_ready_w;

logic  [REG_ADDR_WIDTH-1:0] rd_reg_addr_w [1:0];
logic  [REG_DATA_WIDTH-1:0] rd_reg_data_w [1:0];

stage_IF s_if(
  .clk_i                                  ( clk_i                                 ),
  .rst_i                                  ( rst_i                                 ),
  .execute_en_i                           ( execute_en_i && pipeline_ready_w      ),
    
  .instr_o                                ( instr_w                               )
);

stage_ID s_id(
  .clk_i                                  ( clk_i             ),
  .rst_i                                  ( rst_i             ),

  .instr_i                                ( instr_w           ),
  .pipeline_ready_i                       ( pipeline_ready_w  ),
    
  .task_o                                 ( ex_task_w         ),

  .rd_reg_addr_o                          ( rd_reg_addr_w     ),
  .rd_reg_data_i                          ( rd_reg_data_w     )

);

stage_EX s_ex( 
  .clk_i                                  ( clk_i             ),
  .rst_i                                  ( rst_i             ),
  .task_i                                 ( ex_task_w         ),

  .task_o                                 ( mem_task_w        )
);

stage_MEM s_mem(
  .clk_i                                  ( clk_i             ),
  .rst_i                                  ( rst_i             ),

  .task_i                                 ( mem_task_w        ),
    
  .task_o                                 ( wb_task_w         )

);

cpu_regs c_regs(
  .clk_i                                  ( clk_i             ),
  .rst_i                                  ( rst_i             ),
    
  .task_i                                 ( wb_task_w         ),
    
  .rd_addr_i                              ( rd_reg_addr_w     ),
  .rd_data_o                              ( rd_reg_data_w     )

);

hazard_detection hz(
  
  // регистры из которых сейчас хочет читать ID stage
  .id_src_reg_i                           ( rd_reg_addr_w     ),
  
  .ex_task_i                              ( ex_task_w         ),
  .mem_task_i                             ( mem_task_w        ),
  .wb_task_i                              ( wb_task_w         ),
    
  .pipeline_ready_o                       ( pipeline_ready_w  )

);

endmodule
