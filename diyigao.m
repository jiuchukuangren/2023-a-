clear;clc;
H=80;%吸收塔的高度
r=3.5;%吸收塔圆柱半径
%inputDate和ST是手动输入的
inputDate='2023-08-21';ST=13.5;%这里不妨令：inputDate=2023-04-21;ST=9;
[alpha_s, gamma_s] = sun_location(inputDate,ST);
% 吸收塔入射点坐标C：
C=[r*cos(gamma_s),r*sin(gamma_s),H];
h=4;%第一问中所有定日镜的安装高度
%定日镜镜面中心的坐标B
B_zong = xlsread('C:\Users\Administrator\Desktop\保存的程序\附件.xlsx');
B_X=B_zong(: ,1);
B_Y=B_zong(: ,2);
% %% 镜面方程参数
% for i=1:length(B_X)
%     
%% 计算距离
L=[];
cunchu=[]
for i = 2:length(B_X)
    L(i)=sqrt((B_X(i)-B_X(1))^2+(B_Y(i)-B_Y(1))^2);
end
    zxz=mink(L',5);
    
    for i =1:5
        cunchu(i,:)=B_zong(find(L'==zxz(i)),:);
    end
%% 镜面参数计算
% function cs=jingmian(B)
% cs=[]
% x_B=B(1);y_B=B(2);
% %太阳向量表达式：
% s=[cos(alpha_s).*sin(gamma_s),cos(alpha_s).*cos(gamma_s),sin(alpha_s)];
% magnitude_s=norm(s);
% %镜面中心与吸收塔入射点的向量
% BC=B-C; magnitude_BC = norm(BC);
% %镜面法向量
% B_normal=(BC./magnitude_BC)+(s./magnitude_s);
% x_n=B_normal(1);
% y_n=B_normal(2);
% z_n=B_normal(3);
% % 镜面方程
% %syms x y z  %定义符号变量
% %D=(x_n*x_B + y_n*y_B + z_n*h);
% %mirror_eq = x_n*x + y_n*y + z_n*z - D == 0;
% % 显示镜面方程
% %disp(vpa(subs(mirror_eq),4));
% cs(1,1:3)=[x_n,y_n,z_n];
% end
duibi=[];
for i=1:5
    faxiang(i,1:3)=jingmian([cunchu(i,:) 4],alpha_s,gamma_s,C);
end
%% 阴影遮挡效率计算

% function rate=dangeyinying(An,A,Bn,B,GX,bc)
% jisuan=0;
% for i =1:100
%     a=[rand()*3-rand()*3,rand()*3-rand()*3];
% panduan=true
%     function R=trans(Rn)
%         R=[Rn(2) Rn(3)*Rn(1) Rn(1);
%             -Rn(1) Rn(3)*Rn(2) Rn(2);
%             0 -Rn(1)^2-Rn(2)^2 Rn(3)]
%     end
% R_A=R(An);
% R_B=R(Bn);
% %计算b坐标系下点线
% AO=R_A*a-A;
% AOB=R_B'*(AO-B);
% GX_B=R_B'*GX;
% %判断是否在内
% x=(GX_B(3)*AOB(1)-GX_B(1)*AOB(3))/GX_B(3);
% y=(GX_B(3)*AOB(2)-GX_B(2)*AOB(3))/GX_B(3);
% if x<=bc||y<=bc
%     panduan=true;
% end
% jisuan=jisuan+panduan;
% end
% rate=jisuan/100
% end
bilicunchu=[];
for i = 1:5
bilicunchu(i)=dangeyinying(jingmian([B_zong(1,1:2) 4],alpha_s,gamma_s,C),[B_zong(1,1:2) 4]',faxiang(i,1:3),[cunchu(i,1:2) H]',sun_location(inputDate,ST),3)
end
