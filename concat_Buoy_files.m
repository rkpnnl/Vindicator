function [Lidar] = concat_Buoy_files(Alldata_hk,Alldata_snr,Alldata_main)

    Lidar.Range = Alldata_hk{:,25:30};
    Lidar.Mtime = Alldata_snr{:,7};
    
    Lidar.DoppShift1 = Alldata_snr{:,80}*0.775*125/(2^16);
    Lidar.DoppShift2 = Alldata_snr{:,81}*0.775*125/(2^16);
    Lidar.DoppShift3 = Alldata_snr{:,82}*0.775*125/(2^16);
    
    Lidar.signalAmp1 = Alldata_snr{:,83};
    Lidar.signalAmp2 = Alldata_snr{:,84};
    Lidar.signalAmp3 = Alldata_snr{:,85};
    
    Lidar.GPSlat = Alldata_main{:,38};
    Lidar.GPSlon = Alldata_main{:,39};
    Lidar.Pitch = Alldata_main{:,34};
    Lidar.Roll = Alldata_main{:,32};
    Lidar.Heading = Alldata_main{:,36};
    Lidar.Pitchrate = Alldata_main{:,35};
    Lidar.Rollrate = Alldata_main{:,33};
    Lidar.Headingrate = Alldata_main{:,37};
    Lidar.WS = Alldata_main{:,[8 12 16 20 24 28]};
    Lidar.WD = Alldata_main{:,[9 13 17 21 25 29]};
    Lidar.W = Alldata_main{:,[10 14 18 22 26 30]};
    Lidar.QC = Alldata_main{:,[11 15 19 23 27 31]};
    