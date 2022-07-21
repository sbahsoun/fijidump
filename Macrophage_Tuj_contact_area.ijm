//Projection area and perimeter macro for macrophages on whole mount images

//ask user to input range parameters 
title = "Set File Location";
  width=1024; height=512;
  desktop = "filepath"


  Dialog.createNonBlocking("filez");
  Dialog.addMessage("Create a new file on your desktop. Copy the filepath and paste it below. Add a backslash at the end of the path ")
  Dialog.addString("Macrophage Filepath", desktop);
  Dialog.show();
  desktop = Dialog.getString();;

//Open image and obtain image information
run("Open...");
getTitle();
title = getTitle();
saved_title = getTitle(); 

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
rename("max_c4"); 
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
run("Measure");

// prompt user to save the results here and then go back w/ the remainder of the program
selectWindow("Results");
rename(saved_title); 
saveAs("Results", desktop + saved_title + "area_and_perimeter.csv");
//waitForUser("Copy macrophage area and perimeters to your spreadsheet before preceding with analysis! Hit OK when done!"); 
selectWindow("Results");

selectWindow("max_c4");

roiManager("Show None");
roiManager("Show All with labels");
roiManager("Show None");

run("Clear Results");

//prompt user to select areas 
run("ROI Manager...");
setTool("polygon");
roiManager("Delete");
waitForUser("Add all macrophages projection area to ROI manager. Press t to add. Hit ok when done"); 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//have to duplicate each roi and then select for manual id 
			roi_count = roiManager("count");
			run("Set Measurements...", "area min centroid center perimeter shape integrated limit display redirect=None decimal=3");
			for(i=0; i < roi_count; i++) {
				selectWindow("max_c4");
				roiManager("Select", i);
				run("Duplicate...", "duplicate");
				saveAs("Tiff", desktop + saved_title + "ROI" + i + ".tif");
				selectWindow("max_c4");
				roiManager("Select", i);
				roiManager("Measure");
				}

				

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Measurements 
//run("Set Measurements...", "area min centroid center perimeter shape integrated area_fraction limit display redirect=None decimal=3");
//roiManager("Measure");
roiManager("Show All with labels");
roiManager("List");
selectWindow("Results");
saveAs("Results", desktop + saved_title + "projection_area.csv"); 

waitForUser("Analysis is Complete"); 

