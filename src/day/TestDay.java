package day;

import java.io.File;
import java.io.FileInputStream;

import org.rosuda.REngine.Rserve.RConnection;

public class TestDay {
	public static void main(String[] args) {
		RConnection connection = null;
		try{
			String ip = "180.76.155.84";
			String address = "C:/bjrde/ARIMA/daily/daily_forecast.R";
			
			
			//day数据
			//预测智造大街..到2019-08-22,手动输入了这一天的数据为0
			FileInputStream fis = new FileInputStream(new File("C:\\Users\\Administrator\\Desktop\\测试数据\\zzdj_2018-01-01_2019-08-21.txt"));
			StringBuilder sb = new StringBuilder();
			byte[] arr = new byte[1024];
			int len;
			while((len=fis.read(arr)) != -1){
				sb.append(new String(arr, 0, len));
			}
			String data = sb.toString();
			connection = new RConnection(ip);
			
			connection.eval("source('" + address + "')");
			String function = "RDE_nextday_forecast('" + data + "')";
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
