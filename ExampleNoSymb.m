%% Example For MultiPolyRegress
% X is your Data matrix. 500 data point with 5 dimensions. Another way to
% look at this is 500 samples of 5 independent variables. Y is your
% observation vector 500 by 1. You want to find a good polynomial fit of
% columns of X to Y. Lets say you decided fit a 2nd degree polynomial to
% all 5 independent variables. And you are for the moment, interested in fitting the
% standard polynomial basis without further meddling with the terms.
%% How to Use the Inputs
%% Plain
load Example.mat
reg=MultiPolyRegress(X,Y,2) % Gives you your fit.
%% Normalization - Range
% Different error definition ONLY in the calculation of MAE, MAESTD, CVMAE
% and CVMAESTD. Does not effect the fit.
load Example.mat
reg=MultiPolyRegress(X,Y,2,'range')
%% Figure
% You would like to see a scatter plot of your fit.
reg=MultiPolyRegress(X,Y,2,'figure');
%% Legend
% You would like to see the actual formula of the fit,

% reg=MultiPolyRegress(X,Y,2,'legend');
% PolynomialFormula=vpa([reg.Coefficients reg.Legend],5);

% PolynomialFormula =
%  
% [    0.0052679,    x5]
% [    0.0073888,    x4]
% [ -0.000087941, x4*x5]
% [     0.016723,    x3]
% [  -0.00097694, x3*x5]
% [  0.000083902, x3*x4]
% [     0.015417,    x2]
% [   -0.0025415, x2*x5]
% [     0.002392, x2*x4]
% [  -0.00018939, x2*x3]
% [    -0.028576,    x1]
% [  -0.00045571, x1*x5]
% [  -0.00037732, x1*x4]
% [  -0.00010521, x1*x3]
% [  -0.00047654, x1*x2]
% [       4.0108,   1.0]
% [ -0.000049811,  x1^2]
% [  -0.00026949,  x2^2]
% [   0.00014575,  x3^2]
% [ -0.000065765,  x4^2]
% [     0.011599,  x5^2]
%% PV 
% You would like to limit the observed powers of certain terms in your
% polynomial. For example, you do not want the 1st and 4th Independent
% Variables (x1 and x4) to have second order terms (x1^2 or x4^2). Notice
% you have to explicitly write how high each term can go in powers, so I
% would also state I am fine with (x2 x3 and x5) having 2nd order terms. 

% reg=MultiPolyRegress(X,Y,2,[1 2 2 1 2],'legend'); 
% PolynomialFormula=vpa([reg.Coefficients reg.Legend],5);

% PolynomialFormula =
%  
% [   0.0022642,    x5]
% [   0.0058919,    x4]
% [ -0.00049119, x4*x5]
% [     0.01644,    x3]
% [ -0.00098813, x3*x5]
% [ 0.000076129, x3*x4]
% [    0.014969,    x2]
% [  -0.0023337, x2*x5]
% [   0.0028077, x2*x4]
% [ -0.00012646, x2*x3]
% [   -0.027613,    x1]
% [ -0.00036617, x1*x5]
% [ -0.00043459, x1*x4]
% [ -0.00011518, x1*x3]
% [  -0.0009348, x1*x2]
% [      3.9964,   1.0]
% [   0.0004941,  x2^2]
% [  0.00014775,  x3^2]
% [    0.010017,  x5^2]
%% How to Use the Outputs
reg=MultiPolyRegress(X,Y,2);
%% PowerMatrix
% You have a new data point you would like to evaluate using the computed
% fit. Lets assume for the sake of argument that the 250th row of X is in
% fact a new data point.
NewDataPoint=X(250,:);
NewScores=repmat(NewDataPoint,[length(reg.PowerMatrix) 1]).^reg.PowerMatrix;
% Unless you have a stake in deeply understanding this code, don't try to
% make sense of the NewScores matrix, or what follows. I sometimes have to
% stare at it for a couple minutes to figure it out myself. I am happy
% discuss this in detail upon specific request.
EvalScores=ones(length(reg.PowerMatrix),1);
for ii=1:size(reg.PowerMatrix,2)
    EvalScores=EvalScores.*NewScores(:,ii);
end
yhatNew=reg.Coefficients'*EvalScores % The estimate for the new data point.
% You have to repeat this procedure for every new data point. It might be
% time saving to write a function that does this automatically, however I
% never needed this functionality, so I wouldn't count on me writing that.
%% Scores
% Unless you have a stake in deeply understanding this code, don't try to
% make sense of the Scores matrix, chances are you won't ever need to use
% it.
%% Cofficients
% This was shown earlier at the input examples.
%% Legend
% This was shown earlier at the input examples.
%% yhat
% This is the vector of estimates using your new fit. The scatter plot you
% see when you use the 'figure' option is generated using scatter(yhat,y).
%% Residuals
% This is defined as y-yhat. Can be used for a residual plot to see if
% ordinary least squares assumptions hold true.
%% Goodness of Fit Measures
% These are useful not only in assesing the accuracy of your fit, but also
% comparing different candidates. For example, lets see how different
% powers compare for the same fit for the above dataset. I personally would
% like to use CVMAE as my comparative error measure, since it is more
% sensitive to overfitting.
for ii=1:5
    reg=MultiPolyRegress(X,Y,ii);
    CVMAE(ii)=reg.CVMAE;
end
CVMAE
% It turns out, the second degree polynomial is the best option. One way to
% interpret this number is saying the fit makes in average a 3.66% error with
% respect to the original Y when estimating. 


