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

//Creating the overlap
imageCalculator("AND create stack", "TUJ1-copy","Asyn");
selectWindow("Result of TUJ1-copy");
rename("Composite Image");

//adjust measurement and export settings to show output 
run("Set Measurements...", "area limit display redirect=None decimal=3");

//convert to binary to quantify area of overlap
selectWindow("Composite Image");
run("Make Binary", "method=Default background=Dark calculate black");

//calculate area of overlap
selectWindow("Composite Image");
run("Measure"); 

//calculate area of TUJ1 only 
selectWindow("TUJ1");
run("Make Binary", "method=Default background=Dark calculate black");
run("Measure"); 
