//Projection area and perimeter macro for macrophages on whole mount images

//Open image and obtain image information
run("Open...");
getTitle();
title = getTitle();


//split channels, close out unneeded ones
selectWindow(title);
run("Split Channels"); 
selectWindow("C2-" + title);
close(); 
selectWindow("C1-" + title);
close(); 
selectWindow("C3-" + title); 
close();

//convert image to 8-bit for thresholding purposes
selectWindow("C4-" + title); 
run("8-bit");

//adjust brightness so that the user can see the image better
run("Enhance Contrast", "saturated=0.35");

//ask user to QC images before beginning the thresholding process
//waitForUser("Scrub through the Z-stack. If you observe any speckling or excess noise in front or back channels, adjust parameters in next dialog box.");

//ask user to input range parameters 
title = "Set Parameters";
  width=512; height=512;
  upper = 1
  lower = nSlices

  Dialog.createNonBlocking("scrub");
  Dialog.addMessage("Scrub through the Z-stack. If you observe any speckling or excess noise in front or back channels, adjust parameters below:")
  Dialog.addNumber("Upper Interval", upper);
  Dialog.addNumber("Lower Interval", lower);
  Dialog.show();
  upper = Dialog.getNumber();
  lower = Dialog.getNumber();;

//dialog command to insert range intervals 

run("Duplicate...", "title=C4PFF duplicate range=" + upper + "-" + lower);


//prompt user to set manual threshold
run("Threshold...");
waitForUser("Set the threshold (two windows), then hit OK when done");


//insert manual thresholding portion here



run("Z Project...", "projection=[Max Intensity]");
//run("Close-");
setForegroundColor(255, 255, 255); 


//prompt user to select all macrophages
waitForUser("Connect broken macrophages with pen tool. Hit OK when done.");

setForegroundColor(119, 119, 119); 
//prompt user to select all macrophages
waitForUser("Select all macrophages using the floodfill tool (paintbucket). Click OK when done");

//isolate these macrophages
run("Threshold...");
setThreshold(88, 158); 
setOption("BlackBackground", false);
run("Convert to Mask");
setThreshold(255, 255);

//get area and perimeter measurements for all ROIS selected 
run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3");
run("Analyze Particles...", " show=Outlines display exclude clear summarize add"); 
run("ROI Manager...");
//run("Select All");
roiManager("Measure");
 
//run("Analyze Particles...", " show=Outlines display exclude clear summarize add"); 
selectWindow("Results"); 
