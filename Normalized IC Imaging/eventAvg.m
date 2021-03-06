function [ICpeaks, ACpeaks, VCpeaks, SCpeaks] = eventAvg(ACsignal, ICsignal, VCsignal, SCsignal)
  t = size(ACsignal,2)
  time = [1:1:t]';
  smAC = smooth(msbackadj(time, ACsignal','WindowSize',1000,'StepSize',1000));
  smIC = smooth(msbackadj(time, ICsignal','WindowSize',1000,'StepSize',1000));
  smVC = smooth(msbackadj(time, VCsignal','WindowSize',1000,'StepSize',1000));
  smSC = smooth(msbackadj(time, SCsignal','WindowSize',1000,'StepSize',1000));
  
  [pks, locs] = findpeaks(smIC,time,'MinPeakProminence',.02,'Annotate','extents');
  locn = size(locs,1);
  win_before = 20;
  win_after = 50;
  ICpeaks = [];
  ACpeaks = [];
  VCpeaks = [];
  SCpeaks = [];
  
  j = 1;
  for i=1:locn
      loc = locs(i);

      if loc < win_before || loc + win_after > t
      %elseif smVC(i) > smAC(i)
      %elseif (ICsignalVar(loc) > (varmean-0.7*varstd)) && (ICsignalVar(loc) < (varmean+0.7*varstd))
      elseif ACsignal(loc) > VCsignal(loc)
          rloc = loc - win_before;
          lloc = loc + win_after;
          ICpeaks(:,j) = smIC(rloc:lloc);
          ACpeaks(:,j) = smAC(rloc:lloc);
          VCpeaks(:,j) = smVC(rloc:lloc);
          SCpeaks(:,j) = smSC(rloc:lloc);
          j = j+1;
      else
      end 
      
  end
  
  ICpeaks_avg = mean(ICpeaks,2);
  ICpeaks_norm = (ICpeaks_avg-mean(ICpeaks_avg(1:10)))/max(ICpeaks_avg-mean(ICpeaks_avg(1:10)));
  ACpeaks_avg = mean(ACpeaks,2);
  ACpeaks_norm = (ACpeaks_avg-mean(ACpeaks_avg(1:10)))/max(ACpeaks_avg-mean(ACpeaks_avg(1:10)));
  VCpeaks_avg = mean(VCpeaks,2);
  VCpeaks_norm = (VCpeaks_avg-mean(VCpeaks_avg(1:10)))/max(VCpeaks_avg-mean(VCpeaks_avg(1:10)));
  SCpeaks_avg = mean(SCpeaks,2);
  SCpeaks_norm = (SCpeaks_avg-mean(SCpeaks_avg(1:10)))/max(SCpeaks_avg-mean(SCpeaks_avg(1:10)));
  
  figure; plot(ICpeaks_norm); hold on; plot(ACpeaks_norm);
  figure; plot(ICpeaks_avg-mean(ICpeaks_avg(1:10))); hold on; plot(ACpeaks_avg-mean(ACpeaks_avg(1:10)));
  plot(VCpeaks_avg-mean(VCpeaks_avg(1:10))); plot(SCpeaks_avg-mean(SCpeaks_avg(1:10)));
  
end