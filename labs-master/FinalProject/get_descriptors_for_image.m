function [da] = get_descriptors_for_image(img,colorspaces,type,stepOrSIFTsamples)
%GET_DESCRIPTORS_FOR_IMAGE Summary of this function goes here
%   Detailed explanation goes here

%[rgb , opponent , hsv , xyz , hsi]
    da=[];
%     length(size(img))
    f_all=[];
    if length(size(img))>2
    for colorspace=1:size(colorspaces,2)

        if colorspaces(colorspace)==1 
            R  = double(img(:,:,1));
            G  = double(img(:,:,2));
            B  = double(img(:,:,3));

            ia=rgb2gray(img);
            ia=im2single(ia);
            [f_a,~] = vl_sift(ia);
            
             [Ix, Iy] = vl_grad(R) ;
              mod      = sqrt(Ix.^2 + Iy.^2) ;
              ang      = atan2(Iy,Ix) ;
              grd      = shiftdim(cat(3,mod,ang),2) ;
              grd      = single(grd) ;

            
            dr  = vl_siftdescriptor(grd, f_a) ;
            
              [Ix, Iy] = vl_grad(G) ;
              mod      = sqrt(Ix.^2 + Iy.^2) ;
              ang      = atan2(Iy,Ix) ;
              grd      = shiftdim(cat(3,mod,ang),2) ;
              grd      = single(grd) ;

            dg  = vl_siftdescriptor(grd, f_a) ;
            
            
              [Ix, Iy] = vl_grad(B) ;
              mod      = sqrt(Ix.^2 + Iy.^2) ;
              ang      = atan2(Iy,Ix) ;
              grd      = shiftdim(cat(3,mod,ang),2) ;
              grd      = single(grd) ;

            db = vl_siftdescriptor(grd, f_a) ;
            da=cat(1,da,dr);
            da=cat(1,da,dg);
            da=cat(1,da,db);

          
        end

        if colorspaces(colorspace)==2 
            R  = img(:,:,1);
            G  = img(:,:,2);
            B  = img(:,:,3);
            %convert to opponent space
            O1 = single((R-G)./sqrt(2));
            O2 = single((R+G-2*B)./sqrt(6));
            O3 = single((R+G+B)./sqrt(3));
            ia=rgb2gray(img);
            ia=im2single(ia);
            [f_a,~] = vl_sift(ia);
            
             [Ix, Iy] = vl_grad(O1) ;
              mod      = sqrt(Ix.^2 + Iy.^2) ;
              ang      = atan2(Iy,Ix) ;
              grd      = shiftdim(cat(3,mod,ang),2) ;
              grd      = single(grd) ;

            
            dr  = vl_siftdescriptor(grd, f_a) ;
            
              [Ix, Iy] = vl_grad(O2) ;
              mod      = sqrt(Ix.^2 + Iy.^2) ;
              ang      = atan2(Iy,Ix) ;
              grd      = shiftdim(cat(3,mod,ang),2) ;
              grd      = single(grd) ;

            dg  = vl_siftdescriptor(grd, f_a) ;
            
            
              [Ix, Iy] = vl_grad(O3) ;
              mod      = sqrt(Ix.^2 + Iy.^2) ;
              ang      = atan2(Iy,Ix) ;
              grd      = shiftdim(cat(3,mod,ang),2) ;
              grd      = single(grd) ;

            db = vl_siftdescriptor(grd, f_a) ;
            da=cat(1,da,dr);
            da=cat(1,da,dg);
            da=cat(1,da,db);

          
            
        end
        
         if colorspaces(colorspace)==4 
            %SURF Features
            R  = img(:,:,1);
            G  = img(:,:,2);
            B  = img(:,:,3);
  
            gray=rgb2gray(img);
            points=detectSURFFeatures(gray)
            
           
            
            
            [rf,~] = extractFeatures(R,points,'FeatureSize',128);
            [gf,~] = extractFeatures(G,points,'FeatureSize',128);
            [bf,~] = extractFeatures(B,points,'FeatureSize',128);
            d=[];
            d=cat(1,d,rf');
            d=cat(1,d,gf');
            d=cat(1,d,bf');
            da=cat(2,da,d);
         end
        if colorspaces(colorspace)==5 
            %KAZE Features
            R  = img(:,:,1);
            G  = img(:,:,2);
            B  = img(:,:,3);
            gray=rgb2gray(img);
            points=detectKAZEFeatures(gray);
            
%             points=selectStrongest(points,300);
            
            
            [rf,~] = extractFeatures(R,points,'FeatureSize',128);
            [gf,~] = extractFeatures(G,points,'FeatureSize',128);
            [bf,~] = extractFeatures(B,points,'FeatureSize',128);
            
               d=[];
            d=cat(1,d,rf');
            d=cat(1,d,gf');
            d=cat(1,d,bf');
            da=cat(2,da,d);
        end
            if colorspaces(colorspace)==6 
            %KAZE Features
       
            gray=rgb2gray(img);
            points=detectKAZEFeatures(gray);
            
           
            
            
            [rf,~] = extractFeatures(R,points,'FeatureSize',128);
          
            
               d=[];
            d=cat(1,d,rf');
%             d=cat(1,d,rf');
%             d=cat(1,d,rf');
            da=cat(2,da,d);
        end
    end
    else
            
            [f,d]=sift(img,type,stepOrSIFTsamples);
            d=double(d);
%            f_all=cat(2,f_all,f);
%    d=[];
          
            da=cat(1,da,d);
            da=cat(1,da,d);
            da=cat(1,da,d);
    end
     da =da';
    
end
