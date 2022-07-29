//open prompt 
run("Open...");
getTitle();
title = getTitle();

//Count for max projection, 2D channel 
setOption("BlackBackground", true);
run("Convert to Mask");
run("Open");
roiManager("Deselect");
run("Analyze Particles...", "size=100-Infinity display exclude clear summarize add");
