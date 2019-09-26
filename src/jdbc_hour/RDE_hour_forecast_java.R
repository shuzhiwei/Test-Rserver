
RDE_hour_forecast = function(d){
	
	#����ѵ�����Ͳ��Լ������һЩ����
	startDate = "2019-01-01"
	hoursForTesting = 1 #Ԥ��δ��һСʱ
	
	#����
	source("F:/ldy_workspace/RserveProject/src/jdbc_hour/hourForecastArima.R")
	
	#������ϴ
	d <- d
	ccc<- unlist(strsplit(d,split=","))
	ddd <- list()
	for(i in 1:length(ccc)){
		o <- ccc[i]
		#o <- gsub(",","",o)
		o <- as.numeric(as.character(o))
		ddd[i] <- o
	}
	dataY<- data.frame(matrix(unlist(ddd), nrow=length(ddd)))
	values = as.vector(dataY[,1])
	#values = unlist(ddd)
	
	flag = 1
	if(flag > 0){
		#����ѵ������
		forecastValues = rep(0,hoursForTesting)
		forecastStart = length(values) - hoursForTesting + 1
		for(hour in c(1:hoursForTesting)){
			trainingData = as.vector(values[1:(length(values)-hour)])
			fit <- hourForecastArimaTraining(trainingData)
			forecastData <- hourForecastArima(fit,1)
			forecastValues[hoursForTesting - hour + 1] = forecastData$mean
		}
		
		#����׼ȷ��
		totalErrorPercent = 0
		for(hour in c(1:hoursForTesting)){
			forecastValue = forecastValues[hoursForTesting - hour + 1]
			realValue = values[length(values) - hour + 1]	
			print(paste("f:",class(forecastValue), "  r:", class(realValue)))
			totalErrorPercent = totalErrorPercent + abs(forecastValue - realValue)/realValue
			print(paste("realValue: ", realValue))	
			print(paste("forecastValue: ", forecastValue))
		}
		avgErrorPercent = totalErrorPercent / hoursForTesting
		accuracyPercent = floor((1 - avgErrorPercent)*100)
		print(paste("accuracyPercent: ", accuracyPercent, "%"))
		forecastValues[1]
	}
	
	
}



