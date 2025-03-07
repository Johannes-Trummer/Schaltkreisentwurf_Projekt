% Anzahl der zufälligen Zahlenpaare
num_pairs = 500;
max_value = 2^16 - 1; % Maximale 16-Bit-Zahl (65535)

% Datei zum Speichern öffnen
fileID = fopen('ggt_zahlen.txt', 'w');
fileID2 = fopen('ggt_ergebnisse.txt', 'w');

% Prüfen, ob die Datei erfolgreich geöffnet wurde
if fileID == -1
    error('Fehler beim Öffnen der Datei.');
end

if fileID2 == -1
    error('Fehler beim Öffnen der Datei.');
end

% Generiere Zufallszahlen und berechne den ggT
for i = 1:num_pairs
    % Zufällige Zahlen (16 Bit)
    a = randi([1, max_value]);
    b = randi([1, max_value]);

    % Berechne ggT mit MATLABs gcd-Funktion
    ggt_value = gcd(a, b);

    % In Datei schreiben: "a (ggt) b = [ggT]"
    fprintf(fileID, '%d  %d \n',a, b);
    fprintf(fileID2, '%d\n', ggt_value);
end

% Datei schließen
fclose(fileID);

% Bestätigungsausgabe in der Konsole
disp('Die Berechnung wurde abgeschlossen. Die Ergebnisse wurden in "ggt_ergebnisse.txt" gespeichert.');
