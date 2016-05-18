function [A,Z,B,Da,Db,param,obj] = SFC_setup(X,param)
%%
%SFC_setup Runs Ben Haeffele's Structured Factorization
%   [A,Z,B,Da,Db,param,obj] = SFC_SETUP(X,param)
%
%   Based on the Example.m script, SFC_SETUP sets up and runs FactorTVL1L2.
%   The user is able to define whichever parameters are desired and the
%   rest are set to defaults. Full description of variables is contained in
%   FactorTVL1L2.
%
%   X:      m x n x T movie where T is the number of frames
%   param:  structure that contains parameters for the factorization
%
%   See also FACTORTVL1L2_v1.

%%
[m,n,T] = size(X);
imgs = X;

%% set-up parameters
if ~exist('param','var'), param = []; end
if ~isfield(param,'dt'), param.dt = 0.1; end
if ~isfield(param,'tau'), param.tau = 1; end
if ~isfield(param,'numDb'), param.numDb = 1; end
if ~isfield(param,'num_iter'), param.num_iter = 20; end
if ~isfield(param,'numA'), param.numA = 50; end

if ~isfield(param,'display'), param.display = true; end

%magic regularization numbers
if ~isfield(param,'kA'), param.kA = [1 0 1]; end
if ~isfield(param,'kZ'), param.kZ = [1 0.5 1]; end
if ~isfield(param,'lam'), param.lam = 125; end

%do non-negative factorization
if ~isfield(param,'posA'), param.posA = true; end
if ~isfield(param,'posZ'), param.posZ = true; end

%Get the neighborhood structure of the pixels
if ~isfield(param,'idx'), param.idx = GetLatticeIndex(m,n); end

%Initialize A to be every 5th column of an identity matrix
if ~isfield(param,'A_init')
    param.A_init = eye(T);
    param.A_init = param.A_init(:,round(linspace(1,T,param.numA)));
end

%% create necessary variables
%Make dictionary of decaying exponentials
Da = MakeD(T,param.dt,param.tau);

%Dictionary to represent background intensity
%(Slowest 3 real/imag pairs of a fourier basis)
Db = MakeFourierD(T,param.numDb(1));

% add frequencies at f_temp Hz
% f_temp = 6/T/param.dt;
% f_temp = 11.5;
% Db_temp = [cos((0:T-1)*param.dt*2*pi*f_temp); -sin((0:T-1)*param.dt*2*pi*f_temp)]';
% Db_temp = Db_temp./repmat(sqrt(sum(Db_temp.^2)),T,1);
% Db = [Db Db_temp];

if length(param.numDb) > 1
% add linear and exponential components
t = (0:T-1)'*param.dt;
Db_temp = [(0:T-1)'/T exp(-t/150) exp(-t/75) exp(-t/300)];
Db_temp = Db_temp./repmat(sqrt(sum(Db_temp.^2)),T,1);
Db = [Db Db_temp];
end

%%
%Reshape data so that the time series for each pixel is in the columns
imgs = reshape(imgs,m*n,T)';

%%
[A,Z,B,obj,Anrm,Znrm,Bnrm,Ls] = FactorTVL1L2_v1(imgs,Da,Db,param,param.num_iter);
%%
%Sort columns of A and Z by magnitude
[~,si] = sort(Anrm.*Znrm,'descend');
A = A(:,si);
Z = Z(:,si);
Anrm = Anrm(si);
Znrm = Znrm(si);

% %Display first 25 regions of Z
% for i=1:25
%     subplot(5,5,i)
%     imagesc(reshape(Z(:,i),m,n)); axis off; %axis image;
% end

% %Reconstruct estimated signal
% F_rec = Da*A*Z'; %Estimated transients
% B_rec = Db*B';   %Estimated background
% F_rec2 = A*Z';   %Estimated spike times

