//Obtaining Image Information   
run("Open...");
getTitle();
title = getTitle(); 

run("ROI Manager...");
waitForUser("Select all ROIs. Click OK when done."); 


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
		
			for(a=1; a < roi_count + 1; a++) {
				selectWindow("ROI" + a);
				run("Split Channels");
				selectWindow("C3-ROI" + a);
				//run("Subtract Background...", "rolling=10 stack");
				run("PureDenoise ...");
				waitForUser("Click when channel is de-noised"); 
				selectWindow("Denoised-C3-ROI" + a);
				//run("Threshold...");
				setAutoThreshold("Triangle dark");
				setOption("BlackBackground", true);
				run("Convert to Mask", "method=Triangle background=Dark calculate black");
				run("Fill Holes", "stack");
				selectWindow("Denoised-C3-ROI" + a);
				run("Auto Threshold", "method=Triangle white stack");
				selectWindow("C4-ROI" + a);
				//run("Subtract Background...", "rolling=10 stack");
				run("PureDenoise ...");
				waitForUser("Click when channel is de-noised"); 
				selectWindow("Denoised-C4-ROI" + a);
				//run("Threshold...");
				setAutoThreshold("Triangle dark");
				setOption("BlackBackground", true);
				run("Convert to Mask", "method=Triangle background=Dark calculate black");
				run("Fill Holes", "stack");
				selectWindow("Denoised-C4-ROI" + a);
				run("Auto Threshold", "method=Triangle white stack");
				selectWindow("Denoised-C4-ROI" + a);
				run("Duplicate...", "duplicate");
				selectWindow("Denoised-C3-ROI" + a);
				//run("Fill Holes", "stack");
				run("Magenta");
				selectWindow("Denoised-C3-ROI" + a);
				run("Duplicate...", "duplicate");
				rename("TJ" + a);
				run("Merge Channels...", "c1=[Denoised-C3-ROI" + a + "], c2=[Denoised-C4-ROI" + a + "] create keep");
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
				selectWindow("Denoised-C4-ROI" + b - 0);
				imageCalculator("AND create stack", "Denoised-C4-ROI" + b - 0,"Denoised-C3-ROI" + b);
				rename("ROI Composite" + b);
				run("Merge Channels...", "c1=[Denoised-C3-ROI" + b + "], c2=[ROI Composite" + b + "] create keep");
				rename("Contact Area Composite"); 
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
				; print("Macrophage Contact Area" + b);
				print(roi_sum);
				}

			for (n=1; n < roi_count + 1; n++) {
				selectWindow("Denoised-C4-ROI" + n);
				close();
				selectWindow("Denoised-C4-ROI" + n + "-1");
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
				rename("Contact Area" + n);
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
				; print("TUJ1 Positive Area" + a);
				print(roi_sum_TUJ1);
				}
selectWindow("Log");
waitForUser("Analysis is Complete"); 
