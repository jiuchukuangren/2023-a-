%% 求法向直接辐射辐照度DNI和定日镜场的输出热功率E_field
%%坐标系：以定日镜场中心为坐标原点，正东方向为X轴，正北为Y轴
clear;clc;
H=80;%吸收塔的高度
r=3.5;%吸收塔圆柱半径
%inputDate和ST是手动输入的
%这里不妨令：inputDate=2023-04-21;ST=9;
inputDate=2023-04-21;ST=9;
[alpha_s, gamma_s] = sun_location(inputDate,ST);
% 吸收塔入射点坐标C：
C=[r*cos(gamma_s),r*sin(gamma_s),H];
%定日镜镜面中心的坐标B
h=4;%第一问中所有定日镜的安装高度
B_zong = xlsread('C:\Users\Administrator\Desktop\保存的程序\附件.xlsx');
B_X=B_zong(: ,1)
B_Y=B_zong(: ,2)
%% 计算距离
L=[]
cunchu=[]
for i = 2:length(B_X)
    L(i)=sqrt((B_X(i)-B_X(1))^2+(B_Y(i)-B_Y(1))^2);
end
    zxz=mink(L',5)
    
    for i =1:5
        cunchu(i,:)=B_zong(find(L'==zxz(i)),:)
    end
%% 镜面参数计算
function cs=jingmian(B)
x_B=B(1);y_B=B(2);
%太阳向量表达式：
s=[cos(alpha_s).*sin(gamma_s),cos(alpha_s).*cos(gamma_s),sin(alpha_s)];
magnitude_s=norm(s);
%镜面中心与吸收塔入射点的向量
BC=B-C; magnitude_BC = norm(BC);
%镜面法向量
B_normal=(BC./magnitude_BC)+(s./magnitude_s);
x_n=B_normal(1);
y_n=B_normal(2);
z_n=B_normal(3);
% 镜面方程
%syms x y z  %定义符号变量
%D=(x_n*x_B + y_n*y_B + z_n*h);
%mirror_eq = x_n*x + y_n*y + z_n*z - D == 0;
% 显示镜面方程
%disp(vpa(subs(mirror_eq),4));
cs=(x_n,y_n,z_n);
end
duibi=[];
for i=1:5
    faxiang(i,1:3)=jingmian(cunchu(i,:));
end
%% 阴影遮挡效率计算

function rate=dangeyinying(An,A,Bn,B,GX,bc)
jisuan=0;
for i =1:100
    a=[rand()*3-rand()*3,rand()*3-rand()*3];
panduan=true
    function R=trans(Rn)
        R=[Rn(2) Rn(3)*Rn(1) Rn(1);
            -Rn(1) Rn(3)*Rn(2) Rn(2);
            0 -Rn(1)^2-Rn(2)^2 Rn(3)]
    end
R_A=R(An);
R_B=R(Bn);
%计算b坐标系下点线
AO=R_A*a-A;
AOB=R_B'*(AO-B);
GX_B=R_B'*GX;
%判断是否在内
x=(GX_B(3)*AOB(1)-GX_B(1)*AOB(3))/GX_B(3);
y=(GX_B(3)*AOB(2)-GX_B(2)*AOB(3))/GX_B(3);
if x<=bc||y<=bc
    panduan=true;
end
jisuan=jisuan+panduan;
end
rate=jisuan/100
end
bilicunchu=[]
for i = 1:5
bilicunchu(i)=dangeyinying(jingmian(B_zong(1,1:2)),B_zong(1,1:2),faxiang(i,1:3),cunchu(i,1:2),sun_location(inputDate,ST),3)
end
















eta_sb=1-shadeloss;%eta_sb为阴影遮挡效率
%大气质量
AM=1./cos((pi/2)-alpha_s);
%太阳光能量
I_D=G_0.*0.7^(AM^0.678);
I_D0=G_0.*0.7^(1^0.678);
%余弦损失为cosloss
cosloss=(I_D0-I_D)./I_D;
eta_cos=1-cosloss;%eta_cos为余弦效率
h=4;%第一问中所有定日镜的安装高度
x_B=input('请输入定日镜的横坐标：');
y_B=input('请输入定日镜的纵坐标：');
%B=[x_B,y_B,h];%定日镜中心坐标
%O=[0,0,H];%集热器中心坐标H=80
%d_HR表示镜面中心到集热器中心的距离,d_HR<=1000
d_HR=sqrt((x_B)^2+(y_B)^2+(H-h)^2);
eta_at=0.99321-0.0001176.*d_HR+(1.97e-8).*(d_HR).^2;%大气透射率
%集热器阶段效率：eta_trunc;
%镜面反射率eta_ref=0.92;
eta_trunc=;
%定日镜的光学效率：eta
eta=(eta_sb)*(eta_cos)*(eta_at)*(eta_trunc)*(eta_ref);
%DNI
a = 0.4237-0.00821.*(6-H)^2;
b= 0.5055 + 0.00595.*(6.5-H)^2;
c= 0.2711 + 0.01858.*(2.5-H)^2;
G_0=1.366;%G_0为太阳常数
H=3;%公式里海拔是以千米单位
DNI=G_0 .* (a+b.*exp(-c/sin(alpha_s)));
%N为定日镜总数目
N=length(xlsread('/Users/Sayen/projects/MATLAB/定日镜坐标.xlsx',1,sprintf('A:A')));
A_i=6*6;%？这里写的是定日镜的面积
%eta_i为第i面镜子的光学效率