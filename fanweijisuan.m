%clear;clc;
H=80;%吸收塔的高度
r=3.5;%吸收塔圆柱半径
bc=6;
%inputDate和ST是手动输入的
chakan=[];
for iz = 0:1.5:6
fangzhi=[]
    inputDate='2023-11-21';ST=9+iz;%这里不妨令：inputDate=2023-04-21;ST=9;
[alpha_s, gamma_s] = sun_location(inputDate,ST);
fangzhi=[alpha_s, gamma_s,80/tan(alpha_s)];
chakan=[chakan;fangzhi];
end
fangzhi=[min(chakan(:,1)) max(chakan(:,1)) min(chakan(:,2)) max(chakan(:,2)) min(chakan(:,3)) max(chakan(:,3))];
huizong=[huizong;fangzhi]