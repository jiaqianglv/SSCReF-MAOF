function a=PLOT(A_prediction,input_data3,target, ax_TN, ax_TP)



X=[20, 75];

TN=[A_prediction(:,1),A_prediction(:,3),repmat(target(1),size(A_prediction,1),1)];
TP=[A_prediction(:,1),A_prediction(:,4),repmat(target(2),size(A_prediction,1),1)];


TN_yes=[];
TN_no=[];
for i=1:size(A_prediction,1)
    if TN(i,2)- TN(i,3)>0
        TN_no=[TN_no;TN(i,1:2)];
    else
        TN_yes=[TN_yes;TN(i,1:2)];
    end
end

TP_yes=[];
TP_no=[];
for i=1:size(A_prediction,1)
    if TP(i,2)- TP(i,3)>0
        TP_no=[TP_no;TP(i,1:2)];
    else
        TP_yes=[TP_yes;TP(i,1:2)];
    end
end


if size(TN_no,1)==size(TN,1) 

% figure
plot(ax_TN, TN_no(:,1), TN_no(:,2), 'r*', TN(:,1), repmat(input_data3(1),size(A_prediction,1),1), 'r-',TN(:,1), repmat(target(1),size(A_prediction,1),1), 'k-', TN(:,1), TN(:,2), 'k-','LineWidth', 1)
legend(ax_TN, {'Unqualified','Total nitrogen in influent','Objective line'})
xlabel(ax_TN, 'S wt% in SSCReF')
ylabel(ax_TN, 'TN')
% string = {'训练集预测结果对比'; ['RMSE=' num2str(result1(2))]};
% title(string)
xlim(ax_TN, X)
ylim(ax_TN, [0, 60])
grid(ax_TN, 'on');

    
else if size(TN_yes,1)==size(TN,1)

% figure
plot(ax_TN, TN_yes(:,1), TN_yes(:,2), 'bo', TN(:,1), repmat(input_data3(1),size(A_prediction,1),1), 'r-',TN(:,1), repmat(target(1),size(A_prediction,1),1), 'k-', TN(:,1), TN(:,2), 'k-','LineWidth', 1)
legend(ax_TN, {'Qualified','Total nitrogen in influent','Objective line'})
xlabel(ax_TN, 'S wt% in SSCReF')
ylabel(ax_TN, 'TN')
% string = {'训练集预测结果对比'; ['RMSE=' num2str(result1(2))]};
% title(string)
xlim(ax_TN, X)
ylim(ax_TN, [0, 60])
grid(ax_TN, 'on');

    else
%  绘图
% figure
plot(ax_TN, TN_no(:,1), TN_no(:,2), 'r*', TN_yes(:,1), TN_yes(:,2), 'bo', TN(:,1), repmat(input_data3(1),size(A_prediction,1),1), 'r-',TN(:,1), repmat(target(1),size(A_prediction,1),1), 'k-', TN(:,1), TN(:,2), 'k-','LineWidth', 1)
legend(ax_TN, {'Unqualified','Qualified','Total nitrogen in influent','Objective line'})
xlabel(ax_TN, 'S wt% in SSCReF','FontName', 'Arial', 'FontSize', 12)
ylabel(ax_TN, 'TN')
% string = {'训练集预测结果对比'; ['RMSE=' num2str(result1(2))]};
% title(string)
xlim(ax_TN, X)
ylim(ax_TN, [0, 60])
grid(ax_TN, 'on');

end
end


if size(TP_no,1)==size(TP,1)

% figure
plot(ax_TP, TP_no(:,1), TP_no(:,2), 'r*',  TP(:,1), repmat(input_data3(2),size(A_prediction,1),1), 'r-',TP(:,1), repmat(target(2),size(A_prediction,1),1), 'k-', TP(:,1), TP(:,2), 'k-','LineWidth', 1)
legend(ax_TP, {'Unqualified','Total phosphorus in influent','Objective line'})
xlabel(ax_TP, 'S wt% in SSCReF')
ylabel(ax_TP, 'TP')
% string = {'训练集预测结果对比'; ['RMSE=' num2str(result1(2))]};
% title(string)
xlim(ax_TP, X)
ylim(ax_TP, [0, 1.8])
grid(ax_TP, 'on')

else if size(TP_yes,1)==size(TP,1)
% figure
plot(ax_TP,  TP_yes(:,1), TP_yes(:,2), 'bo', TP(:,1), repmat(input_data3(2),size(A_prediction,1),1), 'r-',TP(:,1), repmat(target(2),size(A_prediction,1),1), 'k-', TP(:,1), TP(:,2), 'k-','LineWidth', 1)
legend(ax_TP, {'Qualified','Total phosphorus in influent','Objective line'})
xlabel(ax_TP, 'S wt% in SSCReF')
ylabel(ax_TP, 'TP')
% string = {'训练集预测结果对比'; ['RMSE=' num2str(result1(2))]};
% title(string)
xlim(ax_TP, X)
ylim(ax_TP, [0, 1.8])
grid(ax_TP, 'on')

else   
% figure
plot(ax_TP, TP_no(:,1), TP_no(:,2), 'r*', TP_yes(:,1), TP_yes(:,2), 'bo', TP(:,1), repmat(input_data3(2),size(A_prediction,1),1), 'r-',TP(:,1), repmat(target(2),size(A_prediction,1),1), 'k-', TP(:,1), TP(:,2), 'k-','LineWidth', 1)
legend(ax_TP, 'Unqualified','Qualified','Total phosphorus in influent','Objective line')
xlabel(ax_TP, 'S wt% in SSCReF')
ylabel(ax_TP, 'TP')
% string = {'训练集预测结果对比'; ['RMSE=' num2str(result1(2))]};
% title(string)
xlim(ax_TP, X)
ylim(ax_TP, [0, 1.8])
grid(ax_TP, 'on')
  
end
end
            
            
end