import risc16::*;
import alu::*;

module stage_ID(
  input                       clk_i,
  input                       rst_i,
  
  input                       pipeline_ready_i,
  input   inst_t              instr_i,

  output  ex_task_t           task_o,
  
  // to cpu regs
  output [REG_ADDR_WIDTH-1:0] rd_reg_addr_o [1:0],
  input  [REG_DATA_WIDTH-1:0] rd_reg_data_i [1:0]

);

inst_rrr_t                 instr_rrr;
inst_rri_t                 instr_rri;
inst_ri_t                  instr_ri;

alu_task_t                 alu_task_w;
alu_cmd_t                  alu_cmd_w;

id_res_t                   id_res_w;

// тип инструкции rri или rrr; ri пока не используем
logic                      rri_instr_type; 
logic [REG_DATA_WIDTH-1:0] imm_extended;

// приводим входную инструкцию к трем возможным вариантам
assign instr_rrr             = instr_i;
assign instr_rri             = instr_i;
assign instr_ri              = instr_i;

assign rri_instr_type        = ( instr_i.opcode == OP_ADDI ) || 
                               ( instr_i.opcode == OP_LW   ) ||
                               ( instr_i.opcode == OP_SW   );

assign imm_extended          = { {(REG_DATA_WIDTH-SIGNED_IMMEDIATE_WIDTH-1){instr_rri.imm[SIGNED_IMMEDIATE_WIDTH-1]} }, instr_rri.imm };

assign alu_task_w.a          = rd_reg_data_i[0];
assign alu_task_w.b          = rri_instr_type ? ( imm_extended      ) : ( rd_reg_data_i[1]    );
assign alu_task_w.cmd        = alu_cmd_w;

assign rd_reg_addr_o[0]      = ( rri_instr_type          ) ? ( instr_rri.reg_src   ) : 
                                                             ( instr_rrr.reg_src_1 );

assign rd_reg_addr_o[1]      = ( instr_i.opcode == OP_SW ) ? ( instr_rri.reg_dst   ) : 
                                                             ( instr_rrr.reg_src_2 );

//assign id_res_w.mem_wr_en = instr_i.

always_comb
  begin
    id_res_w.mem_wr_en       = ( instr_i.opcode == OP_SW );
    // TODO: можно попробовать занулить если не надо писать
    id_res_w.mem_wr_data     = rd_reg_data_i[1];
    
    id_res_w.wb_reg_addr     = ( rri_instr_type          ) ? ( instr_rri.reg_dst ) : 
                                                             ( instr_rrr.reg_dst ); 
    id_res_w.wb_wr_en        = ( instr_i.opcode != OP_SW ) && ( instr_i.opcode != OP_NOP );
    id_res_w.wb_mem_data_sel = ( instr_i.opcode == OP_LW );
  end

always_ff @( posedge clk_i or posedge rst_i )
  if( rst_i )
    task_o <= '0;
  else
    begin
      task_o.id_res   <= pipeline_ready_i ? ( id_res_w ) : ( '0 ); 
      task_o.alu_task <= alu_task_w; 
    end

always_comb
  begin
    case( instr_i.opcode )
      OP_ADD:
        begin
          alu_cmd_w = ALU_ADD;
        end
      OP_SUB:
        begin
          alu_cmd_w = ALU_SUB;
        end
      OP_AND:
        begin
          alu_cmd_w = ALU_AND;
        end
      OP_OR:
        begin
          alu_cmd_w = ALU_OR;
        end
      OP_XOR:
        begin
          alu_cmd_w = ALU_XOR;
        end
      OP_ADDI:
        begin
          alu_cmd_w = ALU_ADD;
        end
      OP_LW:
        begin
          alu_cmd_w = ALU_ADD;
        end
      OP_SW:
        begin
          alu_cmd_w = ALU_ADD;
        end
      default:
        begin
          alu_cmd_w = ALU_NOP;
        end
    endcase
  end

endmodule
