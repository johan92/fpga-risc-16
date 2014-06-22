import risc16::*;

module stage_IF(
  input         clk_i,
  input         rst_i,
  
  input         execute_en_i,

  output inst_t instr_o

);
logic [INSTR_PTR_WIDTH-1:0] instr_ptr = '1;
logic [INSTR_PTR_WIDTH-1:0] instr_ptr_d1 = '1;
logic [INSTR_PTR_WIDTH-1:0] rd_addr_w;

inst_t                      rd_instr_w;

always_ff @( posedge clk_i or posedge rst_i )
  if( rst_i )
    begin
      instr_ptr    <= '1; 
      instr_ptr_d1 <= '1;
    end
  else
    if( execute_en_i )
      begin
        instr_ptr    <= instr_ptr + 1'd1;
        instr_ptr_d1 <= instr_ptr;
      end


logic [INSTR_WIDTH-1:0]     wr_data = '0;
logic [INSTR_PTR_WIDTH-1:0] wr_addr = '0;
logic                       wr_en   = 1'b0;

assign instr_o = rd_instr_w; 

assign rd_addr_w = execute_en_i ? ( instr_ptr ) : ( instr_ptr_d1 );

dp_ram  
#
(
  .DATA_WIDTH                             ( INSTR_WIDTH       ), 
  .ADDR_WIDTH                             ( INSTR_PTR_WIDTH   ) 
) instr_ram(
  .clk                                    ( clk_i             ),
  
  .data                                   ( wr_data           ),
  .write_addr                             ( wr_addr           ),
  .we                                     ( wr_en             ),

  .read_addr                              ( rd_addr_w         ),
  .q                                      ( rd_instr_w        )
);


endmodule
