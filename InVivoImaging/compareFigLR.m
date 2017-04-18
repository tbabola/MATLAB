function compareFigLR(lEvents, rEvents,lHisto, rHisto)
    figure;
    cond1 = 'Left';
    cond2 = 'Right';
    
    subplot(3,1,1);
    cdfplot(lEvents(:,2)*7.45);
    hold on;
    cdfplot(rEvents(:,2)*7.45);
    xlabel('Spatial Spread (\mum)');
    legend(cond1,cond2);
    [h,p]=kstest2(lEvents(:,2),rEvents(:,2))
    text(80,0.5, strcat('p=',num2str(p)))
    
    subplot(3,1,2);
    cdfplot(lEvents(:,1)/10);
    hold on;
    cdfplot(rEvents(:,1)/10);
    xlabel('Half-width (s)');
    legend(cond1,cond2);
    [h,p]=kstest2(lEvents(:,1),rEvents(:,1))
    text(30,0.5,  strcat('p=',num2str(p)))
    
    subplot(3,1,3);
    cdfplot(lEvents(:,3));
    hold on;
    cdfplot(rEvents(:,3));
    xlabel('Amplitude (AIU)');
    legend(cond1,cond2);
    [h,p]=kstest2(lEvents(:,3),rEvents(:,3))
    text(35,0.5,  strcat('p=',num2str(p)))
    
    %%more plot
    figure;
    histogram([lHisto],25,'faceColor','black','edgeColor','black','faceAlpha',1)
    xlim([0,125]);
    hold on;
    histogram([rHisto],25,'faceColor','red','edgeColor','black','faceAlpha',1)
    
end

function compareStats(cond1, indStats, cond2, indStats2, plotFlag)
    m = size(indStats,1);
    m2 = size(indStats2,1);
    
    if(plotFlag)
        figure;
        %frequency
        subplot(1,3,1);
            scatter(ones(m,1), indStats(:,1)/10)
            hold on;
            scatter(2*ones(m2,1), indStats2(:,1)/10)
            ylim([0,25]);
            xlim([0 3]);
            xticklabels({'',cond1,cond2,''});
            ylabel('Frequency (events/min)');
        %amplitude
        subplot(1,3,2);
            scatter(ones(m,1), indStats(:,2))
            hold on;
            scatter(2*ones(m2,1), indStats2(:,2))
            ylim([0,25]);
            xlim([0 3]);
            xticklabels({'',cond1,cond2,''});
            ylabel('Amplitude (AIU)');
        subplot(1,3,3);
            scatter(ones(m,1), indStats(:,4)*7.45)
            hold on;
            scatter(2*ones(m2,1), indStats2(:,4)*7.45)
            ylim([0,800]);
            xlim([0 3]);
            xticklabels({'',cond1,cond2,''});
            ylabel('Spatial Spread (\mum)');
        
    end
end