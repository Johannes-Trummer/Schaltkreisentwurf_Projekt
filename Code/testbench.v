`define SIMULATION;  // Diese Zeile einkommentieren, wenn keine Datei-Handles genutzt werden sollen



module testbench(
    input clk
);

    reg [15:0] Zahl1;
    reg [15:0] Zahl2;
    wire [15:0] ergebnis;
    reg start = 0;
    reg rst = 0;
    wire valid;
	 wire logic_clk;

    // Datei-Handles (nur falls nicht SIMULATION definiert ist)
    `ifndef SIMULATION
    integer file_in, file_out;
    integer scan_result;
    `endif

    // Modul-Instanz
    ggt_top top(
        .clk(logic_clk), 
        .rst(rst), 
        .start_i(start),
        .Zahl1_i(Zahl1), 
        .Zahl2_i(Zahl2),
        .ergebnis(ergebnis),
        .valid(valid)
    );
	 
	 logic_pll pll(
		.inclk0(clk),
		.c0(logic_clk)
	 
	 );
	 

    initial begin
        // Initialwerte setzen
        rst = 1'b1;
        #10 rst = 1'b0;

        `ifndef SIMULATION
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
        `endif

        // Zahlenpaare aus Datei einlesen und verarbeiten (nur falls nicht SIMULATION definiert ist)
        `ifndef SIMULATION
        while (!$feof(file_in)) begin
            scan_result = $fscanf(file_in, "%d %d\n", Zahl1, Zahl2);
            if (scan_result != 2) begin
                $display("Fehler: Konnte keine zwei Zahlen lesen!");
                $finish;
            end
        `else
            // Simulationswerte für den Testlauf
            Zahl1 = 16'd48;
            Zahl2 = 16'd18;
        `endif
            
            // Starte ggT-Berechnung
            start = 1'b1;
            #10 start = 1'b0;

            // Warte auf gültiges Ergebnis
            wait(valid);

            `ifndef SIMULATION
            // Ergebnis in Datei schreiben
            $fwrite(file_out, "%0d\n", ergebnis);
            `endif
            $display("Berechnung abgeschlossen: %d (ggT) %d = [%d]", Zahl1, Zahl2, ergebnis);
            #2;
        `ifndef SIMULATION
        end

        // Dateien schließen
        $fclose(file_in);
        $fclose(file_out);
        `endif

        $display("Alle Berechnungen abgeschlossen. Ergebnisse gespeichert.");
        $stop;
    end
endmodule
