import risc16::*;

module hazard_detection(
  
  // регистры из которых сейчас хочет читать ID stage
  input              [REG_ADDR_WIDTH-1:0] id_src_reg_i [1:0],
  
  // таски каждой из ступеней, если в них содержится
  // регистр, куда будем записывать, надо будет остановить 
  // конвеер
  input  ex_task_t                        ex_task_i, 
  input  mem_task_t                       mem_task_i,
  input  wb_task_t                        wb_task_i,
  
  output logic                            pipeline_ready_o

);

always_comb
  begin
    pipeline_ready_o = 1'b1;

    for( int i = 0; i < 2; i++ )
      begin
        if( id_src_reg_i[i] != '0 )
          begin
            if( 
                ( id_src_reg_i[i] == ex_task_i.id_res.wb_reg_addr  ) || 
                ( id_src_reg_i[i] == mem_task_i.id_res.wb_reg_addr ) ||
                ( id_src_reg_i[i] == wb_task_i.reg_addr            ) 
              )
                begin
                  pipeline_ready_o = 1'b0;
                end
          end
      end
  end

endmodule
