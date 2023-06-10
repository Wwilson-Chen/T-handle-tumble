function T_handle_animation(psi, theta, phi, ts)
% dimensions
R_AG = 0.5;      %  cm
R_BC = 4;        %  cm
R_AD = 2;        %  cm

% state over time
for k = 1:length(psi)
    R1 = [ cos(psi(k)), sin(psi(k)), 0;             %  3-1-3 euler angle 
          -sin(psi(k)), cos(psi(k)), 0;           
                     0,           0, 1];
    R2 = [1,              0,             0;                            
          0,  cos(theta(k)), sin(theta(k));
          0, -sin(theta(k)), cos(theta(k))];   
    R3 = [ cos(phi(k)), sin(phi(k)), 0;
          -sin(phi(k)), cos(phi(k)), 0;
                     0,           0, 1];

    e1(:,k) = ([1, 0, 0]*(R3*R2*R1))';               %  e1
    e2(:,k) = ([0, 1, 0]*(R3*R2*R1))';               %  e2
    e3(:,k) = ([0, 0, 1]*(R3*R2*R1))';               %  e3
    xA(k,1) = -R_AG*e2(1,k);                         %  cm
    yA(k,1) = -R_AG*e2(2,k);                         %  cm                        
    zA(k,1) = -R_AG*e2(3,k);                         %  cm 
    xB(k,1) = xA(k) + R_BC/2*e1(1,k);                %  cm
    yB(k,1) = yA(k) + R_BC/2*e1(2,k);                %  cm                                
    zB(k,1) = zA(k) + R_BC/2*e1(3,k);                %  cm
    xC(k,1) = xA(k) - R_BC/2*e1(1,k);                %  cm
    yC(k,1) = yA(k) - R_BC/2*e1(2,k);                %  cm                                
    zC(k,1) = zA(k) - R_BC/2*e1(3,k);                %  cm 
    xD(k,1) = xA(k) + R_AD*e2(1,k);                  %  cm 
    yD(k,1) = yA(k) + R_AD*e2(2,k);                  %  cm                                 
    zD(k,1) = zA(k) + R_AD*e2(3,k);                  %  cm 
end

% plot
figure;
set(gcf, 'color', 'w');
plot3(0, 0, 0);
xlabel('\itX\rm [cm]', 'fontsize', 12);
set(gca, 'xdir', 'reverse');
ylabel('\itY\rm (cm)', 'fontsize', 12);
set(gca, 'ydir', 'reverse');
zlabel('\itZ\rm (cm)            ', 'rotation', 0, 'fontsize', 12);
axis equal; grid on;
xlim(R_BC*[-1, 1]);
ylim(R_BC*[-1, 1]);
zlim(R_AD*[-1, 1]);

%  Draw the T-handle:
AD = line('xdata', [xA(1), xD(1)], 'ydata', [yA(1), yD(1)], 'zdata', [zA(1), zD(1)], 'color', 'k', 'linewidth', 5);
BC = line('xdata', [xB(1), xC(1)], 'ydata', [yB(1), yC(1)], 'zdata', [zB(1), zC(1)], 'color', 'k', 'linewidth', 5);

pause;

% start
for k = 1:length(psi)
    set(AD, 'xdata', [xA(k), xD(k)], 'ydata', [yA(k), yD(k)], 'zdata', [zA(k), zD(k)]);
    set(BC, 'xdata', [xB(k), xC(k)], 'ydata', [yB(k), yC(k)], 'zdata', [zB(k), zC(k)]);
    drawnow;
end