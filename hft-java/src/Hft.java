import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class Hft {
	public static void main(String[] args) {

		String dataPath = "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/";
		//String dataPath = "C:\\Users\\Moe\\Desktop\\BigData\\";
		
		//Basic MethodPaths
		String dataIndexedPath = dataPath + "hft-data-indexed.csv";
		String dataFixedPath = dataPath + "hft-data-fixed.csv";
		String dataHFTPartPath = dataPath + "hft-data-hftPart.csv";
		String datanonHFTPartPath = dataPath + "hft-data-nonhftPart.csv";
		
		//ExecutionPrices
		String dataExecutionPriceTablePathFull = dataPath + "hft-data-executionPriceTableFull.csv";
		String dataExecutionPriceTablePathHFT = dataPath + "hft-data-executionPriceTableHFT.csv";
		String dataExecutionPriceTablePathnonHFT = dataPath + "hft-data-executionPriceTablenonHFT.csv";

		//BuyTables
		String dataBuyTablePathFull = dataPath + "hft-data-buyTableFull.csv";
		String dataBuyTablePathHFT = dataPath + "hft-data-buyTableHFT.csv";
		String dataBuyTablePathnonHFT = dataPath + "hft-data-buyTablenonHFT.csv";

		//SellTables
		String dataSellTablePathFull = dataPath + "hft-data-sellTableFull.csv";
		String dataSellTablePathHFT = dataPath + "hft-data-sellTableHFT.csv";
		String dataSellTablePathnonHFT = dataPath + "hft-data-sellTablenonHFT.csv";

		try {
			addIndex(dataPath + "hft-data.csv", dataIndexedPath, ";");
			fixData(dataIndexedPath, dataFixedPath, ";");
			hftSplit(dataFixedPath, dataHFTPartPath, datanonHFTPartPath, ";");
			
			//FullSet
			executionPriceTable(dataFixedPath, dataExecutionPriceTablePathFull, ";");
			buyTable(dataFixedPath, dataBuyTablePathFull, ";");
			sellTable(dataFixedPath, dataSellTablePathFull, ";");
			
			//HFTPart
			executionPriceTable(dataHFTPartPath, dataExecutionPriceTablePathHFT, ";");
			buyTable(dataHFTPartPath, dataBuyTablePathHFT, ";");
			sellTable(dataHFTPartPath, dataSellTablePathHFT, ";");
			
			//non-HFTPart
			executionPriceTable(datanonHFTPartPath, dataExecutionPriceTablePathnonHFT, ";");
			buyTable(datanonHFTPartPath, dataBuyTablePathnonHFT, ";");
			sellTable(datanonHFTPartPath, dataSellTablePathnonHFT, ";");		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	// Hinzufügen eines Indizes zur Identifizierung
	public static void addIndex(String oldFile, String newFile, String seperator) throws IOException{
		//Initialisierungen
		BufferedReader br = new BufferedReader(new FileReader(new File(oldFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(newFile)));
		String line = br.readLine();
		int count = 0;
		bw.write("ID;" + line + "\n");
		//Durchlauf durch die Datei
		while((line = br.readLine()) != null){
			//Hinzufügen des jeweiligen Indizes
			line = String.valueOf(count).concat(";"+line);
			//Zurückschreiben in neue Datei
			bw.write(line+"\n");
			line = "";
			count++;
		}
		br.close();
		bw.close();
	}
	//Entfernen falscher Datensätze
	public static void fixData(String oldFile, String newFile, String seperator) throws IOException {
		//Initialisierungen
		BufferedReader br = new BufferedReader(new FileReader(new File(oldFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(newFile)));
		String line = br.readLine();
		//Grober Startwert zur Berechnung der Maximalen Abweichungen vom Vorgängerpreis
		double temp = 9;
		//Schreiben des Headers
		bw.write(line + "\n");
		//Durchlauf durch die Datei
		while((line = br.readLine()) != null){
			//Aufteilung der Zeile nach den einzelnen Spalten
			String[] split = line.split(";");
			line = "";
			//Überprüfung ob ein Limitpreis exisitiert
			if(!split[21].isEmpty()){
				//Maximale Abweichung 0.5 - 1.5 im Vergleich zum vorigen Datensatz
				if(!(temp/Double.parseDouble(split[21]) > 1.5) && !(temp/Double.parseDouble(split[21]) < 0.5)){
					//Betrachtung des Hauptuntersuchungstages im Dezember13
					if(split[8].contains("DEC13")){
						temp = Double.parseDouble(split[21]);
						//Zusammensetzen der neuen Zeile
						for(String s : split){
							line = line.concat(s + ";");
						}
						line = line.substring(0,line.length()-1);
						bw.write(line + "\n");
					}
				}
				line = "";
			}
		}

		bw.close();
		br.close();
	}
	
	//Aufteilen der Datei in HFTler und nicht-HFTler
	public static void hftSplit (String oldFile, String hftFile, String nonhftFile, String seperator) throws IOException{
		//Initialisierungen
				BufferedReader br = new BufferedReader(new FileReader(new File(oldFile)));
				BufferedWriter bwhft = new BufferedWriter(new FileWriter(new File(hftFile)));
				BufferedWriter bwnonhft = new BufferedWriter(new FileWriter(new File(nonhftFile)));

				String line = br.readLine();
				bwhft.write(line + "\n");
				bwnonhft.write(line + "\n");
				while((line = br.readLine()) != null){
					String[] split = line.split(seperator);
					if(split[27].equals("1")){
						bwhft.write(line + "\n");
					} else {
						bwnonhft.write(line + "\n");
					}
				}
				br.close();
				bwhft.close();
				bwnonhft.close();
	}

	//Erstellen der Tabelle, die nur noch die Executions enthält (Partial/FullOrder)
	public static void executionPriceTable (String oldFile, String newFile, String seperator) throws IOException{
		//Initialisierungen
		BufferedReader br = new BufferedReader(new FileReader(new File(oldFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(newFile)));
		String line = br.readLine();
		bw.write(line + "\n");
		while((line = br.readLine()) != null){
			String[] split = line.split(seperator);
			line = "";
			//Überprüfung auf Existenz eines Executionpreises
			if(!split[16].isEmpty()){
				for(String s : split){
					line = line.concat(s + ";");
				}
				line = line.substring(0,line.length()-1);

				bw.write(line + "\n");
			}
			line = "";

		}
		bw.close();
		br.close();
	}
	//Erstellen der Sell Tabelle, die nur noch Verkaufsangebote enthält
	public static void sellTable (String oldFile, String newFile, String seperator) throws IOException{
		BufferedReader br = new BufferedReader(new FileReader(new File(oldFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(newFile)));
		String line = br.readLine();
		//Anpassen des Headers
		bw.write(line + ";SellPrice" + "\n");
		while((line = br.readLine()) != null){
			String[] split = line.split(seperator);
			line = "";
			//Überprüfung der Spalte "Side"
			if(split[17].equals("SELL")){
				for(String s : split){
					line = line.concat(s + ";");
				}
				if(!split[16].isEmpty()){
					line = line.concat(split[16]);
				} else {
					line = line.concat(split[21]);
				}

				bw.write(line + "\n");
			}
			line = "";
		}
		bw.close();
		br.close();
	}
	//Analog zu SellTable
	public static void buyTable (String oldFile, String newFile, String seperator) throws IOException{
		BufferedReader br = new BufferedReader(new FileReader(new File(oldFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(newFile)));
		String line = br.readLine();
		bw.write(line + ";BuyPrice" + "\n");
		while((line = br.readLine()) != null){
			String[] split = line.split(seperator);
			line = "";
			if(split[17].equals("BUY")){
				for(String s : split){
					line = line.concat(s + ";");
				}
				if(!split[16].isEmpty()){
					line = line.concat(split[16]);
				} else {
					line = line.concat(split[21]);
				}

				bw.write(line + "\n");
			}
			line = "";

		}
		bw.close();
		br.close();
	}
}
