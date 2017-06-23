function [trigPeaks, sig2peaks, sig3peaks, sig4peaks] = eventAvg2(trig, sig2, sig3, sig4, plotFlag);
  t = size(trig,2)
  time = [1:1:t]';
  smTrig = smooth(msbackadj(time, trig','WindowSize',1000,'StepSize',1000));
  smsig2 = smooth(msbackadj(time, sig2','WindowSize',1000,'StepSize',1000));
  smsig3 = smooth(msbackadj(time, sig3','WindowSize',1000,'StepSize',1000));
  smsig4 = smooth(msbackadj(time, sig4','WindowSize',1000,'StepSize',1000));
  
  [pks, locs] = findpeaks(smTrig,time,'MinPeakProminence',.02,'Annotate','extents');
  locn = size(locs,1);
  win_before = 20;
  win_after = 50;
  trigPeaks = [];
  sig2peaks = [];
  sig3peaks = [];
  sig4peaks = [];
  
  j = 1;
  for i=1:locn
      loc = locs(i);

      if loc < win_before || loc + win_after > t
      %elseif smVC(i) > smAC(i)
      %elseif (ICsignalVar(loc) > (varmean-0.7*varstd)) && (ICsignalVar(loc) < (varmean+0.7*varstd))
      else
          rloc = loc - win_before;
          lloc = loc + win_after;
          trigPeaks(:,j) = smsig2(rloc:lloc);
          sig2peaks(:,j) = smTrig(rloc:lloc);
          sig3peaks(:,j) = smsig3(rloc:lloc);
          sig4peaks(:,j) = smsig4(rloc:lloc);
          j = j+1;
      end 
      
  end
  
  ICpeaks_avg = mean(trigPeaks,2);
  ICpeaks_norm = (ICpeaks_avg-mean(ICpeaks_avg(1:10)))/max(ICpeaks_avg-mean(ICpeaks_avg(1:10)));
  ACpeaks_avg = mean(sig2peaks,2);
  ACpeaks_norm = (ACpeaks_avg-mean(ACpeaks_avg(1:10)))/max(ACpeaks_avg-mean(ACpeaks_avg(1:10)));
  VCpeaks_avg = mean(sig3peaks,2);
  VCpeaks_norm = (VCpeaks_avg-mean(VCpeaks_avg(1:10)))/max(VCpeaks_avg-mean(VCpeaks_avg(1:10)));
  SCpeaks_avg = mean(sig4peaks,2);
  SCpeaks_norm = (SCpeaks_avg-mean(SCpeaks_avg(1:10)))/max(SCpeaks_avg-mean(SCpeaks_avg(1:10)));
  
  if plotFlag
      figure; plot(ICpeaks_norm); hold on; plot(ACpeaks_norm);
      figure; plot(ICpeaks_avg-mean(ICpeaks_avg(1:10))); hold on; plot(ACpeaks_avg-mean(ACpeaks_avg(1:10)));
      plot(VCpeaks_avg-mean(VCpeaks_avg(1:10))); plot(SCpeaks_avg-mean(SCpeaks_avg(1:10)));
  end
  
end