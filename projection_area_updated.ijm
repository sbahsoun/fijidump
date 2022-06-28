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


//prompt user to select areas 
run("ROI Manager...");
setTool("polygon");
roiManager("Delete");
waitForUser("Add all macrophages to ROI manager. Hit ok when done"); 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//have to duplicate each roi and then select for manual id 
			roi_count = roiManager("count");
			print("Number of ROIs");
			print(roi_count);
			run("Set Measurements...", "area min centroid center perimeter shape integrated area_fraction limit display redirect=None decimal=3");
			for(i=0; i < roi_count; i++) {
				roiManager("Select", i);
				run("Duplicate...", "duplicate");
			//	roi_name = Roi.getName;
			//	selectWindow(roi_name);
				rename("ROI" + i + 1);
                selectWindow("ROI" + i + 1);
				roiManager("Measure"); }

				

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Measurements 
//run("Set Measurements...", "area min centroid center perimeter shape integrated area_fraction limit display redirect=None decimal=3");
//roiManager("Measure");
roiManager("Show All with labels");
roiManager("List");
selectWindow("Results"); 

waitForUser("Analysis is Complete"); 

/*
//get area and perimeter measurements for all ROIS selected 
run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3"); 
run("Analyze Particles...", " show=Outlines display exclude clear summarize add"); 
selectWindow("Results"); 
*/
