function [NoneNaN] = doFix(partChannel)
% % 功能：使用NaN采样点的前后采样点的值取平均计算该点采样值，返回没有NaN值的结果；
% % 输入：partChannel - 某通道含有NaN值的一段数据，首末两个值正常，中间值为NaN，samples*1;
% % 输出：NoneNaN - 去除NaN后的结果，samples*1；
index = find(isnan(partChannel)==1);
if(~isempty(index))
    si = index(1)-1;
    ei = index(length(index))+1;
    mid = floor((si+ei)/2);
else
    return;
end

NoneNaN = partChannel;
NoneNaN(mid) = (partChannel(si)+partChannel(ei))/2;
%修正前段数据
if(mid~=si+1)
    NoneNaN(si:mid) = doFix(NoneNaN(si:mid));
end
%修正后段数据
if(mid~=ei-1)
    NoneNaN(mid:ei) = doFix(NoneNaN(mid:ei));
end

end