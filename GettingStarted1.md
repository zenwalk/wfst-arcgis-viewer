# Requirements #
Flash Builder 4.5+
ArcGIS Viewer 2.2+

# Setup #
1) Download the ArcGIS Viewer source code.
2) Add the wfst-2.4.0.swc (available in the download link) to your project libs.
3) Click on project properties>> Flash Build Path>> Add SWC, browse to the libs directory and select wfst-2.4.0.swc.

Your project is now ready for wfst integration.

# Details #
1) Create an instance of the object WFSLayer.
2) Populate the relevant object properties with valid values.
3) Add the layer to the map.

Example widgets are provided in the source tags examples/wigets directory.