T=2;
mu=0.5;sigma=0.25;
syms t;
%g(t)=0.07*t-0.627;%...
g(t)=0.0008*t.^3-0.0305*t.^2+0.4373*t-2.057;
u=zeros(701,1);
for i=1:701
    t=9+0.01*(i-1);
    u(i)=0.5-g(t)+g(floor((t-9)/T)*T+9);
end 
rate=zeros(701,1);
num_available=zeros(701,1);
aver_avail=0;
for i=1:701
    rate(i)=1-normcdf(0.2,u(i),sigma);
    num_available(i)=70000*rate(i);
    aver_avail=aver_avail+num_available(i);
end
x=9:0.01:16;
%plot(x,rate);
score=zeros(701,1);%用户满意度
average_score=0;
for i=1:701
    a=rate(i);
    score(i)=100*a+a*(1-a)*80+60*a*(1-a)^2;
    average_score=average_score+score(i);
end
average_score=average_score/701;
%考虑收入的问题
k=10000;
aver_avail=aver_avail/701;
income=aver_avail-k/T;

assess=income*average_score;