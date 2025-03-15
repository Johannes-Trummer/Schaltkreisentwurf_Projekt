% Dateinamen
file1 = 'ggt_ergebnisse_euklid.txt';
file2 = 'ggt_ergebnisse.txt';

% Dateien öffnen
fid1 = fopen(file1, 'r');
fid2 = fopen(file2, 'r');

% Prüfen, ob die Dateien existieren
if fid1 == -1
    error('Fehler: Datei %s konnte nicht geöffnet werden.', file1);
end
if fid2 == -1
    error('Fehler: Datei %s konnte nicht geöffnet werden.', file2);
end

% Initialisieren von Variablen
lineNumber = 0;
differences = 0;

% Zeilenweise lesen und vergleichen
while ~feof(fid1) && ~feof(fid2)
    lineNumber = lineNumber + 1;
    
    % Zeilen aus beiden Dateien lesen
    line1 = fgetl(fid1);
    line2 = fgetl(fid2);
    
    % Vergleichen der Zeilen
    if strcmp(line1, line2)
        fprintf('Zeile %d: ✅ Übereinstimmung\n', lineNumber);
    else
        fprintf('Zeile %d: ❌ Unterschied gefunden\n', lineNumber);
        fprintf('   Datei 1: %s\n', line1);
        fprintf('   Datei 2: %s\n', line2);
        differences = differences + 1;
    end
end

% Prüfen, ob eine Datei mehr Zeilen hat
if ~feof(fid1)
    fprintf('⚠ Datei %s hat zusätzliche Zeilen.\n', file1);
    differences = differences + 1;
end
if ~feof(fid2)
    fprintf('⚠ Datei %s hat zusätzliche Zeilen.\n', file2);
    differences = differences + 1;
end

% Dateien schließen
fclose(fid1);
fclose(fid2);

% Endgültige Meldung
if differences == 0
    fprintf('\n✅ Die beiden Dateien sind vollständig identisch!\n');
else
    fprintf('\n⚠ Die Dateien haben %d Unterschiede.\n', differences);
end
