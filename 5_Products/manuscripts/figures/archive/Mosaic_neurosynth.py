import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Open background image
gl.loadimage('mni152')
gl.opacity(0,50)

# Specifying filepath
file_path = r"C:\Users\Wjpmi\Dropbox\PC (2)\Desktop\AvP_Results_TOBEDELETED"

# Open overlay: show not rating run > not rating while rating
gl.overlayload(file_path + r"\figures\neurosynth_rating_association.nii.gz")
gl.colorname(1, "plasma")

# Hiding Colorbar
gl.colorbarposition(0)

#"a"xial, "c"oronal and "s"agittal "r"enderings
gl.mosaic("C R 0 A R 0 S R -0");

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\figures\mosaic_neurosynth.bmp")
