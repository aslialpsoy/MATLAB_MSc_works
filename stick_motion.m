% Rotational motion around a moving center of mass%
%%--Aslı Alpsoy--%%
clear;clc;close all;
%% İnitial Values
m = 0.5; % kg
g = [0 -9.8 0]; % m/sˆ2
h0 = 4.0; % m 
L = 1.0; % m 
tf = 10; % s
dt = 0.001; % s 
k = 1000.0; % N/m 
v0 = 2.0; % m/s
I = (1.0/12.0)*m*L^2;
n = ceil(tf/dt);
p_cm = zeros(n,3); 
v = zeros(n,3); 
theta = zeros(n,1); 
omega = zeros(n,1);
theta(1) = pi*0.5*rand(1); % Initial angle (random) of the stick
p_cm(1,:)=[0 h0  0];
v(1,1)=v0;
t=linspace(0,tf,n)';
n_a=zeros(n,3); %ground force at A
n_b=zeros(n,3); %ground force at B
e_tot=zeros(n,1); %total energy
%% integration
for i=1:n
    p_a(i,:)=p_cm(i,:)-(L/2)*[cos(theta(i)) sin(theta(i)) 0]; %left end coordinates
    p_b(i,:)=p_cm(i,:)+(L/2)*[cos(theta(i)) sin(theta(i)) 0]; %right end coordinates
if p_a(i,2)<=0
   n_a(i,2)=-k*p_a(i,2);
   p_spra(i)=0.5*k*(p_a(i,2)^2); %spring potential energy at A
else
   n_a(i,2)=0;
   p_spra(i)=0;
end 
if p_b(i,2)<=0
   n_b(i,2)=-k*p_b(i,2);
   p_sprb(i)=0.5*k*(p_b(i,2)^2); %spring potential energy at B
else
   n_b(i,2)=0;
   p_sprb(i)=0;
end 
fnet(i,:)=m*g+n_a(i,:)+n_b(i,:); %total force
tnet(i,:)=cross((p_a(i,:)-p_cm(i,:)),n_a(i,:))+cross((p_b(i,:)-p_cm(i,:)),n_b(i,:)); %total torque
a = fnet/m;
% integration steps
v(i+1,:) = v(i,:) + a(i,:)*dt;
p_cm(i+1,:) = p_cm(i,:) + v(i+1,:)*dt;
alphaz(i) = tnet(i,3)'/I;
omega(i+1) = omega(i) + alphaz(i)*dt;
theta(i+1) = theta(i) + omega(i+1)*dt;

% calculate the energies
p_grav(i)=-m*g(2).*(p_cm(i,2)); %potential energy
k_lin(i)=0.5*m.*(v(i,1).^2+v(i,2).^2); %linear kinetic energy
k_ang(i)=0.5*I*(omega(i)^2);    %angular kinetic energy
p_spr(i)=p_spra(i)+p_sprb(i);  %spring potential energy 
e_tot(i)=(p_grav(i)+p_spr(i)+k_lin(i)+k_ang(i))'; %total energy

if (mod(i,20)==0)
            % Plot position of rod, with tracer
            xl = [p_b(i,1) p_a(i,1)];
            yl = [p_b(i,2) p_a(i,2)]; 
            subplot(4,2,[1,2]);
            plot(p_cm(1:i,1),p_cm(1:i,2),':'),hold on;
            plot(xl,yl,'-','LineWidth',3);
            plot((0:n-1),zeros(n,1)','-','LineWidth',1) 
            hold off;
            xlabel('x [m]');ylabel('y [m]');
            axis equal
            axis([0 20 0-L/2 4+L/2]);
            subplot(4,2,3);
            plot(p_cm(1:i,1),p_grav(1:i));ylim([0 20]);xlim([0 20]);
            title('Potential Energy due to Gravity')
            ylabel('[kg.m^2/s^2]')
            subplot(4,2,4);
            plot(p_cm(1:i,1),p_spr(1:i)); ylim([0 20]);xlim([0 20]);
            title('Potential Energy due to Spring')
            ylabel('[kg.m^2/s^2]')
            subplot(4,2,5);
            plot(p_cm(1:i,1),k_lin(1:i)); ylim([0 20]);xlim([0 20]);
            title('Kinetic Energy due to Lienar Motion')
            ylabel('[kg.m^2/s^2]')
            subplot(4,2,6);
            plot(p_cm(1:i,1),k_ang(1:i)); ylim([0 20]);xlim([0 20]);
            title('Kinetic Energy due to Angular Motion')
            ylabel('[kg.m^2/s^2]')
            subplot(4,2,[7,8]);
            plot(p_cm(1:i,1),e_tot(1:i)); ylim([15 25]); xlim([0 20]);
            title('Total Energy')
            ylabel('[kg.m^2/s^2]')
            drawnow 
end
end