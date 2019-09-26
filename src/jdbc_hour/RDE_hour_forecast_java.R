
RDE_hour_forecast = function(d){
	
	#构建训练集和测试集所需的一些参数
	startDate = "2019-01-01"
	hoursForTesting = 1 #预测未来一小时
	
	#导包
	source("F:/ldy_workspace/RserveProject/src/jdbc_hour/hourForecastArima.R")
	
	#数据清洗
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
		#构建训练数据
		forecastValues = rep(0,hoursForTesting)
		forecastStart = length(values) - hoursForTesting + 1
		for(hour in c(1:hoursForTesting)){
			trainingData = as.vector(values[1:(length(values)-hour)])
			fit <- hourForecastArimaTraining(trainingData)
			forecastData <- hourForecastArima(fit,1)
			forecastValues[hoursForTesting - hour + 1] = forecastData$mean
		}
		
		#计算准确率
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




