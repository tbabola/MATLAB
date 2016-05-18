%Analysis of Calcium transients for WT and MRS2500 Application

%3-index moving average filter and bl subtract
Ca2_MRS_data_w = zeros(1,9);
Ca2_MRS_data_w = Ca2_MRS_data;
time = [1:1:1500]';
time(:,2) = time(:);
time(:,3)= time(:,1);

for i=1:size(Ca2_MRS_data,1)
    signal = Ca2_MRS_data_w{i,2};
    signal = smooth(signal,3);
    signal = reshape(signal,([1500 3]));
    signal = msbackadj(time,signal);
    Ca2_MRS_data_w{i,3} = signal;
    %SGN *note: maxPeakWidth used to elimiante any large cell death events
    %from analysis
    [pks,locs] = findpeaks(signal(:,1),'MaxPeakWidth',6,'MinPeakProminence',.001);
    pks = pks(locs < 900);
    locs = locs(locs < 900);
    Ca2_MRS_data_w{i,4}=[pks,locs];
    Ca2_MRS_data_w{i,5}=size(locs(locs<=600),1);
    Ca2_MRS_data_w{i,6}=size(locs(locs>=900),1);
    
    %IHC and ISCs
    [pks,locs] = findpeaks(signal(:,2),'MinPeakProminence',.002);
    Ca2_MRS_data_w{i,7}=[pks,locs];
    Ca2_MRS_data_w{i,8}=size(locs(locs<=600),1);
    Ca2_MRS_data_w{i,9}=size(locs(locs>=900),1);
    
    [pks,locs] = findpeaks(signal(:,3),'MinPeakProminence',.002,'Annotate','extents');
    Ca2_MRS_data_w{i,10}=[pks,locs];
    Ca2_MRS_data_w{i,11}=size(locs(locs<=600),1);
    Ca2_MRS_data_w{i,12}=size(locs(locs>=900),1);
end




