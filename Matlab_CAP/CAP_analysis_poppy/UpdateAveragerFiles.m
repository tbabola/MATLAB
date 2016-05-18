function UpdateAveragerFiles(volt,speaker,datafolder)


%This program will work through datafolder updating old EPavg files
%  to the new format with specified voltage and speaker system
%
%CALL AS: UpdateAveragerFiles(volt,speaker,datafolder)
% Requires volt and speaker inputs. If datafolder is not specified
% the program will process the present working directory

if nargin < 2
    help UpdateAveragerFiles
    return
end

if nargin < 3
    datafolder = pwd;
end

progfolder = fileparts(which('UpdateAveragerFiles'));

d = dir(datafolder);
d = d(find([d.isdir]==0 & strncmp('EPavg_p',{d.name},7)==1)); % Only EP files
epfilelist = {d.name};

if length(epfilelist)
    if ~exist('backup','dir')
        [success,message] = mkdir(datafolder,'backup');
        if ~success
            disp(message)
            return
        end
    end

    d = dir(datafolder);
    d = d(find([d.isdir]==0 & strncmp('cal_p',{d.name},5)==1)); % Only CAL files
    calfilelist = {d.name};

    for filenum = 1:length(calfilelist)
        filename = calfilelist{filenum};
        source = fullfile(datafolder,filename);
        destination = fullfile(datafolder,'backup',filename);
        [success,message] = movefile(source,destination,'f');
        if ~success
            disp(message)
            return
        end
    end
    if strncmpi(speaker,'cr',2)
        source = fullfile(progfolder,'cal_p001_CROWN.m');
        destination = fullfile(datafolder,'cal_p001.m');
        [success,message] = copyfile(source,destination,'f');
        if ~success
            disp(message)
            return
        end
    elseif strncmpi(speaker,'ed',2)
        source = fullfile(progfolder,'cal_p001_ED1.m');
        destination = fullfile(datafolder,'cal_p001.m');
        [success,message] = copyfile(source,destination,'f');
        if ~success
            disp(message)
            return
        end
    end
    for filenum = 1:length(epfilelist)
        filename = epfilelist{filenum};
        source = fullfile(datafolder,filename);
        destination = fullfile(datafolder,'backup',filename);
        [success,message] = copyfile(source,destination,'f');
        if ~success
            disp(message)
            return
        end
        commandstr = sprintf('x=%s;',strtok(filename,'.m'));
        eval(commandstr);
        x.Hardware.amp_vlt = volt;
        x.Hardware.speaker = speaker;

        fname = fullfile(datafolder,filename);
        rc = write_nel_data(fname,x,0);
        while (rc < 0)
            title_str = ['Choose a different file name! Can''t write to ''' fname ''''];
            [fname,dirname] = uiputfile(fullfile(fileparts(fname),'*.m'),title_str);
            fname = fullfile(dirname,fname);
            rc = write_nel_data(fname,x,0);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                     SUBROUTINES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rc = write_nel_data(fname,x,save_spikes)
% write_nel_data  - writes a standard nel output file in a form of an m-file.
%
%       Usage: rc = write_nel_data(fname,x,save_spikes)
%                   'x' should contain the data to be saved in 'fname'.
%                   'save_spikes' is an optional boolean flag
%                   (by default save_spikes = 1).
%                   'write_nel_data' returns 1 on success and -1 on failure.

% AF 9/5/01

global spikes

if (exist('save_spikes') ~= 1)
    save_spikes = 1;
end
[dummy1 dummy2 ext] = fileparts(fname);
if (strcmp(ext,'.m') ~= 1)
    fname = [fname '.m'];
end
fid = fopen(fname,'wt+');
if (fid < 0)
    % errordlg(['write_nel_data: Can''t open ''' fname ''' for writting']);
    rc = -1;
    return;
end
[dirname filename] = fileparts(fname);
fprintf(fid,'function x = %s\n', filename);
mat2text(x,fid);

if (save_spikes)
    for i = 1:length(spikes.times)
        % Code for initializing the spike matrix
        fprintf(fid, '\nx.spikes{%d} = zeros(%d,%d);\n', i, spikes.last(i), size(spikes.times{i},2));
        % Code for self-extracting the data stored in the file comments.
        if (i==1)
            fprintf(fid, '[x.spikes{%d},fid] = fill_marked_val(which(mfilename),''%%%d'',x.spikes{%d});\n', i,i,i);
        else
            fprintf(fid, '[x.spikes{%d},fid] = fill_marked_val(fid,''%%%d'',x.spikes{%d});\n', i,i,i);
        end
    end
    fprintf(fid, 'fclose(fid);');
    % Writing the spike data as comments to the data mfile.
    for i = 1:length(spikes.times)
        fprintf(fid, '\n%%%d\n',i);
        fmt = ['%%' int2str(i) ' %8d %4.10f \n'];
        fprintf(fid,fmt,spikes.times{i}(1:spikes.last(i),:)');
    end
    fprintf(fid,'\n');
    % Add the source code for the subfunction 'fill_marked_val' to the data file.
    subfunc_file = textread(which('fill_marked_val'),'%s','delimiter','\n','whitespace','');
    fprintf(fid,'%s\n',subfunc_file{:});
end
fclose(fid);
rc = 1;

function mat2text(x,fid,level)
% MAT2TEXT - writes a matlab variable to a text file in a matlab mfile format.
%            The variable can be retrieved by evaluating (executing) the file.
%            The variable can be of any intrinsic matlab format (struct, cell,
%            ND array, string and sparse).
%            USAGE: mat2text(x,fid).
%                   fid is an output file descriptor.
%                   Use fid=1 to direct the output to the screen.

% AF 8/6/01

if (exist('fid') ~= 1)
    fid = 1;
end
if (exist('level') ~= 1)
    level = 0;
end
level = level+1;

if (level == 1)
    fprintf(fid,'x = ');
end

switch (class(x))
    case 'struct'
        vals = struct2cell(x);
        names = fieldnames(x);
        fprintf(fid,'struct(');
        for i = 1:length(names)
            if (i>1)
                fprintf(fid,',');
            end
            fprintf(fid,'''%s'', ',names{i});
            mat2text(vals(i,:),fid,level);
        end
        fprintf(fid,')');

    case 'char'
        fprintf(fid,'''%s''', x);

    case 'cell'
        if (ndims(x) > 2)
            fprintf(fid, 'cat(%d, ', ndims(x));
            for i = 1:size(x,ndims(x))
                if (i>1)
                    fprintf(fid,',');
                end
                eval(['tmpmat = squeeze(x(' repmat(':,',[1 ndims(x)-1]) int2str(i) '));']);
                mat2text(tmpmat,fid,level);
            end
            fprintf(fid,') ...\n ');
        else
            if (size(x,2) == 1)
                fprintf(fid,'{');
                for i = 1:size(x,1)
                    mat2text(x{i},fid,level);
                    if (i < size(x,1))
                        fprintf(fid,';');
                    end
                end
                fprintf(fid,'} ...\n');
            else
                fprintf(fid, '[');
                for i = 1:size(x,2)
                    mat2text(x(:,i),fid,level);
                end
                fprintf(fid, '] ...\n');
            end
        end

    case 'sparse'
        fprintf(fid, 'sparse(');
        mat2text(full(x),fid,level);
        fprintf(fid, ')\n');

    case 'double'
        if (isempty(x))
            fprintf(fid,'[]');
            return;
        end
        if (ndims(x) > 2)
            fprintf(fid, 'cat(%d, ', ndims(x));
            for i = 1:size(x,ndims(x))
                if (i>1)
                    fprintf(fid,',');
                end
                eval(['tmpmat = squeeze(x(' repmat(':,',[1 ndims(x)-1]) int2str(i) '));']);
                mat2text(tmpmat,fid,level);
            end
            fprintf(fid,') ...\n ');
        else
            if (size(x,2) == 1)
                if (size(x,1) == 1)
                    fprintf(fid,'%1.10g ',x);
                else
                    fprintf(fid,'[');
                    fprintf(fid,'%1.10g;',x);
                    fprintf(fid,'] ...\n');
                end
            else
                if (size(x,1) == 1)
                    fprintf(fid,'[');
                    fprintf(fid,'%1.10g ',x);
                    fprintf(fid,'] ...\n');
                else
                    fprintf(fid, '[');
                    frmt = ['[' repmat('%1.10g ', 1, size(x,2)) ']; \n'];
                    fprintf(fid, frmt, x');
                    %for i = 1:size(x,2)
                    %   mat2text(x(:,i),fid,level);
                    %end
                    fprintf(fid, '] ...\n');
                end
            end
        end
end


if (level == 1)
    fprintf(fid,';\n');
end
