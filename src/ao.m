clear
clc
% load matlab.mat

%% AO Initial Set-up
aoindex = readtable('ao.csv');
dateao = datenum(aoindex.Year);

aoindex = table2array(aoindex);
aoYear = aoindex(:,1);
aoindex(:,1) = [];

%% Annual

for i = 1:12
aoMean(1,i) = nanmean(aoindex(:,i));
aoStd(1,i)  = nanstd(aoindex(:,i));
aoMin(1,i)  = nanmin(aoindex(:,i)); 
aoMax(1,i)  = nanmax(aoindex(:,i));
end


figure
errorbar([1:12]',aoMean',aoStd')
hold on

plot([1:12]',aoMax,'X')

plot([1:12]',aoMin,'x')

title('P.O.R. Distribution of Index Values (Mean, 1-sigma deviation, max, min)')
xlabel('Month')
ylabel('Index')
xlim([0 13])

%% Seasonal 
%mean

for i = 1:length(aoindex)
       aoSeasonalMean(i,1) = mean(aoindex(i,1:3));
end

aoMoveMean = movmean(aoSeasonalMean,5);

p = polyfit(aoYear,aoSeasonalMean,1);
aoTrend =  polyval(p, aoYear);

p1 = polyfit(aoYear,aoMoveMean,1);
aoTrendMovMean =  polyval(p1, aoYear);

figure
hold on
h(1) = plot(dateao,aoSeasonalMean);
h(2) = plot(dateao,aoMoveMean);
h(3) = plot(dateao,aoTrend,'--');
h(4) = hline(0);
hold off

title('Seasonal JFM Mean for AO 1950-2020')
xlabel('Year')
ylabel('Index')

legend(h(1:3),"Annual JFM mean value", "5yr moving mean", "Trend")

aoFirstHalfMean = mean(aoSeasonalMean(1:35));
aoSecondHalfMean = mean(aoSeasonalMean(36:71));
