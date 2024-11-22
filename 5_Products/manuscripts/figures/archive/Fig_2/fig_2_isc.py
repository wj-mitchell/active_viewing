import gl

gl.resetdefaults()

# Specifying white background
gl.backcolor(255, 255, 255)

# Specifying filepath
file_path = r"C:\Users\wjpmi\Dropbox\PC (2)\Documents\GitHub\active_viewing\3_Data\ISC"

# Open background image
gl.loadimage('mni152')
gl.opacity(0,50)

#open overlay: show positive regions
gl.overlayload(file_path + r"\positive_results_overlay.nii.gz")
gl.minmax(1, 0, 0.025)

#open overlay: show negative regions
gl.overlayload(file_path +  r"\negative_results_overlay.nii.gz")
gl.minmax(2, 0, 0.030)
gl.colorname (2,"3blue")
#gl.orthoviewmm(37,-14,47)

# Hiding Colorbar
gl.colorbarposition(2)

#"a"xial, "c"oronal and "s"agittal "r"enderings
gl.mosaic("C R 0 A R 0 S R -0");

# Save the image as a high-resolution bitmap
gl.savebmp(file_path + r"\..\..\5_Products\manuscripts\figures\archive\Fig_2\fig_2_isc.bmp")
