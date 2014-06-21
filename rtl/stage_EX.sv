import risc16::*;
import alu::*;

module stage_EX( 
  input             clk_i,
  input             rst_i,

  input  ex_task_t  task_i,

  output mem_task_t task_o
);

logic [alu::DATA_WIDTH-1:0] alu_ans;

alu_task_t                  at;

always_ff @( posedge clk_i or posedge rst_i )
  if( rst_i )
    task_o <= '0;
  else
    begin
      task_o.id_res  <= task_i.id_res;
      task_o.alu_res <= alu_ans;
    end

assign at = task_i.alu_task;

always_comb
  begin
    case( at.cmd )
      ALU_ADD: 
        begin
          alu_ans = at.a + at.b;
        end
      ALU_SUB:  
        begin
          alu_ans = at.a - at.b;
        end
      ALU_AND:  
        begin
          alu_ans = at.a & at.b;
        end
      ALU_OR:   
        begin
          alu_ans = at.a | at.b;
        end
      ALU_XOR:
        begin
          alu_ans = at.a ^ at.b;
        end
      default:
        begin
          alu_ans = '0;
        end
    endcase
  end

endmodule
