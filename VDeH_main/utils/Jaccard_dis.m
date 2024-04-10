function D=Jaccard_dis(P1, P2)

D = zeros(size(P1,1),size(P2,1));
for pi1 = 1:size(P1,1)
    for pi2 = 1:size(P2)
        set1 = find(P1(pi1,:)==1);
        set2 = find(P2(pi2,:)==1);
        x1 = 0;
        for i = length(set1)
            for j = 1:length(set2)
                if set1(i) == set2(j)
                    x1 = x1+1;
                end
            end
        end
%         x1 = length(intersect(set1,set2));
        x2 = length(unique([set1,set2]));
        D(pi1,pi2) = 1-x1/(x2+0.0000001);
    end
end

end