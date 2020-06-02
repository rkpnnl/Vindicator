function Alldata = Read_1s_buoy_main(filename, startRow, endRow)
%   ALLDATA = Read_1s_buoy_main(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   ALLDATA = Read_1s_buoy_main(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Alldata = Read_1s_buoy_main('nj_lidar_main_20160820_20160820_1s_ver_1.csv', 3, 86302);

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 3;
    endRow = inf;
end

%% Format for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

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
Alldata = table(dataArray{1:end-1}, 'VariableNames', {'Year','Month','Day','Hour','Min','Sec','Mtime','V_1','D_1','w_1','QC_1','V_2','D_2','w_2','QC_2','V_3','D_3','w_3','QC_3','V_4','D_4','w_4','QC_4','V_5','D_5','w_5','QC_5','V_6','D_6','w_6','QC_6','roll','r_rate','pitch','p_rate','head','h_rate','lat','lon'});
