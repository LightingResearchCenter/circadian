close all
clear
clc

[circadianDir,~,~] = fileparts(pwd);
addpath(circadianDir);

rt = now;

filePath = 'test.cdf';
cdfData = daysimeter12.readcdf(filePath);
[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(cdfData);
subject = cdfData.GlobalAttributes.subjectID;

idx = 6561:13201;
X = relTime.hours(idx);
X = X - min(X);
y = activity(idx);

[cos_nlm,cos_fStat,cos_pVal]   = sigmoidfit.cos_fit_nlm(X,y);
[alg_nlm,alg_fStat,alg_pVal,~] = sigmoidfit.antilog_fit(X,y);
[atn_nlm,atn_fStat,atn_pVal,~] = sigmoidfit.arctan_fit(X,y);
[hll_nlm,hll_fStat,hll_pVal,~] = sigmoidfit.hill_fit(X,y);

hFig = figure;
hFig.Units = 'inches';
hFig.Position = [1,1,10,7.5];
hFig.PaperPositionMode = 'auto';
hFig.PaperOrientation = 'landscape';

hPlot = plot(X,y,'.',X,cos_nlm.Fitted,'-',X,alg_nlm.Fitted,'-',X,atn_nlm.Fitted,'-',X,hll_nlm.Fitted,'-');
hPlot(2).LineWidth = 2;
hPlot(3).LineWidth = 2;
hPlot(4).LineWidth = 2;
hPlot(5).LineWidth = 2;

rpt_cos_amp = cos_nlm.Coefficients.Estimate('amp');
cos_Amp = (max(cos_nlm.Fitted) - min(cos_nlm.Fitted))/2;
cos_Phi = mod(cos_nlm.Coefficients.Estimate('phi'),24);

rpt_alg_amp = alg_nlm.Coefficients.Estimate('amp');
alg_Amp = (max(alg_nlm.Fitted) - min(alg_nlm.Fitted))/2;
alg_Phi = mod(alg_nlm.Coefficients.Estimate('phi'),24);

rpt_atn_amp = atn_nlm.Coefficients.Estimate('amp');
atn_Amp = (max(atn_nlm.Fitted) - min(atn_nlm.Fitted))/2;
atn_Phi = mod(atn_nlm.Coefficients.Estimate('phi'),24);

rpt_hll_amp = hll_nlm.Coefficients.Estimate('amp');
hll_Amp = (max(hll_nlm.Fitted) - min(hll_nlm.Fitted))/2;
hll_Phi = mod(hll_nlm.Coefficients.Estimate('phi'),24);

line1 = sprintf('Cosine:   reported-amp = %.3g, actual-amp = %.3g, phi = %.3g hrs, F = %.3g, p = %.3g',rpt_cos_amp,cos_Amp,cos_Phi,cos_fStat,cos_pVal);
line2 = sprintf('Anti-Log: reported-amp = %.3g,  actual-amp = %.3g, phi = %.3g hrs, F = %.3g, p = %.3g',rpt_alg_amp,alg_Amp,alg_Phi,alg_fStat,alg_pVal);
line3 = sprintf('Arctan:   reported-amp = %.3g,  actual-amp = %.3g, phi = %.3g hrs, F = %.3g, p = %.3g',rpt_atn_amp,atn_Amp,atn_Phi,atn_fStat,atn_pVal);
line4 = sprintf('Hill:     reported-amp = %.3g,  actual-amp = %.3g, phi = %.3g hrs, F = %.3g, p = %.3g',rpt_hll_amp,hll_Amp,hll_Phi,hll_fStat,hll_pVal);
tableText = {line1; line2; line3; line4};

title({'Test Sigmoidally Transformed Cosine Curve';datestr(rt,'yyyy-mmm-dd HH:MM:SS.FFF')})

hLegend = legend('data','cosine','anti-log','arctangent','Hill');
hLegend.Location = 'SouthOutside';
hLegend.Orientation = 'Horizontal';

hAxes = gca;
hAxes.YLim = [0 1];

hTable = text(4,0.98,tableText);
hTable.VerticalAlignment = 'top';
hTable.FontName = 'Courier';

% saveas(hFig,['C:\Users\jonesg5\Desktop\test_',datestr(rt,'yyyy-mm-dd_HHMMSS'),'.pdf']);
