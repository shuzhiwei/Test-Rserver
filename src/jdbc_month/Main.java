package jdbc_month;

import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;


public class Main {
	
	public static void main(String[] args) throws Exception {
		RConnection connection = new RConnection();
		try {
			connection.eval("source('F:/ldy_workspace/RserveProject/src/jdbc_month/RDE_month_forecast_java.R')");
			String data = JDBCUtil.getData();
			String[] splits = data.split(",");
			double realValue = Double.valueOf(splits[splits.length - 1]);
			System.out.println(data);
			System.out.println("realValue= " + realValue);
			double forecastValue=connection.eval("RDE_month_forecast('"+ data +"')").asDouble();
			System.out.println("forecastValue= "+forecastValue);
			double accuracy = Math.floor((1 - (Math.abs(forecastValue - realValue) / realValue)) * 100);
			System.out.println("accuracy= " + accuracy + "%");
		} catch (RserveException e) {
			e.printStackTrace();
		}finally {
			connection.close();
		}
		
	}
}
