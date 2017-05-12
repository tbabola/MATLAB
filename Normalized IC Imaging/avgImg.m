% Average Image
  [fn dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif');
  X = loadTif([dname fn],16);

%
%[dFoF,Fo,bcImg] = normalizeImg(X,10,0);
imgSD = std(single(X),0,3);
savename = ['STD_' fn];
writeTif(imgSD,[dname savename],32);

%figure; imagesc([std(single(X),0,3);mean(X,3)]); colormap(greenfireblue);caxis([0.01 800]);

%% lists
%%Wildtype
 [~,list] = system('dir "M:\Bergles Lab Data\Projects\In vivo imaging\Wildtype\STD_*.tif" /S/B');
 list = textscan(list, '%s', 'Delimiter', '\n');
 WTlist =list{:};

%%VG3
[~,list] = system('dir "M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\STD_*.tif" /S/B');
list = textscan(list, '%s', 'Delimiter', '\n');
VG3list =list{:};

%%VG3 bilateral ablation
[~,list] = system('dir "M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO ablation\Bilateral\STD_*.tif" /S/B');
list = textscan(list, '%s', 'Delimiter', '\n');
VG3billist =list{:};

%%VG3 NBQX
[~,list] = system('dir "M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO NBQX\STD_*.tif" /S/B');
list = textscan(list, '%s', 'Delimiter', '\n');
VG3NBQXlist =list{:};



%%P2ry1 KO bilateral ablation
[~,list] = system('dir "M:\Bergles Lab Data\Projects\In vivo imaging\P2ry1 KO\STD_*.tif" /S/B');
list = textscan(list, '%s', 'Delimiter', '\n');
P2ry1KOlist =list{:};



%% testing
graphSTDs(list);

%% 
function graphSTDs(list)
    [m] = size(list,1);
    figure;
    for i = 1:m
        img = loadTif(list{i},32);
        subplot(m,1,i);
        imagesc(img); colormap(greenfireblue);
        caxis([0.01 800]);
    end
    

end
