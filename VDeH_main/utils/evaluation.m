function [score, recall] = evaluation(Wtrue, Dhat)
%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    Dhat  = estimated distances
%   The next inputs are optional:
%    fig = figure handle
%    options = just like in the plot command
%
% Output:
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  score(n) = --------------------------------------------------------------
%               exp. # of total pairs inside hamming ball of radius <= (n-1)
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs 

[Ntest, Ntrain] = size(Wtrue);
total_good_pairs = sum(Wtrue(:));

% find pairs with similar codes
score = zeros(100,1);
for n = 1:length(score)
    j = find(Dhat<=((n-1)+0.00001));
    
    %exp. # of good pairs that have exactly the same code
    retrieved_good_pairs = sum(Wtrue(j));
    
    % exp. # of total pairs that have exactly the same code
    retrieved_pairs = length(j);

    score(n) = retrieved_good_pairs/retrieved_pairs;
    recall(n)= retrieved_good_pairs/total_good_pairs;
end
