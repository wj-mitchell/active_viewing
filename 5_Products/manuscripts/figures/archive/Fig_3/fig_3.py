import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Specifying filepath
file_path = r"C:\Users\wjpmi\Dropbox\PC (2)\Documents\GitHub\active_viewing\3_Data\univariate\cope1.feat"

# Open background image
gl.loadimage('mni152')

# Open overlay: show Rating > Not Rating 
gl.overlayload(file_path + r"\thresh_zstat6.nii.gz")
gl.colorname(1, "4hot")
gl.opacity(1, 75)

# Open overlay: show Not Rating > Rating
gl.overlayload(file_path + r"\thresh_zstat7.nii.gz")
gl.colorname(2, "5winter")
gl.opacity(2, 75)

# Hiding Colorbar
gl.colorbarposition(2)

# Generating Image 
gl.mosaic("S L- -49 -40 -28 -16; \
	4 16 33 47")

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\..\..\..\5_Products\manuscripts\figures\archive\Fig_3\fig_3.bmp")
