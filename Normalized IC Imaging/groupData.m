function [stat] = groupData(paths,bits)
     if ~exist('bits','var')
        bits = 8;
    end
     m = size(paths,1);
     rpks = [];
     lpks = [];
     rpks_tot = {};
     lpks_tot = {};
     stat =[];
     counts = [];
     counts_tot = [];
     binLim = [0 0.02:.05:.35 100]
     for i = 1:m
         load(paths{i});
         disp(paths{i});
         [filePath name ext] = fileparts(paths{i});
         if bits == 8
             [stats, pkData] = findICpeaks(ICsignal,[filePath '\'],'PCA',1);
         elseif bits == 16
             [stats, pkData] = findICpeaksdFoF(ICsignal,filePath,'dFoF',1);
         end
         stat = [stat; stats];
         rpks_temp = pkData((pkData(:,7)==2),4);
         lpks_temp = pkData((pkData(:,7)==1),2);
         rpks = [rpks; rpks_temp];
         lpks = [lpks; lpks_temp];
         Rcounts = histcounts(rpks_temp,binLim);
         Lcounts = histcounts(lpks_temp,binLim);
         counts = [counts; Lcounts Rcounts];

         %%more complex histogram of every event
         lpks_tot{i} = [pkData(pkData(:,6)==1 | pkData(:,6)==2,2)];
         rpks_tot{i} = [pkData(pkData(:,6)==1 | pkData(:,6)==3,4)];
         counts_tot = [counts_tot;histcounts(lpks_tot{i},binLim) histcounts(rpks_tot{i},binLim)];
         
     end
     
    lt_org = [255, 166 , 38]/255;
    dk_org = [255, 120, 0]/255;
    lt_blue = [50, 175, 242]/255;
    dk_blue = [0, 13, 242]/255;
    l = size(Lcounts,2);
    
    %for average barh with error bars
    count_avg = mean(counts);
    %count_std = std(counts);
    count_sem = std(counts)/sqrt(size(paths,1));
    Lcounts= count_avg(1:l);
    L_sem = count_sem(1:l);
    Rcounts =count_avg(l+1:end);
    R_sem =count_sem(l+1:end);
    binY = [0 .0450:.05:.35];
   
    figh = figure;
    h=barh(binY,Rcounts,.9);
    hold on;
    barh(binY,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor','none');
    %barh(Lbins,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor',lt_org);
    h.FaceColor = lt_blue;
    h.EdgeColor = 'none';
    box off;
    xax_lim = [-60 60];
    xtick = [-60 -30 0 30 60];
    xticklabel = {'60' '30' '0' '30' '60'};
    %%error bars
    line([-Lcounts-L_sem;-Lcounts+L_sem],[binY;binY],'Color',lt_org,'LineWidth',1);
    line([Rcounts-R_sem;Rcounts+R_sem],[binY;binY],'Color',lt_blue,'LineWidth',1);
    xlim(xax_lim);
    xticks(xtick);
    xticklabels(xticklabel);
    ylim([0 .40]);
    yticks([0 .2 .4]);
    box off;
    figh.Units = 'inches';
    figh.Position = [5 5 1.5 1.0];
    set(gca,'FontSize',6);
    xlabel('# of Dominant Events','FontSize',8);
    ylabel('Amplitude (\DeltaF/F)','FontSize',8);
    
    figure;
    m = size(lpks_tot,2)
    for i=1:m
        subplot(m,1,i);
        rCounts = counts_tot(i,l+1:end)
        lCounts = counts_tot(i,1:l);
        h=barh(binY,rCounts,.9);
        hold on;
        barh(binY,-lCounts,.9,'FaceColor',lt_org,'EdgeColor','none');
        %barh(Lbins,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor',lt_org);
        h.FaceColor = lt_blue;
        h.EdgeColor = 'none';
        box off;
        %%error bars
        xlim(xax_lim);
        xticks(xtick);
        xticklabels(xticklabel);
        ylim([0 .40]);
        yticks([0 .20 .40]);
        box off;
        %figh.Units = 'inches';
        %figh.Position = [5 5 1.5 1.0];
%         set(gca,'FontSize',6);
%         xlabel('# of Dominant Events','FontSize',8);
%         ylabel('Amplitude (\DeltaF/F)','FontSize',8);
    end    
    
     %for average barh with error bars total
    count_avg = mean(counts_tot);
    %count_std = std(counts);
    count_sem = std(counts_tot)/sqrt(size(paths,1));
    Lcounts= count_avg(1:l);
    L_sem = count_sem(1:l);
    Rcounts =count_avg(l+1:end);
    R_sem =count_sem(l+1:end);
    
    figh = figure;
    h=barh(binY,Rcounts,.9);
    hold on;
    barh(binY,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor','none');
    %barh(Lbins,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor',lt_org);
    h.FaceColor = lt_blue;
    h.EdgeColor = 'none';
    box off;
    %%error bars
    line([-Lcounts-L_sem;-Lcounts+L_sem],[binY;binY],'Color',lt_org,'LineWidth',1);
    line([Rcounts-R_sem;Rcounts+R_sem],[binY;binY],'Color',lt_blue,'LineWidth',1);
    xlim(xax_lim);
    xticks(xtick);
    xticklabels(xticklabel);
    ylim([0 .4]);
    yticks([0 .2 .40]);
    box off;
    figh.Units = 'inches';
    figh.Position = [5 5 1.5 1.0];
    set(gca,'FontSize',6);
    xlabel('# of Dominant Events','FontSize',8);
    ylabel('Amplitude (\DeltaF/F)','FontSize',8);

        
 end