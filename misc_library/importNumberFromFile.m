function c110001 = importNumberFromFile(filename, formatSpec, delimiter, startRow, endRow)
%importNumberFromFile Import numeric data from a text file as a matrix.
%   C110001 = importNumberFromFile(FILENAME,DELIMITER,FORMATSPEC,STARTROW,ENDROW) 
%   Reads data from text file FILENAME separated by DELIMITER with FORMATSPEC
%   from STARTROW to ENDROW (optional).
%
%   DELIMITER = ',' (default)
%   FORMATSPEC = '%f%f%f%f%f%f%f%f%[^\n\r]' (default)
%   STARTROW = 1 (default)
%   ENDROW = Inf (default)
%
% Example:
%   c110001 = importfile4('c_11_0_001.txt', 1, 3888);
%

%% Initialize variables.
if nargin<2
    formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
end

if nargin<3
    delimiter = ',';
end

if nargin<=4
    startRow = 1;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
% For more information, see the TEXTSCAN documentation.

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
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
dataArray = cellfun(@(x) num2cell(x), dataArray, 'UniformOutput', false);
c110001 = [dataArray{1:end-1}];
