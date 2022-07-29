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
run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3");
run("Analyze Particles...", "  show=Outlines display exclude clear summarize add");
selectWindow("Drawing of MAX_C4-" + title);
run("Duplicate...", "title=new");

//String.copyResults();
//waitForUser("Results are copied! Paste into spreadsheet"); 



for(i=0;i<nResults;i++){
	cx1=getResult("XM",i);	
	cy1=getResult("YM",i);
		
	for(k=0;k<nResults; k++){
			cx2=getResult("XM",k);	
			cy2=getResult("YM",k);
			if(i==k){
				  distance=(sqrt(((cx2-cx1)^2)+((cy2-cy1)^2) ));
	
			}
			else{
				distance = 0;	
			
			}
	//distIndexes = Array.concat(distance, 0);
	
	}
	print("Results for" + i);
	print(distance); 
}


/*

pointIDs = newArray(0);  
pointIndexes = newArray(0); 

//go through each measurement 
for(i=0; i<nR; i++) {
	cX1 = getResult("XM", i);
	cY1 = getResult("YM", i);
	for (k=0; k==i; k++) {
		cX2 = getResult("XM", k);
		cY2 = getResult("YM", k); 
	dist = distance(cX1, cY1, cX2, cY2);    
	//function distance(cX1,cY1,cX2,cY2) {
	//return sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2));
}
	distIndexes = Array.concat(dist, 0);
}
*/

/*
// Results prompt 
IJ.renameResults("Raw From Delaunay");
for(i=0; i<pointIDs.length; i++) {
	setResult("Label", i, name);
	setResult("Object", i, pointIndexes[i]+1);
	setResult("N Neighbors", i, totalNeighbors[i]);
	setResult("Average Distance", i, sumDistances[i]/totalNeighbors[i]);
}

*/ 



//steps:
/*
 * 1. Obtain X and Y coordinates for each macrophage
 * 2. Assign each macrophage an ID number
 * 3. Calculate the distance between each ID number 
 * 4. Save the results for each macrophage in an array
 * 5. Pull the minimum value from each array as the nearest neighbor distance
 * 6. Correspond each macrophage ID to its nearest number measurement
 * 7. Optional: Automate the Poisson diagram 
 */