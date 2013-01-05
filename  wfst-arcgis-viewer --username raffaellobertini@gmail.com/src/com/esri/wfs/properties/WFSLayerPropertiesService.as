package com.esri.wfs.properties
{
	import mx.collections.ArrayCollection;

	public class WFSLayerPropertiesService
	{
		public var url:String;
		public var ns:String; //namespace
		public var useproxy:Boolean;
		public var proxyurl:String;
		public var defaultwkid:String;
		
		public var features:ArrayCollection; 
		
		public function WFSLayerPropertiesService()
		{
		}
	}
}