//projection area fixed macro

//Obtain image tags
run("Open...");
getTitle();
title = getTitle(); 


//Beginning pre-processing steps
selectWindow(title);
run("Split Channels");

//close out unneeded channels
selectWindow("C1-" + title);
close();
selectWindow("C2-" + title);
close(); 
selectWindow("C3-" + title); 
close(); 

//run macrophage pre-processing prompt
selectWindow("C4-" + title);
run("8-bit");
setAutoThreshold("Default");

run("Auto Threshold", "method=Default white stack use_stack_histogram");
run("Z Project...", "projection=[Max Intensity]");

//select color for threshold id
setForegroundColor(119, 119, 119);

//prompt user to select macrophages
waitForUser("Select all macrophages using the floodfill tool (paintbucket). Click OK when done"); 

//isolate selected macrophages 
run("Threshold...");
setThreshold(88, 158);
setOption("BlackBackground", false);
run("Convert to Mask");
setThreshold(255, 255);
run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3");
run("Analyze Particles...", "  show=Outlines display exclude clear summarize add");
selectWindow("Drawing of MAX_C4-" + title );
close();
selectWindow("MAX_C4-" + title);

roiManager("Show None");
roiManager("Show All with labels");
roiManager("Show None");

run("Clear Results");

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
			for(i=0; i < roi_count; i++) {
				roiManager("Select", i);
				run("Duplicate...", "duplicate");
			//	roi_name = Roi.getName;
			//	selectWindow(roi_name);
				rename("ROI" + i + 1);
			}
			for(i=0; i < roi_count; i++) {
                selectWindow("ROI" + i + 1);
				run("Set Measurements...", "area min centroid center perimeter shape integrated area_fraction limit display redirect=None decimal=3");
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

