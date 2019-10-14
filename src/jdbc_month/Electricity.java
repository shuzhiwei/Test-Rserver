package jdbc_month;

public class Electricity {
	String time;
	String zong;
	public Electricity() {

	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getZong() {
		return zong;
	}
	public void setZong(String zong) {
		this.zong = zong;
	}
	@Override
	public String toString() {
		return this.zong;
	}
	
}
