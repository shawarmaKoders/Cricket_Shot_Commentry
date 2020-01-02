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

# Generation Of Commentry
For video and audio integration, few audio clips were generated from a app, approximately 5-7 sample audio clips per shot. The video samples were cropped to get 3-4 sec video clip from youtube, it was done so as to get maximum frames of batsman while playing the shot.For deployment of our service we first pick up frames from video consecutively and feed that image to our CNN model, the model generates a csv file of the classified shot probability which it gets in each frame. After which another separate csv is generated which provides the max count value of the the shot in all frames and after getting the frame number in which the shot is correctly identified the audio is synchronized with the video in that frame.The audio file is chosen randomly from the available ones
