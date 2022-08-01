%walking colors%
%Aslı Alpsoy
clear;clc;close all
a=-10;b=10;  % end ranges 
p=[0 ;0; 0]; % initial position
for j=[1 2 3 4 5 6]
    c=["red" "green" "blue" "cyan" "magenta" "black"];%color codes
    %1:red 2:green 3:blue 4:cyan 5:magenta 6:black
    for i=1:50 
        grid on
        h=plot3(p(1),p(2),p(3),'o','Color',c(j),'MarkerFaceColor',c(j)); 
        hold on
        r=a +(b-a)*rand(3,1);%random x-y-z coordinates in (a,b)
        p=p+r; %take the step              
    end
end