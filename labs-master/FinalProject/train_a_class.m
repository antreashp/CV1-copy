function [model,ap] = train_a_class(class,type,lsa,data)
%TRAIN_A_CLASS Summary of this function goes here
%   Detailed explanation goes here

dir_path='D:/Users/Andy/Downloads/Desktop/CV/labs-master/FinalProject/Caltech4/ImageData/';
if class==1
    if lsa=="true"
        
X=data;        
%     X = matfile('histogs.mat');
%     X = X.all_counts;
    else
        
        
    X = matfile('airplanesX.mat');
    X = X.airplanesX;
    end
%     aX=aX(2:size(aX,1),:,:);
    Y = matfile('airplanesY.mat');
    Y = Y.airplanesY;
%     aY=aY(2:size(aY,1),:,:);
   id = matfile('airplanes_id.mat');
    id = id.airplanes_id;

elseif class==2
    
    
    
    if lsa=="true"
        
        
    X=data;
    else
    X = matfile('carsX.mat');
X = X.carsX;
    end
% aX=aX(2:size(aX,1),:,:);
Y = matfile('carsY.mat');
Y = Y.carsY;
% aY=aY(2:size(aY,1),:,:);

   id = matfile('cars_id.mat');
    id = id.cars_id;
elseif class==3
    
    if lsa=="true"
        
        
    X=data;
    else
    X = matfile('facesX.mat');
    X = X.facesX;
%     aX=aX(2:size(aX,1),:,:);
    end    
Y = matfile('facesY.mat');
    Y = Y.facesY;
% aY=aY(2:size(aY,1),:,:);

   id = matfile('faces_id.mat');
    id = id.faces_id;
elseif class==4

    if lsa=="true"
        
X=data;        
%     X = matfile('histogs.mat');
%     X = X.all_counts;
    else
    X = matfile('motorbikesX.mat');
X = X.motorbikesX;

    end
% aX=aX(2:size(aX,1),:,:);
Y = matfile('motorbikesY.mat');
Y = Y.motorbikesY;
% aY=aY(2:size(aY,1),:,:);
    
   id = matfile('motorbikes_id.mat');
    id = id.motorbikes_id;
end

% size(aX)
% size(aY)



X=squeeze(X);
% aY=squeeze(aY);
if type=="matlab"
c = cvpartition(200,'KFold',40);
opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,'AcquisitionFunctionName','expected-improvement-plus');
model = fitcsvm(X,Y,'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);
elseif type=="liblinear"
    
 best = train(double(Y), sparse(X),[' -C  -s 0 '  ] );
 model = train(double(Y),sparse(X), [' -s 0  -c ' num2str(best(1)) ] );
   ap=best(2);
else
max=-9999;
    X_trn=X(1:(size(X,1)/2),:);
    Y_trn=Y(1:(size(Y,1)/2),:);
    X_val=X((size(X,1)/2):(size(X,1)),:);
    Y_val=Y((size(Y,1)/2):(size(Y,1)),:)  ;         %t 1 -g 10 -r 1 -d 3  -n 0.38 -c 10'
    for c=5:9
        for g=1:10    
            for t=0:3
                for s=0:2
                    for d=3:4
                        
                         if s ~= 1
                             modelsvm = svmtrain(double(Y_trn), sparse(X_trn), ['-s ' num2str(s) ' -t ' num2str(t) '  -d ' num2str(d) '    -g ' num2str(2^g) ' -c ' num2str(2^c) '-b 1  ' ])
                             [lbl, acc, dec] = svmpredict(double(Y_val), sparse(X_val), modelsvm);

                                s
                                c
                                g
                             if acc(1)>max
                                 D=d
                                 S=s
                                 C=c
                                   G=g
                                   T=t
                                   max=acc(1);
                             end
                        end
                    end
                end
            end
        end
    end
    D
    S
    C
    G
    T
    max
    model=svmtrain(double(Y), sparse(X), ['-s ' num2str(S) ' -t ' num2str(T) '   -d ' num2str(D) ' -g ' num2str(2^G) '   -c ' num2str(2^C) '-b 1  '])
    
  ap=max;
    
%     best = train(double(Y), sparse(X),[' -C  -s 2  '  ] );
%  n=-17:17;
% for i=1:numel(n)   % n = {-17,...,17}
%         c=2^n(i);   
%        c=c+2
%         % create model
%         model = svmtrain(double(Y), sparse(X),  ['-s 4 -t 1 -g 10 -r 1 -d 3  -n 0.38 ' num2str(c) ])
%     % option: -t 4 -> precomputed kernel
%         [lbl, acc, dec] = svmpredict(double(Y), sparse(X), model);
%         accuracy(i) = acc(1);
% end
%     
%  plot(accuracy);
%     xlabel('c'), ylabel('Accuracy'); title('Accuracy vs. c');
%  [~, i] = max(accuracy); % find the best value
%     c = 2^n(i); 
%     model = svmtrain(double(Y), sparse(X), ['-s 4 -t 1 -g 10 -r 1 -d 3  -n 0.38 ' num2str(c) ])

end
  
end

