function cs=jingmian(B,alpha_s,gamma_s,C,h)
cs=[];
x_B=B(1);y_B=B(2);
%太阳向量表达式：
s=[cos(alpha_s).*sin(gamma_s),cos(alpha_s).*cos(gamma_s),sin(alpha_s)];
magnitude_s=norm(s);
%镜面中心与吸收塔入射点的向量
BC=C-B; 
magnitude_BC = norm(BC);
%镜面法向量
B_normal=(BC./magnitude_BC)+(s./magnitude_s);
x_n=B_normal(1)/norm(B_normal);
y_n=B_normal(2)/norm(B_normal);
z_n=B_normal(3)/norm(B_normal);
% 镜面方程
%syms x y z  %定义符号变量
D=(x_n*x_B + y_n*y_B + z_n*h);
%mirror_eq = x_n*x + y_n*y + z_n*z - D == 0;
% 显示镜面方程
%disp(vpa(subs(mirror_eq),4));
cs(1,1:4)=[x_n,y_n,z_n,D];
end