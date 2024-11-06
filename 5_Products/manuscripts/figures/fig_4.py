import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Specifying filepath
file_path = r"C:\Users\Wjpmi\Dropbox\PC (2)\Desktop\AvP_Results_TOBEDELETED\univariate\cope1.feat"

# Open background image
gl.loadimage('mni152')

# Open overlay: show Rating > Not Rating 
gl.overlayload(file_path + r"\thresh_zstat6.nii.gz")
gl.colorname(1, "4hot")
gl.opacity(1, 75)

# Open overlay: show not Rating > Not Rating Run
gl.overlayload(file_path + r"\thresh_zstat4.nii.gz")
gl.colorname(2, "5winter")
gl.opacity(2, 75)

# Hiding Colorbar
gl.colorbarposition(2)

# Generating Image 
gl.mosaic("S L- -57 -49 -40 -37 -28 -22; \
	2 8 27 33 47 53")

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\..\..\figures\mosaic_rating_2.bmp")
