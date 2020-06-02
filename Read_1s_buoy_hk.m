function Alldata = Read_1s_buoy_hk(filename, startRow, endRow)
%   Alldata = Read_1s_buoy_hk(FILENAME, STARTROW,
%   ENDROW) Reads data from rows STARTROW through ENDROW of text file
%   FILENAME.
%
% Example:
%   Alldata = Read_1s_buoy_hk('nj_lidar_snr_20160322_20160322_1s_ver_1.csv', 3, 86375);


%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 3;
    endRow = inf;
end

%% Format for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

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
Alldata = table(dataArray{1:end-1}, 'VariableNames', {'Year','Month','Day','Hour','Min','Sec','Epoch','L1_1','D1_1','Low_1_1','High_1_1','L2_1','D2_1','Low_2_1','High_2_1','L3_1','D3_1','Low_3_1','High_3_1','L1_2','D1_2','Low_1_2','High_1_2','L2_2','D2_2','Low_2_2','High_2_2','L3_2','D3_2','Low_3_2','High_3_2','L1_3','D1_3','Low_1_3','High_1_3','L2_3','D2_3','Low_2_3','High_2_3','L3_3','D3_3','Low_3_3','High_3_3','L1_4','D1_4','Low_1_4','High_1_4','L2_4','D2_4','Low_2_4','High_2_4','L3_4','D3_4','Low_3_4','High_3_4','L1_5','D1_5','Low_1_5','High_1_5','L2_5','D2_5','Low_2_5','High_2_5','L3_5','D3_5','Low_3_5','High_3_5','L1_6','D1_6','Low_1_6','High_1_6','L2_6','D2_6','Low_2_6','High_2_6','L3_6','D3_6','Low_3_6','High_3_6'});

% Create a structure













