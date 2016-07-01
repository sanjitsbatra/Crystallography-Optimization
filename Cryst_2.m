clear;clc;

cd ~/Desktop/Play/ML_JD/Crystallography/Z-Final/Code/

load('data-1.mat');

% Minimum score must be best
yData = -yData;

% Scaling of features to [-1,1]
D = size(xData,2);
for d=1:D
    M(d)=mean(xData(:,d));
    Var(d)=var(xData(:,d));
    xData(:,d) = ( xData(:,d)-M(d) )/Var(d);
end

%%% Learn the global landscape; so as to validate predicted conditions
% How tightly should this be learnt?
model = svmtrain2(yData,xData,'-s 3 -g 10 -c 1000 -q');
pred = svmpredict(yData,xData,model,'-q');
max(pred - yData)

%%% Sample from landscape to create artificial experimental dataset
for i=1:5
    rand('state',97);
    labels = unique(randi(size(yData,1),45,1));
    if size(labels,1) >= 30 && size(labels,1) <=35
        fprintf('%d \n' , i);
        break;        
    end
end

%%% Sampled points will used to predict good conditions
xTrain = xData(labels,:);
yTrain = yData(labels,:);

%%% Remove successful crystallization conditions
temp_index = min(find(yTrain<=-80));
xTrain = xTrain(1:temp_index-1,:);
yTrain = yTrain(1:temp_index-1);

%%% The landscape which is to be sampled, to find local minima in
% successive iterations
xTrain1 = xTrain;

%%% In each iteration, we sample the landscape constructed from the 
% experimental data, so as to find local minima. After finding them, we
% filter the data points to obtain a pure set of minima, and consider these
% as the new data, and iterate. At the end we hope to attain a stable and
% good set of minima, which will then be validated, i.e. their score
% checked using the global landscape, which would ordinarily not be known.
%
Max_Iter = 5; 

for i=1:Max_Iter

        % We find successive local minima
        [yTrain, xTrain] = Iter(yTrain, xTrain, xTrain1);
        x{i} = xTrain;    
        y{i} = yTrain;
        display(yTrain)
        if(size(yTrain,1)<=3)
            break;
        end
end 

%%% Now we validate the predicted conditions with the global landscape
predglobal = svmpredict( yTrain, xTrain, model,'-q');

% We would consider our run successful if we are able to find a good
% minimum.
if (min(predglobal) < -80)
    success = 1;
    fprintf(1,'Success: min score is: %d ',min(predglobal));
end


%%%%
%2D
% hold on;
% level = 1;
% x0 = x{level};
% [u,s,v] = svd(x0'*x0);
% T = x0*u(:,1:1);
% 
% plot(T,y{level},'o');
% 







%3D
% % hold on;
figure;
level = 3;

x0 = x{level};
[u,s,v] = svd(x0'*x0);
T = x0*u(:,1:2);


x111=T(:,1);
y111=T(:,2);
z111=y{level};

dx=0.01;
dy=0.01;

x_edge=[floor(min(x111)):dx:ceil(max(x111))];
y_edge=[floor(min(y111)):dy:ceil(max(y111))];
[X111,Y111]=meshgrid(x_edge,y_edge);
F = TriScatteredInterp(x111,y111,z111);
Z111= F(X111,Y111);
surf(X111,Y111,Z111);






% z = repmat(y{level},1,length(y{level}));
% surf(T(:,1),T(:,2),z);


% 
% ti = -2:.25:2;
% [xi,yi] = meshgrid(ti,ti);
% F = TriScatteredInterp(T(:,1),T(:,2),y{level});
% zi = F(xi,yi);
% mesh(xi,yi,zi), hold on;
% plot3(T(:,1),T(:,2),y{level},'o');
