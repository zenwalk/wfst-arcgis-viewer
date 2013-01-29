/****************************************************************************************
 * Upgrade V3.0 : Raffaello Bertini                                                     *
 * 																						*
 ***************************************************************************************/
package com.esri.wfs.renderers
{
	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.renderers.Renderer;
	import com.esri.ags.symbols.CompositeSymbol;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.wfs.layers.WFSLayer;
	
	import mx.collections.ArrayCollection;
	
	public class WFSRenderer extends Renderer
	{
		private const red: Number = 0xFF0000;
		private const green: Number = 0x00FF00;
		private const blue: Number = 0x0000FF;
		
		private var pointshape:String;
		
		private var color:Number;
		private var outline_color:Number;
		private var selcolor : Number;
		private var seloutline_color: Number;
		
		private var column_name:String;
		
		private var hue:Number;
		private var sat:Number;
		private var val:Number;
		private var satb:Number;
		
		private var golden_ratio_conjugate:Number = 0.618033988749895;
		/*
		private function value2color( value: int, n: int ): Number
		{
			if(value<1) return -(0x111111*n); //?
			
			switch(value){
				case 0: return red/n;
				case 1: return green/n;
				case 2: return blue/n;
				case 3: return (red+green)/n;
				case 4: return (red+blue)/n;
				case 5: return (green+blue)/n;
			}	
			
			var p:int =((value) % 6) ;
			
			return value2color(p,n ) +  value2color((value-6),n+1) ;
			//3 ->1,2 1->2,3 2->1,3; 1->+2 3->+1 2->*2+1 --> *(2-2*(p%2))+1+int((3-p)/2)
			
		}
		*/
		
		
		private function value2color( value:int, n:int, s:Number, v:Number) : Number
		{
			//if(value<1) return -(0x111111*n); //?
			var h:Number;
			
			h=n*value;
			
			if(value<360/n)
				return hsv2rgb(h,s,v);
			
			
			var p:int =((value) % 360%n) ;
			
			return value2color(p,n*golden_ratio_conjugate,s,v ) +  value2color((value*golden_ratio_conjugate),n*golden_ratio_conjugate,s,v) ;
		}
		
		private function hsv2rgb(hue:Number, sat:Number, val:Number):Number
		{
			var red:Number, grn:Number,blu:Number, i:int, f:Number, p:Number, q:Number, t:Number;
			if(val==0) {return 0}
			hue%=360;
			sat/=100;
			val/=100;
			hue/=60;
			i = Math.floor(hue);
			f = hue-i;
			p = val*(1-sat);
			q = val*(1-(sat*f));
			t = val*(1-(sat*(1-f)));
			if (i==0) {red=val; grn=t; blu=p;}
			else if (i==1) {red=q; grn=val; blu=p;}
			else if (i==2) {red=p; grn=val; blu=t;}
			else if (i==3) {red=p; grn=q; blu=val;}
			else if (i==4) {red=t; grn=p; blu=val;}
			else if (i==5) {red=val; grn=p; blu=q;}
			red = Math.round(red*255);
			grn = Math.round(grn*255);
			blu = Math.round(blu*255);
			return (red<<16 | grn<<8 | blu);
		}
		
		private function rgb2hsv(red:Number, grn:Number, blu:Number) : Object
		{
			var x:Number, val:Number, f:Number, i:Number, hue:Number, sat:Number;
			red/=255;
			grn/=255;
			blu/=255;
			x = Math.min(Math.min(red, grn), blu);
			val = Math.max(Math.max(red, grn), blu);
			if (x==val)
				return({h:undefined, s:0, v:val*100});
		
			f = (red == x) ? grn-blu : ((grn == x) ? blu-red : red-grn);
			i = (red == x) ? 3 : ((grn == x) ? 5 : 1);
			hue = Math.round((i-f/(val-x))*60)%360;
			sat = Math.round(((val-x)/val)*100);
			val = Math.round(val*100);
			return({h:hue, s:sat, v:val});
		}
		
		/*
		private function getRandomInt (value:int) :int
		{
			return Math.floor(Math.random( )*(value+1));
		}
		*/
		
		
		/*
		private function hue_Random():int
		{
			var h:int;
			h = getRandomInt(360);
			return h += (360*golden_ratio_conjugate) % 360;
		}
		*/
		
		/*
		private function GetRandomColor(hsv_sat:int, hsv_val:int):Number
		{
			var h:int;
			h=hue_Random();
			return hsv2rgb( h,hsv_sat,hsv_val);
		}
		*/
		
		
		public function WFSRenderer( defaultSymbol:Symbol = null )
		{
			super();
			column_name="";
			color=0xfdd0a2;
			outline_color= 0xfd8d3c;
			selcolor=0x2171b5;
			seloutline_color= 0x84594;
			//fix this... make it withaout calc...
			//var o:Object = rgb2hsv(color>>16, (color>>8)&0xff, color&0xff);
			hue= 30; //o.h;
			//sat=36; //o.s;
			//val=99; //o.v;
			
			//o = rgb2hsv(outline_color>>16, (outline_color>>8)&0xff, outline_color&0xff);
//			satb = 76; //o.sat;
			
			sat=40;
			val=80;
			satb=80;

				
		}
		
		public function SetPointShape(value: String) :void
		{
			switch(value)
			{
				case "circle":
				case "square":
				case "triangle":
					pointshape = value;
					break;
				default:
					pointshape = "circle";
			}
		}
		
		public function SetAutoColor(_column_name:String):void
		{
			column_name = _column_name;
		}
		
		public function SetColorHSV(h:Number, s:Number, v:Number, s2:Number):void
		{
			if(h>=0)
				this.hue = h;
			if(s>=0)
				this.sat=s;
			if(v>=0)
				this.val=v;
			if(s2>=0)
				this.satb=s2;
			else
				this.satb=this.sat*2;
			
			if((column_name=="")&&
				((s>=0)||(v>=0)))
			{
				color = hsv2rgb(this.hue,this.sat,this.val);
				selcolor = NegateColor(color);
				outline_color = hsv2rgb(this.hue,this.satb,this.val);
				seloutline_color = NegateColor(outline_color);
			}

		}
		
		private function NegateColor(col:Number):Number
		{
			//test color conversion
			//color = fd8d3c
			//rgb=253,140,60 (max 255,255,255)
			//hsv=25 (24.9),76 (76.3),99 (99.2)   (max 360,100,100)
			/*
			var hsv_tmp:Object = rgb2hsv(253,140,60);
			var rgb_tmp:Number = hsv2rgb(24.9,76.3,99.2);
			trace(hsv_tmp.h, hsv_tmp.s, hsv_tmp.v);
			trace(rgb_tmp.toString(16));
			*/
			
			var hsv:Object = rgb2hsv(col>>16, (col >>8)&0xff, col&0xff);
			hsv.h = (hsv.h + 180);
			//trace(hsv.h, hsv.s, hsv.v);
			
			//if(hsv.hue > 360)
			//	hsv.hue -=360;
			col = hsv2rgb(hsv.h,hsv.s,hsv.v);
			return col;
		}
		
		private function SetColor(value :int) :void
		{
			//color = value2color(value,1);
			//outline_color = value2color(value,2);
			
			color = value2color(value,30,sat,val);
			outline_color = value2color(value,30,satb,val);
		}
		
		private function GetMapPointSymbol(graphic:Graphic, _color:Number, _outline_color:Number) : Symbol
		{
			return new SimpleMarkerSymbol( pointshape, 13, _color, 0.75, 0, 0, 0, new SimpleLineSymbol( "solid", _outline_color, 1, 2 ));
		}
		
		private function GetPolygonSymbol(graphic:Graphic, _color:Number, _outline_color:Number) : Symbol
		{
			return new SimpleFillSymbol( "solid", _color, 0.75, new SimpleLineSymbol( "solid", _outline_color, 1, 2 ) );
		}
		
		private function GetPolyLineSymbol(graphic:Graphic, _color:Number) : Symbol
		{
			return new SimpleLineSymbol( "solid", _color, 1, 3 );
		}
		
		private function GetMarkerSymbol(graphic:Graphic, _color:Number, _outline_color:Number) : Symbol
		{
			return new SimpleMarkerSymbol( "circle", 13, _color, 0.75,0,0,0, new SimpleLineSymbol( "solid", _outline_color, 1, 2 ) );
		}
		
		override public function getSymbol(graphic:Graphic):Symbol
		{
			if( graphic != null && graphic.geometry != null )
			{
				if(graphic.attributes.hasOwnProperty(column_name))
				{
					SetColor(graphic.attributes[column_name]);
					//trace("color val:"+graphic.attributes[column_name]);
				}
				
				if( graphic.geometry is MapPoint )
					return GetMapPointSymbol(graphic,color, outline_color);//0xfdd0a2, 0xfd8d3c);
				
				if( graphic.geometry is Polygon )
					return GetPolygonSymbol(graphic, color, outline_color);

				if( graphic.geometry is Polyline )
					return GetPolyLineSymbol(graphic, outline_color);

				if( graphic.geometry is Multipoint )
					return GetMarkerSymbol(graphic, color, outline_color);
					
			}
			
			return null;
		}
		
		/**
		 * The symbol function for this layer for selected features. The function should have the following signature:
		 * public function mySelectSymbolFunction( graphic : Graphic ) : Symbol
		 * This property can be used as the source for data binding.
		 */
		public function selectSymbolFunction( graphic :Graphic ) :Symbol
		{
			if( graphic != null && graphic.geometry != null )
			{
				if(graphic.attributes.hasOwnProperty(column_name))
				{
					SetColor(graphic.attributes[column_name]);
					selcolor=NegateColor(color);
					seloutline_color=NegateColor(outline_color);
				}
				
				if( graphic.geometry is MapPoint )
					return GetMapPointSymbol(graphic, selcolor, seloutline_color);//  0x2171b5, 0x84594);
				
				if( graphic.geometry is Polygon )
					return GetPolygonSymbol(graphic, selcolor, seloutline_color);
	
				if( graphic.geometry is Polyline )
					return GetPolyLineSymbol(graphic, seloutline_color);
				
				if( graphic.geometry is Multipoint )
					return GetMarkerSymbol(graphic, selcolor, seloutline_color);
			}
			
			return new SimpleMarkerSymbol( "circle", 13, 0x2171b5, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0x84594, 1, 2 ) );
		}
		
		/**
		 * The symbol function for this layer for features being edited. The function should have the following signature:
		 * public function myEditSymbolFunction( graphic : Graphic ) : Symbol
		 * This property can be used as the source for data binding.
		 */
		public var editSymbolFunction :Function = function( graphic :Graphic ) :Symbol
		{
			if( graphic != null && graphic.geometry != null )
			{
				if( graphic.geometry is MapPoint )
													"circle", 13, 0xfdd0a2, 0.75, 0, 0, 0, new SimpleLineSymbol( "solid", 0xfd8d3c, 1, 2 )
					return new SimpleMarkerSymbol( 	"circle", 13, 0xcb181d, 0.75, 0,0,0,new SimpleLineSymbol( "solid", 0x99000d, 1, 2 ) );
				
				if( graphic.geometry is Polygon )
					return new CompositeSymbol( new ArrayCollection( [
						new SimpleFillSymbol( "solid", 0xcb181d, 0.75, new SimpleLineSymbol( "solid", 0x99000d, 1, 2 ) ),
						new SimpleMarkerSymbol( "square", 9, 0xcb181d, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0x99000d, 1, 1 ) )
					] ) );
				
				if( graphic.geometry is Polyline )
					return new CompositeSymbol( new ArrayCollection( [
						new SimpleLineSymbol( "solid", 0x99000d, 1, 5 ),
						new SimpleMarkerSymbol( "square", 9, 0xcb181d, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0x99000d, 1, 1 ) )
					] ) );
				
				if( graphic.geometry is Multipoint )
					return new SimpleMarkerSymbol( "circle", 13, 0xcb181d, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0x99000d, 1, 2 ) );
			}
			
			return new SimpleMarkerSymbol( "circle", 13, 0xcb181d, 0.75,0,0,0, new SimpleLineSymbol( "solid", 0x99000d, 1, 2 ) );
		}

	}
	
}