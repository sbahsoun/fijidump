//Global Area Overlap 


//Obtaining Image Information   
run("Open...");
getTitle();
title = getTitle(); 
selectWindow(title);
run("Split Channels");
selectWindow("C1-" + title);
close();
selectWindow("C3-" + title);
rename("TUJ1");
run("Duplicate...", "title=TUJ1-copy duplicate");
selectWindow("C2-" + title);
close();
selectWindow("C4-" + title);
rename("Macrophage");

selectWindow("Macrophage");
//run("Subtract Background...", "rolling=10 stack");
selectWindow("Asyn");
run("PureDenoise ...");
//run("PureDenoise ", "parameters='1 1' estimation='Manual 1.0 0.0 1.0' ");

waitForUser("Click when Macrophage is de-noised"); 
close("Macrophage");
selectWindow("TUJ1");
//run("Subtract Background...", "rolling=10 stack");
selectWindow("TUJ1");
run("PureDenoise ...");


waitForUser("Click when TUJ1 is de-noised"); 
close("TUJ1");
/*
selectWindow("Macrophage");
run("Subtract Background...", "rolling=10 stack");
selectWindow("Macrophage");
run("PureDenoise ...");
waitForUser("Click when Macrophage is de-noised"); 
close("Macrophage");
*/

selectWindow("TUJ1");
run("Auto Threshold", "method=Triangle white stack");
run("8-bit");

		
			for(a=1; a < roi_count + 1; a++) {
				selectWindow("ROI" + a);
				run("Split Channels");
				selectWindow("C2-ROI" + a);
				run("8-bit");
				run("Auto Threshold", "method=Triangle white stack");
				selectWindow("C2-ROI" + a);
				run("Duplicate...", "duplicate");
				selectWindow("C2-ROI" + a + "-1");
				rename("Unfilled_C2_ROI" + a);
				selectWindow("C1-ROI" + a);
				run("8-bit");
				run("Auto Threshold", "method=Triangle white stack");
				selectWindow("C1-ROI" + a);
				run("Duplicate...", "duplicate");
				selectWindow("C1-ROI" + a + "-1");
				run("Green"); 
				rename("Unfilled_C1_ROI" + a);
				selectWindow("C2-ROI" + a);
				run("Fill Holes", "stack");
				run("Red");
				Dialog.createNonBlocking("Question");
				Dialog.addMessage("Is the current selection OK?");
				Dialog.addCheckbox("Yes", false);
				Dialog.show;

				answer3 = Dialog.getCheckbox();
				if(answer3 ==true) {
					run("Merge Channels...", "c1=[C2-ROI" + a + "], c2=[C1-ROI" + a + "] create keep");
				}
				else{
					Dialog.createNonBlocking("Message");
					Dialog.addMessage("Note the ROI index number:");
					Dialog.addMessage(a);
					Dialog.addMessage("Ignore the results on the final log and remember to analyze this ROI manually!");
					Dialog.show;
				}
		}
	
			for(a=1; a < roi_count + 1; a++) {
				imageCalculator("AND create stack", "C1-ROI" + a,"C2-ROI" + a);
				rename("ROI Composite" + a);
				selectWindow("ROI Composite" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("ROI Composite" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");
				selectWindow("ROI Composite" + a);
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
				; print("ROI Filled Area" + a);
				print(roi_sum);
				}
			//////////////////////////////////
			//New TUJ1 stuff only
			for(a=1; a < roi_count + 1; a++) {
			selectWindow("C1-ROI" + a);
			selectWindow("Unfilled_C1_ROI" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("C1-ROI" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");   
				selectWindow("C1-ROI" + a);
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
				//////////////////////////////////
	//////////////////////////////////
			 // New TUJ1 stuff only
			for(a=1; a < roi_count + 1; a++) {
			selectWindow("C1-ROI" + a);
			selectWindow("Unfilled_C1_ROI" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("Unfilled_C1_ROI" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");   
				selectWindow("Unfilled_C1_ROI" + a);
				run("Select All");
				roiManager("Add");
				roi_count_copy_TUJ1_only_unfilled = roiManager("count");
				//updated_roi_count_copy_unfilled = roi_count_copy_TUJ1_only_unfilled - 1 + a ; 
				roiManager("Select", roi_count_copy_TUJ1_only_unfilled - 1);
				roiManager("Multi Measure");
			
				roiMeasurements_TUJ1_only_unfilled = newArray(nResults);
				for(v=0; v<nResults; v++) {
					roiMeasurements_TUJ1_only_unfilled[v] = getResult("Area1", v);
					//changed Area1 to Area2
				}
				Array.getStatistics(roiMeasurements_TUJ1_only_unfilled, min, max, mean, stdDev);
				number_of_roi_elements_TUJ1_unfilled = lengthOf(roiMeasurements_TUJ1_only_unfilled);
				roi_sum_TUJ1_unfilled = mean * number_of_roi_elements_TUJ1_unfilled;
				; print("TUJ1 UnFilled Area" + a);
				print(roi_sum_TUJ1_unfilled);
				}
			//////////////////////////////////
				
			for(a=1; a < roi_count + 1; a++) {
				imageCalculator("AND create stack", "Unfilled_C1_ROI" + a, "Unfilled_C2_ROI" + a);
				rename("ROI_Unfilled_Composite" + a);
				selectWindow("ROI_Unfilled_Composite" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("ROI_Unfilled_Composite" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");
				selectWindow("ROI_Unfilled_Composite" + a);
				run("Select All");
				roiManager("Add");
				roi_count_copy = roiManager("count");
				//updated_roi_count_copy = roi_count_copy - 1 + a ; 
				roiManager("Select", roi_count_copy - 1);
				roiManager("Multi Measure");
			
				roi_unfilled_Measurements = newArray(nResults);
				for(j=0; j<nResults; j++) {
					roi_unfilled_Measurements[j] = getResult("Area1", j);
						}
				Array.getStatistics(roi_unfilled_Measurements, min, max, mean, stdDev);
				number_of_roi_elements_unfilled = lengthOf(roi_unfilled_Measurements);
				roi_sum_unfilled = mean * number_of_roi_elements_unfilled;
				; print("ROI_Unfilled_Area" + a);
				print(roi_sum_unfilled);
				}
			//clearing up things 
			final_roi_count = roiManager("count");
			final_final_roi_count = final_roi_count + 1 ;
			for(t=1; t < final_final_roi_count / 5; t++) {
				selectWindow("C1-ROI" + t);
				close();
				selectWindow("C2-ROI" + t);
				close();
				selectWindow("Unfilled_C1_ROI" + t);
				close();
				selectWindow("Unfilled_C2_ROI" + t);
				close();
				selectWindow("ROI Composite" + t);
				close();
				selectWindow("ROI_Unfilled_Composite" + t);
				close();
				} 
				