clc 
I=imread('1_1.jpg');
lengthr=[];
widthr=[];
bw = im2bw(I);
G = fspecial('gaussian',[5 5],2);
Ig = imfilter(I,G,'same');
bw1=im2bw(Ig);
figure % displaying the images.
imshow(bw1)

[labeled,numObjects] = bwlabel(bw1,4);
graindata = regionprops(labeled,'basic');
maxArea = max([graindata.Area]);
minArea = min([graindata.Area]);
 biggestGrain = find([graindata.Area]==maxArea);
meanArea = mean([graindata.Area]);
 no_object=max(labeled(:));
 fg=sort([graindata.Area]);
%  removing the small peices of broken rice.
 bw2 = bwareaopen(bw1,fg(12));
 [labeled2,numObjects2] = bwlabel(bw2,4);
 % of broken rice
 brokenpercentage=(numObjects2/numObjects)*100;

% finding the rice properties
s = regionprops(bw2,'Orientation',...
    'MajorAxisLength','MinorAxisLength','Eccentricity','Perimeter','BoundingBox','Centroid');
for i=1:length(s)
    gh=s(i).BoundingBox;
    % apply distance formula to find width and length of the rice
    hk=sqrt(gh(1)^2+gh(2)^2);
    lk=sqrt(gh(3)^2+gh(4)^2);
    lengthr=[lengthr;hk];
    widthr=[widthr;lk];
end
figure
imshow(bw2)
hold on

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

for k = 1:length(s)
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    plot(x,y,'r','LineWidth',2);
end
hold off