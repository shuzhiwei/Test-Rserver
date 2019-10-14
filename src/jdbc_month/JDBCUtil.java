package jdbc_month;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.xml.crypto.Data;

public class JDBCUtil {
	
	public static String getData() throws SQLException, ClassNotFoundException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://mysql.rdsmjd9t68gl6j3.rds.bj.baidubce.com:3306/bjrde_db?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true", "bjrde", "bjrde_2018");
		
		Statement stat = conn.createStatement();
		String sql = "SELECT riqi, SUM(zong) sum_zong FROM (SELECT LEFT(TIME, 7) riqi, zong FROM electricity WHERE trans_code='TR9EYKVA' ) t1  GROUP BY riqi";
		ResultSet rs = stat.executeQuery(sql);
		List<Electricity> list = new ArrayList<Electricity>();
		while(rs.next()){
			String time  = rs.getString("riqi");
			String zong = rs.getString("sum_zong");
			Electricity ele = new Electricity();
			ele.setTime(time);
			ele.setZong(zong);
			list.add(ele);	
		}
		String data = list.toString();
		String data1 = data.substring(1, data.length()-1);

		rs.close();
		stat.close();
		conn.close();
		
		return data1;
	}

}
