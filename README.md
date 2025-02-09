# Cyclic-Gait-Analysis-Tool
Matlab program for cyclic gait analysis

## Overview
This Matlab program is designed to analyze the gait cycle based on movement data. It processes text files with X and Y coordinates of 5 body points, calculates joint angles (hip, knee, ankle), and visualizes the gait cycle through plots. The program allows the user to enter parameters such as scale (pixels/meter) and frames per second (fps).

## How it Works

**1. Video Recording:**

- The subject is recorded walking on a flat, obstacle-free surface. Reference markers are placed on the wall to indicate one meter for pixel-to-meter conversion.
- The subject has 5 markers on the sagittal plane: ***iliac crest, hip joint, knee joint, ankle joint, and the toes***.
- It is recommended that the camera records at 60 fps and is positioned at a level angle.

**2. Data Processing:**

1. The video is converted into individual frames using TotalVideoConverter.
2. The 5 points are manually marked in each frame using [ImageJ](https://imagej.net/ij/features.html) software. The software generates a text file containing the X and Y coordinates for each point.

![Frame Example](images/FrameExample.jpg)

**3. Analysis in MATLAB:**

The user selects a ```.txt``` file containing the coordinates and enters the subject's name, scale (pixels/meter), and fps.
The program calculates the joint angles and displays them through plots.

## Requirements
- Software: Matlab (any recent version).
- Curve Fitting Toolbox (Matlab)
- Data: A ```.txt``` file containing X and Y coordinates for key points in each frame. The total number of lines must be a multiple of 5 (5 points per frame). An example of a ```.txt``` file is given in this repo.

## Visualizations
- ***Stick Bar:*** Displays the subject's gait cycle.
- ***Joint Angles:*** Plots the angular transitions of the hip, knee, and ankle.
- ***Pendulum Movement:*** Plots the angle between the hip and the ankle.

- ***Example Image:***

![Plot Example](images/PlotExample.jpg)

## Credits
- Velasco Lopez Jose Carlos
- Barajas Renteria Jennifer Polet
- Hernandez Gomez Oscar Ivan
- Hernandez Leon Yaisiri Monserrat
- Hernandez Puga Adriana Sarahy
