% Insert data
Lr=csvread("delta_matrix_lr.csv",1,0);
Ij=csvread("delta_matrix_ij.csv",1,0);

% Original features
OriginalLr=Lr(:,11);
OriginalIj=Ij(:,11);
[RejectOr,pOr]=kstest2(OriginalLr,OriginalIj);

% Green features
GreenLr=Lr(:,12);
GreenIj=Ij(:,12);
[RejectGr,pGr]=kstest2(GreenLr,GreenIj);

% Red Features
RedLr=Lr(:,13);
RedIj=Ij(:,13);
[RejectRe,pRe]=kstest2(RedLr,RedIj);

%p-values
pvalues=[pOr,pGr,pRe];