clc
clear all
%vid=videoinput('winvideo',1);                    %for video input
%preview(vid);
%set(vid,'ReturnedColorspace','rgb');
%pause(2);              
%IM1=getsnapshot(vid);
%IM1= 255 * ones(593, 521,3, 'uint8');
IM1=imread('bkgrnd.jpg');                        %path to background image
figure(1);
subplot(2,2,1);
imshow(IM1);
title('Background');
pause(2);                                        %path to gesture image                  
%IM2=getsnapshot(vid);                                              
IM2=imread('hand.jpg');
figure(1);
subplot(2,2,2);
imshow(IM2);
title('Gesture');
IM3=IM1-IM2;
%subplot(2,2,3);
%imshow(IM3);
IM3_grey=rgb2gray(IM3);
thresh=graythresh(IM3_grey);
IM4=im2bw(IM3_grey,thresh);
subplot(2,2,3)
imshow(IM3);
title('subtracted image');
IM5 = bwareaopen(IM4, 10000);
IM5=imfill(IM5,'holes');
IM5 = imerode(IM5,strel('disk',15));                                        %erode image
IM5 = imdilate(IM5,strel('disk',20));
IM5 = medfilt2(IM5, [5 5]);
IM5 = bwareaopen(IM5, 10000); 
subplot(2,2,4);
imshow(IM5);
IM5 = flipdim(IM5,1);


%[B,L] = bwboundaries(IM5,'noholes');
[B] = bwboundaries(IM5,'noholes');

REG=regionprops(IM5,'all'); %calculate the properties of regions for objects found 
CEN = REG.Centroid;                  
BND = B{1};                                                     %boundary set for object
BNDx = BND(:,2);                                                %Boundary x coord
BNDy = BND(:,1);                                                %Boundary y coord
          
pkoffset = (CEN(:,2));                                          %Calculate peak offset point from centroid
[pks,locs] = findpeaks(BNDy,'minpeakheight',pkoffset);         %find peaks in the boundary in y axis with a minimum height greater than the peak offset
pkNo = size(pks,1);                                           %finds the peak Nos
pkNo_STR = sprintf('%2.0f',pkNo);                              %puts the peakNo in a string
            
figure(2);imshow(IM5);
hold on;
plot(BNDx, BNDy, 'b', 'LineWidth', 5);                          %plot Boundary
plot(CEN(:,1),CEN(:,2), '*');                                   %plot centroid
plot(BNDx(locs),pks,'rv','MarkerFaceColor','y','lineWidth',2);  %plot peaks
text(20,180,['Finger(s):' pkNo_STR],'color','g','Fontsize',15);
