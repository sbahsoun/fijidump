//Obtain image info
run("Open...");
getTitle();
title = getTitle(); 

//Close out channels
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
//selectWindow("Drawing of MAX_C4-" + title);
//run("Duplicate...", "title=new");

run("Duplicate...", " ");
//---------------------------------------------
//  Clean the upper part and create the distance map
//---------------------------------------------
setAutoThreshold("RenyiEntropy ");
//run("Threshold...");
//setThreshold(0, 0);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=1000000-Infinity add");
//-----------------------------------------------
//roiManager("Select", 1);
//run("Clear Outside");
roiManager("Show All without labels");
roiManager("Show None");
//roiManager("Delete");
//-----------------------------------------------
run("Distance Map");
run("16 Colors");
close("C");
//----------------------------------------------
// Select particles
//-----------------------------------------------
selectWindow("Drawing of MAX_C4-" + title);
//run("Split Channels");
//close("2 (green)");close("2 (blue)");
setAutoThreshold("Yen dark");
//run("Threshold...");
//setThreshold(76, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Watershed");
run("Set Measurements...", "area add redirect=None decimal=4");
run("Analyze Particles...", "size=0-200 add");
selectWindow("Drawing of MAX_C4-" + title);
roiManager("Show All without labels");
selectWindow("Drawing of MAX_C4-" + title);
run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=0 font=12 zoom=4 overlay");

//------------------------------------------------
// Transfer the particles to the distance map.
//-------------------------------------------------
run("From ROI Manager");
run("Tile");
//-----------------------------
//--------------------------------
exit("All is done !");