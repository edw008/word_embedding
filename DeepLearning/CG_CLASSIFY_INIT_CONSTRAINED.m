% Function:
% Makes error back propagation for the top layer only of the NN, applying
% penalty barrier method
% Inputs:
% VV: Vector of all class weights serialized row-wise
% Dim: Vector of sizes of top layer (input and output)
% wTopProbs: The activations at the input of the top layer
% target: The associated target
% wTopProbs_prev: The top layer activations of the previous mapping phase
% w_class_prev: The class weights of previous mapping phase
% Output:
% f: The negative of the error
% df: The back-propagated delta (to be multiplied by input data to update
% the weigths
function [f, df] = CG_CLASSIFY_INIT_CONSTRAINED(VV, Dim, wTopProbs, target, wTopProbs_prev, w_class_prev);
alpha = 0.1;
l1 = Dim(1);
l2 = Dim(2);
N = size(wTopProbs,1);
% Do decomversion.
w_class = reshape(VV,l1+1,l2);
wTopProbs = [wTopProbs  ones(N,1)];  

targetout = exp(wTopProbs*w_class);
targetout = targetout./repmat(sum(targetout,2),1,size(target,2));
f = -sum(sum( target(:,1:end).*log(targetout))) ;

wTopProbs_prev = [wTopProbs_prev  ones(N,1)]; 
targetout_prev = exp(wTopProbs_prev*w_class_prev);
targetout_prev = targetout_prev./repmat(sum(targetout_prev,2),1,size(target,2));
e = -sum(sum( target(:,1:end).*log(targetout_prev))) ;

f = f + alpha * (f-e)^2;
  
%IO = (targetout-target(:,1:end)) + alpha*(targetout-target(:,1:end)-(targetout_prev-target(:,1:end)));
IO = (targetout-target(:,1:end)) + 2*alpha*(f-e)*(targetout-target(:,1:end)-(targetout_prev-target(:,1:end)));
Ix_class=IO; 
dw_class =  wTopProbs'*Ix_class; 

df = [dw_class(:)']'; 

