
RDE_month_forecast = function(d){
	
	# 加载包
	library(forecast)

	# 参数数据character 转换成 list
	d <- d
	ccc<- unlist(strsplit(d,split=","))
	ddd <- list()
	for(i in 1:length(ccc)){
		o <- ccc[i]
		o <- gsub(",","",o)
		o <- as.numeric(as.character(o))
		ddd[i] <- o
	}

	# list转换为data.frame
	dataY<- data.frame(matrix(unlist(ddd), nrow=length(ddd)))
	dataMonthly <- as.vector(dataY[,1])

	startDate = c(2016,12)
	monthsForTesting = 1

	data <- ts(dataY, frequency = 12, start = startDate)
	tsdisplay(data)

	forecastValues = rep(0, monthsForTesting)
	forecastStart = length(dataMonthly) - monthsForTesting + 1
	
	for(month in c(1:monthsForTesting)){
		trainingData <- ts(as.vector(dataMonthly[1:(length(dataMonthly) - month)]), frequency=12, start=startDate)
		fit <- monthlyForecastArimaTraining(trainingData)
		forecastValue <- monthlyForecastArima(fit, 1)
		forecastValues[monthsForTesting - month + 1] <- forecastValue
	}
	
	totalErrorPercent = 0
	
	for(month in c(1:monthsForTesting)){
		forecastValue = forecastValues[monthsForTesting-month+1]
		realValue = dataMonthly[length(dataMonthly) - month + 1]
		totalErrorPercent = totalErrorPercent + abs(realValue - forecastValue)/realValue
		print(paste(month, "=> realValue: ", realValue, ", forecastValue: ", forecastValue))
	}
	totalErrorPercent = totalErrorPercent / monthsForTesting
	avgAccuracy = floor((1 - (totalErrorPercent))*100)
	print(paste("avgrage-accuracy: ", avgAccuracy, "%"))
	
	forecastValues[monthsForTesting]
}
	
monthlyForecastArimaTraining = function(training){
	
	a = 1
	if(a > 0){
		
		best_p = 0;
		d = 1;
		best_q = 0;
		best_P = 0;
		D = 1;
		best_Q = 0;
		best_AIC = NA;
		
		if(best_p < 0){
			for (p in c(0:1)) {
				for (q in c(0:2)) {
					for (P in c(0:2)) {
						for (Q in c(0:2)) {
							suppressWarnings(f <- try(arima(training, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=12)), silent = TRUE)) #print(f)
							if (!is.element("try-error", class(f)))
							{
								aic = f$aic #print(aic)
								print(paste(p, d, q, P, D, Q))
								if (is.na(best_AIC) || aic < best_AIC)
								{
									best_AIC = aic
									best_p = p
									best_q = q
									best_P = P
									best_Q = Q
								}
							}
						}
					}
				}
			}
		}
		
		fit <- arima(training, order=c(best_p,1,best_q), seasonal=list(order=c(best_P,1,best_Q), period=12))
		print(paste(best_p, d, best_q, best_P, D, best_Q, 12))
		
		fit
	}
}

monthlyForecastArima = function(fit, count){
	
	forecastData = forecast(fit, h = count, level = c(99.5))
	v3 = forecastData$mean
	v3
}
		
