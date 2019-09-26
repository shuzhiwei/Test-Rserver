
RDE_nextday_forecast = function(d){

	startDate = "2018-01-01"
	daysForTesting = 1

	source("F:/ldy_workspace/RserveProject/src/jdbc_day/dailyForecastArima.R")

	#������ϴ
	d <- d
	ccc<- unlist(strsplit(d,split=","))
	ddd <- list()
	for(i in 1:length(ccc)){
		o <- ccc[i]
		o <- gsub(",","",o)
		o <- as.numeric(as.character(o))
		ddd[i] <- o
	}

	# listת��Ϊdata.frame,����ȡ�����е�һ�е�����,����װ��һ������
	dataY<- data.frame(matrix(unlist(ddd), nrow=length(ddd)))
	dataDaily = as.vector(dataY[,1])
	#dataDaily = unlist(ddd)
	
	# ����ԭʼ���ݵ�ʱ����������
	data <- ts(dataDaily, frequency = 1)
	#plot(data, ylab = "Daily electricity usage (Orignal)", xlab = paste("Number of days starting from", startDate))

flag = 1
if(flag > 0){
	#Ԥ��nextday�����н��,��������forecastValues��װ
	#Search all next day
	#�����һ�쿪ʼԤ��,������ǰ,����Ԥ��ֵ���forecastValues����
	forecastValues = rep(0, daysForTesting)
	forecastStart = length(dataDaily) - daysForTesting + 1
	
	for (days in c(1:daysForTesting)) {
	  #Create training data (without last 4 days)
	  trainingData <- as.vector(dataDaily[1:(length(dataDaily) - days)])

	  #Create ARIMA model
	  fit <- dailyForecastArimaTraining(trainingData, 1)
	  #Forecase
	  forecastData = dailyForecastArima(fit, 1)
	  forecastValues[daysForTesting-days+1] = forecastData$mean
	}
	

	#Calculate average error %
	#���������
	totalErrorPercent = 0;
	for (days in c(1:daysForTesting)) {
	  forecastValue = forecastValues[daysForTesting-days+1]
	  realValue = dataDaily[length(dataDaily)-days+1]
	  totalErrorPercent = totalErrorPercent + abs(realValue - forecastValue) / realValue
	  print(paste("realValue: ", realValue))
	  print(paste("forecastValue: ", forecastValue))
	}
	totalErrorPercent = totalErrorPercent / daysForTesting
	print(paste("average-percent: ", totalErrorPercent))

	v3 = as.vector(unlist(forecastValues[1]))
	v3
	}
}



