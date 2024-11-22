import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Specifying filepath
file_path = r"C:\Users\wjpmi\Dropbox\PC (2)\Documents\GitHub\active_viewing\3_Data\univariate\cope1.feat"

# Open background image
gl.loadimage('mni152')

# Open overlay: show not rating run > not rating while rating
gl.overlayload(file_path + r"\thresh_zstat12.nii.gz")
gl.colorname(1, "plasma")

# Hiding Colorbar
gl.colorbarposition(2)

# Generating Image 
gl.mosaic("S L- -48.5 -45.5 -39.6 ; -9.4 -3.5 20.1")

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\..\..\..\5_Products\manuscripts\figures\archive\Fig_2\fig_2_paramod.bmp")
