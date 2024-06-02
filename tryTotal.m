function t=tryTotal(lines,radii,colors)

if (nargin==1)
    [lines,radii,colors] = getPolylines(lines);
    radii=radii;
end

diameters = cell(length(lines),1);
v=cell(length(lines),1);
s=cell(length(lines),1);
l=cell(length(lines),1);
s_sum=0;
v_sum=0;
l_sum=0;
for i = 1 : length(lines)  
     m=size(lines{i},1);
     diameters{i}= ones(1,m)*radii(i)*2;
     s{i}=ones(1,m);
     v{i}=ones(1,m);
     l{i}=ones(1,m);
     for a=1:m
        diameters{i}(1,a)=(1/2)*diameters{i}(1,a)*(m-a+1)/m;
        l{i}(1,a)=0;
        if a>1
            l{i}(1,a) =sqrt((lines{i}(a,1)-lines{i}(a-1,1))^2+(lines{i}(a,2)-lines{i}(a-1,2))^2+(lines{i}(a,3)-lines{i}(a-1,3))^2);         
            s{i}(1,a)=pi*l{i}(1,a)*(diameters{i}(1,a)+diameters{i}(1,a-1));
            v{i}(1,a)=(1/3)*pi*l{i}(1,a)*((diameters{i}(1,a))^2+(diameters{i}(1,a-1))^2+diameters{i}(1,a)*diameters{i}(1,a-1));
        else
            s{i}(1,a)=0;
            v{i}(1,a)=0;
        end
        l_sum = l_sum + l{i}(1,a);
        s_sum = s_sum + s{i}(1,a);
        v_sum = v_sum + v{i}(1,a);
     end
end
s_sum
v_sum
l_sum

