function [CandleBar,PrettyArray] = candlestick(CandleData,xInterval,yInterval,Title,TrendLineSpec)
%   function [CandleBar, PrettyArray] = CANDLESTICK(CandleData,xInterval,yInterval,TrendLineSpec)
% input arguments:
%   CandleData........cell array; { DateLabels(char) , Balance(double) }
%   xInterval.........scalar double; date-axis label interval DEFAULT=7
%   yInterval.........scalar double; dollar-axis tick interval, DEFAULT=1000
%   TrendLineSpec.....'LineSpec' as commonly used, see below
% output arguments:
%   CandleBar.........figure
%   PrettyArray.......nicely formatted matrix of values, as doubles
% 
% TAKES INPUT AS CELL ARRAY OF DATES & BALANCES 
% AND RETURNS A CANDLESTICK PLOT. FUNCTION WILL
% AUTOMATICALLY INSERT STEADY PLOT POINTS FOR MISSING DAYS.
% HANDLE IS SET TO 'visible,'on' BY DEFAULT
% 	line 82
% 
% TrendLineSpec HAS FULL LineSpec FUNCTIONALITY
%   example:  /...xinterval,'b.-')
%     plots a blue dash-dotted line
% BY DEFAULT, TRENDLINE WILL NOT DISPLAY.
% 
% 
% © Michael Lawrenson
% 18-Feb-2019 03:58:00

trendlineON = false;
switch nargin
    case 0
        warning('cannot call _candlestick_ as empty function')
        return
        
    case 1
        yInterval = 1000;
        xInterval = 7;
        
    case 2
        yInterval = 1000;
        
    case 5
        trendlineON = true;
        
end

formatOut = 'mm/dd/yy';
% ScreenSize = get(0, 'ScreenSize');

data = CandleData;

serial = datenum(data(:,1));
total = cell2mat(data(:,2));
change = zeros(length(serial),1);

for i = 1:length(serial)-1      % i = 2:length(serial)
    change(i) = total(i+1) - total(i);  % change(i) = total(i) - total(i-1);
end

Chart = [serial total change];

% % Pad with 0's on days without data
% add missing data to cached array
% vertcat with real data
% sort by first column

Cached = [];
index = 1;
for i = serial(1):1:serial(end)
    if ~any(ismember(serial,i))
        Cached(index,:) = [i 0 0];
        index = index + 1;
    end
end

PrettyArray = [Chart; Cached];
PrettyArray = sortrows(PrettyArray,1);

for i = 1:length(PrettyArray)
    if ~PrettyArray(i,2)
        PrettyArray(i,2) = PrettyArray(i-1,2)+PrettyArray(i-1,3);
    else
        continue
    end
end

Balance = PrettyArray(:,2);
Days = PrettyArray(:,1).';
yesorno = PrettyArray(:,3) < 0;
Neg = (yesorno .* PrettyArray(:,3));
yesorno = PrettyArray(:,3) > 0;
Pos = (yesorno .* PrettyArray(:,3));

Stack = [Balance Neg Pos];
% CandleBar = figure('NumberTitle','off','Name','Candlestick');

% % % % ON / OFF DISPLAY % % %
set(gcf,'visible','on');
% set(gcf,'visible','off')


% subplot(3,1,1)  % DEFAULT VIEW
CandleBar = bar(Days,Stack,'stacked');
CandleBar(1).FaceColor = [1.0 1.0 1.0];
CandleBar(2).FaceColor = [1.0 0.1 0.1];
CandleBar(3).FaceColor = [0.1 1.0 0.1];
CandleBar(1).EdgeColor = [1.0 1.0 1.0];
if trendlineON
    hold on
    plot(Days,Balance,TrendLineSpec,'LineWidth',1.6);
    hold off
end

yAxisJump = 10;

xTicks = cellstr(datestr(Days,formatOut)).';
xticks(Days(1:xInterval:end));
xticklabels(xTicks(1:7:end));
xtickangle(-45);

LoLimit = min(Balance)*0.98;
HiLimit = max(Balance)*1.02;

if nargin == 1
    yTicks = round(linspace(LoLimit,HiLimit,yAxisJump));
else
    yTicks = round(LoLimit:yInterval:HiLimit)
end

yLabels = cellstr(strcat('$ ',num2str(yTicks.')));
yticks(yTicks)
yticklabels(yLabels)
ylim([LoLimit HiLimit])

switch nargin
    case {4,5}
        titlemsg = sprintf('%s\n%s   ...   %s',Title,CandleData{1,1},CandleData{end,1});
    otherwise
        titlemsg = sprintf('%s   ...   %s',CandleData{1,1},CandleData{end,1});
end
title(titlemsg)

end

% % % % % alternate display frameworks
% = = = = = = = = = = = = = =

% Solo = [Neg Pos];
% 
% subplot(3,1,2)  % CHOICE 1
% PanBarSolo = bar(Days,Solo,'stacked');
% PanBarSolo(1).FaceColor = [1.0 0.1 0.1];
% PanBarSolo(2).FaceColor = [0.1 1.0 0.1];
% ylim([1.2*min(Neg) 1.2*max(Pos)])
% 
% Solo2 = [abs(Neg) Pos];
% 
% subplot(3,1,3)  % CHOICE 2
% PanBarSolo2 = bar(Days,Solo2,'stacked');
% PanBarSolo2(1).FaceColor = [1.0 0.1 0.1];
% PanBarSolo2(2).FaceColor = [0.1 1.0 0.1];
