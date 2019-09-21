function Y=dist(csv1,csv2)
top=30.331886;bottom=30.187395;
left=120.058432;right=120.284086;
name1=csv1{1,2};
name2=csv2{1,2};
data1_y=csv1{1,3};
data1_x=csv1{1,4};
data2_y=csv2{1,3};
data2_x=csv2{1,4};
i=1;j=1;%两个指针分别指向两个文件第一行
m1=length(name1);
m2=length(name2);
Y=0;

while i<=m1
    temp=j; %temp之前的车已经被算过
    while j<=m2
        if isequal(name1(i),name2(j))%找到了相同名字的车
            break;
        end
        j=j+1;
    end
    if(j>temp&&j<=m2)%从temp到j-1都是新来的车
        for k=temp:j-1
            K=[abs(data2_x(j)-left)*0.866,abs(data2_x(j)-right)*0.866,abs(data2_y(j)-top),abs(data2_y(j)-bottom)];
            move_dist=min(K);
            Y=Y+move_dist;%假设从最近的地方进来
        end
        move_dist=abs(data2_x(j)-data1_x(i))*0.866+abs(data2_y(j)-data1_y(i));%经度差都要乘以根号3 /2
       % fprintf('%d ',j);
        Y=Y+move_dist;
    end
    if(j==temp&&j<=m2)
        move_dist=abs(data2_x(j)-data1_x(i))*0.866+abs(data2_y(j)-data1_y(i));%经度差都要乘以根号3 /2
        Y=Y+move_dist;
    end
    if(j>m2)%压根没找到
        K=[abs(data1_x(i)-left)*0.866,abs(data1_x(i)-right)*0.866,abs(data1_y(i)-top),abs(data1_y(i)-bottom)];
        move_dist=min(K);
        Y=Y+move_dist;
        j=temp-1;%没找到的话j必须复位
    end
    i=i+1;
    j=j+1;
end
            
        