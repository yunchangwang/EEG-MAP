function [trials] = getUnTrials_BCICMP(s,h)
%% 2012.05.30 LWC
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

%   标记：
%   783 0x030F Cue unknown；

%% 程序
%[s, h] = sload(path);

typ_r = size(h.EVENT.TYP,1); %各类标记的总行数，从中挑选需要的4类
trials.text = '1 左手; 2 右手; 3 双脚; 4 舌头; Classlabel - 原始数据中的分类标记';
trials.count = 0 ;
trials.SampleRate = h.SampleRate; %采样频率
% trials.label = [];
trials.data = [];

for i = 1:typ_r %逐行查找，寻找需要的标记
    if(h.EVENT.TYP(i,1) == 783)
        trials.count = trials.count + 1;
        rows = size(trials.data,1); %现有数据行数
        trials.data(rows+1:rows+750,1:60) = s(h.EVENT.POS(i)+250:h.EVENT.POS(i)+999,1:60); %前22列为数据
        %         trials.data(rows+1:rows+750,23) = trials.count*ones(750,1); %第23列是标记，每行数据一个
        %         trials.label(trials.count) = h.EVENT.TYP(i,1)-768; %独立保存的标记，每个trial一个
    end % of if(h.EVENT.TYP(i,1) == 783)
end % of for i = 1:typ_r

% trials.label = trials.label';
trials.ArtifactSelection = h.ArtifactSelection; %用于排除Artifact;
trials.Classlabel = h.Classlabel; %用于检验trial分类结果是否正确；训练数据(XXXT.gdf)里有，测试数据(XXXE.gdf)中没有提供；

end

