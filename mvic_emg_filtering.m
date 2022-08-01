clear;clc;close all;
%% import data
W=importdata('asli_mvic.mat');
mvic(:,1)=W.emg_veri1; % emg1-flexor muscles
mvic(:,2)=W.emg_veri2; % emg2-extensor muscles
mvic(:,3)=W.kuvvet_veri;    % force 
N=size(mvic,1); % signal length
fs=1000;  %sampling frequency Hz
tmax=floor(N/fs); % seconds
t=linspace(0,tmax,N)';
% plot(t,mvic(:,1))
% figure;plot(t,mvic(:,2))
% figure;plot(t,mvic(:,3))
mvic(:,1:2)=detrend(mvic(:,1:2));
%% residual analysis to determine cutoff frequency
% 4th order zero-lag low-pass digital filter
f_cut(1)=analizeresidual(fs,mvic(:,1));
f_cut(2)=analizeresidual(fs,mvic(:,2));
f_cut(3)=analizeresidual(fs,mvic(:,3));
%% frequency domain
f = fs*(0:(N/2))/N; % FFT frequency range
mvic_freq=fft(mvic); % two-sided spectrum
figure('WindowState','maximized');
for i=1:3
P2(:,i) = abs(mvic_freq(:,i)/N); %normalisation of the power of the output for the length of the input signal
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
mvic_filt(:,j)=filtfilt(b,a,mvic(:,j));
subplot(3,1,j)
plot(t,mvic(:,j),'k');hold on;plot(t,mvic_filt(:,j),'c')
end
lgd2=legend('raw data','filtered data','Location','northwest');
set(lgd2,'Position',[0.055 0.95 0 0]);
%% rectification and RMS envelope detection
figure('WindowState','maximized');
window=500;
for k=1:3
mvic_filt_abs(:,k)=abs(mvic_filt(:,k));
mvic_abs(:,k)=abs(mvic(:,k));
subplot(3,1,k)
plot(t,mvic_abs(:,k),'m');hold on
plot(t,mvic_filt_abs(:,k),'g')
% [up(:,k),lo(:,k)] = envelope(mvic_filt_abs(:,k),50,'rms'); % sıfır değerler 5 e çıktı
% plot(t,up(:,k),'k')
envelope(:,k)=sqrt(movmean(mvic_filt_abs(:,k).^2,window));
plot(t,envelope(:,k),'k')
end
lgd3=legend('rectified raw data','filtered rectified data','RMS envelope','Location','northwest');
set(lgd3,'Position',[0.055 0.95 0 0]);

%% normalization to max flexion and extension

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





