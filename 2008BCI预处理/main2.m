% 2012.05.30 LWC
% 功能：
% 从2008 BCI竞赛数据提取各个trial；调用脚本getUnTrials_BCICMP和getUnTrials_BCICMP2；
% 该脚本提取竞赛数据比赛部分；

%   2012.05.30 试运行 Elapsed time is 76.108145 seconds. 

clear
clc

tic;

%文件路径变量
path1 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A01E.gdf';
path2 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A02E.gdf';
path3 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A03E.gdf';
path4 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A04E.gdf';
path5 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A05E.gdf';
path6 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A06E.gdf';
path7 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A07E.gdf';
path8 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A08E.gdf';
path9 = 'D:\matlabWorkspace\BFN\data\BCICIV_2a_gdf\ori\A09E.gdf';

%获取trials
for i = 1:9
    
    %%【版本1：各trial的数据放在一起 - data】
    eval(['trials = getUnTrials_BCICMP(path',num2str(i),');']);
    eval(['save subject',num2str(i),'_EV1 trials;']); %分别保存个trials
    clear trials;
    
    %%【版本2：每个trial单独保存 - dX】
    eval(['trials = getUnTrials_BCICMP2(path',num2str(i),');']);
    eval(['save subject',num2str(i),'_EV2 trials;']); %分别保存个trials
    clear trials;
    
end

toc
