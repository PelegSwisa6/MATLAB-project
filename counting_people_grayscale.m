video = VideoReader('cctv2.mp4');

% defining the roi in which people pass by
roiWidth = 15;
roiHeight = 15; 
x = (video.Width - roiWidth)/1.5;
y = (video.Height - roiHeight)/1.1;

count = 0;
flag = false;

% defining the background that we compare the next frames to.
% from the background extract the average pixels value.
frame = readFrame(video);
first_frame = rgb2gray(frame);
first_frame_cropped = imcrop(first_frame, [x y roiWidth roiHeight]);
avg_first = mean(first_frame_cropped(:));

disp(avg_first);
figure;

while hasFrame(video)
    current_frame = readFrame(video);
    current_frame = rgb2gray(current_frame);
    current_frame = insertShape(current_frame, 'Rectangle', [x y roiWidth roiHeight], 'LineWidth', 1);
    current_frame_cropped = imcrop(current_frame,  [x y roiWidth roiHeight]);
    
    subplot(121); imshow(current_frame);
    subplot(122); imshow(current_frame_cropped);
    drawnow;

    avg_current = mean(current_frame_cropped(:));
    
    if(abs(avg_current - avg_first) <= 20 && flag)
        count = count + 1;
        disp(num2str(count))
        flag = false;
    end
    if(abs(avg_current - avg_first) > 20)
        flag = true;
    end
end

disp(['Total number of people: ' num2str(count)]);