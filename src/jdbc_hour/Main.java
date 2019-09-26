package jdbc_hour;

import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

public class Main {
	
	public static void main(String[] args) throws Exception {
		RConnection connection = new RConnection();
		try {
			connection.eval("source('F:/ldy_workspace/RserveProject/src/jdbc_hour/RDE_hour_forecast_java.R')");
			String data = JDBCUtil.getData();
			System.out.println(data);
			double forecastValue=connection.eval("RDE_hour_forecast('"+ data +"')").asDouble();
			System.out.println("forecastValue= "+forecastValue);
		} catch (RserveException e) {
			e.printStackTrace();
		}finally {
			connection.close();
		}
		
	}
}
