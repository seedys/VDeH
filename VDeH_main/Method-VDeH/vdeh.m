function [hdata] = vdeh(Sdata,data,m,t)
% generate voronoi diagram hashing space 
% for a given distance matrix
  
[sn,~]=size(Sdata);   
[n,~]=size(data);   
IDX=[]; 

parfor i = 1:t 
    subIndex = datasample(1:sn, m, 'Replace', false);
    tdata=Sdata(subIndex,:);
    dis=pdist2(tdata,data);
    [~, centerIdx] = min(dis);
    IDX=[IDX; centerIdx+(i-1)*m]; 
end 
 
IDR = repmat(1:n,t,1);
V=IDR-IDR+1; 
ndata = sparse(IDR(:)',IDX(:)',V(:)',n,t*m);
hdata = full(ndata);

end

