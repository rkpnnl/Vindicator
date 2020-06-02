function Vindicator = Read_Vin_10min(filename, startRow, endRow)
% Read the Vindicator 10 minute data file

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
%	column24: double (%f)
%   column25: double (%f)
%	column26: double (%f)
%   column27: double (%f)
%	column28: double (%f)
%   column29: double (%f)
%	column30: double (%f)
%   column31: double (%f)
%	column32: double (%f)
%   column33: double (%f)
%	column34: double (%f)
%   column35: double (%f)
%	column36: double (%f)
%   column37: double (%f)
%	column38: double (%f)
%   column39: double (%f)
%	column40: double (%f)
%   column41: double (%f)
%	column42: double (%f)
%   column43: double (%f)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: double (%f)
%	column48: double (%f)
%   column49: double (%f)
%	column50: double (%f)
%   column51: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
Vindicator = table(dataArray{1:end-1}, 'VariableNames', {'DataTimeStamp','MessageID','AverageHorizontalWindSpeedRG1','AverageHorizontalWindSpeedRG2','AverageHorizontalWindSpeedRG3','AverageHorizontalWindSpeedRG4','AverageHorizontalWindSpeedRG5','AverageHorizontalWindSpeedRG6','AverageHorizontalWindDirectionRG1','AverageHorizontalWindDirectionRG2','AverageHorizontalWindDirectionRG3','AverageHorizontalWindDirectionRG4','AverageHorizontalWindDirectionRG5','AverageHorizontalWindDirectionRG6','AverageHorizontalWindGustRG1','AverageHorizontalWindGustRG2','AverageHorizontalWindGustRG3','AverageHorizontalWindGustRG4','AverageHorizontalWindGustRG5','AverageHorizontalWindGustRG6','AverageVerticalWindSpeedRG1','AverageVerticalWindSpeedRG2','AverageVerticalWindSpeedRG3','AverageVerticalWindSpeedRG4','AverageVerticalWindSpeedRG5','AverageVerticalWindSpeedRG6','HorizontalWindSpeedStdDeviationRG1','HorizontalWindSpeedStdDeviationRG2','HorizontalWindSpeedStdDeviationRG3','HorizontalWindSpeedStdDeviationRG4','HorizontalWindSpeedStdDeviationRG5','HorizontalWindSpeedStdDeviationRG6','LastIntervalTxMessageCount','LastIntervalErrorCount','VindicatorHandlerLastError','VindicatorLastMODBUSError','CalibrationPeriodStatus','CleaningEventCount','SNRCalibrationEventCount','StatisticsNumSamplesRG1','StatisticsNumSamplesRG2','StatisticsNumSamplesRG3','StatisticsNumSamplesRG4','StatisticsNumSamplesRG5','StatisticsNumSamplesRG6','RangeGatePositionRG1m','RangeGatePositionRG2m','RangeGatePositionRG3m','RangeGatePositionRG4m','RangeGatePositionRG5m','RangeGatePositionRG6m'});

