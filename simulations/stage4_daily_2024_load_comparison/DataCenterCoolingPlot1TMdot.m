% Code to plot simulation results from DataCenterCooling
%% Plot Description:
%
% This plot shows the mass flow rates and temperatures of the chilled water
% loop and the condenser water loop. In the chilled water loop, the
% chiller's evaporator maintains a temperature of 18 degC. The chilled
% water absorbs heat from the server farm, transfers part of the heat to
% the condenser water via the heat exchanger, and transfers the remaining
% heat to the condenser water via the chiller. The chilled water pump
% adjusts the flow rate to keep the water temperature at the server outlet
% at around 28 degC.
%
% In the condenser water loop, the cooling tower cools the water as much as
% possible based on environmental conditions. The condenser water absorbs
% heat from the chilled water via the heat exchanger and the chiller, then
% rejects all heat to the environment via the cooling tower. The condenser
% water pump adjusts the flow rate to keep the water temperature difference
% across the heat exchanger and condenser to around 6 degC.

% Copyright 2022 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_DataCenterCooling', 'var')
    sim('DataCenterCooling')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_DataCenterCooling', 'var') || ...
        ~isgraphics(h1_DataCenterCooling, 'figure')
    h1_DataCenterCooling = figure('Name', 'DataCenterCooling');
end
figure(h1_DataCenterCooling)
clf(h1_DataCenterCooling)

plotTemperatureFlowRate(simlog_DataCenterCooling)



% Plot water temperatures and flow rates
function plotTemperatureFlowRate(simlog)

% Get simulation results
t = simlog.Sensor_Evaporator_Outlet.Pressure_Temperature_Sensor_TL.T.series.time;
T_chilled_evap = simlog.Sensor_Evaporator_Outlet.Pressure_Temperature_Sensor_TL.T.series.values('degC');
T_chilled_server = simlog.Sensor_Server_Outlet.Pressure_Temperature_Sensor_TL.T.series.values('degC');
T_chilled_hex = simlog.Sensor_Exchanger_Outlet.Pressure_Temperature_Sensor_TL.T.series.values('degC');
T_condenser_tower = simlog.Sensor_Tower_Outlet.Pressure_Temperature_Sensor_TL.T.series.values('degC');
T_condenser_hex = simlog.Heat_Exchanger.A2.T.series.values('degC');
T_condenser_cond = simlog.Sensor_Condenser_Outlet.Pressure_Temperature_Sensor_TL.T.series.values('degC');
mdot_chilled = simlog.Chilled_Water_Pump.mdot_A.series.values('kg/s');
mdot_condenser = simlog.Condenser_Water_Pump.mdot_A.series.values('kg/s');

% Plot results
handles(1) = subplot(3, 1, 1);
plot(t, T_chilled_evap, '-', 'LineWidth', 1)
hold on
plot(t, T_chilled_server, '--', 'LineWidth', 1)
plot(t, T_chilled_hex, '-.', 'LineWidth', 1)
hold off
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
ylabel('Temperature (degC)')
title('Chilled Water Outlet Temperatures')
legend('Evaporator', 'Server', 'Heat Exchanger', 'Location', 'best')

handles(2) = subplot(3, 1, 2);
plot(t, T_condenser_tower, '-', 'LineWidth', 1)
hold on
plot(t, T_condenser_hex, '--', 'LineWidth', 1)
plot(t, T_condenser_cond, '-.', 'LineWidth', 1)
hold off
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
ylabel('Temperature (degC)')
title('Condenser Water Outlet Temperature')
legend('Cooling Tower', 'Heat Exchanger', 'Condenser', 'Location', 'best')

handles(3) = subplot(3, 1, 3);
plot(t, mdot_chilled, '-', 'LineWidth', 1)
hold on
plot(t, mdot_condenser, '--', 'LineWidth', 1)
hold off
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
ylabel('Flow Rate (kg/s)')
title('Water Mass Flow Rate')
legend('Chilled', 'Condenser', 'Location', 'best')
xlabel('Time (s)')

linkaxes(handles, 'x')

end