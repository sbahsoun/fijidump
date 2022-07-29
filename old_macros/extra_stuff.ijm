/*		macro "Measure Stack" {
       					saveSettings;
     					setOption("Stack position", true);
       					for (n=1; n<=nSlices; n++) {
         					setSlice(n);
          					run("Measure");
     											 }
   					
  			
					//roi measurements 
						roiMeasurements = newArray(nResults);
						for(j=0; j<nResults; j++) {
							roiMeasurements[j] = getResult("Area", j);
													}
						Array.getStatistics(roiMeasurements, min, max, mean, stdDev);
						number_of_roi_elements = lengthOf(roiMeasurements);
						roi_sum = mean * number_of_roi_elements;
						; print("ROI Area" + a);
						print(roi_sum);
			}}
			*
			*
			 */
			
			/*	if(answer3 == true) {
					selectWindow("C1-Composite-" + i + 1);
					run("Duplicate...", "duplicate"); 
					rename("Filled_channel" + i + 1);
					selectWindow("C2-Composite-" + i + 1);
					run("Duplicate...", "duplicate");
					rename("Unfilled_channel" + i +1);
					//run("Merge Channels...", "c1=C1-Composite-"+ i "c2=C2-Composite-" + i "create");
					//rename("ROIComposite" + i);
					imageCalculator("AND create stack", "Filled_channel" + i +1,"Unfilled_channel" + i +1);
					selectWindow("Result of Filled_channel" + i +1);
					rename("Result" + i +1); 

					run("Clear Results");
					run("Set Measurements...", "area limit display redirect=None decimal=3");

					selectWindow("Result" + i +1);
					run("Make Binary", "method=Default background=Dark calculate black");
					run("Clear Results");

					selectWindow("Result" + i +1);
  	//figure this out because its not working
  					macro "Measure Stack" {
       					saveSettings;
     					setOption("Stack position", true);
       					for (n=1; n<=nSlices; n++) {
         					setSlice(n);
          					run("Measure");
     											 }
   					
  			
					//roi measurements 
						roiMeasurements = newArray(nResults);
						for(j=0; j<nResults; j++) {
							roiMeasurements[j] = getResult("Area", j);
													}
						Array.getStatistics(roiMeasurements, min, max, mean, stdDev);
						number_of_roi_elements = lengthOf(roiMeasurements);
						roi_sum = mean * number_of_roi_elements;
						; print("ROI Area" + i+1);
						print(roi_sum);

						
					//area without fill holes ///go back and fix! not overlapped
					selectWindow("Filled_channel" + i +1);
					rename("X");
					selectWindow("Unfilled_channel" + i +1);
					rename("Y");
					
					imageCalculator("AND create stack", "X" ,"Y");
					selectWindow("Result of X");
					rename("Result_unfilled"); 

					run("Clear Results");
					run("Set Measurements...", "area limit display redirect=None decimal=3");

					selectWindow("Result_unfilled");
					run("Make Binary", "method=Default background=Dark calculate black");
					run("Clear Results");

					macro "Measure Stack" {
       					saveSettings;
     					setOption("Stack position", true);
       					for (m=1; m<=nSlices; m++) {
         					setSlice(m);
          					run("Measure");
     											 }
   
  
					//unfilled roi measurements 
						roi_unfilledMeasurements = newArray(nResults);
						for(k=0; k<nResults; k++) {
							roi_unfilledMeasurements[k] = getResult("Area", k);
													}
						Array.getStatistics(roi_unfilledMeasurements, min, max, mean, stdDev);
						number_of_roi_elements_copy = lengthOf(roi_unfilledMeasurements);
						roi_sum_copy = mean * number_of_roi_elements_copy;
						; print("ROI Unfilled Area");
						print(roi_sum_copy);
						
					selectWindow("C1-Composite-" + i +1);
					close();
					selectWindow("C2-Composite-" + i +1);
					close();
				
			
			*/	
			
			
			/* else {
					print("That's too bad!");
					exit
		}    

				}
			}
				
		 else {
			Dialog.create("Window");
			Dialog.addMessage("Whoops! You made a mistake! Please go back and restart analysis!");
			Dialog.show();     }
			exit
	} 
	else {
 
			Dialog.create("Window");
			Dialog.addMessage("The Analysis is Complete");
			Dialog.show; }
			exit
*/