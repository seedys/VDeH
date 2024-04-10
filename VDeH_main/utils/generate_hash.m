function [recall, precision, mAP, rec, pre, retrieved_list] = generate_hash(exp_data, param, method)
% input: 
%          data: 
%              data.train_data
%              data.test_data
%              data.db_data
%          param:
%              param.nbits---encoding length
%              param.pos---position
%          method: encoding length
% output:
%            recall: recall rate
%            precision: precision rate
%            evaluation_info: 

train_data = exp_data.train_data;
test_data = exp_data.test_data;
db_data = exp_data.db_data;
trueRank = exp_data.knn_p2;

WtrueTestTraining = exp_data.WTT;
pos = param.pos;

ID.train = exp_data.train_ID;
ID.test = exp_data.test_ID;
ID.query = param.query_ID;

clear exp_data;

[ntrain, D] = size(train_data);

%several methods
switch(method)

    %% Our proposed VDeH
    case 'VDeH'
        addpath('./Method-VDeH/');
	fprintf('......%s start...... \n\n', 'VDeH');
        m = 4;  % default parameter for VDeH
        hdata = vdeh(train_data,[test_data;train_data],m,floor(param.nbits /log2(m)));
        B_trn = compactbit(hdata(1001:end,:));
        B_tst = compactbit(hdata(1:1000,:));
        clear db_data;
        
    % Locality sensitive hashing (LSH)
     case 'LSH'
        addpath('./Method-LSH/');
	fprintf('......%s start ......\n\n', 'LSH');
        LSHparam.nbits = param.nbits;
        LSHparam.dim = D;
        LSHparam = trainLSH(LSHparam);
        [B_trn, ~] = compressLSH(train_data, LSHparam);
        [B_tst, ~] = compressLSH(test_data, LSHparam);
        clear db_data LSHparam;
          
end

% compute Hamming metric and compute recall precision
Dhamm = hammingDist(B_tst, B_trn);
[~, rank] = sort(Dhamm, 2, 'ascend');
clear B_tst B_trn;
choice = param.choice;
switch(choice)
    case 'evaluation_PR_MAP'
        clear train_data test_data;
        [recall, precision, ~] = recall_precision(WtrueTestTraining, Dhamm);
	[rec, pre]= recall_precision5(WtrueTestTraining, Dhamm, pos); % recall VS. the number of retrieved sample
        [mAP] = area_RP(recall, precision);
        retrieved_list = [];
    case 'evaluation_PR'
        clear train_data test_data;
        eva_info = eva_ranking(rank, trueRank, pos);
        rec = eva_info.recall;
        pre = eva_info.precision;
        recall = [];
        precision = [];
        mAP = [];
        retrieved_list = [];
    case 'visualization'
        num = param.numRetrieval;
        retrieved_list =  visualization(Dhamm, ID, num, train_data, test_data); 
        recall = [];
        precision = [];
        rec = [];
        pre = [];
        mAP = [];
end

end
