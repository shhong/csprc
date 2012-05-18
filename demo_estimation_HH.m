%% First of all, we read the data in.
v    = binread('demo_data/v_201.bin');
stim = binread('demo_data/stim_201.bin');

%% And we prepare the data for processing..
pdata = make_PRC_data({stim},{v},struct('mean',0.0839,...
                                        'std', 0.014,...
                                        'srate',20000,...
                                        'L',401));
%% Here we create an estimator object.
cs = csprc(dftBasis(401,201), 'dantzig');

%% We run the cross-validation with 30 folds.
etas = linspace(.1,.5,20);
xvs = xvalidate(cs, pdata, Kfold(pdata, 30), etas);

figure;
subplot(121)
plot(etas,xvs)
xlabel('\eta')
ylabel('XV error')
hold on, plot(etas(5),xvs(5),'or')

%%
% We find that the XV error reaches the minimum at eta = 0.1842 and
% evaluate the PRC at the point.

prc = cs.evaluate(pdata, etas(5));
theta = linspace(0,1,numel(prc));

wsta = getWSTA(pdata); % we compute the WSTA for comparison.

subplot(122)
plot(theta, wsta, theta, prc,'r');
xlabel('Phase')
ylabel('PRC')
legend('WSTA','CS')
axis tight
