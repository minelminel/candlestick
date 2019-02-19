# candlestick
###### :bar_chart: Creates a simplified candlestick chart (without shadows) from cell array of [DateLabel Amount]

Designed for easy visualization of changing values, with single values for each unique date

User has full control over the addition of a *trendline*
Fig. 1   without Trendline (above) and with (below)
![candleimg1](https://user-images.githubusercontent.com/46664545/52989157-29434780-33d0-11e9-8da7-772e4531380f.jpg)
> xInterval = 7, yInterval = 50


*syntax:*
> [CandleBar, PrettyArray] = candlestick(CandleData,xInterval,yInterval,Title,TrendLineSpec)

*wizard:*
> NO

*help:*
> help candlestick

abstract: create easily interpreted visuals for any type of changing value over time
  
inputs:
- CandleData--cell array { DateLabels(char) , Balance(double) }
- xInterval--scalar double; date-axis label interval DEFAULT=7
- yInterval--scalar double; dollar-axis tick interval, DEFAULT=1000
- TrendLineSpec--'LineSpec' as commonly used in plot()
      
output:
- CandleBar--figure
- PrettyArray--nicely formatted matrix of values as doubles

notes:
- function will *automatically* insert plot points for missing dates
- function will *automatically* scale bar-width based on the size of data set
- by default, the Title will display the date range. A top-level heading can be added through argument

Fig. 2   Simple example using 4 weeks of Google's NASDAQ Closing Prices
![candlestickimg2](https://user-images.githubusercontent.com/46664545/52988742-6dcde380-33ce-11e9-85c8-131c360ac45a.jpg)
> xInterval = 7, yInterval = auto, TrendLine *off*


