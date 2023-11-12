clear;clc;

H=80;%吸收塔的高度
r=3.5;%吸收塔圆柱半径
bc=6;
%inputDate和ST是手动输入的
huizong_1=0;
huizong_2=0;
huizong_3=0;
huizong_4=0;
shxs=0.75;
eta_ref=0.92;

for iz = 0:1.5:6
    inputDate='2023-12-21';ST=9+iz;%这里不妨令：inputDate=2023-04-21;ST=9;
    %太阳参数
    [alpha_s, gamma_s] = sun_location(inputDate,ST);
    s=[cos(alpha_s).*sin(gamma_s),cos(alpha_s).*cos(gamma_s),sin(alpha_s)];
    h=4;%第一问中所有定日镜的安装高度
    %DNI
    HB=3;%公式里海拔是以千米单位
    a = 0.4237-0.00821.*(6-HB)^2;
    b= 0.5055 + 0.00595.*(6.5-HB)^2;
    c= 0.2711 + 0.01858.*(2.5-HB)^2;
    G_0=1.366;%G_0为太阳常数
    
    DNI=G_0 .* (a+b.*exp(-c/sin(alpha_s)));
    %定日镜镜面中心的坐标B
    B_zong = xlsread('C:\Users\Administrator\Desktop\保存的程序\附件.xlsx');
    HH=ones(length(B_zong(:,1)),1).*h;
    B_zong=[B_zong HH];
    B_X=B_zong(: ,1);
    B_Y=B_zong(: ,2);
    B_Z=h;
    yuanshigeshu=length(B_X);
    %阴影剔除坐标
    tichumingdan=[];
    for i=1:length(B_X)
        xx=B_X(i);
        yy=B_Y(i);
        pmxz=[cos(gamma_s),sin(gamma_s);-sin(gamma_s),cos(gamma_s)];
        diyige=pmxz*[3.5;0];
        xx_1=diyige(1);
        yy_1=diyige(2);
        dierge=pmxz*[-3.5;0];
        xx_2=dierge(1);
        yy_2=dierge(2);
        bb_1=yy_1-tan(gamma_s)*xx_1;
        bb_2=yy_2-tan(gamma_s)*xx_2;
        bbb=pmxz*[0;84/tan(alpha_s)];
        b_1=yy-tan(gamma_s)*xx;
        b_2=yy-tan(gamma_s+pi/2)*xx;
        if b_1<=max(bb_1,bb_2)&b_1>=min(bb_1,bb_2)&b_2<=max(0,bbb)&b_2>=min(0,bbb)
            B_zong(j,:)=0;
            B_X(j,:)=0;
            B_Y(j,:)=0;
            B_Z=0;
        end
    end
    B_zong (all(B_zong == 0, 2),:) = [];
    B_X=B_zong(: ,1);
    B_Y=B_zong(: ,2);
    TC=yuanshigeshu-length(B_X);
    %% 镜面方程参数
    faxiangliang=[];
    for i=1:length(B_X)
        C=[r*B_X(i)/sqrt(B_X(i)^2+B_Y(i)^2),r*B_Y(i)/sqrt(B_X(i)^2+B_Y(i)^2),H];
        faxiangliang(i,1:4)=jingmian(B_zong(i,1:3),alpha_s,gamma_s,C,h);
    end
    for j = 1:length(B_X)
        C=[r*B_X(j)/sqrt(B_X(j)^2+B_Y(j)^2),r*B_Y(j)/sqrt(B_X(j)^2+B_Y(j)^2),H];
        %计算距离(选取十个点的坐标)
        L=[];
        cunchu=[];
        for i = 2:length(B_X)
            L(i)=sqrt((B_X(i)-B_X(j))^2+(B_Y(i)-B_Y(j))^2);
        end
        zxz=mink(L',10);
        for i =2:10%不要它本身
            hebing=[faxiangliang(find(L'==zxz(i)),:) B_zong(find(L'==zxz(i)),:)];
            cunchu=[cunchu;hebing];
        end
        %计算定日镜互相的光线遮挡
        bilicunchu=[];
        [shadeloss eta_trunc]=dangeyinying(faxiangliang(j,1:3),B_zong(j,1:3),cunchu,sun_location(inputDate,ST),bc,C,shxs);
        huizong_1=huizong_1+shadeloss;
        huizong_4=huizong_4+eta_trunc;
        eta_sb=1-shadeloss-TC/yuanshigeshu;
        %余弦效率
        C=[r*B_X(j)/sqrt(B_X(j)^2+B_Y(j)^2),r*B_Y(j)/sqrt(B_X(j)^2+B_Y(j)^2),H];
        B=[B_X(j),B_Y(j),h];
        BC=C-B;
        Bn=[faxiangliang(j,1),faxiangliang(j,2),faxiangliang(j,3)];
        eta_cos=sum(BC.*Bn)/norm(BC)/norm(Bn);
        huizong_2=huizong_2+eta_cos;
        %大气折射率
        dhr = sqrt(BC(1)^2+BC(2)^2+BC(3)^2);
        eta_at=0.99321-0.0001176*dhr+1.97*10^(-8)*dhr*dhr;
        huizong_3=huizong_3+eta_at;
        %单个定日镜
        E_field=eta_at*eta_sb*eta_cos*eta_trunc*eta_ref*bc^2*DNI;
        zongti(j,(iz+1.5)/1.5)=E_field;
    end
    
end
shadeloss=huizong_1/5/1745;
eta_sb=1-shadeloss%eta_sb为阴影遮挡效率
shadeloss_pingjun=huizong_2/5;
eta_cos=huizong_2/5/1745
eta_at=huizong_3/5/1745
% eta_trunc=1
eta_ref=0.92
eta_trunc=huizong_4/5/1745

%定日镜的光学效率：eta
eta=(eta_sb)*(eta_cos)*(eta_at)*(eta_trunc)*(eta_ref);






