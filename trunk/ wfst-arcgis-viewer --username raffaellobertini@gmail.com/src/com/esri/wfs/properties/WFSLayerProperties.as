/****************************************************
 *** Author : Raffaello Bertini                   ***
 ***                                              *** 
 *** Date: 2012 - Dec                             ***
 ***----------------------------------------------***/
 
package com.esri.wfs.properties
{
	import mx.collections.ArrayCollection;
	import mx.effects.effectClasses.ZoomInstance;

	public class WFSLayerProperties
	{
		/**global var, the sum of all wfs layer do not exceed this value (not implemented)
		 * there's need only one value.
		 */
		public var selectionLabel:String;
		public var consoleLabel:String;
		public var attributesLabel:String;
		public var attrGlobalLabel:String;
		/** end global **/
		
		
		/** single url namespace for WFS layers properties**/
		//public var service:WFSLayerPropertiesService;
		public var services:ArrayCollection;
		
		
		/** single properties for featurelayer **/
		//into services
		
		public static function WFSLayerReadProperties(configXML:Object):WFSLayerProperties
		{
			var prop: WFSLayerProperties = new WFSLayerProperties();

			//<global>
			//prop.maxfeature = configXML.globals.maxfeatures;
			prop.selectionLabel = configXML.globals.selectionlabel;
			prop.attributesLabel = configXML.globals.attributeslabel;	
			prop.consoleLabel = configXML.globals.consolelabel;
			prop.attrGlobalLabel = configXML.globals.attrgloballabel;
			
			//<wfs>		
			prop.services = new ArrayCollection();
			for each(var ss:Object in configXML.service)
			{ 
				var s:WFSLayerPropertiesService = new WFSLayerPropertiesService();
				s.url = ss.URL;
				s.ns = ss.namespace;
				s.proxyurl = ss.proxyurl || "";
				if(s.proxyurl == "")
					s.useproxy=false;
				else
					s.useproxy=true;
				//<feature>
				s.features = new ArrayCollection();
				for each (var ff:Object in ss.feature)
				{
					var f:WFSLayerPropertiesServiceFeature = new WFSLayerPropertiesServiceFeature();
					f.name = ff.name;
					f.wkid = ff.wkid;
					f.shapefield = ff.shapefield;
					f.featurelimit = ff.featurelimit;
					f.featureTitle = ff.featureTitle;
					f.maxfeature = ff.maxfeatures;
					var swap:String = ff.SwapCoordinates;
					f.SwapCoordinates = (swap=="true")?true :false;
					var vis:String = ff.visible;
					f.visible = (vis.toLowerCase()=="false")?false:true; //true default.
					
					//parsare il sottocampo exludedfields...
					//TO DO
					f.ExcludedFields = new ArrayCollection();
					for each (var ex:Object in ff.excluded)
					{
						
					}
					
					s.features.addItem(f); //added feature to .service
				}
				prop.services.addItem(s); //added .service to prop 				
			}
			
			//<feature> nested in <wfs>
			/*
			for each (var f:Object in configXMLwfs.feature)
			{
				var t:String = f.name;
			}
			//prop.name = configXMLwfs.feature.name; 
			//prop.wkid  = configXMLwfs.feature.wkid;
			//prop.shapefield  = configXMLwfs.feature.shapefield;
			//prop.featurelimit  = configXMLwfs.feature.featurelimit;
			//prop.featureTitle = configXMLwfs.feature.featureTitle;
			
			var swap :String = configXMLwfs.feature.SwapCoordinates;
			if(swap.toLowerCase()=="true") 
				prop.SwapCoordinates = true;
			else
				prop.SwapCoordinates = false;
		
			prop.ExcludedFields = new ArrayCollection();
			*/
			return prop;
		}
	}
}