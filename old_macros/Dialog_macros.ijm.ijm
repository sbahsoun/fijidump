 //Opening dialogue box 
 
 Dialog.create("Whole Mount Macro Analysis");
  Dialog.addMessage("Welcome to insert name!");
  Dialog.addMessage("Ready to Continue?");
  //Dialog.addMessage("Small Comment", 9);
  //Dialog.addMessage("Small and colored \nComment", 9, "#ff0000");
  Dialog.show;

//Choices box
  title = "Untitled";
  types = newArray("8-bit", "16-bit");
  threshold_choice = newArray("Default", "Huang", "Intermodees", "IsoData", 
  	"Li", "MaxEntropy", "Mean", "MinError(I)", "Minimum", 
 	 "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", 
  	"Triangle", "Yen");  
  Dialog.create("Analysis Specs");
  Dialog.addString("Image Title:", title);
  Dialog.addChoice("Type:", types);
  Dialog.addChoice("Threshold", threshold_choice);
  Dialog.addCheckbox("Review when complete?", false);
  Dialog.addCheckbox("Export?", false);
  Dialog.show();
  title = Dialog.getString();
  types = Dialog.getChoice();
  review = Dialog.getCheckbox();

//8 vs 16 bit choice 
	if (types == "8-bit") {
  		Dialog.create("Rolling Ball Specs");
  		rbr = "Untitled";
  		Dialog.addMessage("Please Specify the Rolling Ball Radius for your Image Set");
 		Dialog.addString("Rolling Ball Radius", rbr); 
  		Dialog.addMessage("If background subtraction does not apply type 0 above");
  		Dialog.show; 

        Dialog.create("8-bit Window");
		dbr = "Untitled";
		Dialog.addMessage("Ready to Begin the Analysis?");
		Dialog.show;
  		
	}
	else {
 
		Dialog.create("16-bit Window?");
		dbr = "Untitled";
		Dialog.addMessage("Ready to Begin the Analysis?");
		Dialog.show;

	}
		
//Begnning the processing
run("Open...");
getTitle();
title = getTitle(); 
 
// Add CheckboxGroup Demo
// This macro demonstrates how to use the
// Dialog.addCheckboxGroup(rows,columns,labels,defaults)
// macro function.
/*
  rows = 2;
  columns = 3;
  n = rows*columns;
  labels = newArray(n);
  defaults = newArray(n);
  for (i=0; i<n; i++) {
    labels[i] = "Checkbox "+i+1;
    if ((i%2)==0)
       defaults[i] = true;
    else
       defaults[i] = false;
  }
  Dialog.create("Checkbox Group");
  Dialog.addCheckboxGroup(rows,columns,labels,defaults);
  Dialog.show();
  for (i=0; i<n; i++)
     print(labels[i]+": "+Dialog.getCheckbox());
 */
 
 