jisuan=[];
% for i = 1:length(xinde(:,1))
    jisuan=sum(xinde()');
    jisuan=jisuan./12;
% end
zonghe=sum(jisuan');
jisuan_1=mink(jisuan,500)';
jisuan_2=maxk(jisuan,1000)';
