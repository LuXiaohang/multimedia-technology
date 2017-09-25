function sim=HW31()
origin1=HW23('textured3.jpg'); %4*4��������������
origin2=HW23('textured3.jpg');
k1=4; %ͼ1��Ϊ����
k2=4;  %ͼ2��Ϊ����
%Idx�洢����ÿ����ľ����ţ�center�洢����k���������ĵ�λ��
%sumD�洢����������е���������ĵ����֮�ͣ�D�洢����ÿ�������������ĵľ���
opts = statset('Display','final','MaxIter',1000);
[Idx1,~,sumD1]=kmeans(origin1,k1,'Options',opts);
[Idx2,~,sumD2]=kmeans(origin2,k2,'Options',opts);

f1=zeros(k1,9);
for i=1:k1
    fc=feature(origin1,Idx1,sumD1(i,1),i);
    f1(i,:)=fc;   %f1��ͼ1��������������������������������
end
Lf7=max(f1(:,7));   %Lf7����һ�����ֵ�����ͼ��������������ֵ����������һ�� 
f1(:,7)=f1(:,7)/Lf7;
clear max;
Lf8=max(f1(:,8)); 
f1(:,8)=f1(:,8)/Lf8;
clear max;
Lf9=max(f1(:,9)); 
f1(:,9)=f1(:,9)/Lf9;
clear max;
%���ڵ�f1���������������
f2=zeros(k2,9);
for i=1:k2
    fc=feature(origin2,Idx2,sumD2(i,1),i);
   f2(i,:)=fc;     %f2��ͼ2��������������������������������
end
Lf7=max(f2(:,7));   %Lf7����һ�����ֵ�����ͼ��������������ֵ����������һ�� 
f2(:,7)=f2(:,7)/Lf7;
clear max;
Lf8=max(f2(:,8)); 
f2(:,8)=f2(:,8)/Lf8;
clear max;
Lf9=max(f2(:,9)); 
f2(:,9)=f2(:,9)/Lf9;
clear max;
%���ڵ�f2���������������

%�ڼ���d֮ǰ����Ҫ�ж�ͼ����textured����nontextured�������texturedҪ��ȥ��״����
%ֻҪ����ͼ����һ����nontexture���ҾͰ���nontexture�ķ���������
x21=judgetexture(Idx1,k1);
x22=judgetexture(Idx2,k2);
disp(x21);
disp(x22);
%���濪ʼ��d,ds,dt
d=zeros(k1,k2);
for i=1:k1
    for j=1:k2
        if(x21>=0.32 || x22>=0.32)
            w=1/3; %ds���Ȩ�ط���
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
        %�����Ѿ��õ���gֵ��������dt
        wc=0.4;
        wt=0.6;%wc��wt�ֱ�����ɫ����������������Ȩ�أ�����wc+wt=1
        dt=w*(wc*((f1(i,1)-f2(j,1))^2+(f1(i,2)-f2(j,2))^2+(f1(i,3)-f2(j,3))^2)+wt*((f1(i,4)-f2(j,4))^2+(f1(i,5)-f2(j,5))^2+(f1(i,6)-f2(j,6))^2));
        d(i,j)=g*dt;
        %disp(d(i,j));
    end
end
%�Ѿ��õ���d�������濪ʼ��s����
dc=d;
%���ȹ�������ͼ��pֵ����
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
%s������󣬼���D=d����s������
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
f6=f6/number; %���������i��ǰ���������ľ�ֵ
f7=sumD/((16*num)^(1+1/6));
f8=sumD^2/((16*num)^(1+2/6));
f9=sumD^3/((16*num)^(1+3/6));
f=[f6,f7,f8,f9];
return;