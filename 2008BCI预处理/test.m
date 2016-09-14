% 2012.05.30    LWC
% 尝试提取数据
[s, h] = sload('D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A01T.gdf');

typ_r = size(h.EVENT.TYP,1); %行数

trials.count = 0 ;
trials.label = [];
trials.data = [];

for i = 1:typ_r
    if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
        
        trials.count = trials.count + 1;
        
        if(h.ArtifactSelection(trials.count)==0)
            
            h.ArtifactSelection(trials.count)
            
            rows = size(trials.data,1);
            trials.data(rows+1:rows+h.EVENT.DUR(i),1:22) = s(h.EVENT.POS(i):h.EVENT.POS(i)+h.EVENT.DUR(i)-1,1:22);
            trials.data(rows+1:rows+h.EVENT.DUR(i),23) = (h.EVENT.TYP(i,1)-768)*ones(h.EVENT.DUR(i),1);
            trials.label(trials.count) = h.EVENT.TYP(i,1)-768;
            
            trials.ArtifactSelection(trials.count) = h.ArtifactSelection(trials.count); %用于排除Artifact;
            
        end % of if(h.ArtifactSelection(trials.count + 1) == 0)
    end % of if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
    
end % of for i = 1:typ_r

trials.label = trials.label';
% trials.ArtifactSelection = h.ArtifactSelection; %用于排除Artifact;
% trials.Classlabel = h.Classlabel; %用于检验trial分类结果是否正确；


%2012.06.23 测试1023标记的trial与ArtifactSelection标记的trial是否一致
% 结果：9个受试者测试都是一致
index = find(trials.rejected == 1 )
if(trials.rejected==trials.ArtifactSelection)
    disp 1;
end



if(trials.rejected==trials.fixed)
    disp 1;
end
















