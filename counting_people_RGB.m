function count = counting_people_RGB(video) 

    % video = VideoReader('cctv1.mp4');
    count = 0;
    flag = false;

    % defining the background that we compare the next frames to.
    first_frame = readFrame(video);
    f1 = figure('Name', 'Set up');
    imshow(first_frame)
    title('mark the space where people enter');
    
    % add user input for the roi
    roi1 = drawrectangle;
    if ishghandle(f1)
        wait(roi1);
        entrance_box = roi1.Position; % get the entrance area from the ROI chosen by the user
        entrance_text = entrance_box(1:2); 
        close(f1);

        sensor = [entrance_box(1:2) entrance_box(3:4) * 0.4]; % limiting the sensor to a smaller rectangle
        first_frame_cropped = imcrop(first_frame, sensor); % defining the background

        avg_first = mean(first_frame_cropped(:));
       
        f2 = figure('Name', 'Playback');
        

        while hasFrame(video) && ishandle(f2)
       
            current_frame = readFrame(video);
            current_frame_cropped = imcrop(current_frame, entrance_box);
            sensor_view = imcrop(current_frame, sensor);

            current_frame = insertShape(current_frame, 'Rectangle', entrance_box, 'LineWidth', 2); 
            current_frame = insertText(current_frame, entrance_text, "Entrance sensor");
            current_frame_cropped = insertShape(current_frame_cropped, 'Rectangle', sensor, 'LineWidth', 2);

            subplot(131); imshow(current_frame);
            text(0, 0, ['total people: ' num2str(count)], 'FontSize', 16, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
           % subplot(132); imshow(current_frame_cropped);
           % text(0, 0, 'entrance', 'FontSize', 16,'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
           % subplot(133); imshow(sensor_view)
           % text(0, 0, 'sensor', 'FontSize', 16, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
             drawnow;

            % calculate current frame average pixels color
            avg_current = mean(sensor_view(:));

            % compare the value with the first frame
            if(abs(avg_current - avg_first) <= 10 && flag)
                count = count + 1;
                disp(num2str(count))
                flag = false;
            end

            if(abs(avg_current - avg_first) > 10)
                flag = true;
            end
          
        end

        if ishghandle(f2)
            close(f2);
        end
    end
   
    disp(['Total number of people: ' num2str(count)]);
end