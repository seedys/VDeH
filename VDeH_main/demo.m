%% Demo for SIGMOD'25
%% Voronoi Diagram Encoded Hashing: A No-Learning Data-Dependent Approach for Large-Scale Information Retrieval

close all; clear; clc;
addpath('./utils/');

% Data preparation
db_name = 'CIFAR10-Gist512';
load ./DB-FeaturesToBeProcessing/Cifar10-Gist512.mat;
db_data = X(:, 1:end);

% settings
loopnbits = [64,128]; % [64,128,256,...,2048]
runtimes = 2; % repeat times 
hashmethods = {'VDeH','LSH'}; % a no-learning LSH for comparison
nhmethods = length(hashmethods);
param.query_ID = [];
param.choice = 'evaluation_PR_MAP';
param.pos = [1:10:40 50:50:1000];


for k = 1:runtimes
    fprintf('The %d run time, start constructing data\n\n', k);
    exp_data = construct_data(db_name, double(db_data), param, runtimes);
    fprintf('Constructing data finished\n\n');
    for i =1:length(loopnbits)
        fprintf('======start %d bits encoding======\n\n', loopnbits(i));
        param.nbits = loopnbits(i);
        for j = 1:nhmethods
             [recall{k}{i, j}, precision{k}{i, j}, mAP{k}{i,j}, rec{k}{i, j}, pre{k}{i, j}, ~] = generate_hash(exp_data, param, hashmethods{1, j});
             fprintf('The mAP result: %.2f\n\n', mAP{k}{i,j});
        end
    end
    clear exp_data;
end


% average MAP
for j = 1:nhmethods
    for i =1: length(loopnbits)
        tmp = zeros(size(mAP{1, 1}{i, j}));
        for k = 1:runtimes
            tmp = tmp+mAP{1, k}{i, j};
        end
        MAP{i, j} = tmp/runtimes;
    end
    clear tmp;
end
    
