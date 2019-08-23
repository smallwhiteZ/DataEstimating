%% 层次分析法
clc, clear

fid = fopen('data.txt', 'r');
n1 = 6;  %准则层指标个数 。    %%%需要修改
n2 = 3;  %方案层指标个数
a = [];
% 读取准则层判断矩阵
for i = 1:n1
    tmp = str2num(fgetl(fid));   %fgetl读取一行，删除换行符
    a = [a;tmp];
end
% 读取方案层判断矩阵：判断矩阵存入b1~b6中
for i = 1:n1
    str1 = char(['b', int2str(i), '=[];']);
    str2 = char(['b', int2str(i), '=[b', int2str(i), ';tmp];']);
    eval(str1);
    for j = 1:n2
        tmp = str2num(fgetl(fid));
        eval(str2);
    end
end

% 求最大特征值及对应的归一化特征向量
[max(1),wA]=ahp(a);         %max（矩阵）返回的每列最大值的行向量
                            %max(1)存储的是矩阵的最大特征值
for i = 1:n1
    str = char(['[max(', int2str(i+1), '),wb', int2str(i), ']=ahp(', 'b', int2str(i), ')']);
    eval(str);
end

%计算平均一致性指标
RIT=CalculationRI();

% 写入循环    对准则层的判断矩阵求解最大特征值和归一化特征向量
            %以及对6 * 3*3 的矩阵进行求解最大特征值和归一化特征向量
[RIA,CIA]=sglsortexamine(max(1),a,RIT);     
[RIb1,CIb1]=sglsortexamine(max(2),b1,RIT);
[RIb2,CIb2]=sglsortexamine(max(3),b2,RIT);
[RIb3,CIb3]=sglsortexamine(max(4),b3,RIT);
[RIb4,CIb4]=sglsortexamine(max(5),b4,RIT);
[RIb5,CIb5]=sglsortexamine(max(6),b5,RIT);
[RIb6,CIb6]=sglsortexamine(max(7),b6,RIT);

dw=zeros(3,6);      %%%%%这里是需要改的
% 写入循环
dw(1:3,1)=wb1;      %wb1..6是在eval函数下进行的
dw(1:3,2)=wb2;
dw(1:3,3)=wb3;
dw(1:3,4)=wb4;
dw(1:3,5)=wb5;
dw(1:3,6)=wb6;

CIC=[CIb1;CIb2;CIb3;CIb4;CIb5;CIb6];
RIC=[RIb1;RIb2;RIb3;RIb4;RIb5;RIb6];
tw=tolsortvec(wA,dw,CIC,RIC)';
wA %输出准则层对目标层权重
dw %输出准则层对方案层权重
tw  %输出总排序权值
res=tw';
[diffcult,num]=sort(res);
[diffcult,num]
