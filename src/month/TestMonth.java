package month;

import org.rosuda.REngine.Rserve.RConnection;

public class TestMonth {
	public static void main(String[] args) {
		RConnection connection = null;
		try{
			String ip = "180.76.155.84";
			String address = "C:/bjrde/ARIMA/RDE_month_forecast_java.R";
			
			
			//monthly数据
			//智造大街2017-03到2019-02 共23
			String data = "38060.200000000004, 38042.32, 62156.0, 86940.0, 145551.015625, 123270.03125, 82537.0, 56628.0, 128310.0, 189713.03125, 231730.0, 166173.0, 141904.99000000022, 83430.0, 99750.0, 126870.0, 159330.0, 160453.0, 96210.0, 77430.0, 137772.99, 245250.0, 242040.0, 183570, 107310";

			connection = new RConnection(ip);
			
			connection.eval("source('" + address + "')");
			String function = "RDE_month_forecast('" + data + "')";
			double[] forecast = connection.eval(function).asDoubles();
			if(forecast != null){
				if(forecast[0] <= 0){
					forecast = null;
				}else{
					System.out.println("预测值: ");
					for (double d : forecast) {
						System.out.println(d);
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
