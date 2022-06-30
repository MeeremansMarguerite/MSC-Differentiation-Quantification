# MSC-Differentiation-Quantification
> Made by: Marguerite Meeremans, Ghent University, VetSCRU Lab 2022 \
> Marguerite.Meeremans@ugent.be \
> First draft: 		02/12/2021 \
> Latest adjustments:	30/06/2022

This document contains the information needed to quantify adipogenic, chondrogenic, and osteogenic differentiation of mesenchymal stem cells (MSCs). \
Read carefully before taking pictures and before doing the analysis. \
The macro’s are severely adapted from https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6410121/ 

## IMAGE ACQUISITION
! Be sure to use brightfield, NO phase contrast! \
Background illumination correction is essential  in brightfield microscopy to provide both a neutral color background and a uniformly illuminated field.\
Therefore, ALWAYS take darkfield and lightfield images following these steps: 
> 1) Switch on the microscope and lamp. Pre-heat for some time.
> 2) Switch off the camera's "auto-" functions, such as auto-exposure.
> 3) Put the plate on the stage. Adjust focus, illumination and set an appropriate exposure time.
> 4) Go to an empty well and adjust "white balance" on the EMPTY illuminated brightfield.
> 5) Check the histogram of this brightfield to avoid underexposure or oversaturatation. If needed, re-adjust illumination and white-balance.
> 6) Block the light path (by closing the diaphragm, do not switch the light off!) and capture a darkfield image. \
>      This image will be nearly black everywhere, except for “hot pixels”.\
>      Save the image as “1Dark.tif”; this will be used to compensate for hot pixels.
> 7) Reposition the specimen, adjust the light if needed and check histogram saturation and range of grey values (full histogram). 
> 8) Go to empty well and apply white balance function on the EMPTY illuminated brightfield.
> 9) Capture lightfield image (all background). \
>      Save the image as “1Light.tif”; this will be used to compensate the background illumination. \
>      -> DO NOT ADJUST SETTINGS ANYMORE!

More info & credits to: \
https://blog.bham.ac.uk/intellimic/g-landini-software/background-illumination-correction/ \
https://blog.bham.ac.uk/intellimic/g-landini-software/colour-deconvolution-2/ 

Take at least 4 representative images of each condition and take all images with the same magnification + exposure settings. \
Save images without a scalebar, this can wrongly be recognized as signal in imageJ. \
Save 1 extra image with a scalebar per magnification, to manually adjust the scale within the macro's, if needed. 

## IMAGE J MACRO's
### General Tips
>  * Give your images simple names, save a list of what those names are in another document, ImageJ can’t handle spaces, put a “_” instead. 
>  * FIRST install the plugin "Results to Excel" via https://imagej.net/plugins/read-and-write-excel.
>  * Before you start the automatic workflow, try to follow the steps in the macro manually. This is necessary to adjust the size of the particles, scale, etc. depending on the magnification used. 
>  * MAGNIFICATION: Determine the scale on 1 test image with printed scalebar and set as global scale. \
>   		Recommended magnification per differentiation is 20x, 10x and 10x for adipogenic, chondrogenic and osteogenic differentiation, respectively. \
		If you use another scale, do not forget to adjust the appropriate line in the macro (±line 35). \
		Before you run the macro, make sure the right global scale is active!! ((G) next to image name) 
> * If needed, you can add some lines (written at the end of the script) to adjust the Brightness/Contrast of each image (manually OR automatically) before running the analysis, however, doing this manually is a time consuming task. \
> 		For a macro that involves adjusting settings manually, such as Brightness/Contrast, you need to run the macro 4 times and take the mean of these runs.
>  * Before starting the macro, insert the correct path to save the images. Copy the file path from your document folder and change ‘\’ into ‘/’. The last word is followed by ‘.xslx’ and this should be the name of the new document. \
>  		! After analysis, immediately change the name of the excel file. \
>  		! If document with the same name already excists, imageJ will save the results in the same document, overwrite them OR when it is open, will not save them at all.

### Adipogenic – OilRedO staining
>  * The macro ‘VetSCRU_OilRed’ is designed to detect lipid droplets based on Oil Red O staining, with Hematoxylin counterstaining. 
>  * The 'Color deconvolution 2' plugin distinguishes 3 colors. We will use 2, being red = droplets, pink = background.
>  * 'Background'is representative for the cultivated cell area and is therefore a way to normalize the red signal to the amount of cells.
>  * The results contain: the % Red of the full image, % Background, area (µm2) Red and area (µm2) B. The adipogenic capacity of the MSC can be calculated by dividing the % red/area red by the %B/area B, respectively.
>  * Always compare with non-induced controls (cells in expansion medium).

### Chondrogenic – Alcian Blue staining
>  * The macro ‘VetSCRU_AlcianBlue’ is designed to detect the amount of glycosaminoglycans (GAGs) in the image based on Alcian Blue staining, with Nuclear Fast Red counterstaining. 
>  * Additionally, an area in µm^2 is givin for every pellet, based on a fitting ellipse (drawn manually).
>  * After background correction, you need to manually cut the image to the borders of the pellet, to avoid taking the area of the full slide into account. 
>  * The 'Color deconvolution 2' plugin distinguishes 3 colors. We will use 2, being blue = GAGs, pink/red= nuclear fast red. 
>  * The results contain: area of the pellet (µm2), the % GAG of the cut image, % H, area (µm2) GAG and area (µm2) H. The chondrogenic capacity of the MSC can be calculated by dividing the % GAG/area GAG by the %H /area H, respectively, to account for the difference in cell numbers.
>  * Additionally, for chondrogenic differentiation a difference between differentiated and non-induced pellet area can be detected.
>  * Comparison with non-induced controls, cells in expansion medium in 3D micromass culture is possible.

### Osteogenic – Alizarin Red staining
>  * The macro ‘VetSCRU_AlizarinRed’ is designed to detect calcium deposits based on Alizarin Red staining. 
>  * The 'Color deconvolution 2' plugin distinguishes 3 colors. We will use 1, being red = Ca deposits. In negative controls, the Alizarin Red will color the cell cultured area grey/pink, this is used as a background.
>  * 'Background' colors the full cultivated cell area and is therefore a way to normalize the red signal over the cultured area.	
>  * The results contain: the % Red of the full image, % Background, area (µm2) Red and area (µm2) B. The osteogenic capacity of the MSC can be calculated by dividing the % red/area red by the %B/area B, respectively.
>  *Always compare with non-induced controls (cells in expansion medium).

## DATA ANALYSIS
! Before you proceed with data analysis, rename the excel file. Otherwise next time you will run the macro, the results will be combined/deleted and therefore unclear to analyse.
