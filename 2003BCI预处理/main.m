% 2012.06.21 LWC
% 功能：
% 从2008 BCI竞赛数据提取各个trial；调用脚本getTrials_BCICMP和getTrials_BCICMP2；
% 该脚本只提取了竞赛数据训练部分，比赛部分没有实际分类标记；

% 效率记录：
% V1 - Elapsed time is 55.475676 seconds.
% V2 - Elapsed time is 23.558761 seconds.

%处理gdf格式的函数，只是将gdf转换成mat(以*BCICMP结尾的函数都不需要关注)

clear
clc

tic;

%文件路径变量
path1 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A01T.gdf';
path2 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A02T.gdf';
path3 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A03T.gdf';
path4 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A04T.gdf';
path5 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A05T.gdf';
path6 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A06T.gdf';
path7 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A07T.gdf';
path8 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A08T.gdf';
path9 = 'E:\517\Godec\20120530BCI竞赛2008数据提取\BCICIV_2a_gdf\A09T.gdf';

subs = 9;
%2012.06.21 汇总修正记录
fixed = zeros(300,9);

%获取trials
for i = 1:subs
% for i = 4:4
    
%     %%【版本1：各trial的数据放在一起 - data】
%     %%V1 - Elapsed time is 55.475676 seconds.
%     eval(['trials = getTrials_BCICMP(path',num2str(i),');']);
%     eval(['save subject',num2str(i),'_V1 trials;']); %分别保存个trials
%     clear trials;
    
    %%【版本2：每个trial单独保存 - dX】
    %%V2 - Elapsed time is 23.558761 seconds.
    eval(['trials = getTrials_BCICMP2(path',num2str(i),');']);
    eval(['save subject',num2str(i),'_V2 trials;']); %分别保存个trials
    
    %2012.06.21
    len = length(trials.fixed);
    fixed(1:len,i) = trials.fixed;
    
    clear trials;
    
end

toc
