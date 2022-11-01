% clear
% clc
% ao


%% Arctic Sea Ice set up 
janSeaIceExtent = readtable('N_01_extent_v3.0.csv');
febSeaIceExtent = readtable('N_02_extent_v3.0.csv');
marSeaIceExtent = readtable('N_03_extent_v3.0.csv');

seaIceExtent = [janSeaIceExtent.year janSeaIceExtent.extent febSeaIceExtent.extent marSeaIceExtent.extent];
seaIceExtent(10,2) = NaN;

%% Calculate JFM Mean
for i = 1:length(seaIceExtent)
    seaIceYear = seaIceExtent(:,1);
    seaIceMeanExtent(i,1) = nanmean(seaIceExtent(i,[2:4]));
end


%% Calculate Linear Regression and Detrended Extent Array
pSeaIceMeanExtent = polyfit(seaIceYear,seaIceMeanExtent,1);
seaIceRegression = polyval(pSeaIceMeanExtent,seaIceYear);
detrendedSeaIceMeanExtent = seaIceMeanExtent - seaIceRegression;

%% Plot JFM Sea Ice Extent Mean
figure
plot(seaIceYear,seaIceMeanExtent)
hold on
plot(seaIceYear,seaIceRegression,'--')
hold off

ylim([13.5 16.5])
xlim([seaIceYear(1) seaIceYear(end)])

title(['JFM Mean Ice Extent 1979–2020'])
xlabel('Year')
ylabel('Extent (M km)')

legend('JFM Mean Ice Extent', 'Trend')

%% Plot with AO and Sea Ice Mean Extent
figure
yyaxis left
plot(seaIceYear,detrendedSeaIceMeanExtent)
xlim([seaIceYear(1),seaIceYear(end)])
xlabel("Year");
ylabel("Distance from Trend (M km)");

yyaxis right
plot(aoYear(aoYear >= 1979),aoSeasonalMean(aoYear >= 1979))
xlim([seaIceYear(1),seaIceYear(end)])

hline(0, 'k')
xlabel("Year");
ylabel("AO Index");
title("Sea Ice Extent (blue) Overlain with AO Index (orange)")
%% Correlation plot
figure()
corrplot(table(detrendedSeaIceMeanExtent,aoMoveMean(aoYear >= 1979),VariableNames=["ice" "AO"]))
title("Correlation of AO JFM Mean and detrended sea ice JFM mean");