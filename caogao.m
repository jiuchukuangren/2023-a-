clear;clc;
H=80;%吸收塔的高度
r=3.5;%吸收塔圆柱半径
bc=6;
%inputDate和ST是手动输入的
huizong_1=0;
huizong_2=0;
huizong_3=0;
for iz = 0:1.5:6
    inputDate='2023-1-21';ST=9+iz;%这里不妨令：inputDate=2023-04-21;ST=9;
[alpha_s, gamma_s] = sun_location(inputDate,ST);
s=[cos(alpha_s).*sin(gamma_s),cos(alpha_s).*cos(gamma_s),sin(alpha_s)];
% 吸收塔入射点坐标C：
%C=[r*cos(gamma_s),r*sin(gamma_s),H];
h=4;%第一问中所有定日镜的安装高度
%定日镜镜面中心的坐标B
B_zong = xlsread('C:\Users\Administrator\Desktop\保存的程序\附件.xlsx');
HH=ones(length(B_zong(:,1)),1).*h;
B_zong=[B_zong HH];
B_X=B_zong(: ,1);
B_Y=B_zong(: ,2);
B_Z=h;
for j = 1:length(B_X)
    %% 镜面方程参数
    faxiangliang=[];
    for i=1:length(B_X)
        C=[r*B_X(i)/sqrt(B_X(i)^2+B_Y(i)^2),r*B_Y(i)/sqrt(B_X(i)^2+B_Y(i)^2),H];
        faxiangliang(i,1:4)=jingmian(B_zong(i,1:3),alpha_s,gamma_s,C,h);
    end
    %% 计算距离(选取十个点的坐标)
%     L=[];
%     cunchu=[];
%     for i = 2:length(B_X)
%         L(i)=sqrt((B_X(i)-B_X(j))^2+(B_Y(i)-B_Y(j))^2);
%     end
%     zxz=mink(L',10);
%     for i =1:10
%         hebing=[faxiangliang(find(L'==zxz(i)),:) B_zong(find(L'==zxz(i)),:)];
%         cunchu=[cunchu;hebing];
%     end
    %计算定日镜互相的光线遮挡
%     bilicunchu=[];
%     for i = 1:length(cunchu(:,1))
%         bilicunchu(i)=dangeyinying(faxiangliang(j,1:3),B_zong(j,1:3),cunchu(i,1:3),cunchu(i,5:7),sun_location(inputDate,ST),bc,C);
%     end
%     huizong_1=huizong_1+sum(bilicunchu);

    C=[r*B_X(j)/sqrt(B_X(j)^2+B_Y(j)^2),r*B_Y(j)/sqrt(B_X(j)^2+B_Y(j)^2),H];
    B=[B_X(j),B_Y(j),h];
    BC=C-B; 
    Bn=[faxiangliang(j,1),faxiangliang(j,2),faxiangliang(j,3)];
dhr = sqrt(BC(1)^2+BC(2)^2+BC(3)^2);
eta_at=0.99321-0.0001176*dhr+1.97*10^(-8)*dhr*dhr;
huizong_3=huizong_3+eta_at;
eta_cos=sum(BC.*Bn)/norm(BC)/norm(Bn);
huizong_2=huizong_2+eta_cos;
end
% %大气质量
% AM=1./cos((pi/2)-alpha_s);
% %太阳光能量
% G_0=1.366;
% I_D=G_0.*0.7^(AM^0.678);
% I_D0=G_0.*0.7^(1^0.678);
% 
% %余弦损失为cosloss
% cosloss=(I_D0-I_D)./I_D;
% eta_cos=1-cosloss;%eta_cos为余弦效率
% huizong_2=huizong_2+cosloss;
end
% shadeloss=huizong_1/5/1745;
% eta_sb=1-shadeloss%eta_sb为阴影遮挡效率
% shadeloss_pingjun=huizong_2/5;
%eta_cos=1-cosloss
eta_cos=huizong_2/5/1745
eta_at=huizong_3/5/1745
eta_trunc=1
eta_ref=0.92





