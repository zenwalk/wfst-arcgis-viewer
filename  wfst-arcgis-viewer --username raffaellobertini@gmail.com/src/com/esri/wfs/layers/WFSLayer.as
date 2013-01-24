/***************************************************
 *** Update By : Raffaello Bertini                ***
 ***                                              *** 
 *** Date: 2012 - Oct                             ***
 ***----------------------------------------------***
 *** Note: Future Works need to implement more    ***
 *** outputs sub-type formats: KML, ShapeTipe     ***
 ***************************************************/
/* Copyright 2008 ESRI
 *
 * All rights reserved under the copyright laws of the United States
 * and applicable international laws, treaties, and conventions.
 *
 * You may freely redistribute and use this sample code, with or
 * without modification, provided you include the original copyright
 * notice and use restrictions.
 * See use restrictions at http://resources.esri.com/help/9.3/usagerestrictions.htm.
 */
package com.esri.wfs.layers
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.events.ExtentEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.utils.WebMercatorUtil;
	import com.esri.wfs.WFSComm;
	import com.esri.wfs.events.WFSEvent;
	import com.esri.wfs.tasks.WFSQuery;
	import com.esri.wfs.tasks.WFSQueryTask;
	import com.esri.wfs.utils.WFSUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;

	/**
	 * Dispatched when a query task successfully completes.
	 * @eventType com.esri.wfs.events.WFSQueryEvent.EXECUTE_COMPLETE
	 */
	[Event(name="executeComplete", type="com.esri.wfs.events.WFSQueryEvent")]
	
	/**
	 * Dispatched when loading begins.
	 * @eventType com.esri.wfs.events.WFSLoadingEvent.LOADING_STARTED
	 */
	[Event(name="loadingStarted", type="com.esri.wfs.events.WFSEvent")]
	
	/**
	 * Dispatched when the loading is complete.
	 * @eventType com.esri.wfs.events.WFSLoadingEvent.LOADING_COMPLETE
	 */
	[Event(name="loadingComplete", type="com.esri.wfs.events.WFSEvent")]
	
	/**
	 * Dispatched if the loading fails.
	 * @eventType com.esri.wfs.events.WFSLoadingEvent.LOADING_FAILED
	 */
	[Event(name="loadingFailed", type="com.esri.wfs.events.WFSEvent")]

	[Bindable]
	/**
	 * Executes queries against a WFS endpoint and provides transactional commits to that same endpoint.
	 */
	public class WFSLayer extends GraphicsLayer
	{
		/** Alternate label for display purposes. */
		public var label :String = null;
		
		// WFS Query
		protected var m_wfsQuery :WFSQuery = new WFSQuery();
		protected var m_wfsQueryTask :WFSQueryTask = new WFSQueryTask();
		
		
		protected var toupdate: Boolean = true;
		//protected var firsttime: Boolean = true;
		
		// Feature details
		protected var m_clearGraphics :Boolean = false;
		protected var m_featureLimit :int = 0;
		protected var m_featureIDs :ArrayCollection = new ArrayCollection();
		
		
		/**
		 * Constructs a new WFSLayer object.
		 * @param url the URL of the WFS endpoint.
		 */
		public function WFSLayer( url :String = null )
		{
			super();
			m_wfsQuery.returnGeometry = true;
			m_wfsQueryTask.url = url;
		}
		
		/** @private */
		override protected function addMapListeners() :void
		{
			super.addMapListeners();
			if( map != null )
				map.addEventListener( ExtentEvent.EXTENT_CHANGE, handleExtentChange );
		}
		
		/** @private */
		override protected function removeMapListeners() :void
		{
			super.removeMapListeners();
			if( map != null )
				map.removeEventListener( ExtentEvent.EXTENT_CHANGE, handleExtentChange );
		}
		
		/**
		 * The maximum number of features retrieved in any WFS query.
		 * If set to 0, all features will be retrieved for every request.
		 * Defaults to 0.
		 */
		public function get maxFeatures() :int
		{
			return m_wfsQuery.maxFeatures;
		}
		
		/** @private */
		public function set maxFeatures( value :int ) :void
		{
			if( m_wfsQuery.maxFeatures != value )
				m_wfsQuery.maxFeatures = value;
		}
		
		/** The SRS that is used by the WFS feature type. Defaults to "EPSG:4326". */
		public function get featureSRS() :String
		{
			return m_wfsQuery.srsName;
		}
		
		/** @private */
		public function set featureSRS( value :String ) :void
		{
			if( m_wfsQuery.srsName != value )
				m_wfsQuery.srsName = value;
		}
		
		/** The name of the WFS feature type. */
		public function get featureName() :String
		{
			return m_wfsQuery.featureName;
		}
		
		/** @private */
		public function set featureName( value :String ) :void
		{
			if( m_wfsQuery.featureName != value )
				m_wfsQuery.featureName = value;
				resetLayerState();
		}
		
		/** The namespace of the WFS feature type. */
		public function get featureNamespace() :String
		{
			return m_wfsQuery.featureNamespace;
		}
		
		/** @private */
		public function set featureNamespace( value :String ) :void
		{
			if( m_wfsQuery.featureNamespace != value )
				m_wfsQuery.featureNamespace = value;
		}

		/**
		 * Attribute fields to exclude from the FeatureSet.
		 * All fields are included if this is null or empty.
		 * @see outFields
		 */
		public function get excludeFields() :ArrayCollection
		{
			return m_wfsQuery.excludeFields;
		}
		
		/** @private */
		public function set excludeFields( value :ArrayCollection ) :void
		{
			if( m_wfsQuery.excludeFields != value )
				m_wfsQuery.excludeFields = value;
		}
		
		/**
		 * Attribute fields to include in the FeatureSet.
		 * All fields are included if this is null or empty.
		 * @see excludeFields
		 */
		public function get outFields() :ArrayCollection
		{
			return m_wfsQuery.outFields;
		}
		
		/** @private */
		public function set outFields( value :ArrayCollection ) :void
		{
			if( m_wfsQuery.outFields != value )
				m_wfsQuery.outFields = value;
		}
		
		/**
		 * If true, parses and outputs coordinates in "Y X" format.
		 * Otherwise, parses and outputs coordinates in "X Y" format.
		 * Defaults to true.
		 */
		public function get swapCoordinates() :Boolean
		{
			return m_wfsQuery.swapCoordinates;
		}
		
		/** @private */
		public function set swapCoordinates( value :Boolean ) :void
		{
			if( m_wfsQuery.swapCoordinates != value )
				m_wfsQuery.swapCoordinates = value;
		}
		
		/** The feature property name which will contain the feature geometry. Defaults to "SHAPE". */
		public function get shapeField() :String
		{
			return m_wfsQuery.shapeField;
		}
		
		/** @private */
		public function set shapeField( value :String ) :void
		{
			if( m_wfsQuery.shapeField != value )
				m_wfsQuery.shapeField = value;
		}
		
		/**
	     * URL to the ArcGIS Server WFS endpoint. For more information on constructing a URL, see Using ArcGIS Services Directory.
	     */
		public function get url() :String
		{
		    return m_wfsQueryTask.url;
		}

		/** @private */
		public function set url( value :String ) :void
		{
			if( m_wfsQueryTask.url != value )
			{
		    	m_wfsQueryTask.url = value;
		    	resetLayerState();
		 	}
		}
		
		/** The URL to proxy the request through. */
		public function get proxyURL() :String
		{
			return m_wfsQueryTask.proxyURL;
		}
		
		/** @private */
		public function set proxyURL( value :String ) :void
		{
			if( m_wfsQueryTask.proxyURL != value )
				m_wfsQueryTask.proxyURL = value;
		}
		
		/**
		 * The maximum number of features stored in memory or displayed on
		 * the map at any given time. If this number of features is reached, the
		 * store of features will be cleared. A value of 0 (default) indicates that
		 * the feature store will never be cleared, all unique features encountered
		 * will be stored and displayed on the map.
		 */
		public function get featureLimit() :int
		{
			return m_featureLimit;
		}
		
		/** @private */
		public function set featureLimit( value :int ) :void
		{
			if( m_featureLimit != value )
				m_featureLimit = value;
		}
		
		/**
		 * Returns the geometry type of the features currently active in the layer.
		 * @see Geometry.type
		 */
		public function  geometryType() :String
		{
			if( numGraphics > 0 )
			{
				var graphic :Graphic = getChildAt( 0 ) as Graphic;
				if( graphic.geometry )
					return graphic.geometry.type;
			}
			return null;
		}
		
		/*async responder for wfsQuery*/
		protected function onWfsQSuccess( featureSet :FeatureSet, token :Object = null ) :void
		{
			if( m_clearGraphics )
			{
				clear();
				m_clearGraphics = false;
			}
			
			for each( var graphic :Graphic in featureSet.features )
			{
				var featureID :String = graphic.attributes.GML_FEATURE_ID;
				if( !WFSUtil.containsString( featureID, m_featureIDs ) )
				{
					add( graphic );
					m_featureIDs.addItem( featureID );
				}
			}
			
			// event: loading complete
			dispatchEvent( new WFSEvent( WFSEvent.LOADING_COMPLETE ) );	
		}
		
		/*async responder for wfsQuery*/
		protected function onWfsQFailure( info :Object, token :Object = null ) :void
		{
			// event: loading failed
			dispatchEvent( new WFSEvent( WFSEvent.LOADING_FAILED ) );
			handleStringError( "Unable to load features." );
		}
			
		
		/** Execute the query if the layer is made visible. */
		override protected function updateLayer() :void
		{
			super.updateLayer();
			executeQuery();
		}
		
		/** Performs the query against the WFS endpoint. */ 
		public function executeQuery() :void
		{
			//var wm : WebMercatorUtil = new WebMercatorUtil();
			if( map !=null && hasRequiredParameters() && this.visible )
			{
				if ((map.spatialReference.wkid == 102100) || 
					(map.spatialReference.wkid == 3857 ))
					m_wfsQuery.extent = WebMercatorUtil.geographicToWebMercator(map.extent) as Extent;
				else 
					m_wfsQuery.extent = map.extent;				
				
				if( m_featureLimit > 0 && numChildren > m_featureLimit )
					m_clearGraphics = true;
				
				// event: loading started
				dispatchEvent( new WFSEvent( WFSEvent.LOADING_STARTED ) );
				if(toupdate)
				{
					toupdate=false;
					m_wfsQueryTask.execute( m_wfsQuery, 
						new AsyncResponder(
							onWfsQSuccess, onWfsQFailure
						)
					);
				}
				//else onWfsQSuccess(m_featureSet);
				else
					dispatchEvent( new WFSEvent( WFSEvent.LOADING_COMPLETE ) );
			}
		}
		
		//true if the layer has to be updated, false othewise
		public function set updatable( value :Boolean ) :void
		{
			toupdate=value;
		}	
		
		/**
		 * @private
		 * Handles a simple error.
		 * @param error the error message as a String.
		 */
		protected function handleStringError( error :String ) :void
		{
			var stringFault :Fault = new Fault( null, error );
	        dispatchEvent( new FaultEvent( FaultEvent.FAULT, false, true, stringFault ) );
		}
		
		/** Resets the layer state in the event. */
		protected function resetLayerState() :void
		{
			clear();
		}
		
		/** @private */
		protected function handleExtentChange( event :ExtentEvent ) :void
		{
			executeQuery();
		}
		
		/** Determines if the required parameters are set. Returns true if they are, false otherwise. */
		protected function hasRequiredParameters() :Boolean
		{
			if( m_wfsQuery.featureName &&
				m_wfsQuery.srsName &&
				m_wfsQueryTask.url )
				return true;
			
			return false;
		}
	}
}