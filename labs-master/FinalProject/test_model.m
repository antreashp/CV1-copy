function [map,results1,results2,results3,results4,ap,tpos]  = test_model(model,test_data,test_Y,test_id,type)
%TEST_MODEL Summary of this function goes here,ap
%   Detailed explanation goes here

% rp=randperm(size(test_data,1));
% test_data=test_data(rp,:,:);
% test_Y=test_Y(rp,:,:);

% model=cell2struct(model);
count_pos=0;
% test_data=reshape(test_data,[size(test_data,1)*size(test_data,2),size(test_data,3)]);

% test_data=permute(test_data,[2,1]);
% test_data=unique(test_data);
% size(model,2)

        results1=[];
     results2=[];
      results3=[];
       results4=[];

% length(model)

dir_path='D:/Users/Andy/Downloads/Desktop/CV/labs-master/FinalProject/Caltech4/ImageData/';

predictions=[];

    pred=double.empty(4,0);
    pred1=zeros(size(test_Y,1),1);
    pred2=zeros(size(test_Y,1),1);
    pred3=zeros(size(test_Y,1),1);
    pred4=zeros(size(test_Y,1),1);
for image=1:size(test_data,1)
 
    max1=-999999;
%      max2=999999;
    img_preds=[];
    max_idx1=0;
     for cls=1:size(model,2)
         if type=="matlab"
         
%        [prediction,~,score]=predict(double(test_Y(image,1)), sparse(test_data(image,:,:)),model{cls});
       [prediction,score]=predict(model{cls},test_data(image,:,:));
         score=score(2);
         elseif type=="liblinear"
       
       [prediction,~,score]=predict(double(test_Y(image,1)), sparse(test_data(image,:,:)),model{cls});
       
         else
       [prediction,~,score]=svmpredict(double(test_Y(image,1)), sparse(test_data(image,:,:)),model{cls});
      
 
         end      
         
         if cls==1
             pred1(image)=score;
         elseif cls==2
             pred2(image)=score;
         elseif cls==3
             pred3(image)=score;
         else
             pred4(image)=score;
         end
             
             
         
%        pred(cls,:)=cat(2,pred(cls,:),score');      
%        "meh"   
%        score
%           prediction
% %           
        img_preds=cat(1,img_preds,[prediction,score]);
          
       
%     if prediction ==1

        

        if score>max1 
%             "meeeeeeeeeeeeeeh"
          max1=score; 
          max_idx1=cls;
          
       end
%     else
%         if score<max2
%           max2=score; 
%           max_idx2=cls;
%           
%        end
%     end

%    predictions=cat(1,predictions,max_idx);
% 

    
     end
        img_path=char(strcat(convertStringsToChars(dir_path),convertStringsToChars(test_id(image,1))));
%         figure(1);
%         imshow(imread(img_path));
%         pause(2);
%         img_preds
%         disp(max_idx1);
%     if max1>max2
%         
%         max_idx=max_idx1;
%     else
%         max_idx=max_idx2;
%     end

    predictions=cat(2,predictions,max_idx1);
    
   
    
    
    
    
    if max_idx1==1
       results1=cat(2,results1,test_id(image,1));
    elseif max_idx1==2
        results2=cat(2,results2,test_id(image,1));
   
    elseif max_idx1==3
        results3=cat(2,results3,test_id(image,1));
   
    else
        results4=cat(2,results4,test_id(image,1));
   
    end
    
%     if test_Y(image)==max_idx
%        count_pos=count_pos+1; 
%     end
end
% accuracy=count_pos/size(test_data,1);







% pred1=pred(1,:);
% pred1 = sort(pred1);
% pred1=(pred1+1) ./2;
% 
% 
% pred2=pred(2,:);
% pred2 = sort(pred2);
% pred2=(pred2+1) ./2;
% pred3=pred(3,:);
% pred3 = sort(pred3);
% pred3=(pred3+1) ./2;
% pred4=pred(4,:);
% pred4 = sort(pred4);
% pred4=(pred4+1) ./2;


ap=[0 0 0 0];

pred=zeros(4,size(test_Y,1));
pred(1,:)=pred1';
[pred1,order]=sort(pred1);
pred(1,:)=pred(1,order);
% results1=results1(order);
pred(2,:)=pred2';
[pred2,order]=sort(pred2);
pred(2,:)=pred(2,order);

% results2=results2(order);
pred(3,:)=pred3';
[pred3,order]=sort(pred3);
pred(3,:)=pred(3,order);

% results3=results3(order);
pred(4,:)=pred4';
[pred4,order]=sort(pred4);
pred(4,:)=pred(4,order);

% results4=results4(order);

for i =1:4
    
    labels = test_Y == i;
    labels = 2*labels -1;
    
    
   [rc, pr, info] = vl_pr(labels, pred(i,:)) ;
   ap(i)=info.ap_interp_11;
   
   
end
tpos=zeros(4,1);
for i=1:size(test_Y)
    [maxim,inx]=max(pred(:,i));
  
        
       if inx==test_Y(i)
          tpos(inx)=tpos(inx)+1; 
       end

   
end

% results1=pred(1,:);
% results2=pred(2,:);
% results3=pred(3,:);
% results4=pred(4,:);

map=mean(ap);
% 
% map=0;
% pos=0;
% for i =size(test_Y,1)
%     if pred1(i)==1 && test_Y(i)==1
%       pos=pos+1;
%       map=map+ (pos/i);
% 
%     end
% end
% maps=cat(1,maps,map);
% 
% 
% map=0;
% pos=0;
% for i =size(test_Y,1)
%     if pred2(i)==1 && test_Y(i)==1
%       pos=pos+1;
%       map=map+ (pos/i);
% 
%     end
% end
% maps=cat(1,maps,map);
% 
% 
% map=0;
% pos=0;
% for i =size(test_Y,1)
%     if pred1(i)==1 && test_Y(i)==1
%       pos=pos+1;
%       map=map+ (pos/i);
% 
%     end
% end
% maps=cat(1,maps,map);
% 
% 
% map=0;
% pos=0;
% for i =size(test_Y,1)
%     if pred1(i)==1 && test_Y(i)==1
%       pos=pos+1;
%       map=map+ (pos/i);
% 
%     end
% end
% maps=cat(1,maps,map);
% 
% 
% 
% 
% 
% %     results={results1,results2,results3,results4};
% for i =1:size(test_Y,1)
%     if predictions(i)==test_Y(i)
%         pos=pos+1;
%         map=map+(pos/i);
%     end

% map=map/size(test_Y,1);
% [averagePrecision,recall,precision] =evaluateDetectionPrecision(predictions,test_Y)
% 

% end

end