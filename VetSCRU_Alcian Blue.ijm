//MSC DIFFERENTIATION QUANTIFICATION, based on a differentiation ratio - Alcian Blue + Nuclear Fast Red (Chondrogenic)
	//Images order : Name images easy (short)
					//DO NOT take pictures using phase-contrast
					//ALWAYS take a darkfield (name: "1Dark.tif") and a lightfield (name: "1Light.tif") at the same moment of your sample pictures
					//Make sure these are the first 2 images per folder to analyze
					//For more information, see "README"-file
	//Uses Color Deconvolution with user defined thresholds
	//Determine scale on 1 image with scale bar and set as global scale (Adjust line 36), ALL IMAGES SAME MAGNIFICATION
	//Make sure the right global scale is active!! ((G) next to image name)
	//FIRST install the plugin "Results to Excel" via https://imagej.net/plugins/read-and-write-excel
	//Images to analyze: save in .tiff/.jpg WITHOUT scalebar printed (this can wrongly be recognized as a signal)
	//Crop all images into a rectangle touching pellet borders.
	//Written by MARGUERITE MEEREMANS (2022-01-07), marguerite.meeremans@ugent.bebe

	//Get folder containing images
rep=getDirectory("Choose a folder");
list=getFileList(rep);
	
	//Define measurements & clear previous results
run("Set Measurements...", "area area_fraction limit display redirect=None decimal=2");
run("Clear Results");

	//Create a new excel file to save the results
		//Adjust the path, copy the desired path from your document folder bar and adjust \ into /
run("Read and Write Excel", "file=[C:/Users/mmeer/Documents/UGent/2020_Physiology_Regenerative Promise MSCs_MM/1. Cells/AT-MSCs/Article_MSCs differentiation quantification/Data Processing/20220203_bATMSC Diff Calf/Chondrogenic/AlcianBlue.xlsx] file_mode=read_and_open");

 //Image analysis, starts from the third image in the folder
 	//Image 1 & 2 SHOULD be a darkfield and a lightfield image 
for(i=2;i<list.length ;i=i+1)
{
nom=list[i];
path= rep+nom;
open(path);

	//Adjust to correct scale based on preview image
run("Set Scale...", "distance=145 known=100 unit=µm global");
run("Clear Results");
	//Sample image is open + opens darkfield & lightfield image
open(rep + "1Light.tif");
open(rep + "1Dark.tif");

	//To correct for different exposure & illumination settings a correction is applied
imageCalculator("Subtract create", "1Light.tif","1Dark.tif");
imageCalculator("Subtract create", nom ,"1Dark.tif");
selectWindow("Result of " + nom);
run("Duplicate...", "title=Sample");
close("Result of " + nom);
run("Calculator Plus", "i1=[Sample] i2=[Result of 1Light.tif] operation=[Divide: i2 = (i1/i2) x k1 + k2] k1=255 k2=0 create");
selectWindow("Result");

	//Since the pellets are small and do not cover the full slide -> crop all images manually into a rectangle touching pellet borders
title= "Crop";
msg = "Crop all images into a rectangle \n Use \"Image>Crop\" or CTRL+SHIFT+X \n Let the rectangle touch pellet border! \n Then click \"OK\"";
waitForUser(title,msg);

	//Apply colour deconvolution based on user defined values to achieve accurate stain separation
run("Colour Deconvolution2", "vectors=[User values] output=[8bit_Transmittance] simulated cross [r1]=0.9486045041303086 [g1]=0.29612449762795023 [b1]=0.11162336963326985 [r2]=0.5933460108409087 [g2]=0.5911797505187827 [b2]=0.5463030422720802 [r3]=0.0 [g3]=0.0 [b3]=0.0");
close("Result-(Colour_3)");

	//Pink/Red colours = cells (image in channel 2, C2), based on nuclear fast red staining
selectWindow("Result-(Colour_2)");
run("Duplicate...", "title=N#"+ nom);
close("Result-(Colour_2)");
selectWindow("N#"+ nom);
run("8-bit");

	//Thresholding based on auto-settings to obtain representative results for both positive & negative controls (define own values if desired by deleting "//" before line 67)
setAutoThreshold("Default");
//setThreshold(0, 120);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Measure");
close("N#"+ nom);

	// Blue colours = signal, GAG production (image in channel 1, C1), based on alcian blue staining
selectWindow("Result-(Colour_1)");
run("Duplicate...", "title=GAG#"+ nom);
close("Result-(Colour_1)");
selectWindow("GAG#"+ nom);
run("8-bit");

//Thresholding based on auto-settings to obtain representative results for both positive & negative controls (define own values if desired by deleting "//" before line 82)
setAutoThreshold("Default");
//setThreshold(0, 120);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Measure");

close("GAG#"+ nom);
close(nom);

selectWindow("Colour Deconvolution");
run("Close");
	//Results are saved in a list in the excel files named in line 23
run("Read and Write Excel", "stack_results file_mode=queue_write");
run("Close All");
}

run("Read and Write Excel", "file_mode=write_and_close");

selectWindow("Results");
run("Close");
selectWindow("Log");
run("Close");

//ANALYSIS:
//Divide the % Area GAG by the % Area H (representative for the number of nuclei, H positive)

//Optional: include manual Brightness/Contrast settings for better analysis (if needed).  
	//AUTOMATIC
		//setMinAndMax(10, 90);
		//run("Apply LUT");
	//MANUALLY
		//title= "Brightness/Contrast";
		//msg = "If necessary use \"Brightness/ Contrast \" tool\n (Image>Adjust>Brightness/Contrast)\nto adjust then click \"ok\"";
		//waitForUser(title,msg);
