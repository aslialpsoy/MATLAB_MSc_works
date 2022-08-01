% Benchpress Kinematics- Aslı Alpsoy %
clear;clc;close;
%% read the data
B=readmatrix('Bench_Odev_Veri.xlsx');
X=B(:,2);
t=B(:,1);
N=size(B,1);
dt=B(2,1)-B(1,1);
m=30; % benchpress kg
%% taking derivatives 
V=centdiff(X,N,dt)';
A=seccentdiff(X,N,dt)';
%% determine the force, work & power 
F= m*A; %force
dX= X-X(1); %displacement
W= F.*dX; %work
P= centdiff(W,N,dt)'; %power
%% plots
figure('WindowState','maximized');
subplot(3,2,1);plot(t,X,'k') 
title('Vertical position vs Time');ylabel('Position(m)')
subplot(3,2,2);plot(t,V,'r');
title('Vertical velocity vs time');ylabel('Velocity(m/s)')
subplot(3,2,3);plot(t,A,'c')
title('Vertical acceleration vs time');ylabel('Acceleration(m/s^2)')
subplot(3,2,4);plot(t,F,'m')
title('Force applied vs time');ylabel('Force(N)')
subplot(3,2,5);plot(t,W,'b')
title('Work Done vs time');xlabel('Time(s)');ylabel('Work(J)')
subplot(3,2,6);plot(t,P,'g')
title('Power vs time');xlabel('Time(s)');ylabel('Power(W)')

%% functions
function v=centdiff(x,N,dt)
% centdiff function uses central difference method to find the first
% derivative of a column vector
[r,c]=size(x);
v=zeros(c,r);
for i=2:N-1
    v(i)= (x(i+1)-x(i-1))/(2*dt);
end
v(1)=(x(2)-x(1))/dt;
v(N)=(x(N)-x(N-1))/dt;
end
function a=seccentdiff(x,N,dt)
% seccentdiff function uses central difference method to find the second
% derivative of a column vector
[r,c]=size(x);
a=zeros(c,r);
for i=2:N-1
    a(i)= (x(i+1)-2*x(i)+x(i-1))/(dt^2);
end
a(1)=(x(3)-2*x(2)+x(1))/(dt^2);
a(N)=(x(N)-2*x(N-1)+x(N-2))/(dt^2);
end