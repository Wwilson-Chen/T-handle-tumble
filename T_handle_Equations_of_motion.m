close all; clear; clc;

%% Declare Symbols
syms omega1(t) omega2(t) omega3(t) psi(t) theta(t) phi(t);
syms I1 I2 I3;
assume((I1 > 0) & (I2 > 0) & (I3 > 0));

%% Calculation of Symbols
% Angular Momentum
H = diag([I1, I2, I3])*[omega1; omega2; omega3];
omega = [omega1; omega2; omega3];

H_dot = diff(H) + cross(omega, H);
sumM = [0, 0, 0]';

% ode of omega by H_dot
ODEs1 = H_dot == sumM;

% 3-1-3 euler angle
R1 = [ cos(psi), sin(psi), 0;        
      -sin(psi), cos(psi), 0;
              0,        0, 1]; 
R2 = [1,           0,          0;                    	
      0,  cos(theta), sin(theta);
      0, -sin(theta), cos(theta)];
R3 = [ cos(phi), sin(phi), 0;        
      -sin(phi), cos(phi), 0;
              0,        0, 1];  

% omega in boy-fixed
omega = (R3*R2*R1)*[0; 0; diff(psi)] + (R3*R2)*[diff(theta); 0; 0] + R3*[0; 0; diff(phi)];

% ode of omega by euler

ODEs2 = [omega1; omega2; omega3] == omega;

% combination    
StateODE = simplify([ODEs1; ODEs2]);
state = [omega1; omega2; omega3; psi; theta; phi];

[Msym, Fsym] = massMatrixForm(StateODE, state);
Msym = simplify(Msym);
Fsym = simplify(Fsym);
M = odeFunction(Msym, state, I1, I2, I3);  
F = odeFunction(Fsym, state, I1, I2, I3);

% save for data
save t_handle_ODEs.mat Msym Fsym state M F