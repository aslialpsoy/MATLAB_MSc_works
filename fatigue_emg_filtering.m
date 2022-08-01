clear;clc;close all;
%% import data
W=importdata('asli_tukenme_1.mat');
fatigue(:,1)=W.emg_veri1; % emg1-flexor muscles
fatigue(:,2)=W.emg_veri2; % emg2-extensor muscles
fatigue(:,3)=W.kuvvet_veri;    % force 
N=size(fatigue,1); % signal length
fs=1000;  %sampling frequency Hz
tmax=floor(N/fs); % seconds
t=linspace(0,tmax,N)';
% plot(t,mvic(:,1))
% figure;plot(t,mvic(:,2))
% figure;plot(t,mvic(:,3))
fatigue(:,1:2)=detrend(fatigue(:,1:2));
%% residual analysis to determine cutoff frequency
% 4th order zero-lag low-pass digital filter
f_cut(1)=analizeresidual(fs,fatigue(:,1));
f_cut(2)=analizeresidual(fs,fatigue(:,2));
f_cut(3)=analizeresidual(fs,fatigue(:,3));
%% frequency domain
f = fs*(0:(N/2))/N; % FFT frequency range
fatigue_freq=fft(fatigue); % two-sided spectrum
figure('WindowState','maximized');
for i=1:3
P2(:,i) = abs(fatigue_freq(:,i)/N); %normalisation of the power of the output for the length of the input signal
P1(:,i) = P2(1:N/2+1,i);
P1(2:end-1,i) = 2*P1(2:end-1,i);
subplot(3,1,i)
plot(f,P1(:,i),'m')
hold on
xline(f_cut(i),'k')
end
lgd=legend('Signal','Cutoff Frequency','Location','northwest');
set(lgd,'Position',[0.055 0.95 0 0]);
%% Butterworth filtered data
figure('WindowState','maximized');
for j=1:3
[b,a] = butter(6,f_cut(j)/(fs/2),'low');
fatigue_filt(:,j)=filtfilt(b,a,fatigue(:,j));
subplot(3,1,j)
plot(t,fatigue(:,j),'k');hold on;plot(t,fatigue_filt(:,j),'c')
end
lgd2=legend('raw data','filtered data','Location','northwest');
set(lgd2,'Position',[0.055 0.95 0 0]);
%% rectification and RMS envelope detection
figure('WindowState','maximized');
window=500;
for k=1:3
fatigue_filt_abs(:,k)=abs(fatigue_filt(:,k));
fatigue_abs(:,k)=abs(fatigue(:,k));
subplot(3,1,k)
plot(t,fatigue_abs(:,k),'m');hold on
plot(t,fatigue_filt_abs(:,k),'g')
envelope(:,k)=sqrt(movmean(fatigue_filt_abs(:,k).^2,window));
plot(t,envelope(:,k),'k')
end
lgd3=legend('rectified raw data','filtered rectified data','RMS envelope','Location','northwest');
set(lgd3,'Position',[0.055 0.95 0 0]);
%% frequency analysis 
% ff=spectrogram(fatigue_filt_abs(:,3));
% spectrogram(fatigue_filt_abs(:,3),'yaxis')
% z = hilbert(fatigue_filt_abs(:,3));
% ff = angle(z(2:end).*conj(z(1:end-1))).*(fs / (2*pi));
% figure;plot(t,ff)
% dt=1/fs;
% turev=(centdiff(fatigue_filt_abs(:,3),N,dt))';
% % figure;plot(t,turev)
% for ll=1:N
% if turev(:,ll)==0
%     g(ll)=turev(:,ll);
% end
% end
%% functions
function f_cut=analizeresidual(fs,raw)
% residual analysis to determine cutoff frequency of butterworth lowpass
% filter
% fs: sampling freq
% raw:raw data
N= size(raw,1); % number of sample points
f_cb=ceil(fs/3); % beginning cutoff frequency
f_ce=ceil(fs/2-5); % ending cutoff frequency
for j=1:f_ce
    fc(j)=j;
    [b,a] = butter(4,fc(j)/(fs/2));
    filtered(:,j)=filtfilt(b,a,raw); %4th order zero-lag filtered data
    for i=1:N
    d(i,j)=(raw(i,1)-filtered(i,j)).^2;
    end
    summ(1,j)=sum(d(:,j));
    R(1,j)=sqrt(summ(1,j)/N);
end
vq = interp1([f_cb ,f_ce ],[R(f_cb), R(f_ce)],1,'linear','extrap');
[d, f_cut] = min( abs( R-vq ) );
end
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





