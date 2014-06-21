package risc16;
  import alu::*;
 
  parameter INSTR_WIDTH     = 16;
  
  parameter MEM_DATA_WIDTH  = 16;
  parameter MEM_ADDR_WIDTH  = 8;

  parameter REG_DATA_WIDTH  = 16;
  parameter REG_ADDR_WIDTH  = 3;
  
  parameter OP_CODE_WIDTH   = 4;
  
  parameter INSTR_PTR_WIDTH = 5;

  typedef enum logic [OP_CODE_WIDTH-1:0] {
    OP_NOP  = 4'b0000,
    OP_ADD  = 4'b0001, 
    OP_SUB  = 4'b0010,                                                           
    OP_AND  = 4'b0011,                                                           
    OP_OR   = 4'b0100,                                                           
    OP_XOR  = 4'b0101,                                                           
    OP_ADDI = 4'b1001,                                                           
    OP_LW   = 4'b1010,                                                           
    OP_SW   = 4'b1011  
  } opcode_t;

  typedef struct packed{
    opcode_t                               opcode;
    logic [INSTR_WIDTH-OP_CODE_WIDTH-1:0]  not_opcode;

  } inst_t;
  
  parameter RRR_EMPTY_WIDTH = INSTR_WIDTH - ( OP_CODE_WIDTH + 3 * REG_ADDR_WIDTH );

  // тип reg-reg-reg
  typedef struct packed{
    opcode_t                           opcode;
    logic [REG_ADDR_WIDTH-1:0]         reg_dst;
    logic [REG_ADDR_WIDTH-1:0]         reg_src_1;
    logic [RRR_EMPTY_WIDTH-1:0]        rsvd;
    logic [REG_ADDR_WIDTH-1:0]         reg_src_2;
  } inst_rrr_t;
  
  parameter SIGNED_IMMEDIATE_WIDTH = INSTR_WIDTH - ( OP_CODE_WIDTH + 2 * REG_ADDR_WIDTH );

  typedef struct packed{
    opcode_t                           opcode;
    logic [REG_ADDR_WIDTH-1:0]         reg_dst;
    logic [REG_ADDR_WIDTH-1:0]         reg_src;
    logic [SIGNED_IMMEDIATE_WIDTH-1:0] imm;
  } inst_rri_t;
  
  parameter UNSIGNED_IMMEDIATE_WIDTH = INSTR_WIDTH - ( OP_CODE_WIDTH + 1 * REG_ADDR_WIDTH );
  
  typedef struct packed{
    opcode_t                           opcode;
    logic [REG_ADDR_WIDTH-1:0]         reg_dst;
    logic [SIGNED_IMMEDIATE_WIDTH-1:0] imm;
  } inst_ri_t;
  
  typedef struct packed{
    
    logic [MEM_DATA_WIDTH-1:0] mem_wr_data;
    logic                      mem_wr_en;

    logic [REG_ADDR_WIDTH-1:0] wb_reg_addr;
    logic                      wb_wr_en;
    logic                      wb_mem_data_sel;

  } id_res_t;

  typedef struct packed{
    
    id_res_t                   id_res;
    alu_task_t                 alu_task;

  } ex_task_t;

  typedef struct packed{

    id_res_t                   id_res;

    logic [REG_DATA_WIDTH-1:0] alu_res;

  } mem_task_t;
  
  typedef struct packed{
    logic [REG_DATA_WIDTH-1:0] wr_data;
    logic [REG_ADDR_WIDTH-1:0] reg_addr;
    logic                      wr_en;
  } wb_task_t;

endpackage
