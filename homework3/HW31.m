function sim=HW31()
origin1=HW23('textured3.jpg'); %4*4的特征向量矩阵
origin2=HW23('textured3.jpg');
k1=4; %图1分为几类
k2=4;  %图2分为几类
%Idx存储的是每个点的聚类标号，center存储的是k个聚类质心的位置
%sumD存储的是类间所有点与该类质心点距离之和，D存储的是每个点与所有质心的距离
opts = statset('Display','final','MaxIter',1000);
[Idx1,~,sumD1]=kmeans(origin1,k1,'Options',opts);
[Idx2,~,sumD2]=kmeans(origin2,k2,'Options',opts);

f1=zeros(k1,9);
for i=1:k1
    fc=feature(origin1,Idx1,sumD1(i,1),i);
    f1(i,:)=fc;   %f1是图1的特征向量矩阵，用这个向量矩阵算距离
end
Lf7=max(f1(:,7));   %Lf7是这一列最大值，这个图中这个分量的最大值，用它来归一化 
f1(:,7)=f1(:,7)/Lf7;
clear max;
Lf8=max(f1(:,8)); 
f1(:,8)=f1(:,8)/Lf8;
clear max;
Lf9=max(f1(:,9)); 
f1(:,9)=f1(:,9)/Lf9;
clear max;
%现在的f1可以用来算距离了
f2=zeros(k2,9);
for i=1:k2
    fc=feature(origin2,Idx2,sumD2(i,1),i);
   f2(i,:)=fc;     %f2是图2的特征向量矩阵，用这个向量矩阵算距离
end
Lf7=max(f2(:,7));   %Lf7是这一列最大值，这个图中这个分量的最大值，用它来归一化 
f2(:,7)=f2(:,7)/Lf7;
clear max;
Lf8=max(f2(:,8)); 
f2(:,8)=f2(:,8)/Lf8;
clear max;
Lf9=max(f2(:,9)); 
f2(:,9)=f2(:,9)/Lf9;
clear max;
%现在的f2可以用来算距离了

%在计算d之前，先要判断图像是textured还是nontextured，如果是textured要略去形状特征
%只要两张图像有一张是nontexture，我就按照nontexture的方法来计算
x21=judgetexture(Idx1,k1);
x22=judgetexture(Idx2,k2);
disp(x21);
disp(x22);
%下面开始算d,ds,dt
d=zeros(k1,k2);
for i=1:k1
    for j=1:k2
        if(x21>=0.32 || x22>=0.32)
            w=1/3; %ds里的权重分配
            ds=w*((f1(i,7)-f2(j,7))^2+(f1(i,8)-f2(j,8))^2+(f1(i,9)-f2(j,9))^2);
            if(ds>=0.5)
                g=1;
            elseif(ds>=0.2)
                g=0.85;
            elseif(ds<0.2)
                g=0.5;
            end
        else
            g=1;
        end
        %现在已经得到了g值，下面算dt
        wc=0.4;
        wt=0.6;%wc和wt分别是颜色特征和纹理特征的权重，满足wc+wt=1
        dt=w*(wc*((f1(i,1)-f2(j,1))^2+(f1(i,2)-f2(j,2))^2+(f1(i,3)-f2(j,3))^2)+wt*((f1(i,4)-f2(j,4))^2+(f1(i,5)-f2(j,5))^2+(f1(i,6)-f2(j,6))^2));
        d(i,j)=g*dt;
        %disp(d(i,j));
    end
end
%已经得到了d矩阵，下面开始算s矩阵
dc=d;
%首先构造两张图的p值矩阵
images1=zeros(1,k1);
for i=1:k1
    Idx=Idx1';
    pos=find(Idx==i);
    number=length(pos);
    images1(1,i)=16*number;
end
images1=images1/sum(sum(images1));

images2=zeros(1,k2);
for i=1:k2
    Idx=Idx2';
    pos=find(Idx==i);
    number=length(pos);
    images2(1,i)=16*number;
end
images2=images2/sum(sum(images2));

s=zeros(k1,k2);
L=zeros(k1,k2);
s=significance(images1,images2,dc,L,s);
%s计算完后，计算D=d【】s【】；
sim=0;
for i=1:k1 
    for j=1:k2
        sim=sim+d(i,j)*s(i,j);
    end
end
return;

function s=significance(images1,images2,dc,L,s)
mind=min(min(dc));
maxd=max(max(dc))+1;
[row,column]=find(dc==mind);
%disp(row);
%disp(column);
if(images1(1,row)<images2(1,column))
    s(row,column)=images1(1,row);
    images2(1,column)=images2(1,column)-images1(1,row);
    images1(1,row)=0;
else
    s(row,column)=images2(1,column);
    %disp(s(row,column));
    %disp(images2(1,column));
    images1(1,row)=images1(1,row)-images2(1,column);
    images2(1,column)=0;
end
L(row,column)=1;
dc(row,column)=maxd;
if(sum(sum(images1))>0 && sum(sum(images2))>0)
    s=significance(images1,images2,dc,L,s);
else 
    return;
end

function x2=judgetexture(Idx,k)
Idx=Idx';
row=length(Idx);
size=row/16;
%disp(size);
x2=0;
for i=1:k
    for j=1:16
        part=Idx(:,(j-1)*size+1:j*size);
        pos=find(part==i);
        number=length(pos);
        p=number/size;
        %disp(number);
        %disp(p);
        x2=x2+16*(p-1/16)^2;
    end
    break;
end

return;

function f=feature(origin,Idx,sumD,i)
Idx=Idx';
pos=find(Idx==i);
number=length(pos);
f6=zeros(1,6);
for num=1:number
    f6=f6+origin(pos(1,num),:);
end
f6=f6/number; %计算出区域i中前六个向量的均值
f7=sumD/((16*num)^(1+1/6));
f8=sumD^2/((16*num)^(1+2/6));
f9=sumD^3/((16*num)^(1+3/6));
f=[f6,f7,f8,f9];
return;