close all; clear; clc;

%% Prepare for ODEs
T_handle_Equations_of_motion;
load t_handle_ODEs;

%% Parameters
% inertia
I1 = 1;          %  kg-m^2
I2 = 2;          %  kg-m^2
I3 = 3;          %  kg-m^2

% time for simulation
tspan = 10;                     %  s
ts = 0.005;                     %  s
t = [0 : ts : tspan]';          %  s
tol = 1e-6;

%% State Space
% state0
omega10 = 0.1;                  %  rad/s
omega20 = 15;                   %  rad/s
omega30 = 0.1;                  %  rad/s
psi0 = 0;                       %  rad
theta0 = 90*(pi/180);           %  rad
phi0 = 0;                       %  rad

Y0 = [omega10, omega20, omega30, psi0, theta0, phi0]';

% ode
M = @(t, Y) M(t, Y, I1, I2, I3);
F = @(t, Y) F(t, Y, I1, I2, I3);
opts = odeset('mass', M, 'abstol', tol, 'reltol', tol);
[t, Y] = ode45(F, t, Y0, opts);

% Extract the results:
omega1 = Y(:,1);        %  rad/s
omega2 = Y(:,2);        %  rad/s
omega3 = Y(:,3);        %  rad/s
psi = Y(:,4);           %  rad
theta = Y(:,5);         %  rad
phi = Y(:,6);           %  rad

% energy
E = 1/2*(I1*omega1.^2 + I2*omega2.^2 + I3*omega3.^2);  %J

% angular momentum
H1 = I1*omega1;                        %  kg-m^2/s
H2 = I2*omega2;                        %  kg-m^2/s
H3 = I3*omega3;                        %  kg-m^2/s
H = sqrt(H1.^2 + H2.^2 + H3.^2);       %  kg-m^2/s

%% Plot
span = [0.8, 1.2];
% Energy
figure(1);
set(gcf, 'color', 'w');
plot(t, E, '-b', 'linewidth', 2);
xlabel('Time [s]', 'interpreter', 'latex', 'fontsize', 12);
ylabel('Total mechanical energy [J]', 'interpreter', 'latex', 'fontsize', 12);
ylim([min(min(E)*span), max(max(E)*span)]);

% Angular Momentum
figure(2);
set(gcf, 'color', 'w');
plot(t, H1, t, H2, t, H3, t, H, 'linewidth', 2);
xlabel('Time [s]', 'interpreter', 'latex', 'fontsize', 12);
ylabel('Angular momentum about the mass center [kg-m^2/s]', 'interpreter', 'latex', 'fontsize', 12);
legend(' \bf{H}\rm \cdot \bf{e}\rm_{1}', ...
       ' \bf{H}\rm \cdot \bf{e}\rm_{2}', ...
       ' \bf{H}\rm \cdot \bf{e}\rm_{3}', ...
       ' ||\bf{H}\rm||');
  
%% Animation
T_handle_animation(psi, theta, phi, ts);