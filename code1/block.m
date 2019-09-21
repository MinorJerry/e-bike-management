block_of_bike=zeros(17,21);
top_left_x=120.058432;
top_left_y=30.331886;
bottom_right_x=120.284086;
bottom_right_y=30.187395;
horizon_diff=bottom_right_x-top_left_x;%我们选取数据的水平经度差
vertical_diff=top_left_y-bottom_right_y;%垂直方向纬度差
horizon_step=horizon_diff/21;
vertical_step=vertical_diff/17;
data=csvread('20180504-104057-ofo.csv',0,2);
for i=1:70724
    index_y=ceil((data(i,1)-bottom_right_y)/vertical_step);%应该做上取整
    index_x=ceil((data(i,2)-top_left_x)/horizon_step); %数据中第一列是纬度，第二列是经度
    if(index_x>21)
        index_x=21;
    elseif(index_x<=0)
        index_x=1;
    end
    if(index_y>17)
        index_y=17;
    elseif(index_y<=0)
        index_y=1;
    end
    block_of_bike(index_y,index_x)=block_of_bike(index_y,index_x)+1; %index_y是第几行 从下往上数。index是第几列 从左往右数
end
%以上得到了将整个区域分块后每个小块里面的车数量。
%对每个区块设置总体放的停车点数目，一个停车点能接纳的车数：这里取40
stop_num=zeros(17,21);
for j=1:17
    for k=1:21
        if(block_of_bike(j,k)/40<2)
            stop_num(j,k)=ceil(block_of_bike(j,k)/40);
        else
            stop_num(j,k)=round(block_of_bike(j,k)/40);
        end
    end
end
%梯度下降 这里选择block_of_bike(12,7)的车 index_x=7,index_y=12 经纬度上的坐标和矩阵是相反的 
%共有287辆 设立7个停车点 首先把这些点的坐标存到另外的矩阵中
A=[];j=0;
for i=1:70724
    index_y=ceil((data(i,1)-bottom_right_y)/vertical_step);
    index_x=ceil((data(i,2)-top_left_x)/horizon_step);
    if(index_x==7&&index_y==12)
        j=j+1;
        A(j,1)=data(i,1);
        A(j,2)=data(i,2);
    end
end
%梯度下降算法 对该方块再进行100划分 随机取其中的7个点作为停车点(方块中心） 计算所有车到最近一个点的曼哈顿距离之和
%调整一个点 共有28种调整方式（每一个点都能有四种移动方式） 找其中最好的一种作为调整  这样一直循环至无法调整。
stop_points=zeros(7,2);%7个停车点经纬度
start_x=6*horizon_step+top_left_x;
end_x=7*horizon_step+top_left_x;
start_y=11*vertical_step+bottom_right_y;
end_y=12*vertical_step+bottom_right_y;
random=randi([0,100],7,1);
step_x=horizon_step/10;
step_y=vertical_step/10;
for i=1:7
    stop_points(i,2)=(mod(random(i,1),10)-0.5)*step_x+start_x;
    stop_points(i,1)=floor((random(i,1)-1)/10)*step_y+0.5*step_y+start_y;
end
%得到了经纬度.
total_dist=0;

for j=1:287  %开始计算每个点的曼哈顿距离和所有点的总距离 注意由于杭州在北纬30度左右 经度之差要乘以一个系数 我们希望在调整后总距离最小
    min=abs(A(j,1)-stop_points(1,1))*0.866+abs(A(j,2)-stop_points(1,2));
    for i=1:7
        if(min>abs(A(j,1)-stop_points(i,1))*0.866+abs(A(j,2)-stop_points(i,2)))
            min=abs(A(j,1)-stop_points(i,1))*0.866+abs(A(j,2)-stop_points(i,2));
        end
    end
    total_dist=total_dist+min;
end
begin_dist=total_dist;
final_dist=total_dist;
%调整： 用record来记录最佳的调整
adjust_times=0;%调整次数
while (1)
    temp=final_dist;%先记录调整之前的final_dist，如果调整后没有变化 则break
    for i=1:7 %对7个点进行调整
        if(stop_points(i,1)+step_y<end_y) %向上
           stop_points(i,1)=stop_points(i,1)+step_y;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=1;
           end
            stop_points(i,1)=stop_points(i,1)-step_y;%复位
        end
        if(stop_points(i,1)-step_y>start_y) %向下
           stop_points(i,1)=stop_points(i,1)-step_y;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=2;
           end
           stop_points(i,1)=stop_points(i,1)+step_y;%复位
        end
        if(stop_points(i,2)-step_x>start_x) %向左
           stop_points(i,2)=stop_points(i,2)-step_x;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=3;
           end
           stop_points(i,2)=stop_points(i,2)+step_x;%复位
        end
        if(stop_points(i,2)+step_x>start_x) %向右
           stop_points(i,2)=stop_points(i,2)+step_x;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=4;
           end
           stop_points(i,2)=stop_points(i,2)-step_x;%复位
        end
    end
    adjust_times=adjust_times+1;
    if(final_dist<temp)%说明进行了调整
        if(record2==1)
            stop_points(record1,1)=stop_points(record1,1)+step_y;
        elseif(record2==2)
            stop_points(record1,1)=stop_points(record1,1)-step_y;
        elseif(record2==3)
            stop_points(record1,2)=stop_points(record1,2)-step_x;
        elseif(record2==4)
            stop_points(record1,2)=stop_points(record1,2)+step_x;
        end
    else 
        break; %没有调整
    end
        
end

