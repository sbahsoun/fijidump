//Phagocytosis Analysis 
/*
 * Protocol Steps: (from paper)
"Multiple z-stacks taken through the depth of the cells were acquired for each coverslip. 
Images were then imported into Fiji/ImageJ for blinded analysis and the channels were separated. 
The 488nm channel (IBA1) was collapsed into a maximum intensity projection
and regions of interest were manually drawn around each cell. 
The integrated fluorescence density for each region of interest
from the 560nm channel (beads) was extracted and pasted into an excel sheet.

* Above summarized:
* 1. Separate Channels 2. 488 Max Intensity Projection 3. ROI drawn each cell on 488 4. IFD each ROI on 560 channel 
QUESTION: IFD for entire selection or just the overlap? 
* 
* 
My macro (step-by-step)
1. Open images and obtain image tags
2. Split channels
3. Create maximum projection for 480 channel
4. Create n-number of duplications for 480 channel
5. Overlap the two channels, extract the AND portion
6. Duplicate this-> need two copies VERIFY THAT THIS DOESN'T AFFECT IFD
7. Take one copy and make binary, use this to generate analyze particles NEED MEASUREMENTS FOR THIS 
8. Select the non-binary image, run the Measure tool on ROI manager to get the IFD 
 */

//Step 1
run("Open...");
getTitle();
title = getTitle(); 

//Step 2
selectWindow(title);
run("Split Channels");
selectWindow("C2-" + title); 
rename("purple"); 
nslice1 = nSlices; 

//Step 3
selectWindow("C1-" + title); 
run("Duplicate...", "title=green duplicate");
run("Z Project...", "projection=[Max Intensity]");
selectWindow("MAX_green"); 
run("Duplicate...", "title=green_l duplicate");
selectWindow("MAX_green"); 
rename("1"); 
//run("Merge Channels...", "c2=MAX_composite_1 c6=["C2-" + title] create keep");

//Step 4

run("Concatenate...", "  title=488_comp image1=1 image2=1 image3=1 image4=1 image5=1 image6=1 image7=1 image8=1 image9=1 image10=1");
run("Concatenate...", "  title=488_comp_2 image1=488_comp image2=488_comp image3=488_comp image4=488_comp image5=488_comp image6=488_comp image7=[-- None --]");
run("Concatenate...", "  title=488_comp_3 image1=488_comp_2 image2=488_comp_2 image3=488_comp_2 image4=488_comp_2 image5=488_comp_2 image6=488_comp_2 image7=[-- None --]");
run("Concatenate...", "  title=488_comp_4 image1=488_comp_3 image2=488_comp_3 image3=488_comp_3 image4=488_comp_3 image5=488_comp_3 image6=488_comp_3 image7=[-- None --]");
selectWindow("488_comp_4"); 
nslice2 = nSlices; 
nslice2 -=nslice1; 
//rename("green_final"); 

for (i = 1; i <= nslice2; i++) {
    selectWindow("488_comp_4"); 
    run("Delete Slice");
}; 

rename("green_final");



//Step 5
imageCalculator("AND create stack", "purple" ,"green_final");
rename("green_ff"); 

//Step 6
run("Duplicate...", "title=bin duplicate");


//Step 6
//Change threhsold here! 
run("Make Binary", "method=Otsu background=Dark calculate black");
run("Options...", "iterations=1 count=1 black do=Dilate stack");
run("Z Project...", "projection=Median");


//Step 7
run("Set Measurements...", " integrated limit display redirect=None decimal=3");
selectWindow("MED_bin"); 
//Change threhsold and pixel size here! 
run("Make Binary", "method=Otsu background=Dark calculate black");
run("Analyze Particles...", "size=49-Infinity pixel circularity=0.50-1.00 show=Outlines display exclude clear summarize add stack");
//selectWindow("bin");
//close();
run("Clear Results");

//Step 8
selectWindow("green_ff"); 
roiManager("Measure");

//Step 9
selectWindow("green_l"); 
setOption("BlackBackground", false);
run("Convert to Mask");
run("Dilate");
run("Analyze Particles...", "size=49-Infinity pixel circularity=0.50-1.00 show=Outlines exclude summarize");


//cleanup
selectWindow("MED_bin");
close();
selectWindow("green_final");
close();
selectWindow("green");
close();
selectWindow("purple");
close();
selectWindow("Results"); 
selectWindow("green_ff"); 
selectWindow("Summary");
