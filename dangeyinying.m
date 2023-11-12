function [shadeloss eta_trunc]=dangeyinying(An,A,cunchu,GX,bc,C,shxs)
%判断截断面积

taiyang=16/60*pi/180;
BC=C-A;
L=norm(BC);
alpha=asin(80/L);
a1=sin(taiyang)*L/sin(pi/2-alpha-taiyang);
a2=sin(taiyang)*L/sin(pi/2+alpha-taiyang);
a3=L*tan(taiyang);
a4=a3;
S1=bc*bc;
S2=(bc-a1-a2)*(bc-a3-a4);
s1=0;
s2=0;
wanquanzhanbi=S2/S1;
wqdian=100*(S1-S2)/S1;
yydian=100-100*(S1-S2)/S1;
jisuan=0;
for i = 1:length(cunchu(:,1))
    %bilicunchu(i)=cunchu(i,1:3),,sun_location(inputDate,ST),bc,C);
    Bn=cunchu(i,1:3);
    B=cunchu(i,5:7);
    
    BC=C-A;
    
    for ii =0:bc/9:bc
        for jj=0:bc/9:bc
            a=[ii-3,jj-3,0]';
            R_A=rotate(An);
            R_B=rotate(Bn);
            %计算b坐标系下点线
            AO=R_A*a-A;
            AOB=R_B'*(AO-B');
            GX_B=R_B'*GX';
            gx_B=R_B'*BC';
            %判断参数
            x_1=(GX_B(3)*AOB(1)-GX_B(1)*AOB(3))/GX_B(3);
            y_1=(GX_B(3)*AOB(2)-GX_B(2)*AOB(3))/GX_B(3);
            x_2=(gx_B(3)*AOB(1)-gx_B(1)*AOB(3))/gx_B(3);
            y_2=(gx_B(3)*AOB(2)-gx_B(2)*AOB(3))/gx_B(3);
            %判断是否阻挡
            if abs(x_1)<=bc/2&abs(y_1)<=bc/2
                panduan=true;
            elseif abs(x_2)<=bc/2&abs(y_2)<=bc/2
                panduan=true;
            else
                panduan=false;
            end
            
            jisuan=jisuan+panduan;
            if panduan == true
                if a(1)>bc/2-a1||a(1)<-bc/2+a2||abs(a(2))>bc/2-a3
                    s2=s2+1;
                else
                    s1=s1+1;
                end
            end
        end
    end
end
shadeloss=jisuan/100;
%jieduanzhanbi=sum(sum(jieduanhuizong))/100;
eta_trunc=(0.75*(1-s2/yydian)*(S1-S2)+(1-s1/wqdian)*S2)/S1;
jisuanjieguo=[shadeloss eta_trunc];
end