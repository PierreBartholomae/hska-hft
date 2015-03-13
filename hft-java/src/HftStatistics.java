import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Locale;

public class HftStatistics {

	public static final String ACTIVITY_TYPE_MODIFY_ORDER = "MODIFY_ORDER";
	public static final String ACTIVITY_TYPE_ADD_ORDER = "ADD_ORDER";
	public static final String ACTIVITY_TYPE_DELETE_ORDER = "DELETE_ORDER";
	public static final String ACTIVITY_TYPE_FULL_ORDER_EXECUTION = "FULL_ORDER_EXECUTION";
	public static final String ACTIVITY_TYPE_PARTIAL_ORDER_EXECUTION = "PARTIAL_ORDER_EXECUTION";
	
	public static final Integer COLUMN_ID = 1;
	public static final Integer COLUMN_ACTIVITY_TYPE = 9;//10;
	public static final Integer COLUMN_SIDE = 17;
	public static final Integer COLUMN_HFT = 27;
	public static final Integer COLUMN_PRICE = 28;

	public static void main(String[] args) {
		
	    String dataPath = "";
	    String statisticsDirectoryPath = "";
	    String dataDirectoryPath = "";
	    
	    String OS = System.getProperty("os.name", "generic").toLowerCase(Locale.ENGLISH);
	    if (OS.indexOf("win") >= 0) {
			dataPath = "C:\\Users\\Moe\\Desktop\\BigData\\";
			statisticsDirectoryPath = dataPath + "statistics\\";			
			dataDirectoryPath = dataPath + "data\\";
	    } else {
			dataPath = "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/";
			statisticsDirectoryPath = dataPath + "statistics/";
			dataDirectoryPath = dataPath + "data/";
	    }

		File statisticsDirectory = new File(statisticsDirectoryPath);
		if (!statisticsDirectory.exists()) {
			if (statisticsDirectory.mkdir()) {
				System.out.println("Statistics directory created");
			} else {
				System.out.println("please create statistics directory manually");
			}
		}
		
		//Basic MethodPaths
		String dataIndexedPath = dataDirectoryPath + "hft-data-indexed.csv";
		String dataFixedPath = dataDirectoryPath + "hft-data-fixed.csv";
		String dataHFTPartPath = dataDirectoryPath + "hft-data-hftPart.csv";
		String datanonHFTPartPath = dataDirectoryPath + "hft-data-nonhftPart.csv";
		
		//ExecutionPrices
		String dataExecutionPriceTablePathFull = dataDirectoryPath + "hft-data-executionPriceTableFull.csv";
		String dataExecutionPriceTablePathHFT = dataDirectoryPath + "hft-data-executionPriceTableHFT.csv";
		String dataExecutionPriceTablePathnonHFT = dataDirectoryPath + "hft-data-executionPriceTablenonHFT.csv";

		//BuyTables
		String dataBuyTablePathFull = dataDirectoryPath + "hft-data-buyTableFull.csv";
		String dataBuyTablePathHFT = dataDirectoryPath + "hft-data-buyTableHFT.csv";
		String dataBuyTablePathnonHFT = dataDirectoryPath + "hft-data-buyTablenonHFT.csv";

		//SellTables
		String dataSellTablePathFull = dataDirectoryPath + "hft-data-sellTableFull.csv";
		String dataSellTablePathHFT = dataDirectoryPath + "hft-data-sellTableHFT.csv";
		String dataSellTablePathnonHFT = dataDirectoryPath + "hft-data-sellTablenonHFT.csv";

		// Spread: All
		String spreadTablePathFullAll = statisticsDirectoryPath + "hft-data-spreadTableFull-all.csv";
		String spreadTablePathHFTAll = statisticsDirectoryPath + "hft-data-spreadTableHFT-all.csv";
		String spreadTablePathnonHFTAll = statisticsDirectoryPath + "hft-data-spreadTablenonHFT-all.csv";
		
		// Spread: Ranged
		String spreadTablePathFullRanged = statisticsDirectoryPath + "hft-data-spreadTableFull-ranged.csv";
		String spreadTablePathHFTRanged = statisticsDirectoryPath + "hft-data-spreadTableHFT-ranged.csv";
		String spreadTablePathnonHFTRanged = statisticsDirectoryPath + "hft-data-spreadTablenonHFT-ranged.csv";

		// Activity Type Table
		String activityTablePath = statisticsDirectoryPath + "hft-data-activityTable.csv";

		// Standard Deviation
		String standardDeviationTablePath = statisticsDirectoryPath + "hft-data-StandardDeviationTable.csv";
		
		try {
			System.out.println("### Start creating statistics CSVs");
			
			// calcSpreads
			// dataSellTables and dataBuyTables must exists!
			int calcSpreadAll = -1;
			int calcSpreadRange = 10000;
			calcSpread(dataSellTablePathFull, dataBuyTablePathFull, spreadTablePathFullAll, calcSpreadAll);
			calcSpread(dataSellTablePathHFT, dataBuyTablePathHFT, spreadTablePathHFTAll, calcSpreadAll);
			calcSpread(dataSellTablePathnonHFT, dataBuyTablePathnonHFT, spreadTablePathnonHFTAll, calcSpreadAll);
			
			calcSpread(dataSellTablePathFull, dataBuyTablePathFull, spreadTablePathFullRanged, calcSpreadRange);
			calcSpread(dataSellTablePathHFT, dataBuyTablePathHFT, spreadTablePathHFTRanged, calcSpreadRange);
			calcSpread(dataSellTablePathnonHFT, dataBuyTablePathnonHFT, spreadTablePathnonHFTRanged, calcSpreadRange);

			// get more statistics
			getActivityTypeFrequencies(dataSellTablePathHFT, dataBuyTablePathHFT, dataSellTablePathnonHFT, dataBuyTablePathnonHFT, activityTablePath, ";");
			
			// get standard deviation
			ArrayList<String> deviationsPathArray = new ArrayList<String>(9);
			deviationsPathArray.add(dataExecutionPriceTablePathFull);
			deviationsPathArray.add(dataExecutionPriceTablePathHFT);
			deviationsPathArray.add(dataExecutionPriceTablePathnonHFT);
			deviationsPathArray.add(dataBuyTablePathFull);
			deviationsPathArray.add(dataBuyTablePathHFT);
			deviationsPathArray.add(dataBuyTablePathnonHFT);
			deviationsPathArray.add(dataSellTablePathFull);
			deviationsPathArray.add(dataSellTablePathHFT);
			deviationsPathArray.add(dataSellTablePathnonHFT);
			getStandardDeviations(deviationsPathArray, standardDeviationTablePath);
						
			System.out.println("### Finished creating data CSVs");

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// range: any number or -1 for all
	public static void calcSpread (String sellFile, String buyFile, String resultFile, Integer stepCount) throws IOException{
		BufferedReader br1 = new BufferedReader(new FileReader(new File(sellFile)));
		BufferedReader br2 = new BufferedReader(new FileReader(new File(buyFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(resultFile)));

		ArrayList<String> sellList = new ArrayList<String>();
		ArrayList<String> buyList = new ArrayList<String>();
		
		sellList = getPriceForColumn(br1, stepCount);
		buyList = getPriceForColumn(br2, stepCount);
		
		bw.write("CurrentStep;Spread;SellBuyPercentage" + "\n");
		for (int i = 0; i < sellList.size() && i < buyList.size(); i++) {
			String[] sellSplit = sellList.get(i).split(";");
			double sellPrice = Double.parseDouble(sellSplit[1]);
			String[] buySplit = buyList.get(i).split(";");
			double buyPrice = Double.parseDouble(buySplit[1]);
			
			double priceDifference = sellPrice - buyPrice;
			double priceDifferenceWithPrecision = new BigDecimal(priceDifference).setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
			
			if (stepCount == -1 || (Double.parseDouble(sellSplit[0]) == Double.parseDouble(buySplit[0]))) {
				double sellCount = Double.parseDouble(sellSplit[2]);
				double buyCount = Double.parseDouble(buySplit[2]);
				
				double countDifference = sellCount / buyCount;
				double countDifferenceWithPrecision = new BigDecimal(countDifference).setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

				bw.write(sellSplit[0] + ";" + String.valueOf(priceDifferenceWithPrecision) + ";" + String.valueOf(countDifferenceWithPrecision) + "\n");
			}
		}
		
		br1.close();
		br2.close();
		bw.close();
		
		System.out.println("calcSpread finished");
	}
	
	public static ArrayList<String> getPriceForColumn(BufferedReader br, Integer stepCount) throws IOException {
		String line = br.readLine();
		int count = 0;
		double priceValue = 0;
		int rowID = 0;
		int currentStepCount = stepCount;
		ArrayList<String> priceList = new ArrayList<String>();
		
		while((line=br.readLine())!=null){
			String[] split = line.split(";");
			priceValue += Double.parseDouble(split[28]);
			rowID = Integer.parseInt(split[0]);
			count++;
			if (stepCount != -1 && rowID >= currentStepCount){
				double currentSpread = priceValue/count;
				String row = currentStepCount + ";" + String.valueOf(currentSpread) + ";" + count; 
				priceList.add(row);
				priceValue = 0;
				currentStepCount += stepCount;
				count = 0;
			}
		}
		if(stepCount == -1) {
			double currentSpread = priceValue/count;
			String row = count + ";" + String.valueOf(currentSpread) + ";" + count; 

			priceList.add(row);
		}
		return priceList;
	}
	
	public static void getActivityTypeFrequencies (String sellFileHFT, String buyFileHFT, String sellFilenonHFT, String buyFilenonHFT, String resultFile, String separator) throws IOException {
		BufferedReader brSellHFT = new BufferedReader(new FileReader(new File(sellFileHFT)));
		BufferedReader brBuyHFT = new BufferedReader(new FileReader(new File(buyFileHFT)));
		BufferedReader brSellnonHFT = new BufferedReader(new FileReader(new File(sellFilenonHFT)));
		BufferedReader brBuynonHFT = new BufferedReader(new FileReader(new File(buyFilenonHFT)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(resultFile)));
		
		bw.write("HFT" + separator + "Side" + separator + "Add Order" + separator + "Delete Order" + separator + "Modify Order" + separator + "Order Execution" + "\n");

		String sellLineHFT = getActivityTypeForSide(brSellHFT, "Sell", separator, 1);
		String buyLineHFT = getActivityTypeForSide(brBuyHFT, "Buy", separator, 1);
		String sellLinenonHFT = getActivityTypeForSide(brSellnonHFT, "Sell", separator, 0);
		String buyLinenonHFT = getActivityTypeForSide(brBuynonHFT, "Buy", separator, 0);
		
		bw.write(sellLineHFT + buyLineHFT + sellLinenonHFT + buyLinenonHFT);
		
		brSellHFT.close();
		brBuyHFT.close();
		brSellnonHFT.close();
		brBuynonHFT.close();
		bw.close();
		
		System.out.println("getActivityTypeFrequencies finished");
	}
	
	public static String getActivityTypeForSide(BufferedReader br, String side, String separator, Integer HFT) throws IOException {
		String line = br.readLine();
		Integer count = 0;
		
		Integer addOrderCount = 0;
		Integer deleteOrderCount = 0;
		Integer modifyOrderCount = 0;
		Integer orderExecutionCount = 0;
		
		while((line = br.readLine()) != null){
			String[] cells = line.split(separator);
			line = "";
			switch (cells[COLUMN_ACTIVITY_TYPE]) {
				case ACTIVITY_TYPE_ADD_ORDER:
					addOrderCount++;
					break;
				case ACTIVITY_TYPE_DELETE_ORDER:
					deleteOrderCount++;
					break;
				case ACTIVITY_TYPE_MODIFY_ORDER:
					modifyOrderCount++;
					break;
				case ACTIVITY_TYPE_FULL_ORDER_EXECUTION:
					// combine partial and full order Ececution
					orderExecutionCount++;
					break;
				case ACTIVITY_TYPE_PARTIAL_ORDER_EXECUTION:
					// combine partial and full order Ececution
					orderExecutionCount++;
					break;
				default:
					break;
			}
			count++;
		}
		
		String result = HFT + separator + side + separator + addOrderCount + separator + deleteOrderCount + separator + modifyOrderCount + separator + orderExecutionCount + "\n";
		return result;
	}
	
	public static void getStandardDeviations(ArrayList<String> paths, String resultFile) throws IOException {
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(resultFile)));
		bw.write("TableName;StandardDeviation" + "\n");

		for (String path : paths) {
			double standardDeviation = 0;
			String newLine = "";
			String currentLine;
			ArrayList<Double> priceList = new ArrayList<Double>(9);
			BufferedReader br = new BufferedReader(new FileReader(new File(path)));
			
			currentLine = br.readLine();
			while((currentLine = br.readLine()) != null) {
				String[] cell = currentLine.split(";");
				priceList.add(Double.parseDouble(cell[COLUMN_PRICE]));
			}
			
			standardDeviation = calculateStandardDeviations(priceList);
			
			String[] pathSplit = path.split("/");
			String fullTableName = pathSplit[pathSplit.length-1];
			String[] tableNameSplit = fullTableName.split("\\.");
			String tableName = tableNameSplit[0];
			
			newLine = tableName + ";" + String.valueOf(standardDeviation); 
					
			bw.write(newLine + "\n");
			br.close();
		}
		
		bw.close();
		
		System.out.println("getStandardDeviations finished");
	}
	
	public static Double calculateStandardDeviations(ArrayList<Double> priceList) {
		double result = 0;
		double sumPrice = 0;
		int priceLength = priceList.size();
		double averagePrice = 0;
		double varianceSum = 0;

		for (Double price : priceList) {
			sumPrice += price;
		}

		averagePrice = sumPrice/priceLength;
		
		for (Double price : priceList) {
			varianceSum += Math.pow((price-averagePrice), 2);
		}
		
		result = Math.sqrt((varianceSum/priceLength));
		
		double resultWithPrecision = new BigDecimal(result).setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

		return resultWithPrecision;
	}
}
