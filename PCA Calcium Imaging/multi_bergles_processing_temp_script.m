[fname, dname] = uigetfile('*.tif','Multiselect','on');

for i=1:length(fname)

%% load data (provide filename fn and correct directory name dname)
cd(dname);
%loadPath = strcat(dname, fname{i});
loadPath = strcat(dname, fname);
%fn = fname{i};
fn = fname;

%% load movie
X = loadTif(loadPath,16);
X = imresize(X, 0.5);

[dFoF,Fo, X] = normalizeImg(X,10,1);

[m,n,T] = size(X);
t = (1:T)/10; % frame rate of 10 fps
X = double(X);
%% crop image if desired
% crop_inds = cell(3,1);
% crop_inds{1} = 30:60; crop_inds{2} = 5:120; crop_inds{3} = 1:T;
% X = X(crop_inds{1},crop_inds{2},crop_inds{3});
% [m,n,T] = size(X);
%% normalize images if desired (to account for inhomogeneities in brightness)
% [X,Xnormalizer] = img_normalize(X,1);
%% set-up parameters. 'defaults' in parentheses
param = [];
param.numA = 25*4; % number of components (50)
param.numDb = [1 1]; % number of components in sinusoid (7) - first number is for sinusoids, second number (optional) is for exponentials
param.num_iter = 50; % number of iterations to run factorization for (50)
param.display = true; % display outputs as code is running (true)
param.tau = [.55 .12]; % decay constant in seconds. 2nd number (optional) is the rise time ([.55 .12] for gcamp6s)
param.kZ = [80 15 1]*.1; % parameters for spatial fit (in general, bigger number = smoother spatial components)
param.kA = [2 0 2]/20*.25; % parameters for temporal fit (in general, bigger number = less accurate fits to small transients)
param.lam = .01; % global scaling parameter that is multiplied times kZ and kA
param.dt = mean(diff(t)); % assumes frame time is constant throughout trace
param.A_init = zeros(T,param.numA);
for k = 1:param.numA, param.A_init(k:param.numA:T,k) = 1; end
%% run Ben Haeffele's structured factorization algorithm
tic; [A,Z,B,Da,Db,P] = SFC_setup(X,param); toc
%% at this point, you can save data (Da is usually large so we don't save it since it's easy to remake)
%%% put in desired save_name first %%%
dims = [m n T];
processed_name = '_PCA\'
processed_dir = [dname fn(1:end-4) processed_name];
if ~exist(processed_dir,'dir')
    mkdir(processed_dir);
    disp('Folder created');
end
save_name = [fn(1:end-4)];
%save([dname save_name '.mat'],'t','A','Z','B','Db','P','dims','crop_inds','Xnormalizer','fn')
save([processed_dir save_name '.mat'],'t','A','Z','B','Db','P','dims','fn','dname','processed_dir','fn')

%% to load data: just need to set dname and save_name
% load([processed_dir save_name '.mat'])
%   m = dims(1); n = dims(2); T = dims(3);
%   Da = MakeD(T,P.dt,P.tau);

% if you need to reload X
% fname = [dname fn];
% X = load_tif(fname,'uint8');
% X = double(X);
% X = X(crop_inds{1},crop_inds{2},crop_inds{3});
% X = X./repmat(Xnormalizer,[1 1 T]); % normalize image

%% create variables to be used for analysis
imgs = reshape(X,m*n,T)';
F_rec = Da*A*Z'; %F_rec = Da*A*Z'; %Estimated transients
B_rec = Db*B'; %B_rec = Db*B'; %Estimated background
%F_rec2 = A*Z'; %F_rec2 = A*Z'; %Estimated spike times
%% plot first 25 spatial components
%for j = 1:25, subplot(5,5,j); imagesc(reshape(Z(:,j),m,n)); title(num2str(j)); axis off; axis image; end
%% plot first 25 temporal components
% clf; for i = 1:25, plot(t,A(:,i)/10+i,'k'); hold on; end; hold off
%% select 'bad' components for deletion (click on bad ones, then right-click when done)
% k = 0; bad_i = [];
% while k~=3
%     [p_x,p_y,k] = ginput(1);
%     if k~=3
%     i = floor(p_y); bad_i = [bad_i; i];
%     hold on; plot(t,A(:,i)/10+i,'r'); hold off
%     end
% end
% A(:,bad_i) = 0;

%% select region and show raw trace and fit
%plot_small_region(t,F_rec,B_rec,F_rec2,imgs,m)
%% play back normalized movies
% mvo = X-reshape(permute(B_rec,[2 1]),m,n,T);
% writeTif(single(mvo),[processed_dir 'PCA_baselinesubt.tif'],32);
% clearvars mvo;
mve = reshape(permute(F_rec,[2 1]),m,n,T);
writeTif(single(mve),[processed_dir fn(5:18) '_PCA.tif'],32);
%mva = cat(1,normmat(mvo),normmat(mve));
%writeTif(single(mva),[processed_dir 'PCAbeforeafter.tif'],32);
% for i = 1:T
% imagesc(mva(:,:,i),[0.01 .95]); axis image; axis off;
% pause(.001)
% end
movefile([dname fn], processed_dir);
end