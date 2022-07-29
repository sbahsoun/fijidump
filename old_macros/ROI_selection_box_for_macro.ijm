/*
 * To do:
 * Create dialog box for selecting specific ROIs to count (so first, yes no feature)
 * Then, autoselect rectangle tool and have user select each region and add to roi manager
 * then, split channels and have macro fill holes for each image, asking user if it is okay and if yes to press enter
 * if no, they have to go back and do it manually
 * then, channels combine and find the total area as an output
 * user will have to subtract this output 
 */

//COPY PROGRAM FROM HERE 
Dialog.create("Whole Mount Macro Analysis");
  Dialog.addMessage("Ready to Start?");
  //Dialog.addMessage("Small Comment", 9);
  //Dialog.addMessage("Small and colored \nComment", 9, "#ff0000");
  Dialog.show;
  

//open prompt 
run("Open...");
getTitle();
title = getTitle(); 

//starting 
selectWindow(title);
run("Split Channels");

//closing unnecessary 
selectWindow("C4-" + title);
close();
selectWindow("C1-" + title);
close();

//renaming for clarity 
selectWindow("C3-" + title);
rename("TUJ1");
run("Duplicate...", "title=TUJ1-copy duplicate");
selectWindow("C2-" + title);
rename("Asyn");

//begin conversion of images from 16-bit to 8-bit
selectWindow("Asyn");
run("8-bit");
selectWindow("TUJ1-copy");
run("8-bit");

//apply background subtraction
selectWindow("Asyn"); 
run("Subtract Background...", "rolling=20 stack");


//begin thresholding 
selectWindow("Asyn");
run("Auto Threshold", "method=Triangle white stack");
selectWindow("TUJ1-copy");
run("Auto Threshold", "method=Triangle white stack");
selectWindow("Asyn");
selectWindow("TUJ1");
run("Auto Threshold", "method=Triangle white stack");

//color change, merge for validation of overlap
selectWindow("Asyn");
run("Green");
selectWindow("TUJ1-copy");
run("Red");
run("Merge Channels...", "c1=TUJ1-copy c2=Asyn create keep");


/*	if (choice == true) {
  		Dialog.create("Rolling Ball Specs");
  		rbr = "Untitled";
  		Dialog.addMessage("Please Specify the Rolling Ball Radius for your Image Set");
 		Dialog.addString("Rolling Ball Radius", rbr); 
  		Dialog.addMessage("If background subtraction does not apply type 0 above");
  		Dialog.show; 

        Dialog.create("8-bit Window");
		dbr = "Untitled";
		Dialog.addMessage("Ready to Begin the Analysis?");
		Dialog.show;
  		
	}
	else {
 
		Dialog.create("16-bit Window?");
		dbr = "Untitled";
		Dialog.addMessage("Ready to Begin the Analysis?");
		Dialog.show;

	}
*/		

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

//closing out extra stuff
selectWindow("TUJ1-copy");
close();
selectWindow("Asyn");
close();
selectWindow("TUJ1");
close();
selectWindow("Composite Image");
close();


//putting log on front
selectWindow("Log");
//////////Goal 1: Create dialog box for coutning specific ROIs
	Dialog.create("Message");
	Dialog.addMessage("Perform ROI selection on this image?");
	Dialog.addCheckbox("Yes", false);
	Dialog.show;
	answer = Dialog.getCheckbox();
	if (answer == true) {
			//insert what needs to be done
selectWindow("Composite");
//////////Goal 2: Begin ROI selection tool
		run("ROI Manager...");
		setTool("polygon");
		Dialog.createNonBlocking("Title");("Message");
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
for(t=1; t < final_final_roi_count / 3; t++) {
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
	
}


run("Clear Results");

selectWindow("Log");
print("Done with Analysis!");
exit



