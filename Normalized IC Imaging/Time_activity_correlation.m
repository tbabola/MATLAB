[~,str] = dos('dir "M:\Bergles Lab Data\RecordingsAndImaging\*.czi" /s');
str = strrep(str,',','');
rgx = '(\d{2}/\d{2}/\d{4})\s{2}(\d{2}):(\d{2})\s([AP]M)\s*\d*\s*Experiment-(\d*)';
tkn = regexp(str,rgx,'tokens');
InVivo.dates = tkn{:,1};
cell2m

 
