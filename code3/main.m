fid1=fopen('20180506-145929-ofo.csv');%���������������Ҫʹ�õ��ļ� ��������ʱ�Ρ�
fid2=fopen('20180506-160217-ofo.csv');
data1=textscan(fid1,'%s %s %f %f','delimiter',',');
data2=textscan(fid2,'%s %s %f %f','delimiter',',');
sigma=0.25;
u=0.5;
name1=data1{1,2};
name2=data2{1,2}; %�õ����ź����name1,name2
num1=length(name1);
num2=length(name2);
total_dist=dist(data1,data2);
total_dist_km=total_dist*111;%һγ�ȴ���111ǧ�� ���ȵĻ� ֮ǰ�Ѿ����˸���3 /2
average=total_dist_km*2/(num1+num2);%ƽ����ÿһ������


