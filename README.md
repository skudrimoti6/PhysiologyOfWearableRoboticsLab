# PhysiologyOfWearableRoboticsLab
Identified aponeuroses in ultrasound images from test patients’ walking data using ML in MATLAB. PURA Thesis: Development of a Machine Learning Tool to Post-Process Rectus Femoris Ultrasound Images.

Ultrasound images of rectus femoris muscle were previously collected from walking trials. The aponeuroses in ultrasound images were then traced and indetified manually using Fiji software. A machine learning mdoel was developed to automatically trace the top and bottom aponeuroses in a singular ultrasound image of the rectus femoris. This project was an extension of NJ Cronin's DL Track model: https://github.com/njcronin/DL_Track.

Main Files: 
Image_Preprocessing.m preprocesses the image by cropping, cleaning, and resizing the images
TopApo_Model_Training.m trains the model to indentify top aponeuroses
BotApo_Model_Training trains the model to identify bottom aporneuroses
PURA_Final_Report.pdf details the project overview and presents the results
