% Assuming you have already defined the functions and variables as mentioned in your code

% Initialize arrays to store results
PBoiler_values = linspace(12E+6, 15E+6, 100); % Vary P4 from 12 MPa to 15 MPa
n_values = zeros(size(PBoiler_values));
wnet_values = zeros(size(PBoiler_values));
w=Solution('liquidvapor.cti','water');
P1=10E+3;
P2=0.5E+6;
P3=0.5E+6;

P6=4E+6;

T9=500+273.15;
P10=P6;
P11=P6;
T11=T9;
P11prime=2E+6;
T12prime=500+273.15;
P12prime=P11prime;
P12=P3;
P13=P1;

% Loop over different P4 values
for i = 1:length(PBoiler_values)
    % Update P4 value
    P4 = PBoiler_values(i);
    
    % Update State 4
   % State 1
setState_Psat(w,[P1, 0]); 
h1=enthalpy_mass(w);
s1=entropy_mass(w);

% State 2
s2=s1;
setState_SP(w, [s2,P2]);
h2=enthalpy_mass(w);
s2=entropy_mass(w);

% State 3
setState_Psat(w,[P3, 0]);
h3=enthalpy_mass(w);
s3=entropy_mass(w);

% State 4
s4=s3;
setState_SP(w, [s4,P4]);
h4=enthalpy_mass(w);
s4=entropy_mass(w);

% State 6

setState_Psat(w,[P6, 0]);
T6=temperature(w);
h6=enthalpy_mass(w);
s6=entropy_mass(w);

% State 5
T5=T6;
set(w,'P',P4,'T',T5);
h5=enthalpy_mass(w);
s5=entropy_mass(w);

% State 7
s7=s6;
setState_SP(w, [s7,P4]);
h7=enthalpy_mass(w);
s7=entropy_mass(w);

% State 9
set(w,'P',P4,'T',T9);
h9=enthalpy_mass(w);
s9=entropy_mass(w);

% State 10
s10=s9;
setState_SP(w, [s10,P10]);
h10=enthalpy_mass(w);
s10=entropy_mass(w);

% State 11
set(w,'P',P11,'T',T11);
h11=enthalpy_mass(w);
s11=entropy_mass(w);

% State 11prime
s11prime=s11;
setState_SP(w, [s11prime,P11prime]);
h11prime=enthalpy_mass(w);
s11prime=entropy_mass(w);


% State 12prime
set(w,'P',P12prime,'T',T12prime);
h12prime=enthalpy_mass(w);
s12prime=entropy_mass(w);

% State 12
s12=s12prime;
setState_SP(w, [s12,P12]);
h12=enthalpy_mass(w);
s12=entropy_mass(w);

% State 13
s13=s12;
setState_SP(w, [s13,P13]);
h13=enthalpy_mass(w);
s13=entropy_mass(w);
x13= vaporFraction(w);

P8=P4;
    
    % Calculate efficiency (n)
    y = (h5 - h4) / ((h10 - h6) + (h5 - h4));
    z = (1 - y) * (h3 - h2) / (h12 - h2);
    
    h8 = ((1 - y) * h5) + (y * h7);
    wout = (h9 - h10) + (1 - y) * (h11 - h11prime) + (1 - y) * (h12prime - h12) + (1 - y - z) * (h12 - h13);
    win = (1 - y - z) * (h2 - h1) + (1 - y) * (h4 - h3) + (y) * (h7 - h6);
    qin=(h9-h8)+(1-y)*(h11-h10)+(1-y)*(h12prime-h11prime);
    n_values(i) = (wout - win) / (qin);
    
    % Calculate net work (wnet)
    wnet_values(i) = wout - win;
end

% Plot efficiency vs P4
figure;
plot(PBoiler_values / 1E+6, n_values, 'LineWidth', 2);
xlabel('Boiler Pressure (MPa)');
ylabel('Efficiency (n)');
title('Effect of Boiler Pressure on Efficiency');
grid on;

% Plot wnet vs P4
figure;
plot(PBoiler_values / 1E+6, wnet_values / 1E+6, 'LineWidth', 2);
xlabel('Boiler Pressure (MPa)');
ylabel('Net Work (KJ)');
title('Effect of Boiler Pressure on Net Work ');
grid on;
