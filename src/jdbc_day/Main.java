package jdbc_day;

import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

public class Main {
	
	public static void main(String[] args) throws Exception {
		RConnection connection = new RConnection();
		try {
			connection.eval("source('F:/ldy_workspace/RserveProject/src/jdbc_day/RDE_nextday_forecast_java.R')");
			String data = JDBCUtil.getData();
			double forecastValue=connection.eval("RDE_nextday_forecast('"+ data +"')").asDouble();
			System.out.println("forecastValue= "+forecastValue);
		} catch (RserveException e) {
			e.printStackTrace();
		}finally {
			connection.close();
		}
		
	}
}
