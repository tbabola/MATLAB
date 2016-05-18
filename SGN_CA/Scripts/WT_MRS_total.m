%SGN Script Wildtype versus MRS
%Script to find ISIs for SGN Ca

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
            %WT + MRS25000
            '150719\15719003.abf',0,600,900,1500
            '150723\15723000.abf',0,600,900,1500
            '150723\15723002.abf',0,600,900,1500
            '150723\15723003.abf',0,600,900,1500
            '150723\15723006.abf',60,660,960,1560
            '150724\15724007.abf',0,600,900,1500
            '150725\15725007.abf',0,600,900,1500
            };
        
ISI_data = loadSGNs(base,files);
