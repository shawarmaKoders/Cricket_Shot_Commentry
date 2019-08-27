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



const img = new Image();

img.src = '/home/puneet/Work/minor1/data/training/scoop/100_scoop_main.jpg';
img.onload=()=>{
  console.log("Helllllllllllllllllo")
}

console.log(img)

const canvas = createCanvas(200, 300);

const ctx = canvas.getContext('2d');
  setTimeout(async function(){
    ctx.drawImage(img, 0, 0,img.width,img.height);

  const input =tf.browser.fromPixels(canvas);

  singlePoseOutput(input).then((data)=>
  {
    console.log(data);
  })
  },
1000);


async function singlePoseOutput(imageElement) {
  const imageScaleFactor = 0.50;
  const flipHorizontal = false;
  const outputStride = 16;

  const net = await posenet.load();

  const pose = await net.estimateSinglePose(imageElement, imageScaleFactor, flipHorizontal, outputStride);
  return pose;
};

// arr=['cover','cut','leg',"pull","scoop","straight"]
// list={}
// for (i=0;i<6;i++)
// {
//   testFolder="./data/training/"+arr[i];
//   final=[];
//   fs.readdir(testFolder, (err, files) => {
//     files.forEach(file => {
//       f=testFolder+"/"+file
//       abc(f).then((data)=>
//       {
//       }).catch((err)=>
//       {
//         console.log(err)
//       })

//     });
//   });
// }

// async function abc(file)
// {
//   const img = new Image();
//   img.src = file;  
//   const canvas = createCanvas(200, 300);
  
//   const ctx = canvas.getContext('2d');

//   ctx.drawImage(img, 0, 0,img.width,img.height)
  
//     const input =tf.browser.fromPixels(canvas);
  
//     singlePoseOutput(input).then((data)=>
//     {
//       console.log(data);

//     })
//  }




