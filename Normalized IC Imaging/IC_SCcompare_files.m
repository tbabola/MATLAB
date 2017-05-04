WTpaths = {'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-265-P7_Wildtype_PCA\integrals.mat';
         'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-314-P6_Wildtype_PCA\integrals.mat';
         'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\integrals.mat';
         'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-337-ds_PCApro\integrals.mat';
         'M:\Bergles Lab Data\RecordingsAndImaging\160420\integrals.mat';
         'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-495-P7-Snap25GC6s_Wildtype_PCA\integrals.mat';
         'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-569_P6-Snap25GC6s_PCA\integrals.mat';
         'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-571_P6-Snap25GC6s_PCA\integrals.mat' 
}

vG3paths = {'M:\Bergles Lab Data\RecordingsAndImaging\161006\integrals.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-545_P8_Snap25GC6s_vGluT3_matreg_PCA\integrals.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-593-Snap25GC6s_vGluT3KO_PCA\integrals.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-606_Snap25GC6s_vGluT3KO_PCA\integrals.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-607_Snap25GC6s_vGluT3KO_PCA\integrals.mat';  
};

vg3bilpaths = {
    'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO ablation\Bilateral\DUP_Experiment-671_Snap25GC6s_vGluT3KO_bilat_abl_reg_PCA\integrals.mat';
    'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO ablation\Bilateral\DUP_Experiment-673_Snap25GC6s_vGluT3KO_bilat_abl_reg_PCA\integrals.mat';
    'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO ablation\Bilateral\DUP_Experiment-714_Snap25GC6s_vGluT3KO_bilateralablation_PCA\integrals.mat';
    'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO ablation\Bilateral\DUP_Experiment-762_Snap25GC6s_vGluT3KO_bilateral_ablation_PCA\integrals.mat';
    'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO ablation\Bilateral\DUP_Experiment-763_Snap25GC6s_vGluT3KO_bilateral_ablation_PCA\integrals.mat'
};



WTtbl_stats = [];
n=size(WTpaths,1);
for i=1:n
    load(WTpaths{i});
    if size(tbl_stats,2) < 8
        rctx_int = 0;
        lctx_int = 0;
        tbl_stats = [tbl_stats(1,1) table(lctx_int, rctx_int) tbl_stats(1,2:6)];
    end
    WTtbl_stats = [WTtbl_stats; tbl_stats];
    if i==1
        figure; subplot(n,1,i);
        plot(RSC); hold on; %plot(ctx);
        ylim([0 0.5]);
        xlim([0 6000]);
    else
        subplot(n,1,i);
        plot(RSC); hold on;% plot(ctx);
        ylim([0 0.5]);
        xlim([0 6000]);
    end
end

vg3biltbl_stats = [];
n = size(vg3bilpaths,1);
for i=1:n
    load(vg3bilpaths{i});
    vg3biltbl_stats = [vg3biltbl_stats; tbl_stats];
    if i==1
        figure; subplot(n,1,i);
        plot(RSC); hold on; %plot(ctx);
        ylim([0 0.5]);
        xlim([0 6000]);
    else
        subplot(n,1,i);
        plot(RSC); hold on;% plot(ctx);
        ylim([0 0.5]);
        xlim([0 6000]);
    end
    ylim([0 0.5]);
end

vg3tbl_stats = [];
n = size(vG3paths,1);
for i=1:n
    load(vG3paths{i});
    if size(tbl_stats,2) < 8
        rctx_int = 0;
        lctx_int = 0;
        tbl_stats = [tbl_stats(1,1) table(lctx_int, rctx_int) tbl_stats(1,2:6)];
    end
    vg3tbl_stats = [vg3tbl_stats; tbl_stats];
    if i==1
        figure; subplot(n,1,i);
        plot(RSC); hold on; %plot(ctx);
        ylim([0 0.5]);
        xlim([0 6000]);
    else
        subplot(n,1,i);
        plot(RSC); hold on;% plot(ctx);
        ylim([0 0.5]);
        xlim([0 6000]);
    end
end

figure;
xlabel('Integral of Activity');
ylabel('Frequency of IC events');
plot(WTtbl_stats{:,6},WTtbl_stats{:,8},'.','MarkerSize',20);
hold on;
plot(vg3tbl_stats{:,6},vg3tbl_stats{:,8},'.','MarkerSize',20);
plot(vg3biltbl_stats{:,6},vg3biltbl_stats{:,8},'.','MarkerSize',20);
legend('WT','VG3KO','VG3KO ABLATION');
xlabel('Integral of Activity');
ylabel('Frequency of IC events');
