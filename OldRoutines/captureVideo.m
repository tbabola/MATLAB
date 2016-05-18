function captureVideo(time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % Add the callback function used for this example to the MATLAB® path.
    utilpath = fullfile('D:\Bergles Lab Data\Matlab');
    addpath(utilpath);

    vid = videoinput('winvideo');
    
    triggerconfig(vid,'manual');
    vid.TimerFcn = @trigger;
    acqPeriod = 1;
    vid.TimerPeriod = acqPeriod; %wait time (s)
     
    framesPerTrigger = 5;
    vid.FramesPerTrigger = framesPerTrigger;
    trigRepeat = time * 60 - 1;
    vid.TriggerRepeat = trigRepeat;
    
    vid.TriggerFcn = {'util_imaverage2', framesPerTrigger};
    vwObj = VideoWriter('150520_Vid_big','Uncompressed AVI');
    
    userdata.average = {};
    userdata.avi = vwObj;
    vid.UserData = userdata;
   
    start(vid);
    
    wait(vid,time*60+1);
    
    delete(vid);
    delete(vwObj);
    clear vid vwObj;
    rmpath(utilpath);
end
