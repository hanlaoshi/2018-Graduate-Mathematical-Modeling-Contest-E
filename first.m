clear all
clc

A=xlsread('data');
a=A(:,2);
b=A(:,3);
c=A(:,4);
% p2=[66594	67518	7280];%假目标终点坐标
% p1=[65646	68253	7500];%假目标始点坐标
q=[80000 0 0;30000 60000 0;55000 110000 0;105000 110000 0;130000 60000 0];%雷达坐标
x1=[];
y1=[];
M=zeros(19,20);
for e = 1:5
    for h =1:20
    plot3(a(h),b(h),c(h),'r*','MarkerSize',5);
%     text(data(j,2)+18,data(j,3)+18,data(j,4)+8,num2str(j));
    plot3(q(e,1),q(e,2),q(e,3),'rp','MarkerSize',10);
    text(q(e,1)+22,q(e,2)+22,q(e,3)+22,num2str(e));
    x11 = [q(e,1),a(h)];
    x12 = [q(e,2),b(h)];
    x13 = [q(e,3);c(h)];
    if e == 1
        plot3(x11,x12,x13,'y-','MarkerSize',4);
        hold on;
    end
    if e == 2
        plot3(x11,x12,x13,'g-','MarkerSize',4);
        hold on;
    end
    if e == 3
        plot3(x11,x12,x13,'b-','MarkerSize',4);
        hold on;
    end
    if e == 4
        plot3(x11,x12,x13,'c-','MarkerSize',4);
        hold on;
    end
    if e == 5
        plot3(x11,x12,x13,'k-','MarkerSize',4);
        hold on;
    end
    grid on;
    end

end   


for i=1:19
    for j=i+1:20
        p1=[a(i),b(i),c(i)];
        p2=[a(j),b(j),c(j)];
        for k=1:5
            x1(k)=(2500-q(k,3))/(q(k,3)-p1(3))*(q(k,1)-p1(1))+q(k,1);%高度取2500，截得的坐标
            y1(k)=(2500-q(k,3))/(q(k,3)-p1(3))*(q(k,2)-p1(2))+q(k,2);
        end
    x2=[];
    y2=[];
       for k=1:5
           x2(k)=(2500-q(k,3))/(q(k,3)-p2(3))*(q(k,1)-p2(1))+q(k,1);
           y2(k)=(2500-q(k,3))/(q(k,3)-p2(3))*(q(k,2)-p2(2))+q(k,2);
       end
   sum=0; 
   X1 = [];
   X2 = [];
   Y1 = [];
   Y2 = [];
       for k=1:5
           for m=1:5
               d(k,m)=sqrt((x1(k)-x2(m))^2+(y1(k)-y2(m))^2);%距离
               if (j-i)*100/3*10<d(k,m) && (j-i)*50*10>d(k,m)
                   v = d(k,m)/((j-i)*10);  %把符合距离的速度算出来
                   X1(k,i)=x1(k);
                   Y1(k,i)=y1(k);
                   X2(m,j)=x2(m);
                   Y2(m,j)=y2(m);
                   sum=sum+1;
                   x21 =  [X1(k,i),X2(m,j)];
                   x22 =  [Y1(k,i),Y2(m,j)];
                   x23 =  [2500,2500];
                   plot3(x21,x22,x23,'r-','MarkerSize',7)
                   hold on;
                  
                   theta = atand((Y2(m,j)-Y1(k,i))/(X2(m,j)-X1(k,i)));
%                    theta = acos(d(k,m)/(X2(m,j)-X1(k,i)));
                   V_level = v *cosd(theta); %水平速度
                   V_ver = v *sind(theta);   %垂直速度
                   for g = 0:19    %每条航线的20个坐标值
                       D_level = X1(k,i)+(V_level*10*g);  %水平方向的水平坐标
                       D_ver = Y1(k,i)+(V_ver*10*g);     %竖直方向的坐标
                       fp=fopen('airline_axis_2.txt','a');
                       fprintf(fp,'%6.1f    %6.1f    %d    %3.1f \r\n',D_level,D_ver,2500,theta); %输出的txt文档顺序
                       fclose(fp);

                   end
                   fp=fopen('airline_axis_2.txt','a');
                   fprintf(fp,'%s \r\n','--------'); %做个标记隔开来
                   fclose(fp);
%                    disp(i)
%                    disp(j)
%                    disp(k)
%                    disp(m)
%                    
%                    disp("----------")
                   fp=fopen('new_zuobiao_123.txt','a');
                   fprintf(fp,'%d   %d  %d  %d  %3.1f  %6.1f  %6.1f  %6.1f  %6.1f\r\n',i,j,k,m,v, X1(k,i),Y1(k,i),X2(m,j),Y2(m,j)); %输出的txt文档顺序
                   fclose(fp);
  %                 i
%                    j
%                    k
%                    m

               end
           end
       end
               C(i,j)=sum;
               
    end
   
end

%  xlswrite('new_test.xlsx',C)