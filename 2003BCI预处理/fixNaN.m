%% 2012.06.20 LWC
% % 计算方法：
% %   1. 某通道连续有奇数个NaN值（含1个） - 从中间的一个NaN开始计算，然后使用算的值计算前后的两段数据；
% %   2. 某通道连续有偶数个NaN值（含2个） - 计算中间位置，上取整ceil【或下取整floor】；

function [outM] = fixNaN(inM)
% % 功能：
% %   逐通道检查传入矩阵是否含有NaN值，如果含有则使用该采样点的前后采样点的值取平均，
% %   计算该点的采样值；
% % 输入：
% %   inM - 输入矩阵【第一个和最后一个采样点不能含有NaN值】，samples*channels;
% % 输出：
% %   outM - 修正NaN值后得到的输出矩阵，samples*channels;
[samples, channels] = size(inM);
outM = inM;

%逐通道检查
for i=1:channels
    index = find(isnan(inM(:,i))==1);
    if(isempty(index)) %该通道没有NaN值，退出循环
        continue; %跳出本次循环，继续检查下一通道
    end
    
    len = length(index);
    if(len==1) %该通道只有一个NaN值，修正
        outM(index(1)-1:index(1)+1,i) = doFix(outM(index(1)-1:index(1)+1,i));
        continue; %跳出本次循环，继续检查下一通道
    end
    
    si = 1;
    ei = 2;
    while(ei<=len)
        sv = index(si);
        ev = index(ei);
        base = sv;
        while(ev == base + 1 && ei<len) %获取连续的NaN区段
            base = ev;
            ei = ei + 1;
            ev = index(ei);
        end % while(ev == base + 1 && ei<=len)
        
        if(ev~=base+1)
            if(ei<len) %NaN段没有到结尾，只处理前段，后段留到下一循环；
                outM(sv-1:base+1,i) = doFix(outM(sv-1:base+1,i));
                si = ei;
                ei = ei + 1;
            else %NaN段已经到结尾且不连续，分别处理后跳出循环
                outM(sv-1:base+1,i) = doFix(outM(sv-1:base+1,i));
                outM(ev-1:ev+1,i) = doFix( outM(ev-1:ev+1,i));
                break;
            end %if(ei<len)
        else %NaN段到结尾，且连续，一次处理后跳出循环
            outM(sv-1:ev+1,i) = doFix(outM(sv-1:ev+1,i));
            break;
        end %if(ev~=base+1)
    end % while(j<len)
end % for i=1:channels
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % doFix: 实际对某段数据进行修正操作
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

