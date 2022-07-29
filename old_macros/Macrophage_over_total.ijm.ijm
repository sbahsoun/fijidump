//Goals of program
/* Get total area of image
 *  Get total macrophage positive area 
 *  Macrophage positive area/ image area for each image
 */

//opening prompts
run("Open...");
getTitle();
title = getTitle(); 
selectWindow(title);
getDimensions(width, height, channels, slices, frames);
print("Total Image Area");
print(width * height * slices); 

run("Split Channels");

selectWindow("C1-" + title);
close();
selectWindow("C2-" + title);
rename("Asyn");
selectWindow("C4-" + title);
rename("Macrophage");
//begin conversion of images from 16-bit to 8-bit
selectWindow("Asyn");
run("8-bit");
selectWindow("Macrophage");
run("8-bit");
selectWindow("Macrophage");
run("Subtract Background...", "rolling=20 stack");
//apply background subtraction
selectWindow("Asyn"); 
run("Subtract Background...", "rolling=20 stack");
 
selectWindow("Asyn");
run("Auto Threshold", "method=Triangle white stack");
selectWindow("Macrophage");
run("Auto Threshold", "method=Otsu white stack");

selectWindow("Asyn");
run("Duplicate...", "title=Asyn-copy duplicate");


selectWindow("Asyn-copy");
run("Green");
selectWindow("Macrophage");
run("Red");
run("Merge Channels...", "c1=Macrophage c2=Asyn-copy create keep");



//putting log on front
selectWindow("Log");

	
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


selectWindow("Log");
	
run("Clear Results");

selectWindow("Log");
exit



