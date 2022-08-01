% SBT646 HW3 %
% Image processing of a free falling ball %
% Aslı Alpsoy %
clear;clc;close all;
%% read the images and form time vector
folder='C:\Users\aslıı\Documents\MATLAB\SBT646\image\TopSerbestDusme' ; 
img=dir(fullfile(folder,'*.jpg'));
for k=1:numel(img)
  filename=fullfile(folder,img(k).name);
  I{k}=im2gray(imread(filename));
end
fps=50;
dt=1/fps;
N=numel(I)-1;
tf=N/fps;
t=linspace(0,tf,N);
%% calibration
% from hand calculation
horz=52;  % horizontal distance btw calibration markers,pixels
vert=138; % vertical distance btw calibration markers,pixels
realhorz=.6; realvert=1;  %m
%below is an approximation, needs to be improved
    % cal=cell2mat(I(1));
    % [r,c] = find(cal == 255);
    % horz=max(c)-min(c);
    % vert=max(r)-min(r);
sx=realhorz/horz;
sy=realvert/vert;
%% find the approximate centers 
% below is an approximation, needs to be improved
%   for i=1:numel(img)-1
%   a=cell2mat(I(i+1));
%   [rows, cols] = find(a == 255); % a>255/2 daha makul mü olurdu?
%   cr(i)=median(sort(rows));
%   cc(i)=median(sort(cols));t
%   end
  for i=1:numel(img)-1
  a=cell2mat(I(i+1));
  IB = imbinarize(a,0.5);  % a>255/2 daha makul mü olurdu?
  stats(i) = regionprops(IB,'basic');
  end
     centers = [stats.Centroid];
     c=centers(:,2:2:end);
  %% vertical position, velocity and acceleration of the ball in meters
 P=-c.*sy; % position,m
%   P_sgolay = sgolayfilt(P,2,5); %order ve framelength nasıl belirleniyor
 P_sgolay = smoothdata(P,'sgolay'); % this gives better results
 V=centdiff(P_sgolay,N,dt); %central difference method  
 A=seccentdiff(P_sgolay,N,dt);  
 %% analytic solution
 y_0=-0.2029; %m
 v_0=0;
 g=-9.81* ones(1, length(t)); % m/s^2
 y=(1/2)*g.*t.^2+y_0;
 v=g.*t+v_0;
%% plots
figure
 plot(t,P); hold on; plot(t,y)
 xlabel('Time(s)');ylabel('Vertical Position (m)')
 legend('Mocap Analysis','Analytic Solution')
 title('Vertical Position vs Time')
figure
 plot(t,V); hold on; plot(t,v)
 xlabel('Time(s)');ylabel('Vertical Velocity (m/s)')
  legend('Mocap Analysis','Analytic Solution')
   title('Vertical Velocity vs Time')
figure
 plot(t,A); hold on; plot(t,g,'r')
 xlabel('Time(s)');ylabel('Vertical Acceleration (m/s^2)')
  legend('Mocap Analysis','Analytic Solution')
 title('Vertical Acceleration vs Time')
 
 %% functions used
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
