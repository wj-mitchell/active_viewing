import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Specifying filepath
file_path = r"C:\Users\Wjpmi\Dropbox\PC (2)\Desktop\AvP_Results_TOBEDELETED\univariate\cope1.feat"

# Open background image
gl.loadimage('mni152')

# Open overlay: show not rating run > not rating while rating
gl.overlayload(file_path + r"\thresh_zstat10.nii.gz")
gl.colorname(1, "1red")
gl.opacity(1, 75)

# Open overlay: show not rating > rating
gl.overlayload(file_path + r"\thresh_zstat11.nii.gz")
gl.colorname(2, "2green")
gl.opacity(2, 75)

# Hiding Colorbar
gl.colorbarposition(2)

# Generating Image 
gl.mosaic("A L- -05 15 23 35 39 42")

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\mosaic_notrating.bmp")
