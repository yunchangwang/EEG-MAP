function [trials] = getTrials_BCICMP2(path)
%% 2012.05.30 LWC

%   【与getTrials_BCICMP的区别：此处每个trial单独保存】
% % 改动：
%   2012.06.21 添加修正NaN数据功能；

%功能：
%   从BCI竞赛训练数据中分类提取trial；原始数据格式：*.gdf；
%   本函数获取结果包括有Artifact的trial；
%   每个trial有3秒数据，750行（原始数据采样频率250Hz）；
%输入：
%   path - 原始数据文件路径；例：'..\data\BCICIV_2a_gdf\ori\A01T.gdf'；
%   [s, h] = sload('..\data\BCICIV_2a_gdf\ori\A01T.gdf');
%   [trials] = getTrials_BCICMP('..\data\BCICIV_2a_gdf\ori\A01T.gdf');
%输出：
%   trial - 按类别分别存储的各个trial数据；

% 各类数据提示开始标记：
% 769 0x0301 Cue onset left (class 1)
% 770 0x0302 Cue onset right (class 2)
% 771 0x0303 Cue onset foot (class 3)
% 772 0x0304 Cue onset tongue (class 4)
% 思路：根据 h.EVENT.TYP，寻找以上4类数据，每个是一个trial；

%% 程序
[s, h] = sload(path);

typ_r = size(h.EVENT.TYP,1); %各类标记的总行数，从中挑选需要的4类
trials.text = 'dX - 表示一个trial的数据;1 左手; 2 右手; 3 双脚; 4 舌头; Classlabel - 原始数据中的分类标记';
trials.count = 0 ;
trials.SampleRate = h.SampleRate; %采样频率
% trials.label = [];

for i = 1:typ_r
    if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
        trials.count = trials.count + 1;
        %【每个trial单独】
        tmpData = s(h.EVENT.POS(i)+250:h.EVENT.POS(i)+999,1:22);
        
%         %         % 2012.06.23 标记trial是否被舌弃【Rejected Trial】
%         % % 测试发现ArtifactSelection里的值就是这里获得的trails。rejected
%         %         if(h.EVENT.TYP(i-1,1)==1023)
%         %             trials.rejected(trials.count) = 1;
%         %         else
%         %             trials.rejected(trials.count) = 0;
%         %         end
        
        %2012.06.21 当数据第一和最后一个采样点没有NaN值时，修正其他采样点的NaN值；
        if(isempty(find(isnan(tmpData(1,:))==1)) && isempty(find(isnan(tmpData(750,:))==1)))
            if(isempty(find(isnan(tmpData(2:749,:))==1)))
                trials.fixed(trials.count) = 0; %无需修正NaN
            else
                tmpData = fixNaN(tmpData);
                trials.fixed(trials.count) = 1; %需要修正NaN，且已修正
            end
        else
            disp '数据无法修正！！！'
            trials.fixed(trials.count) = 2; %首末行存在NaN值，无法修正；
        end
        
        eval(['trials.d',num2str(trials.count),'= tmpData;']);
        %         trials.label(trials.count) = h.EVENT.TYP(i,1)-768;
    end % of if(h.EVENT.TYP(i,1)>768 && h.EVENT.TYP(i,1)<773)
end % of for i = 1:typ_r

% trials.label = trials.label';
trials.fixed = trials.fixed';
trials.rejected = trials.rejected';
trials.ArtifactSelection = h.ArtifactSelection; %用于排除Artifact;
trials.Classlabel = h.Classlabel; %用于检验trial分类结果是否正确；训练数据(XXXT.gdf)里有，测试数据(XXXE.gdf)中没有提供；

end

