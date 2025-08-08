% Gait Analysis Program

while (1) % Loop to repeat the analysis
    close all; % Close figures from previous analyses
    % Clear variables selectively to avoid residual data without resetting functions
    clearvars;
    % Keep command window history to aid debugging (previously used clc)
    fprintf('\t\t GAIT ANALYSIS\n');
    
    % Load data from a selected file
    while (1)
        [filename, folder] = uigetfile('*.txt'); % Allow selection of .txt files
        if filename == 0 % No file selected
            fprintf('No file selected.\nPlease select one to continue.\n');
            continue;
        end
        fullfilename = fullfile(folder, filename);
        [~, fileNameOnly, extension] = fileparts(fullfilename);
        if strcmpi(extension, '.txt') == 0
            fprintf('The selected file is not of type .txt\nPlease select a file with the correct extension\n');
            continue;
        end
        fileData = fileread(fullfilename);
        if isempty(fileData)
            fprintf('The file must contain numerical data.\nPlease select a valid file.\n');
            continue;
        end
        break;
    end
    
    name = input('What is the subject''s name? ', 's');
    color = [rand, rand, rand]; % Random color for plotting
    
    % Ask for scale (pixels per meter)
    while (1)
        scale = input('What is the scale (pixels per meter)? ', 's');
        scale = str2num(scale);
        if isempty(scale) || scale <= 0 % Only allows valid input
            disp('Invalid input. Try again.');
            continue;
        end
        break;
    end
    
    % Ask for frames per second (fps)
    while (1)
        fps = input('Enter the number of frames per second: ', 's');
        fps = str2num(fps);
        if isempty(fps) || fps <= 0 % Only allows valid input
            disp('Invalid input. Try again.');
            continue;
        end
        break;
    end
    
    fileData = str2num(fileData); % Convert the data from string to numerical array
    
    % Process the data
    x = (fileData(:, 1)) / scale; % Apply the scale from pixels to meters
    y = (-1 * fileData(:, 2)) / scale; % Apply the scale and adjust the y-axis
    % Trim vectors to ensure the number of frames is a multiple of 15
    while mod(length(x), 15) ~= 0
        x(end) = [];
        y(end) = [];
    end
    x = x - min(x); % Shift x to start at 0
    y = y - min(y); % Shift y to start at 0

    % Initialize variables for plotting
    frameCount = length(x) / 5; % Number of frames
    figure; % Open a new figure
    set(gcf, 'Position', get(0, 'Screensize')); % Full screen figure
    subplot(3, 2, [1 2]); % Subplot for Stick Bar
    sgtitle(name); % Display the subject's name
    set(gca, 'Color', 'k'); % Black background
    title('Stick Bar'); % Subplot title
    xlabel('Meters'); % x-axis label
    ylabel('Meters'); % y-axis label
    axis('equal'); % Maintain aspect ratio
    hold on; % Hold the plot for updating

    % Plot the Stick Bar animation
    for i = 1:frameCount
        a = 5 * i - 4; % Start index for markers
        b = 5 * i;     % End index for markers
        plot(x(a:b), y(a:b), 'color', color); % Plot markers for each frame
        pause(1 / fps); % Pause to simulate fps
    end

    % Calculate mean positions for one stride
    division = length(x) / 3; % Divide data into three strides
    meanX = (x(1:division) + x(division + 1:2 * division) + x(2 * division + 1:3 * division)) / 3;
    meanY = (y(1:division) + y(division + 1:2 * division) + y(2 * division + 1:3 * division)) / 3;

    % Calculate joint angles
    pointCount = length(meanX) / 5; % Number of points in the mean data
    percentage = (1 / pointCount : 1 / pointCount : 1) * 100; % Percentage of gait cycle
    hipAngle = zeros(1, pointCount);
    kneeAngle = zeros(1, pointCount);
    ankleAngle = zeros(1, pointCount);

    for i = 1:pointCount
        % Hip angle calculation
        deltax = meanX(5 * i - 4) - meanX(5 * i - 3); % Adjacent side
        deltay = meanY(5 * i - 4) - meanY(5 * i - 3); % Opposite side
        hypotenuse = sqrt(deltax^2 + deltay^2); % Hypotenuse
        hipAngle(i) = acosd(deltax / hypotenuse); % Angle in degrees

        % Knee angle calculation
        deltax = meanX(5 * i - 2) - meanX(5 * i - 3);
        deltay = meanY(5 * i - 3) - meanY(5 * i - 2);
        hypotenuse = sqrt(deltax^2 + deltay^2);
        kneeAngle(i) = acosd(deltax / hypotenuse);

        % Ankle angle calculation
        deltax = meanX(5 * i) - meanX(5 * i - 1);
        deltay = meanY(5 * i) - meanY(5 * i - 1);
        hypotenuse = sqrt(deltax^2 + deltay^2);
        ankleAngle(i) = acosd(deltax / hypotenuse);
    end

    % Smooth the angle data
    hipAngle = smooth(hipAngle);
    kneeAngle = smooth(kneeAngle);
    ankleAngle = smooth(ankleAngle);

    % Plot hip angle
    subplot(3, 2, 3);
    plot(percentage, hipAngle, 'color', color);
    title('Hip');
    formatPlot(); % Apply formatting

    % Plot knee angle
    subplot(3, 2, 4);
    plot(percentage, kneeAngle, 'color', color);
    title('Knee');
    formatPlot(); % Apply formatting

    % Plot ankle angle
    subplot(3, 2, 5);
    plot(percentage, ankleAngle, 'color', color);
    title('Ankle');
    formatPlot(); % Apply formatting

    % Calculate and plot pendulum angle
    pendulumAngle = zeros(1, pointCount);
    for i = 1:pointCount
        deltax = meanX(5 * i - 1) - meanX(5 * i - 3);
        deltay = meanY(5 * i - 3) - meanY(5 * i - 1);
        hypotenuse = sqrt(deltax^2 + deltay^2);
        pendulumAngle(i) = acosd(deltax / hypotenuse);
    end

    subplot(3, 2, 6);
    plot(percentage(1), pendulumAngle(1), 'color', color);
    title('Pendulum');
    formatPlot(); % Apply formatting
    axis([0 100 45 135]); % Adjust axis for pendulum plot
    hold on;

    % Animate pendulum angle
    for i = 2:pointCount
        X = [percentage(i - 1) percentage(i)];
        Y = [pendulumAngle(i - 1) pendulumAngle(i)];
        plot(X, Y, 'color', color);
        pause(1 / fps);
    end

    pause(3); % Pause to appreciate the graphs
    text(2, 60, 'Press any key to close', 'Color', 'w');
    waitforbuttonpress; % Wait for key press to close the figure
    close all; % Close the figure

    % Display information
    fprintf('The scale in %s''s gait is %d pixels/meter.\n', name, scale);
    fprintf('The data contains %d points.\n', length(x));
    fprintf('%d frames were taken in the 3 strides.\n', frameCount);

    % Ask if the user wants to perform another analysis
    continueAnalysis = input('To analyze another gait, press 1: ', 's');
    if ~strcmpi(continueAnalysis, '1') % Exit the loop if not '1'
        break;
    end
end

fprintf('Thank you for using the program.\n');

% Function to format plots
function formatPlot()
    set(gca, 'Color', 'k'); % Black background
    xline(0, '-', {'Postural', 'Phase'}, 'Color', [1 1 1]); % Postural phase label
    xline(60, '--', {'Swing', 'Phase'}, 'Color', [1 1 1]); % Swing phase label
    xline(60, '--', 'Color', [1 1 1]); % Dashed line between phases
    xlim([0 100]); % x-axis limits
    xlabel('Percentage'); % x-axis label
    ylabel('Degrees'); % y-axis label
end
