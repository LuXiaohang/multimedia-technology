function origin=HW23(name)
pic = double(imread(name))/255; %read color img
[width height l]=size(pic);
width=width/4;
height=height/4;
seg=mat2cell(pic,4*ones(1,width),4*ones(1,height),3);
[m n]=size(seg);
for i=1:m
    for j=1:n
        h=cell2mat(seg(i,j));
        R=h(:,:,1);
        G=h(:,:,2);
        B=h(:,:,3);
        R=sum(sum(R))/16;
        G=sum(sum(G))/16;
        B=sum(sum(B))/16;
        feature(i,j,1)=R;
        feature(i,j,2)=G;
        feature(i,j,3)=B;
        [LL LH HL HH]=HW22(h);
        feature(i,j,4)=figure(HL);
        feature(i,j,5)=figure(LH);
        feature(i,j,6)=figure(HH);     
    end
end
origin=zeros(1,6);
for i=1:m
    for j=1:n
         origin=[origin;feature(i,j,1),feature(i,j,2),feature(i,j,3),feature(i,j,4),feature(i,j,5),feature(i,j,6)];     
    end
end
origin(1,:)=[];
%这里是分为几类
%k=5;
%[Idx,center,sumD,D]=kmeans(origin,k);  %Idx存储的是每个点的聚类标号，center存储的是k个聚类质心的位置,sumD存储的是类间所有点与该类质心点距离之和，D存储的是每个点与所有质心的距离
%Idx=Idx';
%hist(Idx,10);
% l=length(seg);
% for h=1:k
%     pos=find(Idx==h);
%     number=length(pos);
%     for num=1:number
%         i=floor(pos(1,num)/n);
%         j=mod(pos(1,num),n);
%         if j==0
%             j=n;
%         else
%             i=i+1;
%         end
%         segment=cell2mat(seg(i,j)); %此时给这个类重新上色
%         R=[1,1,1,1;1,1,1,1;1,1,1,1;1,1,1,1;];
%         G=R;
%         B=R;
%         if(h==1)
%             R=zeros(4,4);
%         elseif(h==2)
%             G=zeros(4,4);
%         elseif(h==3)
%             B=zeros(4,4);
%         elseif(h==4)
%             R=zeros(4,4);
%             G=zeros(4,4);
%         elseif(h==5)
%             R=zeros(4,4);
%             B=zeros(4,4);
%         elseif(h==6)
%             G=zeros(4,4);
%             B=zeros(4,4);
%         end
%         segment(:,:,1)=R;
%         segment(:,:,2)=G;
%         segment(:,:,3)=B;
%         seg(i,j)=mat2cell(segment,4,4,3);
%     end
% end
% pic=cell2mat(seg);
% %imshow(pic);
% imwrite(pic,'textured3k5.bmp'); %save the bmp
return;

function one=figure(C)
    a=C(1,1);
    b=C(1,2);
    c=C(2,1);
    d=C(2,2);
    one=sqrt(1/4*(a^2+b^2+c^2+d^2));
return;
