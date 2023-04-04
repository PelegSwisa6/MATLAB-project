function myGUI()
    % Create a figure with a specified size
    f = figure('Name', 'My GUI', 'Units', 'normalized', 'Position', [0.2 0.2 0.6 0.6]);
    video = VideoReader('cctv1.mp4');
    start_of_video = video.CurrentTime;
    
    % Create four buttons
    btn_upload = uicontrol('Style', 'pushbutton', 'String', 'Upload New Video', ...
        'Units', 'normalized', 'Position', [0.05 0.8 0.2 0.1], 'Callback', @upload_callback);
    btn_start = uicontrol('Style', 'pushbutton', 'String', 'Start', ...
        'Units', 'normalized', 'Position', [0.05 0.65 0.2 0.1], 'Callback', @start_callback);
    btn_delete = uicontrol('Style', 'pushbutton', 'String', 'Delete', ...
        'Units', 'normalized', 'Position', [0.05 0.5 0.2 0.1], 'Callback', @delete_callback);
    btn_quit = uicontrol('Style', 'pushbutton', 'String', 'Quit', ...
        'Units', 'normalized', 'Position', [0.05 0.1 0.2 0.1], 'Callback', @quit_callback);
    
    % Create an axes to display images
    ax = axes('Units', 'normalized', 'Position', [0.3 0.05 0.65 0.9]);
    imshow(readFrame(video), 'Parent', ax);
    
    function upload_callback(hObject, eventdata)
        % Open a dialog box to select a video file
        [filename, pathname] = uigetfile({'*.mp4;*.avi','Video Files (*.mp4,*.avi)'});
        if isequal(filename,0)
            disp('User selected Cancel');
        else
            % Load the video and first frame
            video = VideoReader(fullfile(pathname, filename));
            frame = readFrame(video);
            imshow(frame, 'Parent', ax);
            drawnow;
            % hold on;
        end
    end

    function start_callback(hObject, eventdata)
        CreateStruct.Interpreter = 'tex';
        CreateStruct.WindowStyle = 'modal';
        
        if ~isempty(allchild(ax))
            video.CurrentTime = start_of_video;
            count = counting_people_RGB(video);
            m = msgbox({['\fontsize{14} Total Customers: ' num2str(count)]}, 'Success', CreateStruct);
        end

    end

    function delete_callback(hObject, eventdata)
        delete(video);
        cla(ax,'reset');
        disp('Delete button clicked');
    end

    function quit_callback(hObject, eventdata)
        close(f);
        close all;
    end
end
