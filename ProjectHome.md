Functionality Example:
var wfsLayer:WFSLayer = new WFSLayer();
map.addLayer(wfsLayer);

This Flex Library Project enables the ArcGIS Flex Viewer to display Web Feature Services from various WFS implementations (Geoserver, ArcGISServer,...).

One of the biggest shortcomings of the ArcGIS Viewer is the inability to natively work with Web Feature Services. ESRI's ArcGIS Server even supports an implementation that is not supported in the Viewer out of the box (even in version 3.0). This is an incredible shortcoming. This library hopes to fill that gap.

This project started out of the 2009 ESRI dev summit in which WFS capabilities were demonstrated in a Flex Client using the 1.3 ESRI Flex API. Available here http://arcscripts.esri.com/details.asp?dbid=16191. I have since refined it and tested it against GeoServer 2.1 in FlexViewer (ArcGIS Viewer 2.4).

Further testing against other WFS Servers and various versions is needed to improve the product.

The discussions that prompted this code project are available on the ESRI Forum. http://forums.arcgis.com/threads/27183-WFS-T-in-FlexViewer-Widget?p=227213&posted=1#post227213

Marco Vassura has made some great updates available at http://www.arcgis.com/home/item.html?id=d93a120bffa941baa584bc49a97b85c2

At the time of this post we are working to fix some issues in the 2.5 compatibility and work towards a 3.0 release.