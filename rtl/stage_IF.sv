import risc16::*;

module stage_IF(
  input         clk_i,
  input         rst_i,
  
  output inst_t instr_o

);
logic [INSTR_WIDTH-1:0] instr_ptr;

always_ff @( posedge clk_i or posedge rst_i )
  if( rst_i )
    instr_ptr <= '0;
  else
    instr_ptr <= instr_ptr + 1'd1;

dp_ram  
#
(
  .DATA_WIDTH                             ( INSTR_WIDTH       ), 
  .ADDR_WIDTH                             ( INSTR_PTR_WIDTH   ) 
) instr_ram(
  .clk                                    ( clk_i             ),
  
  .data                                   ( data              ),
  .write_addr                             ( write_addr        ),
  .we                                     ( we                ),

  .read_addr                              ( instr_ptr         ),
  .q                                      ( instr_o           )
);


endmodule
