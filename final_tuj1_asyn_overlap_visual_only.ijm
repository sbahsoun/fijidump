//open prompt 
run("Open...");
getTitle();
title = getTitle(); 

//background subtraction
selectWindow(title);
run("Subtract Background...", "rolling=20 stack");

//split channels
selectWindow(title);
run("Split Channels");

//denoise each
selectWindow("C3-" + title);
rename("TUJ1");
run("PureDenoise ...");
waitForUser("Click when channel is de-noised"); 
selectWindow("Denoised-TUJ1");
setAutoThreshold("Triangle dark");
setOption("BlackBackground", true);
run("Convert to Mask", "method=Triangle background=Dark calculate black");

selectWindow("C2-" + title);
rename("Asyn");
run("PureDenoise ...");
waitForUser("Click when channel is de-noised"); 
selectWindow("Denoised-Asyn");
setAutoThreshold("Triangle dark");
setOption("BlackBackground", true);
run("Convert to Mask", "method=Triangle background=Dark calculate black");


//recombine with colors
run("Merge Channels...", "c1=Denoised-TUJ1 c2=Denoised-Asyn create keep");



