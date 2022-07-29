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

/*
// create dialog box for manual selection
 Dialog.create("Message");
  Dialog.addCheckbox("Selecting ROIs?", false);
  choice = Dialog.getCheckbox();
  Dialog.show;

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





/*
getStatistics(area, mean, min, max, std, histogram);
sum2 = mean * areaMeasurements2
print(Sum2); 

*/

//generate the total area of this (TUJ1)

//areaMeasurements2 = newArray(nResults);
//for(i=0; i<nResults; i++) {
//	areaMeasurements2[i] = getResult("Area", i);
//}
//Array.print(areaMeasurements);
/*
Array.getStatistics(areaMeasurements2, min, max, mean, stdDev);
number_of_elements1 = lengthOf(areaMeasurements2);
sum2 = mean * number_of_elements1
//sum = newArray(mean * number_of_elements); 
//Array.print(sum);
print("TUJ1");
print(sum2); );
for(i=0; i<nResults; i++) {
	areaMeasurements2[i] = getResult("Area", i);
}
Array.print(areaMeasurements2);

Array.getStatistics(areaMeasurements2, min, max, mean, stdDev);
number_of_elements2 = lengthOf(areaMeasurements2);
sum = mean * number_of_elements2
//sum = newArray(mean * number_of_elements); 
//Array.print(sum);
print("Total TUJ1 Area");
print(sum); 


/*
/reformatting the results output
IJ.renameResults("Results"); 
for (row=0; row<nResults; row++) {
	a = getResult("Area", row);  // * getResult("Mean", row);
    setResult("Sum of Area", row, a);
    
}
updateResults();

*/

/*sum and export of data
getResult("Area", 1)
	for (n=1; n,=nSlices; n++) {
	setSlice(n);
	run("Sum");

*/


//manually selecting the roi for coloc 
/*
 * selectWindow("Composite");
makeRectangle(527, 297, 396, 235);
makeRectangle(537, 319, 396, 235);
makeRectangle(537, 319, 396, 217);
makeRectangle(537, 319, 362, 217);
makeRectangle(533, 309, 362, 217);
makeRectangle(533, 309, 362, 217);
selectWindow("Composite-2");
selectWindow("Composite");
run("Duplicate...", "duplicate");
selectWindow("PFF 7dpi Mix 2003.nd2");
makeRectangle(0, 41, 409, 36);
selectWindow("Composite-1");
run("Split Channels");
selectWindow("C1-Composite-1");
run("Make Binary", "method=Default background=Default calculate black");
run("Options...", "iterations=1 count=1 black do=[Fill Holes] stack");
run("Red");
selectWindow("C2-Composite-1");
rename("green_1");
selectWindow("C1-Composite-1");
rename("red_1");
run("Merge Channels...", "c1=red_1 c2=green_1 create");

 */

/*
 * Notes
 * Areas needed: Original total, ganglia selected area before filling, ganglia selected area after filling
 * Export into excel sheet
 * Excel sheet needs two sheets, one with area per slice and then one total 
 */

