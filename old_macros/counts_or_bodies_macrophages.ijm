//Macrophage Cell Body Macro 

//Steps
/* 1. Open up image and split channels 
 * 2. De-noise entire image
 * 3. Threshold image
 * 4. Convert to Z-stack 
 * 5. Analyze particles? 
 * 6. Measure the area of each circle OR counts? 

 */

//Obtain image info
run("Open...");
getTitle();
title = getTitle(); 

//Close out DAPI and Asyn channel
selectWindow(title);
run("Split Channels");
selectWindow("C2-" + title);
close();
selectWindow("C1-" + title);
close();

//Run Pure Denoise for TUJ1 and MHC2
selectWindow("C3-" + title);
run("PureDenoise ...");
waitForUser("Click when channel is de-noised"); 
selectWindow("C4-" + title);
run("PureDenoise ...");
waitForUser("Click when channel is de-noised"); 

//Run thresholded on Denoised Images
selectWindow("Denoised-C3-" + title);
rename("TUJ1");
run("16-bit");
run("Auto Threshold", "method=Triangle white stack use_stack_histogram");
//setAutoThreshold("Triangle dark stack");
//run("Convert to Mask", "method=Triangle background=Dark calculate black");
//setOption("BlackBackground", false);
//run("Convert to Mask");
run("Magenta");
/////////////////////
selectWindow("Denoised-C4-" + title);
rename("Macrophage");
run("16-bit"); 
/*
setAutoThreshold("Triangle dark stack");
run("Convert to Mask", "method=Triangle background=Dark calculate black");
run("Convert to Mask");
*/
run("Auto Threshold", "method=Triangle white stack use_stack_histogram");
run("Yellow");

//Merge thresholded stacks
run("Merge Channels...", "c6=TUJ1 c7=Macrophage create"); 

//Convert stacks to Z-stack 
run("Z Project...", "projection=[Max Intensity]");


waitForUser("Analysis is Complete"); 





//Denoising options
// run("Remove Outliers...", "radius=1 threshold=25 which=Bright");



// Go through the phan paper and various plugins mentioned on the Sholl analysis 
