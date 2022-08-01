function collisiondetection(N,L,nt,dt,it)
% Aslı Alpsoy
% This function forms a L-by-L square and places N non-colliding particles
% with random radii. Assigns random mass and initial velocity to each
% particle and calculates the post collision velocities. Plots the motion
% of the particles simultaneously.Collisions are assumed to be elastic.
% The inputs:
% N: number of particles between 1-6
% L: length of the square
% nt: number of time steps,for example 10000 
% dt: time step,for example 0.0002
% it: number of iterations between two plots, for example 50
%% initializing the particles
r=0.1+rand(1,N);  % radius vector, 0.1 is added to prevent the huge differences btw radii, it can be omitted 
m=pi*r.^2;    % mass vector
P=zeros(2,N); % position matrix preallocation
V=zeros(2,N); % velocity matrix preallocation
theta=0:pi/20:2*pi;
x=zeros(numel(theta),N); % used for drawing circles with known center position and radius,preallocation
y=zeros(numel(theta),N); % used for drawing circles with known center position and radius,preallocation
a=-L+max(r); % a and b used for initial position and velocity it is guaranteed... 
b=L-max(r);  % that no circle is positioned beyond the limits of the box 
c=['m','b','g','r','k','y']; % colors for circles, should be modified if N>6
%% Setting random positions and velocities
for i=1:N
    valid=0;    
    P(:,i)= a +(b-a).*rand(2,1); %random initial position
    while valid==0
        ok=0;
        for j=1:i-1
            if norm(P(:,j)-P(:,i))<=r(1,i)+r(1,j) % making sure that the circles don't overlap
                P(:,i)= a +(b-a).*rand(2,1);
                ok=1;
                break
            end
        end
        if ok==0
            valid=1;
        end      
    end
    V(:,i)=5*(a +(b-a).*rand(2,1)); %random initial velocity
end
%% Collision detection
 for T=0:nt
     P=P+dt.*V; % moving the circles 
     V=wallcollision(N,P,r,L,V);
     [ro,co]=colldetect(N,r,P); 
     V=postcollision(V,ro,co,m);      
  if T==it*ceil(T/it)
         clf
         hold on
         axis equal
         for l=1:N      
              x=P(1,l)+r(l)*cos(theta);
              y=P(2,l)+r(l)*sin(theta);
              plot(x,y,c(l))
              fill(x,y,c(l))
         end
        plotdomain(L)
        title(T*dt)
        drawnow
        pause(0.01)
  end 
 end

function plotdomain(L)
    xlim([-L L])
    ylim([-L L])
    rectangle('Position',[-L,-L,2*L,2*L],'LineWidth',1.5,'EdgeColor','k')
 end
function [ro,co]=colldetect(N,r,P) 
% the function colldetect detects the collisions between the circles
% the inputs are:
% N:number of particles, r:radius,P: x&y position of the center
% the outputs are ro and co values.ro(i) and co(i) denotes a pair of colliding particles
    Dx=zeros(N,N); % x positions of the center of the circles,preallocation
    Dy=zeros(N,N); % y positions of the center of the circles,preallocation
    Dr=zeros(N,N); % sum of radii of the circles,preallocation
for ii=1:N %calculates the distance btw particles' centers
    Dx(ii,:)=P(1,ii)-P(1,:); % distance along x for each pair of circles
    Dy(ii,:)=P(2,ii)-P(2,:); % distance along y for each pair of circles 
    Dr(ii,:)=(r(1,ii)+r(1,:)); % sum of each pair of radii
end
    Dx=triu(Dx); % Dx,Dy and Dr are symmetric matrices. by taking the upper 
    Dy=triu(Dy); % triangle of each, the repeated data are eliminated
    Dr=triu(Dr,1);  
    D=sqrt(Dx.^2+Dy.^2); % distance btw center of two circles
    col=D-Dr;    % if D is less than Dr, the particles are colliding
    [ro,co]=find(col<0); % gives pair of colliding circles

end  
function V=postcollision(V,ro,co,m)
% the function postcollision calculates velocities after collision btw
% circles using conservation of momentum and conservation of energy
% laws.The derivation of eqns are presented in the report
% the inputs are: 
% V=velocity of the circle, ro&co: pair of colliding circles, m:mass vector
% the output is velocity V after collision btw circles

if ~isempty(ro) && ~isempty(co) %means ro&co are not empty and there are colliding circles
        for jj=1:length(ro)
            p1=ro(jj); % colliding circle 1
            p2=co(jj); % colliding circle 2
            V2(:,p2)=(2*m(p1).*V(:,p1)+(m(p2)-m(p1))*V(:,p2))./(m(p1)+m(p2));
            V2(:,p1)=V2(:,p2)+V(:,p2)-V(:,p1);
            V(:,p1)=V2(:,p1); %assign the post velocity to circle1
            V(:,p2)=V2(:,p2); %assign the post velocity to circle1
        end
    
end   

end
function V=wallcollision(N,P,r,L,V)
%the function wallcollision detects the collision btw circles and the
%walls, and determines the post wall collision velocities.
%the inputs are:
%N:number of particles,P: x&y position of the center,r:radius,L:length of
%the box, V=velocity of the circle
%the output is the velocity V after wall collision. It is simply the same
%amount but the reversed direction
%the amount subtracted form L "-10^-3" is a safety factor
for k=1:N % collision with walls
    if P(1,k)+r(1,k)>=L-10^-3  || P(1,k)-r(1,k)<=-L-10^-3  %horizontal collision
        V(1,k)=-V(1,k); 
    end
    if P(2,k)+r(1,k)>=L-10^-3  || P(2,k)-r(1,k)<=-L-10^-3  %vertical collision 
         V(2,k)=-V(2,k);
    end 
end 
end
end