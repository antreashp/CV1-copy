% % 
maps=[];

type="liblinear";

lsabool="tre";

numComponents = 25;
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
[model_airplane,ap1] = train_a_class(1,type,lsabool,data);

%% 
[model_cars,ap2] = train_a_class(2,type,lsabool,data);
%% 
[model_faces,ap3] = train_a_class(3,type,lsabool,data);
%% 
[model_motorbikes,ap4] = train_a_class(4,type,lsabool,data);
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
