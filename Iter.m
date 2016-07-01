function [ yTrain, xTrain ] = Iter( yTrain, xTrain, xTrain1)
    %%% Create Function handle for searching landscape
    model2 = svmtrain2(yTrain,xTrain,'-s 3 -g 10 -c 1000 -q');
    pred2 = svmpredict(yTrain,xTrain,model2,'-q');
    landscape = @(xi) svmpredict(50,xi,model2,'-q');

    % We need to keep gamma low beacuse : sigma of the rbf should be large
    % enough to not overfit, since already c is very high

    % Now, we need to use the function handle landscape to traverse the
    % landscape to obtain local minima.

    % We must remove redundant entries in xTrain for successive
    % iterations

    %%% Currently quasi-newton, with steepdesc.
    options=optimset('Display','off','LargeScale','off','Diagnostics','off','HessUpdate','steepdesc');
    
    for i=1:1500
        % Initial point from experimental data's sample space
        x0 = NewStart(xTrain1);  
        [x,fval,exitflag,output,grad] = fminunc(landscape, x0, options);
        % We store the minima in Min(ima)A(rray)
        MinA(i,:) = [x fval];
    end

    %%% Now we must filter out those minima which would be useful for the
    % next iteration.
    
    % Add a column of integral scores, to group, despite of floating point
    % differences
    MinA2 = [MinA floor(MinA(:,end))];
    
    % To do this, we first group the conditions by their score.
    MinA2 = sortrows(MinA2, size(MinA2,2));

    % Now, we first remove the worst minima
    minscore = max(MinA2(:,end));
    MinA2 =  MinA2(1:max(find(MinA2(:,end)<minscore)),:);
    
    % Now, we consolidate the remaining data, so as to remove repeated rows
    % upto some numerical tolerance.
    [xg,yg] = consolidator(MinA2(:,1:end-1),MinA2(:,end),'mean',0.0001);
    MinA2 = [xg,yg];

    % We now construct the data for the next iteration
    xTrain = MinA2(:,1:end-2);
    yTrain = MinA2(:,end-1);
    
end

