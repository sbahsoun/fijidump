//Macrophage projection area Macro

//Steps
/* 1. Open up image and split channels 
 * 2. De-noise entire image
 * 3. Threshold image
 * 4. Convert to Z-stack 
 * 5. Select ROIs
 * 6. Automatically quantify Area
 * Questions for Phil: 
 * Macrophage tagging system? YES; coordinates save for spatial distribution! Do we need each macrophage to be identified on the image? YES 
 * >need to ask: 
 * Which macrophages are we looking at projection area for? On neurons or not? 
 * Do we need a merged image to do this? Or just look at one channe
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
selectWindow("C3-" + title);
close();

//Run Pure Denoise for TUJ1 and MHC2
selectWindow("C4-" + title);
run("PureDenoise ...");
waitForUser("Click when channel is de-noised"); 

//Run thresholded on Denoised Images

selectWindow("Denoised-C4-" + title);
rename("Macrophage");
run("16-bit"); 

run("Auto Threshold", "method=Triangle white stack use_stack_histogram");


//Convert stacks to Z-stack 
run("Z Project...", "projection=[Max Intensity]");

//Open ROI manager prompt and give directions for projection area 
//waitForUser("Use the polygon tool to select the projection area for the macrophages "); 
run("ROI Manager...");
setTool("polygon");
waitForUser("Click when all macrophages have been selected"); 

//Measurements 
run("Set Measurements...", "area limit display redirect=None decimal=3");
roiManager("Measure");
roiManager("Show All with labels");
roiManager("List");
/*
 * 
 */
//Close all option 

waitForUser("Analysis is Complete"); 

