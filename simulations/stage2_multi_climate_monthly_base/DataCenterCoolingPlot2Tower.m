% Code to plot simulation results from DataCenterCooling
%% Plot Description:
%
% This plot shows the evaporative cooling performance of the cooling tower.
% The cooling tower removes heat from the condenser water by allowing some
% of the water to evaporate into the environment. The heat of vaporization
% needed for evaporation comes from the water and thus it cools the water.
% The fan draws in fresh air from the environment and pushes out the hot
% humid air. A colder and dryer environment increases the performance of
% the cooling tower. Unlike a regular water-air heat exchanger, the cooling
% tower can reduce the water temperature to below the environment
% temperature. The drawback is the loss of around 1% of the water flow,
% which must be replenished.
%
% The evaporative process is modeled approximately using the e-NTU method
% based based on an analogy between heat and mass transfer. For sensible
% heat transfer, the e-NTU method obtains the heat flow rate by multiplying
% the theoretical maximum temperature difference with an effectiveness
% factor. For evaporative heat transfer, the analogous e-NTU method
% multiplies the theoretical maximum mixture enthalpy difference with an
% effectiveness factor. The use of mixture enthalpy accounts for
% differences in both temperature and humidity. The maximum occurs when air
% is assumed to become fully saturated with the evaporated water.

% Copyright 2022-2023 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_DataCenterCooling', 'var')
    sim('DataCenterCooling')
end

% Reuse figure if it exists, else create new figure
if ~exist('h2_DataCenterCooling', 'var') || ...
        ~isgraphics(h2_DataCenterCooling, 'figure')
    h2_DataCenterCooling = figure('Name', 'DataCenterCooling');
end
figure(h2_DataCenterCooling)
clf(h2_DataCenterCooling)

plotCoolingTower(simlog_DataCenterCooling)



% Plot cooling tower performance
function plotCoolingTower(simlog)

% Get simulation results
t = simlog.Cooling_Tower.Cooling_Tower.moist_air_2.T.series.time;
T_env = simlog.Cooling_Tower.Cooling_Tower.moist_air_2.T.series.values('degC');
RH_env = simlog.Cooling_Tower.Cooling_Tower.moist_air_2.RH.series.values('1');
T_water_in = simlog.Cooling_Tower.Cooling_Tower.thermal_liquid_1.A.T.series.values('degC');
T_water_out = simlog.Cooling_Tower.Cooling_Tower.thermal_liquid_1.B.T.series.values('degC');
Q_tower = simlog.Cooling_Tower.Cooling_Tower.Q.series.values('kW');
evaporation = simlog.Cooling_Tower.Cooling_Tower.E.series.values('kg/s');

% Plot results
handles(1) = subplot(3, 1, 1);
yyaxis left
plot(t, T_env, '-', 'LineWidth', 1)
ylabel('Temperature (degC)')
yyaxis right
plot(t, RH_env, '--', 'LineWidth', 1)
ylabel('Relative Humidity')
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
title('Environmental Conditions')
legend('Temperature', 'Relative Humidity', 'Location', 'best')

handles(2) = subplot(3, 1, 2);
plot(t, T_water_in, '-', 'LineWidth', 1)
hold on
plot(t, T_water_out, '--', 'LineWidth', 1)
hold off
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
ylabel('Temperature (degC)')
title('Cooling Tower Water Temperature')
legend('Inlet', 'Outlet', 'Location', 'best')

handles(3) = subplot(3, 1, 3);
yyaxis left
plot(t, Q_tower, '-', 'LineWidth', 1)
ylabel('Heat Flow (kW)')
yyaxis right
plot(t, evaporation, '--', 'LineWidth', 1)
ylabel('Evaporation (kg/s)')
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
title('Cooling Tower Heat and Mass Transfer')
legend('Heat', 'Evaporation', 'Location', 'best')
xlabel('Time (s)')

linkaxes(handles, 'x')

end