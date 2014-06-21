package alu;
  parameter ALU_CMD_WIDTH = 3;
  parameter DATA_WIDTH    = 16;
  
  typedef enum logic [ALU_CMD_WIDTH-1:0] {
    ALU_NOP  = 3'b000,
    ALU_ADD  = 3'b001,
    ALU_SUB  = 3'b010,                                                           
    ALU_AND  = 3'b011,
    ALU_OR   = 3'b100,                                                            
    ALU_XOR  = 3'b101                                                            
  } alu_cmd_t;

  typedef struct packed{
    alu_cmd_t              cmd;
    logic [DATA_WIDTH-1:0] a;
    logic [DATA_WIDTH-1:0] b;

  } alu_task_t;

endpackage
