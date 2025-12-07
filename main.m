function main(app)

%% 输入需求,这几项是界面输入，输出在最下面
if nargin == 0
    TN = 20;
    TP = 1;
    alkalinity =150;
    EBCT = 1;

    TN_removal = 10;
    TP_removal = 0.6;

    ax_TN = axes(figure(1));
    ax_TP = axes(figure(2));
else
    TN = app.EditField_TN.Value;
    TP = app.EditField_TP.Value;
    alkalinity = app.EditField_alkalinity.Value;
    EBCT = app.EditField_EBCT.Value;
    
    TN_removal = app.EditField_TN_removal.Value;
    TP_removal = app.EditField_TP_removal.Value;

    ax_TN = app.UIAxes;
    ax_TP = app.UIAxes_2;
end

%% 导入模型
load('model_NO2.mat')
load('model_NO3.mat')
load('model_TP.mat')
load('model_SO4.mat')
load('model_Fe.mat')

load('ps_input.mat')
load('ps_output_NO3.mat')
load('ps_output_NO2.mat')
load('ps_output_TP.mat')
load('ps_output_SO4.mat')
load('ps_output_Fe.mat')


NO2=0.05;
input_data1=[TN-NO2;TP;alkalinity];
input_data2=[TN_removal;TP_removal];
% input_data1 =input('Please enter influent nitrate, total phosphorus and alkalinity concentration (mg/L):  ');
% input_data2 =input('Please enter the removal concentration (total nitrogen and total phosphorus, mg/L):  ');

%% 建模

HRT=EBCT;
input_data3=[input_data1(1)+NO2,input_data1(2),input_data1(3)];
x_input=[input_data1(1),0.05,input_data1(2),input_data1(3),HRT];
target=[input_data1(1)+NO2-input_data2(1),input_data1(2)-input_data2(2)];


%S/Fe
SFe=[];
for i=20:0.01:75
    SFe=[SFe;[i,100-i]];
end

Xdata=[repmat(x_input,size(SFe,1),1),SFe];
Xdata_new = mapminmax('apply', Xdata', ps_input);
Xdata_new=Xdata_new';
%% 模型输出
Y_NO3_new = model_NO3(Xdata_new');
Y_NO2_new = model_NO2(Xdata_new');
Y_TP_new = model_TP(Xdata_new');
Y_SO4_new = model_SO4(Xdata_new');
Y_Fe_new = model_Fe(Xdata_new');

%反归一化
Y_NO3 = mapminmax('reverse', Y_NO3_new, ps_output_NO3);
Y_NO2 = mapminmax('reverse', Y_NO2_new, ps_output_NO2);
Y_TP = mapminmax('reverse', Y_TP_new, ps_output_TP);
Y_SO4 = mapminmax('reverse', Y_SO4_new, ps_output_SO4);
Y_Fe = mapminmax('reverse', Y_Fe_new, ps_output_Fe);

%% 计算出水达标
A_prediction=[SFe,Y_NO3'+Y_NO2',Y_TP'];

A_comparison1=[SFe,target-A_prediction(:,3:4)];
%% 计算可持续性
C_DisFe_actual=(Y_SO4'+5*2.46)./96*32*48.34/100.*(SFe(2)./SFe(1));

C_SO4_calculated = (Xdata(:,1)+Xdata(:,2)-Y_NO3'-Y_NO2')*55/50*96/14+(Y_NO2'-Xdata(:,2))*22/50*96/14;

C_DisFe_calculated =((Xdata(:,1)+Xdata(:,2)-Y_NO3'-Y_NO2').*(1-Y_SO4'./C_SO4_calculated)*100)/100/14*5*56+((Y_NO2'-Xdata(:,2)).*(1-Y_SO4'./C_SO4_calculated)*100)/100/14*2*56+Y_Fe';

A_comparison2=[SFe,C_DisFe_actual - C_DisFe_calculated];


%% 模型输出
% disp('*****************Start of calculationt*****************')
% disp('   ')
% disp(' S:Fe————Total nitrogen————Total phosphorus———Ultimate fate of SSCReF————Co-Qualified')
for k=1:size(SFe,1)
% 判断除氮是否满足
    if A_comparison1(k,3)>=0
        TN=' Qualified ';
    else 
       TN='Unqualified';
    end
    
% 判断除磷是否满足   
    if A_comparison1(k,4)>=0
        TP=' Qualified ';
    else
       TP='Unqualified';
    end
% 判断可持续条件是否满足     
    if A_comparison2(k,3)>=0
        Ultimate=' Sustainable  ';
    else
        Ultimate='Unsustainable ';
    end
        
    if A_comparison1(k,3)>=0 & A_comparison1(k,4)>=0 & A_comparison2(k,3)>=0
       total='YES';
    else
       total=' NO ';
    end
     
output_print1=[num2str(SFe(k,1)),'%:',num2str(SFe(k,2)),'%—————',TN,'—————',TP ,'——————',Ultimate,'————————',total];
% disp(output_print1)
end




%% 绘图
PLOT(A_prediction,input_data3,target, ax_TN, ax_TP);


%% 计算价格
% disp('   ')
% disp('-----------------Calculate the USD/t water-----------------')

C_s=(Y_SO4'+5*2.46)*32/96;
C_Filler=C_s.*(1+(SFe(2)./SFe(1)));
P_Filler=(1500*SFe(2)+100*SFe(1))*0.14;
P_Filler=2.1*SFe(1)+1.4*SFe(2);
TCwater=[SFe,round(C_Filler/1000.*P_Filler/1000,4)];


for p=1:size(SFe,1)
    if A_comparison1(p,3)<0 | A_comparison1(p,4)<0 | A_comparison2(p,3)<0
        TCwater(p,3)=inf;
    end
end


[min_money, ind] = min( TCwater(:,3));  % 找到最小的花费的值，以及其在向量中的下标
best_SFe =  TCwater(ind,:); % 根据下标找到此时方案

if min_money ~= inf
    
output_print2=['  ',num2str(best_SFe(1)),'%:',num2str(best_SFe(2)),'%:'];
% disp('Minimum USD/t wate of SSCReF for optimum solution：')
% disp(min_money)
% disp('Sulfur to siderite ratio for optimum solution：')
% disp(output_print2)



%% 输出
result = ['The calculation results are as follows:'];
S0_Fe_mass_ratio = [num2str(best_SFe(1)),'% : ',num2str(best_SFe(2)),'%'];
Sustainability=['The current filler can be sustained.'];
Cost_USD_t_water = min_money;

app.Label_Result.Text = result;
app.EditField_MassRatio.Value = S0_Fe_mass_ratio;
app.EditField_Sustainability.Value = 'Sustainable';
app.EditField_Cost.Value = num2str(Cost_USD_t_water);
else
%% 如果没有合适的，就只输出这个
result = ['There is no plan that meets the standards!'];
uialert(app.UIFigure, result, '');
app.Label_Result.Text = result;
app.EditField_MassRatio.Value = '';
app.EditField_Sustainability.Value = '';
app.EditField_Cost.Value = '';

end
% disp('*****************Complete the calculation*****************')

end
