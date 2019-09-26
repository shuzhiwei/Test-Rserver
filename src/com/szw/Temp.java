package com.szw;

import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;
import org.rosuda.REngine.REXPMismatchException;;
public class Temp {
 
	public static void main(String[] args) throws REXPMismatchException {
		RConnection connection = null;
		System.out.println("平均值");
		try {
			//创建对象
			connection = new RConnection();
			String vetor="c(1,2,3,4)";
			connection.eval("meanVal<-mean("+vetor+")");
	
			//System.out.println("the mean of given vector is="+mean);
			double mean=connection.eval("meanVal").asDouble();
			System.out.println("the mean of given vector is="+mean);
			//connection.eval(arg0)
			
		} catch (RserveException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		/*
		System.out.println("执行脚本");
		try {
			connection.eval("source('D:/myAdd.R')");//此处路径也可以这样写D:\\\\myAdd.R
			int num1=20;
			int num2=10;
			int sum=connection.eval("myAdd("+num1+","+num2+")").asInteger();
			System.out.println("the sum="+sum);
		} catch (RserveException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		*/
		connection.close();
	}
}

