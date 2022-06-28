waitForUser("Welcome to area and perimeter macro for microglia. Press OK to continue. ");


//Open image and obtain image information
run("Open...");
getTitle();
title = getTitle();

//convert image to 8-bit for thresholding purposes
selectWindow(title); 
run("8-bit");

//setOption("BlackBackground", false);
//run("Convert to Mask");
//run("Invert LUT");

waitForUser("Connect or separate macrophages as needed w/ pen tool. Hit OK when done.");


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
//selectWindow("Results"); 


selectWindow(title);

waitForUser("Check outlines to see if all microglia were selected. If not, go back manually and measure.");

selectWindow("Results"); 