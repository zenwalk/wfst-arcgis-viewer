package com.esri.wfs.properties
{
	import mx.collections.ArrayCollection;

	public class WFSLayerPropertiesServiceFeature
	{
		public var name:String;
		public var wkid:String;
		public var shapefield:String;
		public var featurelimit:int;  // ??? for perfomance? 
		public var featureTitle:String;
		public var SwapCoordinates:Boolean;
		public var ExcludedFields :ArrayCollection;
		public var maxfeature:int; //rows limit for the query
		public var visible:Boolean;
		
		public function WFSLayerPropertiesServiceFeature()
		{
		}
	}
}