% Code to plot simulation results from DataCenterCooling
%% Plot Description:
%
% This plot shows the performance of the chiller and the overall system.
% The chiller's coefficient of performance (CoP) is the ratio of the heat
% transfer in the evaporator to the power consumed by the compressor.
% Applying the same concept to the entire system, the system's CoP is the
% ratio of the heat transfer in the server farm to the total power consumed
% by the compressor, fan, and all pumps. Both CoP values are around 13,
% which is higher than typical air conditioning units. This is because heat
% transfer between the refrigerant and water is more effective than heat
% transfer between the refrigerant and air. This allows the refrigeration
% cycle to have a smaller temperature difference and thus smaller pressure
% difference between the condenser and evaporator, which reduces the work
% required by the compressor.

% Copyright 2022-2023 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_DataCenterCooling', 'var')
    sim('DataCenterCooling')
end

% Reuse figure if it exists, else create new figure
if ~exist('h3_DataCenterCooling', 'var') || ...
        ~isgraphics(h3_DataCenterCooling, 'figure')
    h3_DataCenterCooling = figure('Name', 'DataCenterCooling');
end
figure(h3_DataCenterCooling)
clf(h3_DataCenterCooling)

plotPeformance(simlog_DataCenterCooling)



% Plot chiller and system performance
function plotPeformance(simlog)

% Get simulation results
t = simlog.Server_Farm.Controlled_Heat_Flow_Rate_Source.Q.series.time;
Q_server = simlog.Server_Farm.Controlled_Heat_Flow_Rate_Source.Q.series.values('kW');
if ~isempty(simscape.logging.findNode(simlog, [simlog.id '/Chiller/Refrigeration Cycle']))
    Q_evap = simlog.Chiller.Refrigeration_Cycle.System_Level_Refrigeration_Cycle_2P.Qe.series.values('kW');
    pwr_comp = simlog.Chiller.Refrigeration_Cycle.System_Level_Refrigeration_Cycle_2P.Pwr.series.values('kW');
else
    Q_evap = simlog.Chiller.Abstract_Model.CoP.O.series.values('kW');
    pwr_comp = simlog.Chiller.Abstract_Model.Nominal_Power.O.series.values('kW');
end
pwr_cond_water = simlog.Condenser_Water_Pump.mechanical_power.series.values('kW');
pwr_chilled_water = simlog.Chilled_Water_Pump.mechanical_power.series.values('kW');
pwr_fan = simlog.Cooling_Tower.Cooling_Tower.Pwr_in.series.values('kW');

% Calculate chiller coefficient of performance
CoP_chiller = Q_evap./pwr_comp;

% Calculate overall coefficient of performance
pwr_total = pwr_comp + pwr_cond_water + pwr_chilled_water + pwr_fan;
CoP_total = Q_server./pwr_total;

% Plot results
handles(1) = subplot(2, 1, 1);
plot(t, Q_server, '-', 'LineWidth', 1)
hold on
plot(t, Q_evap, '--', 'LineWidth', 1)
plot(t, pwr_total, '-', 'LineWidth', 1)
plot(t, pwr_comp, '--', 'LineWidth', 1)
hold off
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
ylabel('Power (kW)')
title('Energy Flow')
legend('Server Heat', 'Evaporator Heat', 'Total Power', 'Compressor Power', ...
    'Location', 'best')

handles(2) = subplot(2, 1, 2);
plot(t, CoP_total, '-', 'LineWidth', 1)
hold on
plot(t, CoP_chiller, '--', 'LineWidth', 1)
hold off
grid on
set(get(gca, 'XAxis'), 'Exponent', 0)
set(gca, 'XLimitMethod', 'tight')
ylim([0 30])
ylabel('Coefficient')
title('Coefficient of Performance')
legend('Overall System', 'Chiller', 'Location', 'best')
xlabel('Time (s)')

linkaxes(handles, 'x')

end