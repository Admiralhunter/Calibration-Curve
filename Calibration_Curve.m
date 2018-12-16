clear all
close all
clc

%%% this file is automatic, please modify "Calibration Curve Data
%%% input.xlsx" to get calibration curve.
%Contact Hunter Palcich if need help @
%palcicha@mail.uc.edu

%reads data from excel
excel = 'Calibration Curve data input.xlsx';

Data = xlsread(excel,'E1:E5');

%gets concentrations and amp readings (Lines 15-26)
concentrations = int2str(Data(5) + 1);
rangecon = strcat('H2',':','H',concentrations');
rangeread = strcat('I2',':','I',concentrations');

length = Data(1);
PBS = Data(2);
Each = Data(3);
Each_ConsT = xlsread(excel,rangecon);
Each_Cons = transpose(Each_ConsT);
Base = Data(4);
ReadingsT = xlsread(excel,rangeread);
Readings = transpose(ReadingsT);


beginning_time = 'A2';
beginning_A = 'B2';
ending_time = strcat('A',int2str(length +1));
ending_A = strcat('B',int2str(length + 1));

columnA = strcat(beginning_time,':',ending_time);
columnB = strcat(beginning_A,':',ending_A);


time = xlsread(excel,columnA);
A = xlsread(excel,columnB);




x_FitStart = 1;
x_FitEnd = Data(5);

%Calculate actual consentration
for k=1:Data(5)
    Vol_Current=PBS+k*Each;
    if k==1
        Pt_Cons(k)=Each_Cons(k)*Each/Vol_Current;
    else
        Pt_Cons(k)=(Pt_Cons(k-1)*(Vol_Current-Each)+Each_Cons(k)*Each)/Vol_Current;
    end
end

%Fit data
fitting=polyfit(Pt_Cons(x_FitStart:x_FitEnd),Readings(x_FitStart:x_FitEnd)-Base,1);
fit_val=polyval(fitting,Pt_Cons(x_FitStart:x_FitEnd));
ybar=mean(Readings(x_FitStart:x_FitEnd)-Base);
St=sum((Readings(x_FitStart:x_FitEnd)-Base-ybar).^2);
Sr=sum((fit_val-(Readings(x_FitStart:x_FitEnd)-Base)).^2);
r=sqrt(1-Sr/St);
r2 = r^2;
fprintf('Fitting Result:\ny = %0.4f x + %0.4f \nr= %0.4f\nr2= %0.4f\n',fitting(1),fitting(2),r,r2)

%Plot
subplot(2,1,1);
plot(time,A)
xlabel('Time (s)')
ylabel('Current (uA)')
title('Current vs Time')

subplot(2,1,2);
plot(Pt_Cons*1000,Readings-Base,'*',Pt_Cons(x_FitStart:x_FitEnd)*1000,fit_val)
xlabel('Concentration(mM)')


ylabel('Current Difference(uA)')
title('Calibration Curve')