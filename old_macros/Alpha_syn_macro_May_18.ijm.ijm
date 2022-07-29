
//opening info, make sure to add variables
getTitle();
title = getTitle()
title = "file-name"

//begin splitting channels
run("Split Channels");

//DAPI and TUJ1 overlap first 
selectWindow("C3-SNCA.nd2");
rename("Neurons");
selectWindow("C1-SCNA.nd2"); 
rename("DAPI");


//play around with correct thresholds just to be sure 
selectWindow("Neurons");
run("Auto Threshold", "method=Shanbhag white stack use_stack_histogram");

selectWindow("DAPI");
run("Auto Threshold", "method=Shanbhag white stack use_stack_histogram");

//then run command to find overlap of two and mark as positive

//measure part 1 
run("Measure"); 

//repeat with Alpha syn channel and neurons
selectWindow("C4-SCNA.nd2"); 
rename("Alpha"); 
selectWindow("Alpha"); 
run("Auto Threshold", "method=Shanbhag white stack use_stack_histogram");

//then run command that finds neuron over alpha channel as positive

//measure part 2 
run("Measure"); 


//To do list
//find good channel overlap command
//figure out best treshold (this will differ for each image
//optimize for batch processing? 


//Notes
// neurons and dapi first, overlap is total neuron coverage
// neurons and alpha syn, then get alpha syn coverage 
