% Track setup
track_length = 900;
track_radius = 200;
track_width = 15;
delta_s = 1;
delta_theta = 1;

path.width = track_width;
path.l_st = track_length;
path.radius = track_radius;

P4init % call init

% Get track points
[xp,yp] = trackinfo(track_length,track_radius,0,delta_s,delta_theta);

set_param('Project4_MODEL','StopTime','3600');
simout = sim("Project4_MODEL.slx");

X = simout.X.data;
Y = simout.Y.data;
psi = simout.psi.data;

% Calculate height from x-position
ex = exp((X - 450)/50);
Z = (ex ./ (1 + ex)) * 10;

% Race stats
stats = raceStat(X,Y,simout.tout,path,simout);
disp(stats)

% Track bounds
[xp_in,yp_in] = trackinfo(track_length,track_radius,-7.5,delta_s,delta_theta);
[xp_out,yp_out] = trackinfo(track_length,track_radius,7.5,delta_s,delta_theta);

figure
plot(xp_in,yp_in,'k')
hold on
plot(xp_out,yp_out,'k')

% Original car shape in body frame
xc = [4 -4 -4 4];
yc = [2 2 -2 -2];

% Create animated line (optional 3D trace)
h = animatedline('Color','r');
axis([-300 1200 -100 500 0 12])  % 3D axis range
view(3)  % switch to 3D view

for k = 1:length(X)
    delete(findall(gca,'Type','Patch'));
    rot = rotate_car(xc, yc, psi(k));

    x_new = X(k) + rot(1,:);
    y_new = Y(k) + rot(2,:);
    z_car = Z(k) * ones(size(x_new));  % constant height for all corners

    fill3(x_new, y_new, z_car, 'y')  % 3D patch
    drawnow limitrate

    addpoints(h, X(k), Y(k), Z(k))
end

% rotate car points
function rotated = rotate_car(x,y,angle)
    R = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    rotated = R*[x;y];
end

% make track points
function [xp,yp] = trackinfo(L,R,offset,delta_s,delta_theta)
    R = R+offset;
    sx1 = linspace(0,L,(L-0)/delta_s+1);
    sy1 = ones(size(sx1))*(-offset);
    sx2 = linspace(L,0,(L-0)/delta_s+1);
    sy2 = ones(size(sx2))*(400+offset);
    
    t1 = linspace(-pi/2,pi/2,pi/(delta_theta*pi/180));
    t2 = linspace(pi/2,3*pi/2,pi/(delta_theta*pi/180));
    
    xp = [sx1, R*cos(t1)+L, sx2, R*cos(t2)];
    yp = [sy1, R*sin(t1)+R-offset, sy2, R*sin(t2)+R-offset];
end
