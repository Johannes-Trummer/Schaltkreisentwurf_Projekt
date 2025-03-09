//`define SIMULATION;  // Diese Zeile einkommentieren, wenn keine Datei-Handles genutzt werden sollen


`ifndef SIMULATION
module testbench(
    input clk
);

    reg [15:0] Zahl1;
    reg [15:0] Zahl2;
    wire [15:0] ergebnis;
    reg start = 'd0;
    reg rst = 'd0;
    wire valid;
	 wire logic_clk;

    // Datei-Handles (nur falls nicht SIMULATION definiert ist)


    ggt_top TOP(
	 
	 .clk(logic_clk), 
	 .rst_i(rst), 
	 .start_i(start),

    .Zahl1_i(Zahl1), 
	 .Zahl2_i(Zahl2),

	 
	 
	 .valid_o(valid),
    .ergebnis_o(ergebnis)
	 
	 
	 );
	 
 	 logic_pll PLL(
		.inclk0(clk),
		.c0(logic_clk)
	 
	 ); 
	 

    initial begin
        // Initialwerte setzen
        rst = 1'b1;
        #10 rst = 1'b0;


 
            
            // Starte ggT-Berechnung
            start = 1'b1;
            #10 start = 1'b0;

            // Warte auf gültiges Ergebnis
            wait(valid);

        

        $display("Alle Berechnungen abgeschlossen. Ergebnisse gespeichert.");
        $stop;
    end
endmodule
`endif 



`ifdef SIMULATION
module testbench(
	

	
);

    reg [15:0] Zahl1;
    reg [15:0] Zahl2;
    wire [15:0] ergebnis;
    reg start = 0;
    reg clk = 0;
    reg rst = 0;
    wire valid;

    // Datei-Handles
    integer file_in, file_out;
    integer scan_result;
    
    // Modul-Instanz
    ggt_top TOP(
	 
	 .clk(clk), 
	 .rst_i(rst), 
	 .start_i(start),

    .Zahl1_i(Zahl1), 
	 .Zahl2_i(Zahl2),

	 
	 
	 .valid_o(valid),
    .ergebnis_o(ergebnis)
	 
	 
	 );
	 
	 

    // Taktgenerierung
    always #5 clk = !clk;

    initial begin
        // Initialwerte setzen
        clk = 1'b0;
        rst = 1'b1;
        #10 rst = 1'b0;
        
        // Datei öffnen
        file_in = $fopen("ggt_zahlen.txt", "r");
        file_out = $fopen("ggt_ergebnisse_euklid.txt", "w");

        if (file_in == 0) begin
            $display("Fehler: Datei ggt_zahlen.txt konnte nicht geöffnet werden!");
            $stop;
        end
        if (file_out == 0) begin
            $display("Fehler: Datei ggt_ergebnisse_euklid.txt konnte nicht geöffnet werden!");
            $stop;
        end

        // Zahlenpaare aus Datei einlesen und verarbeiten
        while (!$feof(file_in)) begin
            scan_result = $fscanf(file_in, "%d %d\n", Zahl1, Zahl2);
            if (scan_result != 2) begin
                $display("Fehler: Konnte keine zwei Zahlen lesen!");
                $finish;
            end
            
            // Starte ggT-Berechnung
            start = 1'b1;
            #10 start = 1'b0;

            // Warte auf gültiges Ergebnis
            wait(valid);
            
            // Ergebnis in Datei schreiben
            $fwrite(file_out, "%0d\n", ergebnis);
            $display("Berechnung abgeschlossen: %d (ggt) %d = [%d", Zahl1, Zahl2, ergebnis);
            #2;
        end

        // Dateien schließen
        $fclose(file_in);
        $fclose(file_out);

        $display("Alle Berechnungen abgeschlossen. Ergebnisse gespeichert.");
        $stop;
    end

endmodule
`endif 