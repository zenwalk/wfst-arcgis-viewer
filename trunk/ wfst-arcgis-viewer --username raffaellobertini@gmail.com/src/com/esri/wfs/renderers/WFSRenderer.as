/****************************************************************************************
 * Upgrade V3.0 : Raffaello Bertini                                                     *
 * 																						*
 ***************************************************************************************/
package com.esri.wfs.renderers
{
	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.renderers.Renderer;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	
	public class WFSRenderer extends Renderer
	{
		//private const red: uint = 0x660000;
		//private const green: uint = 0x006600;
		//private const blu: uint = 0x000066;
		
		/*
		private function value2color( value: int, n: int ): int
		{
			
			if(value<1) return -(0x111111*n);
			
			switch(value){
				case 1: return red/n;
				case 2: return green/n;
				case 3: return blu/n;
				case 4: return (red+green)/n;
				case 5: return (red+blu)/n;
				case 6: return (blu+green)/n;
			}	
			
			var p:int =((value) % 6) + 1;
			
			return value2color(p,n ) +  value2color((value-6),n+1) ;
			//3 ->1,2 1->2,3 2->1,3; 1->+2 3->+1 2->*2+1 --> *(2-2*(p%2))+1+int((3-p)/2)
			
		}
		*/
		public function WFSRenderer( defaultSymbol:Symbol = null )
		{
			super();
		}
		
		//public var pointSymbol:Symbol;
		//public var polylineSymbol:Symbol;
		//public var polygonSymbol:Symbol;
	
		override public function getSymbol(graphic:Graphic):Symbol
		{
			//super.getSymbol(graphic);
			
			if( graphic != null && graphic.geometry != null )
			{
				if( graphic.geometry is MapPoint )
					return new SimpleMarkerSymbol( "circle", 13, 0xfdd0a2, 0.75, 0, 0, 0, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 ));
				
				if( graphic.geometry is Polygon )
					return new SimpleFillSymbol( "solid", 0xfdd0a2, 0.75, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 ) );

				if( graphic.geometry is Polyline )
					return new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 3 );

				if( graphic.geometry is Multipoint )
					return new SimpleMarkerSymbol( "circle", 13, 0xfdd0a2, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 ) );
			}
			
			//return new SimpleMarkerSymbol( "circle", 13, 0xfdd0a2, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 ) );
			return null;
		}
	}
	
}