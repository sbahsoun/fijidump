macro  "Average distance a line and particles. (2) "
{
requires("1.52v");
run("Open...");
getTitle();
title = getTitle(); 

run("Split Channels");
selectWindow("C2-" + title);
close();
selectWindow("C1-" + title);
close();
selectWindow("C3-" + title);
close();
selectWindow("C4-" + title);
rename("C"); 

selectWindow("C"); close("K"); close("Y"); close("M");
close("3");

setAutoThreshold("Huang dark");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Set Measurements...", "area add redirect=None decimal=4");
run("Analyze Particles...", "size=1000000-Infinity add");
setBackgroundColor(0, 0, 0);
roiManager("Select", i);
run("Select All");


run("Clear Outside");
//---------------------------------------------
roiManager("Show All without labels");
roiManager("Show None");
roiManager("Delete");
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
roiManager("Select", 0);
run("Clear Outside");
roiManager("Show All without labels");
roiManager("Show None");
roiManager("Delete");
//-----------------------------------------------
run("Distance Map");
run("16 Colors");
close("C");
//----------------------------------------------
// Select particles
//-----------------------------------------------
selectWindow("2");
run("Split Channels");
close("2 (green)");close("2 (blue)");
setAutoThreshold("Yen dark");
//run("Threshold...");
//setThreshold(76, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Watershed");
run("Set Measurements...", "area add redirect=None decimal=4");
run("Analyze Particles...", "size=0-200 add");
selectWindow("1"); 
roiManager("Show All without labels");
selectWindow("C-1");
run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=0 font=12 zoom=4 overlay");
close("2 (red)");
//------------------------------------------------
// Transfer the particles to the distance map.
//-------------------------------------------------
run("From ROI Manager");
run("Tile");
//-----------------------------
// End of processing
//----------------------------
// End of batch mode
setBatchMode(false);
run("Tile");
//--------------------------------
exit("All is done !");
}