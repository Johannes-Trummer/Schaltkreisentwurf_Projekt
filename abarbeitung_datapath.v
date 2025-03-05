module cordic_datapath(
	
	


	

	


);











always @ (*) begin

	
	/// Initialize Registers upon start_i
	if(start_r) begin
		numIterations_temp  = numIt_r;
		n_temp 				= 'd0; 
		phi_save_temp 		= {phi_r,8'd0};
		phi_sum_temp 		= 'd0;
		x_0_temp 			= x_r;
		y_0_temp 			= y_r;
		sigma_n_temp 		= phi_r[7];
	end
	
	
	
	
end
	
//===Ausgänge zuweisen===
assign eab_o 	= n_r;
assign x_o		= x_0_r;
assign y_o 		= y_0_r;
assign deg_o 	= phi_sum_r;
	
endmodule