clc;clear;
shuffled = load('shuffled.mat');
  
x_train (1:629, 1:10) = [shuffled.shuffled(1:69, 2:11); shuffled.shuffled(140:699,2:11)]; %training data 
x_test (1:70, 1:10) = shuffled.shuffled(70:139, 2:11); %test data 
y_pred (1:70) = 0;
xy_distances (1:629) = 0;  %will store all the distances calculated

p = 2;  %1 is manhattan distance, 2 is euclidean distance
k = 10; %number of nearest neighbors we want to consider
falsepositive = 0;
falsenegative = 0;
positive = 0;
negative = 0;
benign = 0;
malignant = 0;
idx = 0;
accuracy = 0;
for i = 1:70
    for j = 1:629
        xy_distances(j) = (abs(x_test(i,1) - x_train(j,1)).^p +  abs(x_test(i,2) - x_train(j,2)).^p +  abs(x_test(i,3) - x_train(j,3)).^p +  abs(x_test(i,4) - x_train(j,4)).^p +  abs(x_test(i,5) - x_train(j,5)).^p +  abs(x_test(i,6) - x_train(j,6)).^p +  abs(x_test(i,7) - x_train(j,7)).^p +  abs(x_test(i,8) - x_train(j,8)).^p +  abs(x_test(i,9) - x_train(j,9)).^p).^(1/p) ;  
        
    end
    for w = 1:k
        [v,maximum] = max(xy_distances);
        [val,idx] = min(xy_distances);
        xy_distances(idx) = v; %set the min to max so we can find the next minimum
        
        if x_train(idx,10) == 2
            benign = benign + 1;
        end
        if x_train(idx,10) == 4
            malignant = malignant + 1;
        end
        
    end
    if benign >= malignant
        y_pred(i) = 2;
    end
    if malignant > benign
        y_pred(i) = 4;
    end
    benign = 0;
    malignant = 0;
    
end
for i = 1:70
   if y_pred(i) == x_test(i,10)  %check for accuracy
       accuracy = accuracy + 1;
   end
   if x_test(i,10) == 4     %check total count of positive 
       positive = positive + 1;
   end
   if x_test(i,10) == 2     %check total count of negative
       negative = negative + 1;
   end
   if y_pred(i) == 4 && x_test(i,10) ~= 4   
       falsepositive = falsepositive + 1;
   end
   if y_pred(i) == 2 && x_test(i,10) ~= 2
       falsenegative = falsenegative + 1;
   end
end

accuracy = accuracy / 70;
sensitivity = (positive - falsepositive)/positive;
specificity = (negative - falsenegative)/negative;