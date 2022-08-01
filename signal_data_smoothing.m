%% signal
clear;clc;close;
S=importdata('BilgSinyal.mat');
Sdata=S.data;
S_acc=S.acc;
Sdt=S.dt;
St=S.t;
SN=length(Sdata);
Sfps=S.FrameRate;
SdataV=centdiff(Sdata,SN,Sdt);
SdataA=seccentdiff(Sdata,SN,Sdt);
%Kayan Ortalama (3, 5 noktalı) ile hız ve ivme hesabı:
Sdata3 = movmean(Sdata,3,1);
Sdata_V3 = centdiff(Sdata3,SN,Sdt)';
Sdata_A3 = seccentdiff(Sdata3,SN,Sdt)';

Sdata5 = movmean(Sdata,5,1);
Sdata_V5 = centdiff(Sdata5(:,1),SN,Sdt)';
Sdata_A5 = seccentdiff(Sdata5(:,1),SN,Sdt)';
%Eğri Oturtma (Polinom ve Cubic Spline)ile hız ve ivme hesabı:
Spol = polyfit(St,Sdata,5);
Spol_V = polyder(Spol);
Spol_A = polyder(Spol_V);
Sdata_Vp = polyval(Spol_V,St);
Sdata_Ap = polyval(Spol_A,St);
Sdatap = polyval(Spol,St);

Sdatas = spline(St,Sdata,St);
Sdata_Vs = centdiff(Sdatas,SN,Sdt);
Sdata_As = seccentdiff(Sdatas,SN,Sdt);
%Butterworth Sayısal Filtre ile hız ve ivme hesabı:
Sfc = 50;
Sfs = S.FrameRate;
[Sb,Sa] = butter(4,Sfc/(Sfs/2));
Sdatab=filtfilt(Sb,Sa,Sdata);
Sdata_Vb = centdiff(Sdatab,SN,Sdt)';
Sdata_Ab = seccentdiff(Sdatab,SN,Sdt)';
%% Plots
figure % position
plot(St,Sdata,'c','linewidth',7); hold on ;
plot(St,Sdata3,'y','linewidth',5);
plot(St,Sdata5,'b','linewidth',2);  
plot(St,Sdatap,'mo');
plot(St,Sdatas,'k.','linewidth',15);
plot(St,Sdatab,'r--','linewidth',1.5);
legend('Original','MovAvg3','MovAvg5','Polyfit-5d','Spline','Butterworth')
title('Comparison of Smoothing Methods for Position- Bilgsignal')

figure % velocity
plot(St,SdataV,'c','linewidth',7); hold on ;
plot(St,Sdata_V3,'y','linewidth',5);
plot(St,Sdata_V5(:,1),'b','linewidth',2);
plot(St,Sdata_Vp,'mo');
plot(St,Sdata_Vs,'k.','linewidth',15);
plot(St,Sdata_Vb,'r--','linewidth',1.5);
legend('Original','MovAvg3','MovAvg5','Polyfit-5d','Spline','Butterworth')
title('Comparison of Smoothing Methods for Velocity- Bilgsignal')

figure % acceleration
plot(St,SdataA,'c','linewidth',7); hold on ;
plot(St,Sdata_A3,'y','linewidth',5);
plot(St,Sdata_A5,'b','linewidth',2);
plot(St,Sdata_Ap,'mo');
plot(St,Sdata_As,'k.','linewidth',15);
plot(St,Sdata_Ab,'r--','linewidth',1.5);
plot(St,S_acc,'m-.','linewidth',2);
legend('Original','MovAvg3','MovAvg5','Polyfit-5d','Spline','Butterworth','pre-Filtered')
title('Comparison of Smoothing Methods for Acceleration- Bilgsignal')

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