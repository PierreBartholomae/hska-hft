Hypothese 1
HFT betreiben zum größten Teil passives Market Making und stellen damit Liquidität zur Verfügung

(HFT gibt eher Quotes rein und nimmt weniger Quotes raus) <- Stimmt das?

Untersuchen unter folgenden Aspekten:
1. Insgesamt
2. Peaks

# Präsentation
20 min

# Offene Fragen
Liquidität <- Was ist das? Prozentsatz vom Spread?
Addition Liquidität = Differenz aus Eurex Spread und dem abgeschlossenen Handels-Spread
Subtraktion Liquidität = abgeschlossenen Handels-Spread

# Verständnis

		add order		full order
hft 1 		x			x			hft 1  	-> hft 1: Liquidität++ ; hft 1: Liquidität - -
hft 0 		x			x			hft 0  	-> hft 0: Liquidität++ ; hft 0: Liquidität - -
hft 1 		x			x			hft 0  	-> hft 1: Liquidität++ ; hft 0: Liquidität - -
hft 0 		x			x			hft 1  	-> hft 0: Liquidität++ ; hft 1: Liquidität - -


# Beispiel

Eurex Spread = 5%
Handel wird mit 4% Spread abgeschlossen

hft 0: add		hft 1: full

hft 0 -> 4% ++
hft 1 -> 4% - -

Handel wird mit 1% Spread abgeschlossen

hft 0: add		hft 1: full

hft 0 -> 1% ++
hft 1 -> 1% - -


# Nützliche Hinweise
## (26.11.14)
Das ist ein zweiteiliger Markt -> "SIDE"-Feld bestimmt, ob du Käufer oder Verkäufer bist.
Käufer: hat ein maximales limit -> buy
Verkäufer: hat ein minimales limit -> sell
Execution Price: ist nur gefüllt wenn nicht zum Limit ge/verkauft wurde
Partial und Full Order Execution nimmt immer Liquidität aus dem Markt
Load und Add Order stellt immer Liquidität zur Verfügung
EUREX vergibt recht an deutsche börse telekomaktien zu handeln und die deutsche börse muss gleichzeitig sell und buy bereitstellen 
Spread: Differenz zwischen sell und buy
Je kleiner der Spread desto liquider ist der Markt
EUREX gibt maximalen Spread vor in %
Spread zur Messung der Liquidität benutzen
