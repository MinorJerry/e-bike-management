block_of_bike=zeros(17,21);
top_left_x=120.058432;
top_left_y=30.331886;
bottom_right_x=120.284086;
bottom_right_y=30.187395;
horizon_diff=bottom_right_x-top_left_x;%����ѡȡ���ݵ�ˮƽ���Ȳ�
vertical_diff=top_left_y-bottom_right_y;%��ֱ����γ�Ȳ�
horizon_step=horizon_diff/21;
vertical_step=vertical_diff/17;
data=csvread('20180504-104057-ofo.csv',0,2);
for i=1:70724
    index_y=ceil((data(i,1)-bottom_right_y)/vertical_step);%Ӧ������ȡ��
    index_x=ceil((data(i,2)-top_left_x)/horizon_step); %�����е�һ����γ�ȣ��ڶ����Ǿ���
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
    block_of_bike(index_y,index_x)=block_of_bike(index_y,index_x)+1; %index_y�ǵڼ��� ������������index�ǵڼ��� ����������
end
%���ϵõ��˽���������ֿ��ÿ��С������ĳ�������
%��ÿ��������������ŵ�ͣ������Ŀ��һ��ͣ�����ܽ��ɵĳ���������ȡ40
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
%�ݶ��½� ����ѡ��block_of_bike(12,7)�ĳ� index_x=7,index_y=12 ��γ���ϵ�����;������෴�� 
%����287�� ����7��ͣ���� ���Ȱ���Щ�������浽����ľ�����
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
%�ݶ��½��㷨 �Ը÷����ٽ���100���� ���ȡ���е�7������Ϊͣ����(�������ģ� �������г������һ����������پ���֮��
%����һ���� ����28�ֵ�����ʽ��ÿһ���㶼���������ƶ���ʽ�� ��������õ�һ����Ϊ����  ����һֱѭ�����޷�������
stop_points=zeros(7,2);%7��ͣ���㾭γ��
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
%�õ��˾�γ��.
total_dist=0;

for j=1:287  %��ʼ����ÿ����������پ�������е���ܾ��� ע�����ں����ڱ�γ30������ ����֮��Ҫ����һ��ϵ�� ����ϣ���ڵ������ܾ�����С
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
%������ ��record����¼��ѵĵ���
adjust_times=0;%��������
while (1)
    temp=final_dist;%�ȼ�¼����֮ǰ��final_dist�����������û�б仯 ��break
    for i=1:7 %��7������е���
        if(stop_points(i,1)+step_y<end_y) %����
           stop_points(i,1)=stop_points(i,1)+step_y;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=1;
           end
            stop_points(i,1)=stop_points(i,1)-step_y;%��λ
        end
        if(stop_points(i,1)-step_y>start_y) %����
           stop_points(i,1)=stop_points(i,1)-step_y;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=2;
           end
           stop_points(i,1)=stop_points(i,1)+step_y;%��λ
        end
        if(stop_points(i,2)-step_x>start_x) %����
           stop_points(i,2)=stop_points(i,2)-step_x;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=3;
           end
           stop_points(i,2)=stop_points(i,2)+step_x;%��λ
        end
        if(stop_points(i,2)+step_x>start_x) %����
           stop_points(i,2)=stop_points(i,2)+step_x;
           total_dist=Manhattan(A,stop_points);
           if(total_dist<final_dist)
               final_dist=total_dist;
               record1=i;record2=4;
           end
           stop_points(i,2)=stop_points(i,2)-step_x;%��λ
        end
    end
    adjust_times=adjust_times+1;
    if(final_dist<temp)%˵�������˵���
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
        break; %û�е���
    end
        
end

