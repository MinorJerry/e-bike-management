function total_dist=Manhattan(A,stop_points)%给点经纬度的点和停车点 算Manhattan距离之和
total_dist=0;
for j=1:287  
    min=abs(A(j,1)-stop_points(1,1))*0.866+abs(A(j,2)-stop_points(1,2));
    for i=1:7
        if(min>abs(A(j,1)-stop_points(i,1))*0.866+abs(A(j,2)-stop_points(i,2)))
            min=abs(A(j,1)-stop_points(i,1))*0.866+abs(A(j,2)-stop_points(i,2));
        end
    end
    total_dist=total_dist+min;
end