


//welcome prompt
Dialog.create("Macrophage Analysis (Again)");
	Dialog.addMessage("Welcome to Macrophage analysis as a function of distance to soma macro");
	Dialog.addMessage("Ready to Continue?");
	Dialog.show();


//obtain image info 
run("Open...");
getTitle();
title = getTitle(); 

//start roi manager and prompt 
run("ROI Manager...");
waitForUser("Select all Soma. Click OK when done."); 

//printing number of rois 
//duplicating 
roi_count = roiManager("count");
			print("Number of ROIs");
			print(roi_count);
			for(i=0; i < roi_count; i++) {
                selectWindow(title);
				roiManager("Select", i);
				run("Duplicate...", "duplicate");
			//	roi_name = Roi.getName;
			//	selectWindow(roi_name);
				rename("ROI" + i + 1);
			}
//		
			for(a=1; a < roi_count + 1; a++) {
				selectWindow("ROI" + a);
				run("Split Channels");
				selectWindow("C3-ROI" + a);
				//run("Subtract Background...", "rolling=10 stack");
				run("PureDenoise ...");
				waitForUser("Click when channel is de-noised"); 
				selectWindow("Denoised-C3-ROI" + a);
				run("8-bit");
				selectWindow("Denoised-C3-ROI" + a);
				run("Auto Threshold", "method=Triangle white stack");
				selectWindow("C2-ROI" + a);
				run("Subtract Background...", "rolling=10 stack");
				run("PureDenoise ...");
				waitForUser("Click when channel is de-noised"); 
				selectWindow("Denoised-C2-ROI" + a);
				run("8-bit");
				selectWindow("Denoised-C2-ROI" + a);
				run("Auto Threshold", "method=Triangle white stack");
				selectWindow("Denoised-C2-ROI" + a);
				run("Duplicate...", "duplicate");
				selectWindow("Denoised-C3-ROI" + a);
				run("Fill Holes", "stack");
				run("Red");
				selectWindow("Denoised-C3-ROI" + a);
				run("Duplicate...", "duplicate");
				rename("TJ" + a);
				run("Merge Channels...", "c1=[Denoised-C3-ROI" + a + "], c2=[Denoised-C2-ROI" + a + "] create keep");
			}
//spaceholder
			for (n=1; n < roi_count + 1; n++) {
				selectWindow("C1-ROI" + n);
				close();
				selectWindow("C2-ROI" + n);
				close();
				selectWindow("C3-ROI" + n);
				close();
				selectWindow("C4-ROI" + n);
				close();
							}
			for(b=1; b < roi_count + 1; b++) {
				//imageCalculator("AND create stack", "Denoised-C2-ROI" + a + "-1" ,"TJ" + a);
				//Title: Denoised-C2-ROI1-1
				selectWindow("Denoised-C2-ROI" + b - 0);
				imageCalculator("AND create stack", "Denoised-C2-ROI" + b - 0,"Denoised-C3-ROI" + b);
				rename("ROI Composite" + b);
				selectWindow("ROI Composite" + b);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("ROI Composite" + b);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");
				selectWindow("ROI Composite" + b);
				run("Select All");
				roiManager("Add");
				roi_count_copy = roiManager("count");
				//updated_roi_count_copy = roi_count_copy - 1 + a ; 
				roiManager("Select", roi_count_copy - 1);
				roiManager("Multi Measure");
			
				roiMeasurements = newArray(nResults);
				for(j=0; j<nResults; j++) {
					roiMeasurements[j] = getResult("Area1", j);
				}
				Array.getStatistics(roiMeasurements, min, max, mean, stdDev);
				number_of_roi_elements = lengthOf(roiMeasurements);
				roi_sum = mean * number_of_roi_elements;
				; print("ROI Filled Area" + b);
				print(roi_sum);
				}

			for (n=1; n < roi_count + 1; n++) {
				selectWindow("Denoised-C2-ROI" + n);
				close();
				selectWindow("Denoised-C2-ROI" + n + "-1");
				close();
				/*selectWindow("C1-ROI" + n);
				close();
				selectWindow("C2-ROI" + n);
				close();
				selectWindow("C3-ROI" + n);
				close();
				selectWindow("C4-ROI" + n);
				close(); */
				//selectWindow("Denoised-C3-ROI" + n);
			//	close();
				selectWindow("TJ" + n);
				close();
				selectWindow("ROI Composite" + n);
				rename("Overlap Area" + n);
			}
//selectWindow("Log");
//waitForUser("Analysis is Complete"); 
			//////////////////////////////////
			
			//New TUJ1 stuff only
			for(a=1; a < roi_count + 1; a++) {
			selectWindow("Denoised-C3-ROI" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("Denoised-C3-ROI" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");   
				selectWindow("Denoised-C3-ROI" + a);
				run("Select All");
				roiManager("Add");
				roi_count_copy_TUJ1_only = roiManager("count");
				//updated_roi_count_copy = roi_count_copy_TUJ1_only - 1 + a ; 
				roiManager("Select", roi_count_copy_TUJ1_only - 1);
				roiManager("Multi Measure");
			
				roiMeasurements_TUJ1_only = newArray(nResults);
				for(j=0; j<nResults; j++) {
					roiMeasurements_TUJ1_only[j] = getResult("Area1", j);
				}
				Array.getStatistics(roiMeasurements_TUJ1_only, min, max, mean, stdDev);
				number_of_roi_elements_TUJ1 = lengthOf(roiMeasurements_TUJ1_only);
				roi_sum_TUJ1 = mean * number_of_roi_elements_TUJ1;
				; print("TUJ1 Filled Area" + a);
				print(roi_sum_TUJ1);
				}
selectWindow("Log");
waitForUser("Analysis is Complete"); 







///////////////////////////////////////NOTESSSSSSSSSSSSSSSSS

//new analysis step by step (delete as each step is met
/*
 * 1 open titles with name of analysis DONE 
 * 2 image info (get title, etc) DONE 
 * 3 split and rename channels 
 * 4 process asyn and tuj1 channels as done in whole mount analysis (e.g. denoising, threshold, etc)
 * 5 merge channels and use ROI prompt to ask Phil to select soma rois and add to the roi manager 
 * 6 
 */

//soma acquisition steps: preprocess first, then select rois after you can see the overlap from multiple channels
// this means 



/*
 * To dos:
 * figure out how to get macrophage distance from center of mass to center of soma (or edge of soma) 
 * neighboring macrophages are determined by voronoi algorithm, how to isolate those macrophages and find
 * the distance of those macrophages specifically 
 */









//steps
/*
 * 1 preprocessing steps for tuj1, asyn channels
 * 2 manual roi selection for soma positive for both asyn and tuj1
 * 3 merge this channel with the macrophage channel 
 */

//testing steps for voronoi
/*
 * 1 preprocess and threshold z-stacks for the tuj1, asyn channels 
 * 2 take the nn pre-processed macrophage channel and merge with the stacks above
 * 3 make sure ROI manager has the center of mass' selected for the stuff above
 * 4 add voronoi overlay 
 */

//notes
// may want to fill in the holes for the neuron channel after thresholding and z-stack 
// e.g. fill with white paint bucket --> this will need eye validation 

//note
/*
 * neuron channel is pink
 * macrophage channel is yellow 
 * asyn channel is cyan 
 */

 /*

//Obtain image info
run("Open...");
getTitle();
title = getTitle(); 

//Close out channels

*/

selectWindow(title);
run("Split Channels");
selectWindow("C2-" + title);
close();
selectWindow("C1-" + title);
close();
selectWindow("C3-" + title);
close();


run("8-bit");
setAutoThreshold("Default");

run("Auto Threshold", "method=Default white stack use_stack_histogram");
run("Z Project...", "projection=[Max Intensity]");
setForegroundColor(119, 119, 119);

waitForUser("Select all macrophages using the floodfill tool (paintbucket). Click OK when done"); 


run("Threshold...");
setThreshold(88, 158);
setOption("BlackBackground", false);
run("Convert to Mask");
setThreshold(255, 255);
run("Set Measurements...", "area centroid center perimeter limit display redirect=None decimal=3");
run("Analyze Particles...", "  show=Outlines display exclude clear summarize add");
selectWindow("Drawing of MAX_C4-" + title);
run("Duplicate...", "title=new");

selectWindow("C4-" + title);
run("Nnd ");
selectWindow("Nearest Neighbor Distances");