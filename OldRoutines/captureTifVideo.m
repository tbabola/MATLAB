function captureTifVideo(time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % Add the callback function used for this example to the MATLAB® path.
    utilpath = fullfile('D:\Bergles Lab Data\Matlab\');
    addpath(utilpath);

    %set up trigger configuration
    vid = videoinput('winvideo');
    triggerconfig(vid,'manual');
    vid.TimerFcn = @trigger; %timer callback function, this triggers every acqPeriod
    acqPeriod = 1; %wait time between acquisition(s)
    vid.TimerPeriod = acqPeriod; 
    framesPerTrigger = 3; %number of frames to capture per trigger; these are averaged into one image
    vid.FramesPerTrigger = framesPerTrigger;
    trigRepeat = time * 60 - 1; %number of repeats
    vid.TriggerRepeat = trigRepeat;
    
    vid.TriggerFcn = {'util_imaveragetif', framesPerTrigger};
    
    userdata.average = {};
    userdata.writePath = writePath('D:\Bergles Lab Data\RecordingsAndImaging\');
    pause(1);
    vid.UserData = userdata;
   
    start(vid);
    
    wait(vid,time*60+1);
    
    fprintf('%s\n',userdata.writePath);
    delete(vid);
    clear vid;
end

function writePath = writePath(dir)
    formatOut = 'yymmdd';
    date = datestr(now,formatOut);
    
    folderStr = [dir,date,'\'];
    if ~exist(folderStr,'dir')
        mkdir(dir,date);
    end
    
    startInd = 000;
    
    fileString = [folderStr,date,'_','vid_',num2str(startInd,'%03.f'),'.tif'];
    while exist(fileString,'file') == 2
        startInd = startInd + 1;
        fileString = [folderStr,date,'_','vid_',num2str(startInd,'%03.f'),'.tif'];
    end
    
    writePath = fileString;
    
end
