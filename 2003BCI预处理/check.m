% 2012.05.30 LWC
% 检查 h.EVENT.DUR; 768与后面的标记位置总是 500行数据【不是，有些废弃trial】；
[s, h] = sload('D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A01T.gdf');

for i=2:length(h.EVENT.POS) ...
        dur(i-1) = h.EVENT.POS(i) - h.EVENT.POS(i-1);
end

index = find(dur==500);

for i=2:length(index) ...
        dif(i-1) = index(i) - index(i-1);
        if(dif(i-1) ~=2)
        i
        end
end