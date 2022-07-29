/*
 * To do: 
 * toubleshoot stuff
 * leave original image open
 */


/* Important Notes
 *  Asyn channel has background subtraction! 
 *  
 */

//Opening Dialogues 
Dialog.create("Whole Mount Macro Analysis");
Dialog.addMessage("Ready to Start?");
Dialog.show;

  /*
Dialog.create("Question");
Dialog.addMessage("What will you be analyzing?");
Dialog.addCheckbox("Asyn and Macrophage Overlap?", false);
asyn_choice = Dialog.getCheckbox();
Dialog.addCheckbox("Asyn and Neuron Overlap?", false);
macrophage_choice = Dialog.getCheckbox();
Dialog.show();
	*/
	
//Obtaining Image Information and Beginning the Splitting channels process   
run("Open...");
getTitle();
title = getTitle(); 
selectWindow(title);
run("Split Channels");
//closing unnecessary 
	//selectWindow("C4-" + title);
	//close();
selectWindow("C1-" + title);
close();
//renaming for clarity 
selectWindow("C3-" + title);
rename("TUJ1");
run("Duplicate...", "title=TUJ1-copy duplicate");
selectWindow("C2-" + title);
rename("Asyn");
selectWindow("C4-" + title);
rename("Macrophage");
//begin conversion of images from 16-bit to 8-bit
selectWindow("Asyn");
run("8-bit");
selectWindow("TUJ1-copy");
run("8-bit");
selectWindow("Macrophage");
run("8-bit");
selectWindow("Macrophage");
run("Subtract Background...", "rolling=20 stack");
//apply background subtraction
selectWindow("Asyn"); 
run("Subtract Background...", "rolling=20 stack");
		
//****************************************************THRESHOLD STUFF below
//Beginning the Thresholding Process for TUJ1/Asyn images 
selectWindow("Asyn");
run("Auto Threshold", "method=Triangle white stack");
selectWindow("TUJ1-copy");
run("Auto Threshold", "method=Triangle white stack");
selectWindow("Asyn");
selectWindow("TUJ1");
run("Auto Threshold", "method=Triangle white stack");
selectWindow("Macrophage");
run("Auto Threshold", "method=Otsu white stack");
//************************************************THRESHOLD STUFF above 

//Color change for validation of overlaps
selectWindow("Asyn");
run("Duplicate...", "title=Asyn-copy duplicate");
selectWindow("Asyn");
run("Green");
selectWindow("TUJ1-copy");
run("Red");
run("Merge Channels...", "c1=TUJ1-copy c2=Asyn create keep");

selectWindow("Asyn-copy");
run("Green");
selectWindow("Macrophage");
run("Red");
run("Merge Channels...", "c1=Macrophage c2=Asyn-copy create keep");

//Creation of overlap between Neurons and Asyn
//Creating the overlap
imageCalculator("AND create stack", "TUJ1-copy","Asyn");
selectWindow("Result of TUJ1-copy");
rename("Composite Image");
//adjust measurement and export settings to show output 
run("Set Measurements...", "area limit display redirect=None decimal=3");
//convert to binary to quantify area of overlap
selectWindow("Composite Image");
run("Make Binary", "method=Default background=Dark calculate black");
run("Clear Results");


//Calculating Area of Overlap between TUJ1 and Asyn
//calculate area of overlap
selectWindow("Composite Image");
  macro "Measure Stack" {
       saveSettings;
       setOption("Stack position", true);
       for (n=1; n<=nSlices; n++) {
          setSlice(n);
          run("Measure");
      }

//generate the total area of this (Asyn)
areaMeasurements = newArray(nResults);
for(i=0; i<nResults; i++) {
	areaMeasurements[i] = getResult("Area", i); 
}
Array.getStatistics(areaMeasurements, min, max, mean, stdDev);
number_of_elements = lengthOf(areaMeasurements);
sum = mean * number_of_elements
print("Total Overlap Area");
print(sum); 
run("Clear Results");

//calculate area of TUJ1 only 
selectWindow("TUJ1");
run("Make Binary", "method=Default background=Dark calculate black");
selectWindow("TUJ1")
	macro "Measure Stack" {
		saveSettings;
		setOption("Stack position", true);
		for (n=1; n<nSlices; n++) {
			setSlice(n);
			run("Measure");
		}

TMeasurements = newArray(nResults);
for(i=0; i<nResults; i++) {
	TMeasurements[i] = getResult("Area", i);
}
Array.getStatistics(TMeasurements, min, max, mean, stdDev);
number_of_elements1 = lengthOf(TMeasurements);
sum2 = mean * number_of_elements1
print("TUJ1 Area");
print(sum2); 

//Aesthetic stuff 
//Commenting out as requested
/*
selectWindow("TUJ1-copy");
close();
selectWindow("Asyn");
close();
selectWindow("TUJ1");
close();
selectWindow("Composite Image");
close();
*/

//putting log on front
selectWindow("Log");

//////////Dialog box for coutning specific ROIs
	Dialog.createNonBlocking("Message");
	Dialog.addMessage("Perform ROI selection on this image?");
	Dialog.addCheckbox("Yes", false);
	Dialog.show;
	answer = Dialog.getCheckbox();
	if (answer == true) {
		selectWindow("Composite");
//////////Begin ROI selection tool
		run("ROI Manager...");
		setTool("polygon");
		Dialog.createNonBlocking("Title");
		Dialog.addMessage("Select all ganglia and add to the ROI manager");
		Dialog.addMessage("When you are finished check the box below"); 
		Dialog.addCheckbox("Done?", false);
		Dialog.addMessage("Note: Do not click OK before you are done selecting all ROIs!");
		Dialog.show;
		answer2 = Dialog.getCheckbox();

		if(answer2 == true) {
			//generate rest of stuff for selecting ROIs and further analysis
			roi_count = roiManager("count");
			print("Number of ROIs");
			print(roi_count);
			for(i=0; i < roi_count; i++) {
                selectWindow("Composite");
				roiManager("Select", i);
				run("Duplicate...", "duplicate");
			//	roi_name = Roi.getName;
			//	selectWindow(roi_name);
				rename("ROI" + i + 1);
			}
		
			for(a=1; a < roi_count + 1; a++) {
				selectWindow("ROI" + a);
				run("Split Channels");
				selectWindow("C1-ROI" + a);
				run("Duplicate...", "duplicate");
				selectWindow("C1-ROI" + a + "-1");
				rename("Unfilled_C1_ROI" + a);
				selectWindow("C2-ROI" + a);
				run("Duplicate...", "duplicate");
				selectWindow("C2-ROI" + a + "-1");
				rename("Unfilled_C2_ROI" + a);
				selectWindow("C1-ROI" + a);
				run("Fill Holes", "stack");
				Dialog.createNonBlocking("Question");
				Dialog.addMessage("Is the current selection OK?");
				Dialog.addCheckbox("Yes", false);
				Dialog.show;

				answer3 = Dialog.getCheckbox();
				if(answer3 ==true) {
					run("Merge Channels...", "c1=[C1-ROI" + a + "], c2=[C2-ROI" + a + "] create keep");
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
				for(j=0; j<nResults; j++) {
					roiMeasurements_TUJ1_only_unfilled[j] = getResult("Area1", j);
				}
				Array.getStatistics(roiMeasurements_TUJ1_only, min, max, mean, stdDev);
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
				
		//review dialoguee			
		Dialog.createNonBlocking("Title");
		Dialog.addMessage("Review the ROIs in the ROI manager before continuing.");
		Dialog.addMessage("Once you press OK, delete measurements in ROI manager before proceeding"); 
		Dialog.show;

		
		
			}
//this closes the if loop at the very top of the program	
 
		
 else {
 	Dialog.create("Prompt");
	Dialog.addMessage("Ready to Continue to Macrophage Analysis?");
	Dialog.show;
 }}
else {
 	Dialog.create("Prompt");
	Dialog.addMessage("Ready to Continue to Macrophage Analysis?");
	Dialog.show;}
	
selectWindow("Asyn-copy");
run("Green");
selectWindow("Macrophage");
run("Red");
run("Merge Channels...", "c1=Macrophage c2=Asyn-copy create keep");
rename("Composite123");

//Creation of overlap between Neurons and Asyn
//Creating the overlap
imageCalculator("AND create stack", "Asyn-copy","Macrophage");
selectWindow("Result of Asyn-copy");
rename("Composite M Image");
//adjust measurement and export settings to show output 
run("Set Measurements...", "area limit display redirect=None decimal=3");
//convert to binary to quantify area of overlap
selectWindow("Composite M Image");
run("Make Binary", "method=Default background=Dark calculate black");
run("Clear Results");


//Calculating Area of Overlap between Asyn and Macrophage
//calculate area of overlap
selectWindow("Composite M Image");
  macro "Measure Stack" {
       saveSettings;
       setOption("Stack position", true);
       for (n=1; n<=nSlices; n++) {
          setSlice(n);
          run("Measure");
      }

//generate the total area of this (Asyn)
areaMMeasurements = newArray(nResults);
for(i=0; i<nResults; i++) {
	areaMMeasurements[i] = getResult("Area", i); 
}
Array.getStatistics(areaMMeasurements, min, max, mean, stdDev);
number_of_elementsM = lengthOf(areaMMeasurements);
sumM = mean * number_of_elementsM ;
print("Total Overlap Area M");
print(sumM); 
run("Clear Results");

//calculate area of Macrophage only 
selectWindow("Macrophage");
run("Make Binary", "method=Default background=Dark calculate black");
selectWindow("Macrophage");
	macro "Measure Stack" {
		saveSettings;
		setOption("Stack position", true);
		for (n=1; n<nSlices; n++) {
			setSlice(n);
			run("Measure");
		}

MMeasurements = newArray(nResults);
for(i=0; i<nResults; i++) {
	MMeasurements[i] = getResult("Area", i);
}
Array.getStatistics(MMeasurements, min, max, mean, stdDev);
number_of_elementsMM = lengthOf(MMeasurements);
sum2MM = mean * number_of_elementsMM ; 
print("Macrophage Only Area");
print(sum2MM); 


//////////Dialog box for coutning specific ROIs
	Dialog.create("Message");
	Dialog.addMessage("Perform ROI selection on this image?");
	Dialog.addCheckbox("Yes", false);
	Dialog.show;
	answer4 = Dialog.getCheckbox();
	if (answer4 == true) {
		selectWindow("Composite123");
//////////Begin ROI selection tool
		run("ROI Manager...");
		setTool("polygon");
		Dialog.createNonBlocking("Title");("Message");
		Dialog.addMessage("Select all ROIs and add to manager");
		Dialog.addMessage("When you are finished check the box below"); 
		Dialog.addCheckbox("Done?", false);
		Dialog.addMessage("Note: Do not click OK before you are done selecting all ROIs!");
		Dialog.show;
		answer5 = Dialog.getCheckbox();

		if(answer5 == true) {
			//generate rest of stuff for selecting ROIs and further analysis
			roi_countMM = roiManager("count");
			print("Number of ROIs");
			print(roi_countMM);
			for(i=0; i < roi_count; i++) {
                selectWindow("Composite123");
				roiManager("Select", i);
				run("Duplicate...", "duplicate");
			//	roi_name = Roi.getName;
			//	selectWindow(roi_name);
				rename("ROIMM" + i + 1);
			}
		
			for(a=1; a < roi_count + 1; a++) {
				selectWindow("ROIMM" + a);
				run("Split Channels");
				selectWindow("C1-ROIMM" + a);
				run("Duplicate...", "duplicate");
				selectWindow("C1-ROIMM" + a + "-1");
				rename("Unfilled_C1_ROIMM" + a);
				selectWindow("C2-ROIMM" + a);
				run("Duplicate...", "duplicate");
				selectWindow("C2-ROIMM" + a + "-1");
				rename("Unfilled_C2_ROIMM" + a);
				selectWindow("C1-ROIMM" + a);
				run("Fill Holes", "stack");
				Dialog.createNonBlocking("Question");
				Dialog.addMessage("Is the current selection OK?");
				Dialog.addCheckbox("Yes", false);
				Dialog.show;

				answer6 = Dialog.getCheckbox();
				if(answer6 ==true) {
					run("Merge Channels...", "c1=[C1-ROIMM" + a + "], c2=[C2-ROIMM" + a + "] create keep");
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
				imageCalculator("AND create stack", "C1-ROIMM" + a,"C2-ROIMM" + a);
				rename("ROI Composite MM" + a);
				selectWindow("ROI Composite MM" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("ROI Composite MM" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");
				selectWindow("ROI Composite MM" + a);
				run("Select All");
				roiManager("Add");
				roi_count_copy_MM = roiManager("count");
				//updated_roi_count_copy = roi_count_copy - 1 + a ; 
				roiManager("Select", roi_count_copy_MM - 1);
				roiManager("Multi Measure");
			
				roiMeasurementsMMM = newArray(nResults);
				for(j=0; j<nResults; j++) {
					roiMeasurementsMMM[j] = getResult("Area1", j);
				}
				Array.getStatistics(roiMeasurementsMMM, min, max, mean, stdDev);
				number_of_roi_elementsMMM = lengthOf(roiMeasurementsMMM);
				roi_sum_MMM = mean * number_of_roi_elementsMMM;
				; print("ROI Filled Area MM" + a);
				print(roi_sum_MMM);
				}
			for(a=1; a < roi_count + 1; a++) {
				imageCalculator("AND create stack", "Unfilled_C1_ROIMM" + a, "Unfilled_C2_ROIMM" + a);
				rename("ROI_Unfilled_CompositeMM" + a);
				selectWindow("ROI_Unfilled_CompositeMM" + a);
				run("Clear Results");
				run("Set Measurements...", "area limit display redirect=None decimal=3");
				selectWindow("ROI_Unfilled_CompositeMM" + a);
				run("Make Binary", "method=Default background=Dark calculate black");
				run("Clear Results");
				selectWindow("ROI_Unfilled_CompositeMM" + a);
				run("Select All");
				roiManager("Add");
				roi_count_copyMMMMM = roiManager("count");
				//updated_roi_count_copy = roi_count_copy - 1 + a ; 
				roiManager("Select", roi_count_copyMMMMM - 1);
				roiManager("Multi Measure");
			
				roi_unfilled_MeasurementsMMMMM = newArray(nResults);
				for(j=0; j<nResults; j++) {
					roi_unfilled_MeasurementsMMMMM[j] = getResult("Area1", j);
						}
				Array.getStatistics(roi_unfilled_MeasurementsMMMMM, min, max, mean, stdDev);
				number_of_roi_elements_unfilledMMMMM = lengthOf(roi_unfilled_MeasurementsMMMMM);
				roi_sum_unfilledMMMMM = mean * number_of_roi_elements_unfilledMMMMM;
				; print("ROI_Unfilled_AreaMMMMM" + a);
				print(roi_sum_unfilledMMMMM);
				}
			//clearing up things
			final_roi_countMMMMM = roiManager("count");
			final_final_roi_countMMMMM = final_roi_countMMMMM + 1 ;
			for(t=1; t < final_final_roi_count / 3; t++) {
				selectWindow("C1-ROIMM" + t);
				close();
				selectWindow("C2-ROIMM" + t);
				close();
				selectWindow("Unfilled_C1_ROIMMMMM" + t);
				close();
				selectWindow("Unfilled_C2_ROIMMMMM" + t);
				close();
				selectWindow("ROI CompositeMM" + t);
				close();
				selectWindow("ROI_Unfilled_CompositeMMMMM" + t);
				close();
			}
//this closes the if loop at the very top of the program	
}} else {Dialog.create("Prompt");
	Dialog.addMessage("Done");
	Dialog.show;}
/*else {
 	Dialog.create("Prompt");
	Dialog.addMessage("Done");
	Dialog.show;}
*/
//putting log on front
selectWindow("Log");
	
run("Clear Results");

selectWindow("Log");
print("Done with Analysis!");
exit



