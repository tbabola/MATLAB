WTpaths = {'M:\Bergles Lab Data\RecordingsAndImaging\160323\integrals.mat';
         'M:\Bergles Lab Data\RecordingsAndImaging\160329\integrals.mat';
         'M:\Bergles Lab Data\RecordingsAndImaging\160413\integrals.mat';
         'M:\Bergles Lab Data\RecordingsAndImaging\160415\integrals.mat';
         'M:\Bergles Lab Data\RecordingsAndImaging\160420\integrals.mat';
         'M:\Bergles Lab Data\RecordingsAndImaging\161006\integrals.mat'
}

vG3paths = {'M:\Bergles Lab Data\RecordingsAndImaging\161006\integrals.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-545_P8_Snap25GC6s_vGluT3_matreg_PCA\integrals.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-593-Snap25GC6s_vGluT3KO_PCA\integrals.mat';
            
};


WTtbl_stats = [];
for i=1:size(paths,1)
    load(paths{i});
    WTtbl_stats = [WTtbl_stats; tbl_stats];
end

