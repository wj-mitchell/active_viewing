import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Specifying filepath
file_path = r"C:\Users\Wjpmi\Dropbox\PC (2)\Desktop\AvP_Results_TOBEDELETED\univariate\cope1.feat"

# Open background image
gl.loadimage('mni152')

# Open overlay: show Rating > Not Rating 
gl.overlayload(file_path + r"\thresh_zstat7.nii.gz")
gl.colorname(1, "6warm")
gl.opacity(1, 75)

# Open overlay: show not Rating > Not Rating Run
gl.overlayload(file_path + r"\thresh_zstat5.nii.gz")
gl.colorname(2, "7cool")
gl.opacity(2, 75)

# Hiding Colorbar
gl.colorbarposition(2)

# Generating Image 
gl.mosaic("S L- -53 -42 -36 -25 ; -15 -02 08 11 ; 18 25 45 54")

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\..\..\figures\mosaic_rating.bmp")
