function util_imaverage2(obj, event, nFrames)
%UTIL_IMAVERAGE Average acquired image frames and save result to disk.
%
%    UTIL_IMAVERAGE(OBJ, EVENT, NFRAMES) accesses the video input 
%    object OBJ and uses it to remove NFRAMES of acquired images. 
%    These images are then averaged using the Image Processing Toolbox.
%    The results are saved to disk using the AVI file object stored in
%    OBJ.
%

%    CP 1-27-03
%    Copyright 2001-2011 The MathWorks, Inc.

% Display information on the current event.
eventTime = datestr(event.Data.AbsTime, 13);
statusStr = [event.Type, ' event occurred at ' eventTime, '.'];
fprintf('%s\n', statusStr);

% Access acquired data.
data = getdata(obj, nFrames);
pause(0.2);
flushdata(obj);

% Access the video input object's userdata, and
% determine if this is the first average or not.
firstFrame = 1;
userdata = obj.UserData;
if isempty(userdata.average),
    average = data(:, :, :, 1);
else
    average = userdata.average{end};
end

% Average acquired data.
imageSum = uint16(zeros(size(data,1),size(data,2),size(data,3)));
for f = firstFrame:nFrames,
    imageSum = imageSum + uint16(data(:, :, :, f));
    %assignin('base','isum',imageSum);
end
average = uint8(imdivide(imageSum, nFrames));

% Log averaging results to disk.
vwObj = userdata.avi;
open(vwObj);
writeVideo(vwObj, average);

% If there are no more frames to process, the 
% AVI file can be closed.
framesLeft = get(obj, 'FramesAvailable');
acqActive = strcmp(obj.Running, 'on');

if (framesLeft==0) && ~acqActive,
    close(vwObj);
end

% Store the current state for the next iteration.
userdata.average{end+1} = average;
obj.UserData = userdata;
end 