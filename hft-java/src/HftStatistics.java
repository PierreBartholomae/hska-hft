import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;

public class HftStatistics {

	public static final String ACTIVITY_TYPE_MODIFY_ORDER = "MODIFY_ORDER";
	public static final String ACTIVITY_TYPE_ADD_ORDER = "ADD_ORDER";
	public static final String ACTIVITY_TYPE_DELETE_ORDER = "DELETE_ORDER";
	public static final String ACTIVITY_TYPE_FULL_ORDER_EXECUTION = "FULL_ORDER_EXECUTION";
	
	public static final Integer COLUMN_ID = 1;
	public static final Integer COLUMN_ACTIVITY_TYPE = 9;//10;
	public static final Integer COLUMN_SIDE = 18;
	public static final Integer COLUMN_HFT = 28;
	public static final Integer COLUMN_PRICE = 29;

	public static void main(String[] args) {
		String dataPath = "/Users/pierre/Dropbox/MYDROPBOX/studium/master/wpfs/high-frequency-trading/daten/";
		//String dataPath = "C:\\Users\\Moe\\Desktop\\BigData\\";

		String statisticsDirectoryPath = dataPath + "statistics/";
		//String statisticsDirectoryPath = dataPath + "statistics\\";

		File statisticsDirectory = new File(statisticsDirectoryPath);
		if (!statisticsDirectory.exists()) {
			if (statisticsDirectory.mkdir()) {
				System.out.println("Statistics directory created");
			} else {
				System.out.println("please create statistics directory manually");
			}
		}
		
		//Basic MethodPaths
		String dataIndexedPath = dataPath + "hft-data-indexed.csv";
		String dataFixedPath = dataPath + "hft-data-fixed.csv";
		String dataHFTPartPath = dataPath + "hft-data-hftPart.csv";
		String datanonHFTPartPath = dataPath + "hft-data-nonhftPart.csv";

		//BuyTables
		String dataBuyTablePathFull = dataPath + "hft-data-buyTableFull.csv";
		String dataBuyTablePathHFT = dataPath + "hft-data-buyTableHFT.csv";
		String dataBuyTablePathnonHFT = dataPath + "hft-data-buyTablenonHFT.csv";

		//SellTables
		String dataSellTablePathFull = dataPath + "hft-data-sellTableFull.csv";
		String dataSellTablePathHFT = dataPath + "hft-data-sellTableHFT.csv";
		String dataSellTablePathnonHFT = dataPath + "hft-data-sellTablenonHFT.csv";

		//Spread
		String spreadTablePathFull = statisticsDirectoryPath + "hft-data-spreadTableFull.csv";
		String spreadTablePathHFT = statisticsDirectoryPath + "hft-data-spreadTableHFT.csv";
		String spreadTablePathnonHFT = statisticsDirectoryPath + "hft-data-spreadTablenonHFT.csv";
		
		// StatisticsTable
		String activityTablePath = statisticsDirectoryPath + "hft-data-activityTable.csv";

		try {
			// calcSpreads
			// dataSellTables and dataBuyTables must exists!
			double calcSpreadRange = 10000;
			calcSpread(dataSellTablePathFull, dataBuyTablePathFull, spreadTablePathFull, calcSpreadRange);
			calcSpread(dataSellTablePathHFT, dataBuyTablePathHFT, spreadTablePathHFT, calcSpreadRange);
			calcSpread(dataSellTablePathnonHFT, dataBuyTablePathnonHFT, spreadTablePathnonHFT, calcSpreadRange);
			
			// get more statistics
			getActivityTypeFrequencies(dataSellTablePathHFT, dataBuyTablePathHFT, dataSellTablePathnonHFT, dataBuyTablePathnonHFT, activityTablePath, ";");

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// range: any number or -1 for all
	public static void calcSpread (String sellFile, String buyFile, String resultFile, double range) throws IOException{
		BufferedReader br1 = new BufferedReader(new FileReader(new File(sellFile)));
		BufferedReader br2 = new BufferedReader(new FileReader(new File(buyFile)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(resultFile)));

		ArrayList<Double> sellList = new ArrayList<Double>();
		ArrayList<Double> buyList = new ArrayList<Double>();
		
		sellList = getPriceForColumn(br1, range);
		buyList = getPriceForColumn(br2, range);
		
		bw.write("ID;Spreads;" + "\n");
		for(int i = 0; i < sellList.size() && i < buyList.size(); i++){
			double priceDifference = sellList.get(i) - buyList.get(i);
			double priceDifferenceWithPrecision = new BigDecimal(priceDifference).setScale(7, BigDecimal.ROUND_HALF_UP).doubleValue();
			
			bw.write(String.valueOf(priceDifferenceWithPrecision) + "\n");
		}
		
		br1.close();
		br2.close();
		bw.close();
		
		System.out.println("calcSpread finished");
	}
	
	public static ArrayList<Double> getPriceForColumn(BufferedReader br, double range) throws IOException {
		String line = br.readLine();
		int count = 0;
		double priceValue = 0;
		ArrayList<Double> priceList = new ArrayList<Double>();
		
		while((line=br.readLine())!=null){
			String[] split = line.split(";");
			priceValue += Double.parseDouble(split[28]);
			count++;
			if (count == range){
				priceList.add(priceValue/range);
				priceValue = 0;
				count = 0;
			}
		}
		if(range == -1) {
			priceList.add(priceValue/count);
		}
		return priceList;
	}
	
	public static void getActivityTypeFrequencies (String sellFileHFT, String buyFileHFT, String sellFilenonHFT, String buyFilenonHFT, String resultFile, String separator) throws IOException {
		BufferedReader brSellHFT = new BufferedReader(new FileReader(new File(sellFileHFT)));
		BufferedReader brBuyHFT = new BufferedReader(new FileReader(new File(buyFileHFT)));
		BufferedReader brSellnonHFT = new BufferedReader(new FileReader(new File(sellFilenonHFT)));
		BufferedReader brBuynonHFT = new BufferedReader(new FileReader(new File(buyFilenonHFT)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(resultFile)));
		
		bw.write("HFT" + separator + "Side" + separator + "Add Order" + separator + "Delete Order" + separator + "Modify Order" + separator + "Full Order Execution" + separator + "\n");

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
		Integer fullOrderExecutionCount = 0;
		
		while((line = br.readLine()) != null){
			String[] cells = line.split(separator);
			line = "";
			// Split in HFT and nonHFT
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
					fullOrderExecutionCount++;
					break;
				default:
					break;
			}
			count++;
		}
		
		String result = HFT + separator + side + separator + addOrderCount + separator + deleteOrderCount + separator + modifyOrderCount + separator + fullOrderExecutionCount + separator + "\n";
		return result;
	}
}
