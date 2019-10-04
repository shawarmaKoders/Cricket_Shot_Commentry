  var posenet=require('@tensorflow-models/posenet');
const tf = require('@tensorflow/tfjs');
require('@tensorflow/tfjs-node');
const coverFolder = './data/training/cover';
const cutFolder = './data/training/cut';
const pullFolder = './data/training/pull';
const scoopFolder = './data/training/scoop';
const straightFolder = './data/training/straight';
const legFolder = './data/training/leg';
const fs = require('fs');
const { createCanvas, Image } = require('canvas');


async function singlePoseOutput(imageElement) {
  var imageScaleFactor = 0.50;
  var flipHorizontal = false;
  var outputStride = 16;

  var net = await posenet.load();

  var pose = await net.estimateSinglePose(imageElement, imageScaleFactor, flipHorizontal, outputStride);
  return pose;
};

arr=['cover','cut','leg',"pull","scoop","straight"]
list={}
//for (i=0;i<6;i++)
//{
  testFolder="./testing/"+arr[0];
  final=[];
  fs.readdir(testFolder, (err, files) => {
    files.forEach(file => {
      f=testFolder+"/"+file
      abc(f).then((data)=>
      {
        
      }).catch((err)=>
      {
        console.log(err)
      })

    });
  });
//}

async function abc(file)
{console.log("AAAA")
  var img = new Image();
    
  var canvas = createCanvas(200, 300);
  
  var ctx = canvas.getContext('2d');
  img.onload=()=>{
    ctx.drawImage(img, 0, 0,img.width,img.height)
  
    var input =tf.browser.fromPixels(canvas);
    singlePoseOutput(input).then((data)=>
    {
      console.log("H")
      console.log(data);
      
      var str=data.score+","+data.keypoints[0].position.x+","+data.keypoints[0].position.y+","+data.keypoints[0].score+","+
              data.keypoints[1].position.x+","+data.keypoints[1].position.y+","+data.keypoints[1].score+","+
              data.keypoints[2].position.x+","+data.keypoints[2].position.y+","+data.keypoints[2].score+","+
              data.keypoints[3].position.x+","+data.keypoints[3].position.y+","+data.keypoints[3].score+","+
              data.keypoints[4].position.x+","+data.keypoints[4].position.y+","+data.keypoints[4].score+","+
              data.keypoints[5].position.x+","+data.keypoints[5].position.y+","+data.keypoints[5].score+","+
              data.keypoints[6].position.x+","+data.keypoints[6].position.y+","+data.keypoints[6].score+","+
              data.keypoints[7].position.x+","+data.keypoints[7].position.y+","+data.keypoints[7].score+","+
              data.keypoints[8].position.x+","+data.keypoints[8].position.y+","+data.keypoints[8].score+","+
              data.keypoints[9].position.x+","+data.keypoints[9].position.y+","+data.keypoints[9].score+","+
              data.keypoints[10].position.x+","+data.keypoints[10].position.y+","+data.keypoints[10].score+","+
              data.keypoints[11].position.x+","+data.keypoints[11].position.y+","+data.keypoints[11].score+","+
              data.keypoints[12].position.x+","+data.keypoints[12].position.y+","+data.keypoints[12].score+","+
              data.keypoints[13].position.x+","+data.keypoints[13].position.y+","+data.keypoints[13].score+","+
              data.keypoints[14].position.x+","+data.keypoints[14].position.y+","+data.keypoints[14].score+","+
              data.keypoints[15].position.x+","+data.keypoints[15].position.y+","+data.keypoints[15].score+","+
              data.keypoints[16].position.x+","+data.keypoints[16].position.y+","+data.keypoints[16].score+","+"cover\n";
              console.log(str);
      fs.appendFile("cover.csv",str, function (err) {
        if (err) throw err;
        console.log('Saved!');
      })

    }).catch((msg)=>{
      console.log(msg)
    })
  }
  img.src = file;
 }




