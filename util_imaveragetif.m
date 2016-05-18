function util_imaveragetif(obj, event, nFrames)
%UTIL_IMAVERAGE Average acquired image frames and save result to disk.
%
%    UTIL_IMAVERAGETIF(OBJ, EVENT, NFRAMES) accesses the video input 
%    object OBJ and uses it to remove NFRAMES of acquired images. 
%    These images are then averaged using the Image Processing Toolbox.
%    The results are saved to disk using the tif file object stored in
%    OBJ.
%

%    TB 5/21/2015

% Display information on the current event.
eventTime = datestr(event.Data.AbsTime, 13);
triggerNum = obj.TriggersExecuted;
triggerNum = num2str(triggerNum);
statusStr = ['Frame ', triggerNum , ', ',event.Type, ' event occurred at ' eventTime, '.'];
fprintf('%s\n', statusStr);

% Access acquired data.
data = getdata(obj, nFrames);
data = squeeze(data(:,:,1,:)); %only take out the important channel
pause(0.2);
flushdata(obj);
userdata = obj.userdata;

% Access the video input object's userdata, and
% determine if this is the first average or not.
firstFrame = 1; 

% Average acquired data.
imageSum = uint16(zeros(size(data,1),size(data,2)));
for f = firstFrame:nFrames,
    imageSum = imageSum + squeeze(uint16(data(:, :, f)));
    %assignin('base','isum',imageSum);
end
average = uint8(imdivide(imageSum, nFrames));

% Log averaging results to disk.
writePath = userdata.writePath;
if isempty(userdata.average),
    userdata.average = 1;
    imwrite(average,writePath);
else
    imwrite(average,writePath,'WriteMode','Append');
end

obj.userdata = userdata;
end 