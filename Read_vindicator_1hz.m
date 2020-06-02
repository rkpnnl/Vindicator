function [Lidar] = Read_vindicator_1hz(filename)

% This function reads raw data from Vindicator Lidar text file and converts
% into a structured output in Matlab after applying the required
% corrections

% Written by: R Krishnamurthy, PNNL


% Initialize variables.
delimiter = ',';

% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: categorical (%C)
%   column5: double (%f)
%	column6: text (%s)
formatSpec = '%s%f%f%C%f%s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');
% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
% Close the text file.
fclose(fileID);

% Post-Processing the raw data
data_len = 500; % Data length
bit_length = 4; % Bit length

% convert the data from hex to decimal
for i = 1:length(dataArray{1,6})
    
    clear date_time year month day hour mins secs temp temp1
    % Time stamps from the onboard computer (?)
    date_time = strsplit(dataArray{1}(i),{'[',']','$','/',' ', ':'});
    year(i) = str2double(strcat('20',date_time(2)));
    month(i) = str2double(date_time(3));
    day(i) = str2double(date_time(4));
    hour(i) = str2double(date_time(5));
    mins(i) = str2double(date_time(6));
    secs(i) = str2double(date_time(7));
    Lidar.Mtime(i) = datenum(year(i),month(i),day(i),hour(i),mins(i),secs(i));
    
    % raw data from the Vindicator
    temp = dataArray{6}(i); % The 6th column data contains the raw hex data
    if(length(temp{1}(:)) > data_len)
        % convert hex to decimal for every 4 string length characters 16-bit unsigned or signed
        temp1 = [];
        for j = 1:bit_length:data_len
            temp1 = [temp1;uint16(hex2dec(temp{1}(j:j+(bit_length-1))))]; 
        end
        
        Lidar.Serial(i) = temp1(1);
        Lidar.Version(i) = temp1(2);
        Lidar.Totallaser(i) = temp1(3);

        % Not sure if this is right - Julian day seems wrong, when converted to
        % 16-bit binary form!!
        Lidar.daytime(i) = temp1(4);
        Lidar.secondsmidnight(i) = temp1(5);
        
        clear status
        % Status messages
        status = dec2bin(temp1(6),16);
        Lidar.statusreg(i,1) = bin2dec(status(1)); % Good data = 1, Bad data = 0 @ range gate #1
        Lidar.statusreg(i,2) = bin2dec(status(2)); % Good data = 1, Bad data = 0 @ range gate #2
        Lidar.statusreg(i,3) = bin2dec(status(3)); % Good data = 1, Bad data = 0 @ range gate #3
        Lidar.statusreg(i,4) = bin2dec(status(4)); % Good data = 1, Bad data = 0 @ range gate #4
        Lidar.statusreg(i,5) = bin2dec(status(5)); % Good data = 1, Bad data = 0 @ range gate #5
        Lidar.statusreg(i,6) = bin2dec(status(6)); % Good data = 1, Bad data = 0 @ range gate #6
        Lidar.statusreg(i,7) = bin2dec(status(7)); % Lasers ON = 1, Lasers STANDBY = 0
        Lidar.statusreg(i,8) = bin2dec(status(8)); % Laser Fault = 1, Clear = 0
        Lidar.statusreg(i,9) = bin2dec(status(9)); % Low Fluid Level = 1, otherwise = 0
        Lidar.statusreg(i,10) = bin2dec(status(10)); % Window Cleaning = 1, otherwise = 0
        Lidar.statusreg(i,11) = bin2dec(status(11)); % Power Supply warning, on UPS battery = 1, on external power = 0
        Lidar.statusreg(i,12) = bin2dec(status(12)); % Pod breached = 1, sealed = 0
        Lidar.statusreg(i,13) = bin2dec(status(13)); % FPGA accumulations increasing = 1, not = 0
        Lidar.statusreg(i,14) = bin2dec(status(14)); % Pod Leaking? If the RH is above a threshold percentage = 1, less than = 0
        Lidar.statusreg(i,15) = bin2dec(status(15)); % Spare set to zero
        Lidar.statusreg(i,16) = bin2dec(status(16)); % SNR Threshold Adjustment in progress = 1, not = 0

        % Wind speed, wind direction and vertical velocity
        % Apply corrections - All divide by 10.

        Lidar.WS(i,1) = double(temp1(7))/10; % Represents range 0 to 6553 m/s divide the integer by 10
        Lidar.WD(i,1) = double(typecast(temp1(8),'int16'))/10; % Represents range -180° to 180°, divide by 10 [ 0° means wind from magnetic North (compass mode).]
        Lidar.W(i,1) = double(typecast(temp1(9),'int16'))/10; % Represents range -3276 to 3276 m/s, divide the integer by 10 [positive means wind is blowing upward]

        Lidar.WS(i,2) = double(temp1(10))/10;
        Lidar.WD(i,2) = double(typecast(temp1(11),'int16'))/10;
        Lidar.W(i,2) = double(typecast(temp1(12),'int16'))/10;

        Lidar.WS(i,3) = double(temp1(13))/10;
        Lidar.WD(i,3) = double(typecast(temp1(14),'int16'))/10;
        Lidar.W(i,3) = double(typecast(temp1(15),'int16'))/10;

        Lidar.WS(i,4) = double(temp1(16))/10;
        Lidar.WD(i,4) = double(typecast(temp1(17),'int16'))/10;
        Lidar.W(i,4) = double(typecast(temp1(18),'int16'))/10;

        Lidar.WS(i,5) = double(temp1(19))/10;
        Lidar.WD(i,5) = double(typecast(temp1(20),'int16'))/10;
        Lidar.W(i,5) = double(typecast(temp1(21),'int16'))/10;

        Lidar.WS(i,6) = double(temp1(22))/10;
        Lidar.WD(i,6) = double(typecast(temp1(23),'int16'))/10;
        Lidar.W(i,6) = double(typecast(temp1(24),'int16'))/10;

        % IMU data
        Lidar.Pitch(i,1) = double(typecast(temp1(25),'int16'))/10; % Represents range -90° to 90°, divide by 10 [0° meaning along horizontal]
        Lidar.Roll(i,1) = double(typecast(temp1(26),'int16'))/10; % Represents range -180° to 180°, divide by 10 [0° meaning flat]
        Lidar.Heading(i,1) = double(typecast(temp1(27),'int16'))/10; % Represents range -180° to 180°, divide by 10 [0° meaning magnetic North]

        Lidar.Pitchrate(i,1) = double(typecast(temp1(28),'int16'))/10;
        Lidar.Rollrate(i,1) = double(typecast(temp1(29),'int16'))/10;
        Lidar.Headingrate(i,1) = double(typecast(temp1(30),'int16'))/10;
        % 31 is a spare bit

        % Range-gate heights
        Lidar.Range(i,1) = double(temp1(32));
        Lidar.Range(i,2) = double(temp1(33));
        Lidar.Range(i,3) = double(temp1(34));
        Lidar.Range(i,4) = double(temp1(35));
        Lidar.Range(i,5) = double(temp1(36));
        Lidar.Range(i,6) = double(temp1(37));

        % GPS locations
        Lidar.GPSlat(i) = double(typecast(temp1(38),'int16'))/183; % Latitude
        Lidar.GPSlon(i) = double(typecast(temp1(39),'int16'))/183; % Longitude

        % Laser 1 prperties at Range-gate #1
        Lidar.signalAmp1(i,1) = double(temp1(40)); % signal amplitude in a.u.
        Lidar.DoppShift1(i,1) = double(typecast(temp1(41),'int16'))*0.775*125/(2^16); % frequency shift, to convert to m/s multiply by 0.775*125/2^16, [+] means air is moving towards the sensor
        Lidar.SNR1(i,1) = double(temp1(42)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 2 prperties at Range-gate #1
        Lidar.signalAmp2(i,1) = double(temp1(43));
        Lidar.DoppShift2(i,1) = double(typecast(temp1(44),'int16'))*0.775*125/(2^16);
        Lidar.SNR2(i,1) = double(temp1(45)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 3 prperties at Range-gate #1
        Lidar.signalAmp3(i,1) = double(temp1(46));
        Lidar.DoppShift3(i,1) = double(typecast(temp1(47),'int16'))*0.775*125/(2^16);
        Lidar.SNR3(i,1) = double(temp1(48)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)

        % Laser 1 prperties at Range-gate #2
        Lidar.signalAmp1(i,2) = double(temp1(50));
        Lidar.DoppShift1(i,2) = double(typecast(temp1(51),'int16'))*0.775*125/(2^16);
        Lidar.SNR1(i,2) = double(temp1(52)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 2 prperties at Range-gate #2
        Lidar.signalAmp2(i,2) = double(temp1(53));
        Lidar.DoppShift2(i,2) = double(typecast(temp1(54),'int16'))*0.775*125/(2^16);
        Lidar.SNR2(i,2) = double(temp1(55)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 3 prperties at Range-gate #2
        Lidar.signalAmp3(i,2) = double(temp1(56));
        Lidar.DoppShift3(i,2) = double(typecast(temp1(57),'int16'))*0.775*125/(2^16);
        Lidar.SNR3(i,2) = double(temp1(58)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)

        % Laser 1 prperties at Range-gate #3
        Lidar.signalAmp1(i,3) = double(temp1(60));
        Lidar.DoppShift1(i,3) = double(typecast(temp1(61),'int16'))*0.775*125/(2^16);
        Lidar.SNR1(i,3) = double(temp1(62)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 2 prperties at Range-gate #3
        Lidar.signalAmp2(i,3) = double(temp1(63));
        Lidar.DoppShift2(i,3) = double(typecast(temp1(64),'int16'))*0.775*125/(2^16);
        Lidar.SNR2(i,3) = double(temp1(65)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 3 prperties at Range-gate #3
        Lidar.signalAmp3(i,3) = double(temp1(66));
        Lidar.DoppShift3(i,3) = double(typecast(temp1(67),'int16'))*0.775*125/(2^16);
        Lidar.SNR3(i,3) = double(temp1(68)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)

        % Laser 1 prperties at Range-gate #4
        Lidar.signalAmp1(i,4) = double(temp1(70));
        Lidar.DoppShift1(i,4) = double(typecast(temp1(71),'int16'))*0.775*125/(2^16);
        Lidar.SNR1(i,4) = double(temp1(72)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 2 prperties at Range-gate #4
        Lidar.signalAmp2(i,4) = double(temp1(73));
        Lidar.DoppShift2(i,4) = double(typecast(temp1(74),'int16'))*0.775*125/(2^16);
        Lidar.SNR2(i,4) = double(temp1(75)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 3 prperties at Range-gate #4
        Lidar.signalAmp3(i,4) = double(temp1(76));
        Lidar.DoppShift3(i,4) = double(typecast(temp1(77),'int16'))*0.775*125/(2^16);
        Lidar.SNR3(i,4) = double(temp1(78)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)

        % Laser 1 prperties at Range-gate #5
        Lidar.signalAmp1(i,5) = double(temp1(80));
        Lidar.DoppShift1(i,5) = double(typecast(temp1(81),'int16'))*0.775*125/(2^16);
        Lidar.SNR1(i,5) = double(temp1(82)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 2 prperties at Range-gate #5
        Lidar.signalAmp2(i,5) = double(temp1(83));
        Lidar.DoppShift2(i,5) = double(typecast(temp1(84),'int16'))*0.775*125/(2^16);
        Lidar.SNR2(i,5) = double(temp1(85)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 3 prperties at Range-gate #5
        Lidar.signalAmp3(i,5) = double(temp1(86));
        Lidar.DoppShift3(i,5) = double(typecast(temp1(87),'int16'))*0.775*125/(2^16);
        Lidar.SNR3(i,5) = double(temp1(88)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)

        % Laser 1 prperties at Range-gate #6
        Lidar.signalAmp1(i,6) = double(temp1(90));
        Lidar.DoppShift1(i,6) = double(typecast(temp1(91),'int16'))*0.775*125/(2^16);
        Lidar.SNR1(i,6) = double(temp1(92)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 2 prperties at Range-gate #6
        Lidar.signalAmp2(i,6) = double(temp1(93));
        Lidar.DoppShift2(i,6) = double(typecast(temp1(94),'int16'))*0.775*125/(2^16);
        Lidar.SNR2(i,6) = double(temp1(95)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        % Laser 3 prperties at Range-gate #6
        Lidar.signalAmp3(i,6) = double(temp1(96));
        Lidar.DoppShift3(i,6) = double(typecast(temp1(97),'int16'))*0.775*125/(2^16);
        Lidar.SNR3(i,6) = double(temp1(98)); %bits 0-7: Signal Loss Threshold (signal amplitude must fall below this value to lose the signal)
                            %bits 8-15: Signal Detect Threshold (signal amplitude must rise above this value to detect the signal)
        clear temp temp1
    end
end

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans temp temp1;