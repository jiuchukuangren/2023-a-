%% 根据日期和时间 求太阳高度角，方位角
%中心位于东经 98.5∘，北纬 39.4∘，海拔 3000 m，半径 350 m 的圆形区域
% 建立以定日镜场中心为坐标原点，正东方向为X轴，正北为Y轴
%当地时间为每月21日的9，10：30，12，13：30，15
function [alpha_s,gamma_s]=sun_location(inputDate,ST)
%ST=9;%先不妨设为9点
w=(pi/12)*(ST-12);%w为太阳时角
phi=(39.4/180)*pi;%phi是当地的纬度39.4°转化为弧度制
% 获取输入的日期
%inputDate = input('请输入日期（格式：yyyy-mm-dd）: ', 's');
% 将输入日期解析为年、月和日
inputDateVec = datevec(inputDate);
% 设置春分日期为3月21日
springEquinox = datenum(inputDateVec(1), 3, 21);
% 计算输入日期距离春分的天数（D）
D = floor(datenum(inputDate) - springEquinox);
%fprintf('距离春分的天数（D）为：%d\n', D);
%delta为太阳赤尾角
delta=asin(sin((2*pi*D)/365).*sin((2*pi*23.45)/360));
% 求太阳高度角：
alpha_s=asin(cos(delta).*cos(phi).*cos(w)+sin(delta).*sin(phi));
% 求太阳方位角
gamma_s=acos((sin(delta)-sin(alpha_s).*sin(phi))/(cos(alpha_s).*cos(phi)));
% fprintf('太阳高度角（alpha_s）：%f radians\n', alpha_s);
% fprintf('太阳方位角（gamma_s）：%f radians\n', gamma_s);

end
