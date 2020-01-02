# Automated_Cricket_Shot_Commentry
The problem which we are addressing is about recognizing different shots played by a
batsman in a cricket match by analysing the video of the played shot and providing
commentary for the same.Our task was to minimize the latency in delivering the commentary and maximizing the success rate.Henceforth we decided to implement a deep
convolutional neural network based action detection for it on real time basis.<br />
Therefore we intend to classify six types of cricket shot by breaking the video into
frames and then applying CNN on it and the maximum confidence score of the shot which we achieve over all the frames, we classify shot to that category.

# Processing The Input

1. Video was broken into respective frames(images).
2. For each frame obtained, the following steps were done.<br />
  a. Conversion of images to grey scale.<br />
  b. Changing dimension of image to 100x100.<br />
  c.Necessary rotations of images were done(where ever required).<br />
  d.Reducing intensity range from (0,255) to (0,1). <br /><br />

All the data gathered from above steps were combined together to make a single
csv file.
![alt text](https://github.com/Puneet-Jain-18/Cricket_Shot_Commentry/blob/master/finalOutputs/Preprocessing.png)

# Generation Of Commentry
For video and audio integration, few audio clips were generated from a app, approximately 5-7 sample audio clips per shot. The video samples were cropped to get 3-4 sec video clip from youtube, it was done so as to get maximum frames of batsman while playing the shot.For deployment of our service we first pick up frames from video consecutively and feed that image to our CNN model. The model generates a csv file of the classified shot probability which it gets in each frame. After which another separate csv is generated which provides the max count value of the the shot in all frames and after getting the frame number in which the shot is correctly identified the audio is synchronized with the video in that frame.The audio file is chosen randomly from the available ones

# CNN Model Features

At first we provide a 100x100 pixel grayscale image to our model after which, In our model we have<br />
A. 3, convolutional layers of 64,128 and 236 of 3x3 filter, each of which have Relu as activation<br />
B. 3 Max pooling layers of size 2x2 each applied after convolutional layer.<br />
C. 3 Dropout layers of with 0.25 parameter.<br />
D. 1 Flatten layer<br />
E. 2 Dense layers in which for one Relu activation function is used and in the other<br />
F. one softmax is used to get probability of each class<br />

![alt text](https://github.com/Puneet-Jain-18/Cricket_Shot_Commentry/blob/master/finalOutputs/CNN.png)

# Running The Project
The project is based on linux OS and we have used python and R as major languages for development.
To build the project 
1. Open terminal and locate to video_processing directory.Now Run commands
````
source venv/bin/activate
pip3 install -r requirements.txt
pip freeze > requirements.txt
````
This should install the required python dependencies in your system.

2. Now to install R dependencies run script r_dependencies
````
Rscirpt "install_dependencies.R"
````
Ensure that all the packages have been sucessfully installed.If any of thoes fails you would need to build it from source form the corresponding github repo.
3. Now we need to pick out frames from the videos for CNN to process them.
````
./final_shell_script.sh
````
this command would extract frame from videos, preprocess them for different filters and give them to the CNN model for classification. CNN model shall return the probability of each frame for each class. ie we would have a matrix of (No. of frames)X6. Now we need to make decision on which shot is being played in the video on basis of that information.
4. Our final script makes this decision on basis of differnt parameters like no of shots classified in particular class and max confidence level for a frame etc. Run
````
./decision_shell.sh
````
This shall make our decision and then integrate commentry to video iteslf such that the audio of video is replaced with the actural commentry for that video.<br/>
<b>The video is placed in final_output directory.</b><br />

![alt text](https://github.com/Puneet-Jain-18/Cricket_Shot_Commentry/blob/master/finalOutputs/sample_output.png)
# Future Work
This was a really fun project and helped us learn a lot about deep learning and neural nets. We were able to obtain high accuracy for image classification but could not obtain such high accuracy on video classification.
1. One looking for extending this project could make use of pretrained models like vgg or resnet50 to improve accuracy of videos and overcome the boundation of limited data we have.
2. the dataset iteslf could be reconstructed as current dataset only shows the batsman whereas in videos we have a total field view containing bowler, umpire etc which is affection the accuracy of model.
3. 3-D CNN could be directly applied if one has sufficient amount of video dataset. This could extremely increase the robustness of model and lead to a better classification.
<h4>Thanks-For-Your-Time</h4>
