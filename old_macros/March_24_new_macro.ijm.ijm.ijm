//plan 




//create and stack between asyn and macrophage thrshold in order to get only positive macrophages 
imageCalculator("AND create stack", "Denoised-Asyn","macrophage_thresholded");
selectWindow("Result of Denoised-Asyn");
selectWindow("Denoised-Asyn");
floodFill(544, 285);
run("Undo");
run("Duplicate...", "duplicate");



//z project the maximum intensity of the asyn channel, not sure if the results change based
// on a single channel or the other channel 
run("Z Project...", "projection=[Max Intensity]");



imageCalculator("AND create", "MAX_Denoised-Asyn-1","macrophage_thresholded");
selectWindow("Result of MAX_Denoised-Asyn-1");
selectWindow("MAX_Composite-3 (blue)-1");
selectWindow("Result of MAX_Denoised-Asyn-1");
run("Duplicate...", " "); //make sure to duplicate the channel 
selectWindow("MAX_Composite-3 (blue)-1");
run("Merge Channels...", "c1=[MAX_Composite-3 (blue)-1] c2=[Result of MAX_Denoised-Asyn-1-1] create keep");
selectWindow("Result of MAX_Denoised-Asyn-1-1");
selectWindow("MAX_Composite-3 (blue)-1"); //rois 
imageCalculator("AND create", "Result of MAX_Denoised-Asyn-1-1","MAX_Composite-3 (blue)-1");
selectWindow("Result of Result of MAX_Denoised-Asyn-1-1");
selectWindow("Composite");
