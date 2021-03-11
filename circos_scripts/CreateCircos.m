function CreateCircos(Bands, Rho_Thresh)

[AllData, AllNames] = MadeDataFile();

% top 1% of values plotted as fully opaque
MAX_E = prctile(AllData(:,1),98); 
load AreaNames

NEWPOWERNAME = AreaNames';

SFile=fopen('Connectivity.txt', 'wt');
SFile2=fopen('chr-highlights.txt', 'wt');

for Counter = 1:length(NEWPOWERNAME)
    ChrStr = ['chr - hs', num2str(Counter), ' ', char(NEWPOWERNAME(Counter)), ' ', num2str(min(Bands)), ' ', num2str(max(Bands)+1), ' chr22'];
    
    
    fprintf(SFile, ChrStr);
    fprintf(SFile, '\n');
    for DataCounter = 1:length(AllData(:,1))
        if isempty (strfind (AllNames{DataCounter}, 'XXX')) & ~isempty (strfind (AllNames{DataCounter}, NEWPOWERNAME{Counter})) 
            DataName= AllNames{DataCounter};
            idx = strfind(DataName, '_');
            idx = idx(end);
            Freq = str2num (DataName(idx+1:end));

            if AllData (DataCounter,1) >Rho_Thresh & Freq>=min(Bands) & Freq<=max(Bands); 
              Freq = Freq;
                ColorStr = ['hue', sprintf('%03d' ,round(150*((Freq-1)/max(Bands)) + 175))];
                %ColorStr = ['dpblue'];
                ChrHStr = ['hs', num2str(Counter), ' ', num2str(Freq), ' ', num2str(Freq+1), ' fill_color=', ColorStr];
                transparency = max(round(abs(AllData(DataCounter,1))/MAX_E*20),2);
                if transparency
                    ChrHStr = [ChrHStr, '_a', num2str(transparency)];
                end 
                fprintf(SFile2, ChrHStr);
                fprintf(SFile2, '\n');
            elseif  Freq>=min(Bands) & Freq<=max(Bands);   %only for cases where low  values are thresholded out
                Freq = Freq;
                ChrHStr = ['hs', num2str(Counter), ' ', num2str(Freq), ' ', num2str(Freq+1), ' fill_color=white_a20'];
                fprintf(SFile2, ChrHStr);
                fprintf(SFile2, '\n');
            end
            
        end
    end    
end
    fclose('all')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SFile3=fopen('SPCALinks.txt', 'wt');

for DataCounter = 1:length(AllData)
    if ~isempty (strfind (AllNames{DataCounter}, 'XXX')) 
        DataName = AllNames{DataCounter};
        idx = strfind(DataName, '_');
        Freq = str2num(DataName(idx(end)+1:end));
        DataName = DataName(1:idx(end)-1);
        idx = strfind(DataName, 'XXX');
        Area1 = DataName(1:idx-2);
        Area2 = DataName(idx+4:end);
        
        ChrLoc1 = find(strcmp(NEWPOWERNAME,Area1));
        ChrLoc2 = find(strcmp(NEWPOWERNAME,Area2));
    
        if AllData(DataCounter,1) >Rho_Thresh & Freq>=min(Bands) & Freq<=max(Bands);
            Freq = Freq;
            LinkStr = ['hs', num2str(ChrLoc1), ' ', num2str(Freq), ' ', num2str(Freq+1), ' hs', num2str(ChrLoc2), ' ', num2str(Freq), ' ', num2str(Freq+1)];
            LinkStr = [LinkStr, ' color='];
            %ColorStr = ['(255,' num2str(round(200*(Freq/max(Bands) - 1/max(Bands)))),',0)'];
            ColorStr = ['hue', sprintf('%03d' ,round(150*((Freq-1)/max(Bands)) + 175))];
            %ColorStr = ['dpblue'];
            LinkStr = [LinkStr, ColorStr];
            transparency = max(round(abs(AllData(DataCounter,1))/MAX_E*20),2);
            LinkStr = [LinkStr, '_a', num2str(transparency)];
            fprintf(SFile3, LinkStr);
            fprintf(SFile3, '\n');
        end
 
       
    end
end


fclose('all')



end 
