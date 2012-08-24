package com.esri.wfs.renderers
{
	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.renderers.Renderer;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	
	public class WFSRenderer extends Renderer
	{
		/*		

		*/
		//public var defaultSymbol:Symbol;

		public function WFSRenderer( defaultSymbol:Symbol = null )
		{
			super();
		}
		
		public var pointSymbol:Symbol;
		public var polylineSymbol:Symbol;
		public var polygonSymbol:Symbol;
	
		override public function getSymbol(graphic:Graphic):Symbol
		{
			super.getSymbol(graphic);
			
			if( graphic != null && graphic.geometry != null )
			{
				if( graphic.geometry is MapPoint )
				{
					return new SimpleMarkerSymbol( "circle", 13, 0xfdd0a2, 0.75, 0, 0, 0, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 ));
					//return new SimpleMarkerSymbol( "x", 13, 0xfdd0a2, 0.75, 0, 0, 0, null);
					//return new SimpleMarkerSymbol();
				}
				if( graphic.geometry is Polygon )
				{
					return new SimpleFillSymbol( "solid", 0xfdd0a2, 0.75, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 ) );
				}
				if( graphic.geometry is Polyline )
				{
					return new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 3 );
				}
			}			
			return null;
		}
	}
	
}