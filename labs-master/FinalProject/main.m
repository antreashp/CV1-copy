
run('D:/Users/Andy/Downloads/Desktop/vlfeat-0.9.21/toolbox/vl_setup');

dir_path='D:/Users/Andy/Downloads/Desktop/CV/labs-master/FinalProject/Caltech4/ImageData/';
shuffle=0;
number_each_class=100; %half of these is vocabulary so the vocab_size is (this*4/2) and the train size is  (this*4/2) 
number_each_class_test=50; % test size = this*4
classes=[1,2,3,4];   
svmtype="liblinear";

lsabool="false";

numComponents = 25;
k=400;                %number of visual words
colorspaces=[5];

type="sift";
stepOrSIFTsamples=32;


[vocabulary,train_data,test_data]=give_me_data(number_each_class,number_each_class_test,shuffle,classes);
%% 

get_vocalulary(vocabulary,dir_path,k,colorspaces,type,stepOrSIFTsamples);
%% 
% 
% 
vo = matfile('vocabulary.mat');
clusters = vo.clusters_idx;

meh = matfile('C.mat');
C = meh.C;
% 
% 
% %% 
%  
%% 
shuffle=1;
create_histograms(train_data,"train",classes,dir_path,k,colorspaces,C,type,stepOrSIFTsamples,shuffle)
% %% 
% 
%% 
shuffle=1;
create_histograms(test_data,"test",classes,dir_path,k,colorspaces,C,type,stepOrSIFTsamples,shuffle)
% 
% 
%% % % 
maps=[];


file= matfile('histogs.mat');
counts=file.all_counts;

file=matfile('test_counts');
test_counts=file.test_counts;


bag=bagOfWords(string(1:1:400),counts)
% for doc =1: size(couns,1)
%     
% end

lsa = fitlsa(bag,numComponents)
data=lsa.DocumentScores;

for  i=1:size(data,1)
    
    for j =1:size(data,2)
        if data(i,j)>0
            data(i,j)=data(i,j)/max(data(i,:));
        
        else
            data(i,j)=-data(i,j)/min(data(i,:));
            
            
        end
    end
end


%% 
[model_airplane,ap1] = train_a_class(1,svmtype,lsabool,data);

%% 
[model_cars,ap2] = train_a_class(2,svmtype,lsabool,data);
%% 
[model_faces,ap3] = train_a_class(3,svmtype,lsabool,data);
%% 
[model_motorbikes,ap4] = train_a_class(4,svmtype,lsabool,data);
%% 
% [model_all] = train_a_class(5);
%% 
models={model_airplane,model_cars,model_faces,model_motorbikes};
%  

kx=100;

classes=[1,2,3,4];

[test] = load_data(classes);
if  lsabool~= "true"
    [map,results1,results2,results3,results4,ap,tpos] = test_model(models,test{1},test{2},test{3},type);
else
    
    data=transform(lsa,test_counts)
    
for  i=1:size(data,1)
    
    for j =1:size(data,2)
        if data(i,j)>0
            data(i,j)=data(i,j)/max(data(i,:));
        
        else
            data(i,j)= -data(i,j)/min(data(i,:));
            
            
        end
    end
end
    [map,results1,results2,results3,results4,ap,tpos] = test_model(models,data,test{2},test{3},type);
end
maps=cat(1,maps,map);

vo = matfile('ds.mat');
vo = vo.ds;
voc_size=size(vo,1);
method="normal";
create_results(results1,results2,results3,results4,voc_size,method,map,ap,tpos)

