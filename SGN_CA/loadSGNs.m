function [ ISI_data ] = loadSGNs(base, files)
%loadSGNs
%   This functions loads a list of SGN recordings, finds peaks and
%   locations, and outputs relevant measurements into ISI_data

ISI_data = cell(size(files,1),5);

parfor i=1:size(files,1)
    ISI_slice = ISI_data(i,:);
    filepath = strcat(base,files{i,1});
    [pathstr, name] = fileparts(char(filepath));
    ISI_slice{1,1}=name;
    [d,time]=loadPclampData(filepath); %load pClamp data
    time = time*1000; %convert seconds to milliseconds
    

    %check for size of files to set endpoints
    if size(files,2) == 4 %single
        startTime = files{i,2}
        endTime = files{i,3}
        ISI_slice{1,2} = files{i,4}
    elseif size(files,2) == 5 %drug condition
        startTime = files{i,2};
        endTime = files{i,5}
    end
    
    d = d(time >= startTime*1000 & time <= endTime*1000);
    time = time(time >= startTime*1000 & time <=endTime*1000);
    time = time - time(1);
    
    %get ISIs
    [b_sp,b_ISIs,b_locs]=SGNpeaksSingle(d,time);
    ISI_slice{1,3}=b_sp;
    ISI_slice{1,4}=b_ISIs;
    ISI_slice{1,5}=b_locs;
    
    %ISI_data{i,8}=d;
    %ISI_data{i,9}=time;
    
%     create figure to showcase data
    figure(i);
    subplot(2,1,1);
    plot(resample(time/1000,1,10),resample(d,1,10));
    upper_y = max(d);
    axis([-inf inf -inf upper_y+2]);

ISI_data(i,:)=ISI_slice;
end


end

