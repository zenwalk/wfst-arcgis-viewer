/*****************************************************************************************
 * Upgrade Version 3.0 : Raffaello Bertini                                               
 *                                                    
 * Date : Oct 2012
 * 
 * 
 * 
 *----------------------------------------------------------------------------------------
 */
package com.esri.wfs.layers
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.events.ExtentEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.CompositeSymbol;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.ags.utils.WebMercatorUtil;
	import com.esri.wfs.WFSComm;
	import com.esri.wfs.events.WFSEvent;
	import com.esri.wfs.events.WFSTEvent;
	import com.esri.wfs.renderers.WFSRenderer;
	import com.esri.wfs.tasks.WFSQuery;
	import com.esri.wfs.tasks.WFSQueryTask;
	import com.esri.wfs.utils.SnapContext;
	import com.esri.wfs.utils.SnapUtil;
	import com.esri.wfs.utils.WFSUtil;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.FlexEvent;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
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

	/**
	 * Dispatched when a task call fails.
	 * eventType mx.rpc.events.FaultEvent.FAULT
	 */
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
	/**
	 * Dispatched when editing of the selected feature begins.
	 * eventType com.esri.wfs.events.WFSTEvent.EDIT_BEGUN
	 */
	[Event(name="editBegun", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature lock is requested.
	 * eventType com.esri.wfs.events.WFSTEvent.LOCK_REQUESTED
	 */
	[Event(name="lockRequested", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature lock is acquired.
	 * eventType com.esri.wfs.events.WFSTEvent.LOCK_ACQUIRED
	 */
	[Event(name="lockAcquired", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature lock request fails.
	 * eventType com.esri.wfs.events.WFSTEvent.LOCK_FAILED
	 */
	[Event(name="lockFailed", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when the edits made to the the selected feature are saved.
	 * eventType com.esri.wfs.events.WFSTEvent.EDIT_SAVED
	 */
	[Event(name="editSaved", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when editing of the selected feature is canceled.
	 * eventType com.esri.wfs.events.WFSTEvent.EDIT_CANCELED
	 */
	[Event(name="editCanceled", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is selected.
	 * eventType com.esri.wfs.events.WFSTEvent.FEATURE_SELECTED
	 */
	[Event(name="featureSelected", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is deselected.
	 * eventType com.esri.wfs.events.WFSTEvent.FEATURE_DESELECTED
	 */
	[Event(name="featureDeselected", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is inserted.
	 * eventType com.esri.wfs.events.WFSTEvent.FEATURE_INSERTED
	 */
	[Event(name="featureInserted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is updated.
	 * eventType com.esri.wfs.events.WFSTEvent.FEATURE_UPDATED
	 */
	[Event(name="featureUpdated", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is deleted.
	 * eventType com.esri.wfs.events.WFSTEvent.FEATURE_DELETED
	 */
	[Event(name="featureDeleted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after the transaction is started.
	 * eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_STARTED
	 */
	[Event(name="transactionStarted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after the transaction is committed.
	 * eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_COMMITTED
	 */
	[Event(name="transactionCommitted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after the transaction is canceled.
	 * eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_CANCELED
	 */
	[Event(name="transactionCanceled", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after a transaction fails.
	 * eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_FAILED
	 */
	[Event(name="transactionFailed", type="com.esri.wfs.events.WFSTEvent")]
	
	[Bindable]
	/**
	 * Executes queries against a WFS endpoint and provides transactional commits to that same endpoint.
	 */
	public class WFSTLayer extends WFSLayer
	{
		protected static const SERVICE        :String    = WFSComm.SERVICE;
		protected static const VERSION        :String    = WFSComm.VERSION;
		protected static const OUTPUT_FORMAT  :String    = WFSComm.OUTPUT_FORMAT;
		protected static const EXPIRY_TIME    :String    = WFSComm.EXPIRY_TIME;
		protected static const RELEASE_ACTION :String    = WFSComm.RELEASE_ACTION;
		protected static const WFS            :Namespace = WFSComm.WFS;
		protected static const GML            :Namespace = WFSComm.GML;
		protected static const OGC            :Namespace = WFSComm.OGC;
		protected static const OWS            :Namespace = WFSComm.OWS;
		protected static const XS             :Namespace = WFSComm.XS;
		protected static const XLINK          :Namespace = WFSComm.XLINK;
		
		//Features for data binding
		private var m_featureSet :FeatureSet = new FeatureSet;
		
		
		// Feature details
		protected var m_selectedFeatureID :String;
		protected var m_selectedFeature :Graphic;
		protected var m_selectedFeatureAttributes :ArrayCollection = new ArrayCollection(); 
		
		protected var m_renderer:WFSRenderer; // = new WFSRenderer();	
		
		
		// Lock details
		protected var m_lockID :String;
		
		// Controls for attribute and geometry editing
		protected var m_updatedAttributes :ArrayCollection = new ArrayCollection();
		protected var m_updatedGeometry :Boolean = false;
		protected var m_usingCenter :Boolean = false;
		protected var m_startPoint :MapPoint;
		protected var m_delta :Number;
		protected var m_offsetX :Number;
		protected var m_offsetY :Number;
		protected var m_editPoint :MapPoint;
		protected var m_backupGeometry :Geometry;
		protected var m_intermediateBackupGeometry :Geometry;
		protected var m_selectTolerance :int = 20; // default tolerance is 20 pixels
				
		// Type of modification
		private var m_new :Boolean = false;
		private var m_update :Boolean = false;
		private var m_delete :Boolean = false;
		protected var m_editing :Boolean = false;

		// New features
		protected var m_featureAttributes :Object;
		protected var m_featureTypes :ArrayCollection = new ArrayCollection();
		protected var m_geometryType :String;
		
		protected var pointshape:String; //used only for render points.
		
		public function GetPointShape() : String
		{
			return pointshape;
		}
		
		public function  SetPointShape( value:String):void
		{
			m_renderer.SetPointShape(value);	
		}
		
		public function SetAutoColor(column_name:String):void
		{
			m_renderer.SetAutoColor(column_name);
		}
		
		public function SetColorHSV(h:Number, s:Number, v:Number, s2:Number):void
		{
				m_renderer.SetColorHSV(h,s,v,s2);
		}
		
		/*
		/**
		 * value = 0 based index
		 * */
		//public function SetRenderColor(value : int):void // 0 based index
		//{
		//	m_renderer.SetColor(value);
		//}
		
		// Snapping attributes
		protected var m_snapContext :SnapContext = new SnapContext();
		
		
		// Snapping options
		[Inspectable(category="Mapping", enumeration="vertex,edge,end,none", defaultValue="none")]
		/** Set the snapping mode. Defaults to "none"; no snapping. */
		public function get snapTo() :String
		{
			return m_snapContext.snapMode;
		}
		
		/** @private */
		public function set snapTo( value :String ) :void
		{
			if( m_snapContext.snapMode != value )
				m_snapContext.snapMode = value;
		}		
		
		[Inspectable(category="Mapping", defaultValue="20")]
		/** Set the snapping tolerance in pixels. Defaults to 20 pixels. */
		public function get snapTolerance() :int
		{
			return m_snapContext.snapTolerance;
		}
		
		/** @private */
		public function set snapTolerance( value :int ) :void
		{
			if( m_snapContext.snapTolerance != value )
				m_snapContext.snapTolerance = value;
		}
		
		[Inspectable(category="Mapping", range="0x000000,0xFFFFFF", defaultValue="0x333333")]
		/** The snap indicator color. Default is 0x333333. */
		public function get snapColor() :Number
		{
			return m_snapContext.snapColor;
		}
		
		/** @private */
		public function set snapColor( value :Number ) :void
		{
			if( m_snapContext.snapColor != value && value >= 0x000000 && value <= 0xFFFFFF )
				m_snapContext.snapColor = value;
			else
				m_snapContext.snapColor = 0x333333;
		}
		
		[Inspectable(category="Mapping", range="0,1", defaultValue="0.5")]
		/** The alpha value of the snap indicator. Default is 0.5. */
		public function get snapAlpha() :Number
		{
			return m_snapContext.snapAlpha;
		}
		
		/** @private */
		public function set snapAlpha( value :Number ) :void
		{
			if( m_snapContext.snapAlpha != value && value >= 0 && value <= 1 )
				m_snapContext.snapAlpha = value;
			else
				m_snapContext.snapAlpha = 0.5;
		}
		
		/**
		 * Constructs a new WFSTransactionalLayer object.
		 * @param url the URL of the WFS endpoint.
		 */
		public function WFSTLayer( url :String = null )
		{
			super(url);
			addEventListener( FlexEvent.HIDE, onHide );			

			var sort :Sort = new Sort();
			sort.fields = [new SortField("Name", false, false )];
			selectedFeatureAttributes.sort = sort;
			selectedFeatureAttributes.refresh();
			
			m_renderer = new WFSRenderer();
			
			//m_renderer.ShowDepot(true);
		}
		
		/**
		 * The snap function allows a user to override the snapping functionality with their own algorithm.
		 * The function must have the form:
		 * mySnapFunction( context :SnapContext ) :MapPoint
		 * This function can be used as the source for data binding.
		 * @see SnapContext
		 * @see MapPoint
		 */
		public var snapFunction :Function = SnapUtil.findSnapPoint;
		
		/**
		 * This function allows an outside method to determine the snapping mode for the layer.
		 * The layer name or id must be passed as the parameter and the function will return the snap mode.
		 * The function must have the form:
		 * mySnapEnabledFunction() :String
		 * This function can be used as the source for data binding.
		 * @see SnapMode.NONE
		 * @see SnapMode.EDGE
		 * @see SnapMode.END
		 * @see SnapMode.VERTEX
		 */
		public var snapEnabledFunction :Function = null;
		
		/**
		 * The tolerance, in pixels, used to determine whether the mouse is to
		 * move a vertex of a geometry, or the center of the geometry.
		 */
		public function get selectTolerance() :int
		{
			return m_selectTolerance;
		}
		
		/** @private */
		public function set selectTolerance( value :int ) :void
		{
			if( m_selectTolerance != value )
				m_selectTolerance = value;
		}
		
		/** To select a feature without clicking it (e.g. from a list) */
		public function setselectedFeature( gml_id: String ) :void
		{
			var i: int = 0;
			
			if( m_selectedFeature != null )
			{
				m_selectedFeature.symbol = m_renderer.getSymbol( m_selectedFeature );
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			}
			
			while(i <= m_featureSet.features.length &&
				!(m_featureSet.features[i].attributes.GML_FEATURE_ID == gml_id) )
				i++;
			
			if(i <= m_featureSet.features.length)
			{
				m_selectedFeature = m_featureSet.features[i] as Graphic;
				m_selectedFeature.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				m_selectedFeature.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
				m_selectedFeatureID = m_selectedFeature.attributes.GML_FEATURE_ID;
				// add non-excluded feature attributes into the editor
				m_selectedFeatureAttributes.removeAll();
				for( var attribute :String in m_selectedFeature.attributes )
				{
					if( attribute != "GML_FEATURE_ID" )
						m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );
				}
				
				m_selectedFeatureAttributes.refresh();
				dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_SELECTED ) );
			}
		}
		/** The currently selected feature. */
		public function get selectedFeature() :Graphic
		{
			return m_selectedFeature;
		}
		
		/** The whole set of features. */
		public function get featureSetAttributes() :Array
		{
			return m_featureSet.attributes;
		}
		
		/**
		 * The collection of the currently selected feature attributes.
		 * The ArrayCollection contains Objects, where Name holds the
		 * attribute name, and Value holds the attribute value.
		 */ 
		public function get selectedFeatureAttributes() :ArrayCollection
		{
			return m_selectedFeatureAttributes;
		}
		
		/** Returns true if the layer is currently in edit mode on the selected point, false otherwise. */
		public function get editing() :Boolean
		{
			return m_editing;
		}
		
		/** Returns true if the layer has a selected feature, false otherwise. */
		public function get featureSelected() :Boolean
		{
			return m_selectedFeature != null;
		}
		
		/**
		 * Returns the geometry type of the features currently active in the layer.
		 * @see Geometry.type
		 * [See difference from the super class]
		 */
		override public function  geometryType() :String
		{
			return m_geometryType;
		}
		
		public function Refresh():void
		{
			for each( var graphic :Graphic in m_featureSet.features )
			{
				var featureID :String = graphic.attributes.GML_FEATURE_ID;
				graphic.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				graphic.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				graphic.addEventListener( MouseEvent.CLICK, onClick );
				if( !WFSUtil.containsString( featureID, m_featureIDs ) )
				{
					if( m_selectedFeatureID != null &&
						featureID == m_selectedFeatureID &&
						m_selectedFeature == null )
					{
						m_selectedFeature = graphic;
					}
					// added to initiate the drawing of the graphic
					// using the WFSRenderer version 2.4
					graphic.symbol = m_renderer.getSymbol(graphic);
					add( graphic );
					m_featureIDs.addItem( featureID );
				}
			}
			if( m_selectedFeature != null )
				m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
		}
		
		/*async responder for wfsQuery*/
		override protected function onWfsQSuccess( featureSet :FeatureSet, token :Object = null ) :void
		{
			if( m_clearGraphics )
			{
				clear();
				m_featureIDs.removeAll();
				m_clearGraphics = false;
			}
			
			m_featureSet.features=featureSet.features;
			/*
			for each( var graphic :Graphic in featureSet.features )
			{
				var featureID :String = graphic.attributes.GML_FEATURE_ID;
				graphic.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				graphic.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				graphic.addEventListener( MouseEvent.CLICK, onClick );
				if( !WFSUtil.containsString( featureID, m_featureIDs ) )
				{
					if( m_selectedFeatureID != null &&
						featureID == m_selectedFeatureID &&
						m_selectedFeature == null )
					{
						m_selectedFeature = graphic;
					}
					// added to initiate the drawing of the graphic
					// using the WFSRenderer version 2.4
					graphic.symbol = m_renderer.getSymbol(graphic);
					add( graphic );
					m_featureIDs.addItem( featureID );
				}
			}
			*/
			Refresh();
			
			if( m_selectedFeature != null )
				m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
			// event: loading complete
			dispatchEvent( new WFSEvent( WFSEvent.LOADING_COMPLETE ) );
		}
		
		/*async responder for wfsQuery*/
		override protected function onWfsQFailure( info :Object, token :Object = null ) :void
		{
			// event: loading failed
			dispatchEvent( new WFSEvent( WFSEvent.LOADING_FAILED ) );
			handleStringError( "Unable to load features - wfsQuery failed." );
		}
		
		
		/** Performs the query against the WFS endpoint. */ 
		
		override public function executeQuery() :void
		{
			if( map != null && !m_editing && hasRequiredParameters() && this.visible )
			{
				// initialize the feature type
				if( !m_featureAttributes && !m_geometryType )
					initializeFeatureType();
				
				if (map.spatialReference.wkid == 102100 || 
					map.spatialReference.wkid == 3857 )
					m_wfsQuery.extent = WebMercatorUtil.webMercatorToGeographic(map.extent) as Extent;
				else 
					m_wfsQuery.extent = map.extent;				

				//m_wfsQuery.extent = null;
				
				if( m_featureLimit > 0 && numChildren > m_featureLimit )
					m_clearGraphics = true;
				
				// event: loading started
				dispatchEvent( new WFSEvent( WFSEvent.LOADING_STARTED ) );
				if(toupdate)
				{
					toupdate=false;
					m_wfsQueryTask.execute( m_wfsQuery, new AsyncResponder(
						onWfsQSuccess,onWfsQFailure					
					) );
				}
				//else onWfsQSuccess(m_featureSet);
				else
					dispatchEvent( new WFSEvent( WFSEvent.LOADING_COMPLETE ) );
			}
		}
		
		
		/** Returns true if there are changes currently set in the transaction for later committal, false otherwise. */
		public function get hasChanges() :Boolean
		{
			return ( m_new || m_update || m_delete );
		}
		
		/**
		 * Clears the current feature selection.
		 * If editing was active, the edits are canceled before the selection is cleared.
		 */
		public function clearSelection() :void
		{
			// if editing, cancel edits that were not explicitly saved
			if( m_editing )
				cancelEdit();
			deselectFeature();
		}
		
		/** Begins editing the currently selected feature. */
		public function beginEdit() :void
		{
			// if editing, cancel edits that were not explicitly saved
			if( m_editing )
				cancelEdit();
			// backup the geometry in case the user wishes to cancel the edit
			backupSelectedGeometry();
			
			// set editing flag and state
			m_editing = true;
			m_selectedFeature.addEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
			m_selectedFeature.symbol = m_renderer.editSymbolFunction( m_selectedFeature );
			
			// retrieve lock here if this is not a new feature
			if( !m_new && String( m_selectedFeature.attributes.GML_FEATURE_ID ).search( "NEW_FEATURE_" ) == -1 )
			{
				// set the edit type
				if( !m_delete )
					m_update = true;
				
				// event: lock requested
				dispatchEvent( new WFSTEvent( WFSTEvent.LOCK_REQUESTED ) );
				
				// start the transaction by retrieving the lock
				var lockRequest :XML = WFSComm.lockRequestQuery(m_wfsQuery.featureName, m_wfsQuery.srsName, m_selectedFeature.attributes.GML_FEATURE_ID);
				var http :HTTPService = WFSUtil.createService( m_wfsQueryTask.url );
				var lockToken :AsyncToken = http.send( lockRequest );
				lockToken.addResponder( new AsyncResponder(
					function onSuccess( result :Object, token :Object = null ) :void
					{
						m_lockID = result.result.@lockId;
						
						// event: lock acquired
						dispatchEvent( new WFSTEvent( WFSTEvent.LOCK_ACQUIRED ) );
						
						if( m_featureAttributes != null )
							balanceAttributes(); 
						else
						{
							describeFeatureType( new AsyncResponder(
								function onSuccess( result :Object, token :Object = null ) :void
								{
									setFeatureAttributes( result.result );
									balanceAttributes();
								},
								function onFault( error :Object, token :Object = null ) :void
								{
									// if we can't describe the feature type
									var attributes :Object = getEmptyAttributes();
									balanceAttributes();
								}, this
							) );
						}
						
						dispatchEvent( new WFSTEvent( WFSTEvent.EDIT_BEGUN ) );
					},
					function onFailure( fault :FaultEvent, token :Object = null ) :void
					{
						// event: lock failed
						dispatchEvent( new WFSTEvent( WFSTEvent.LOCK_FAILED ) );
						
						handleStringError( "Unable to retrieve a lock." );
						cancelEdit();
					}, this
				) );
			}
			// new feature doesn't require a lock
			else
			{
				if( m_featureAttributes != null )
					balanceAttributes(); 
				else
				{
					describeFeatureType( new AsyncResponder(
						function onSuccess( result :Object, token :Object = null ) :void
						{
							setFeatureAttributes( result.result );
							balanceAttributes();
						},
						function onFault( error :Object, token :Object = null ) :void
						{
							// if we can't describe the feature type
							var attributes :Object = getEmptyAttributes();
							balanceAttributes();
						}, this
					) );
				}
				
				dispatchEvent( new WFSTEvent( WFSTEvent.EDIT_BEGUN ) );
			}
		}
		
		/**
		 * @private
		 * Retrieves details about the feature type from the server.
		 */
		private function initializeFeatureType() :void
		{
			describeFeatureType( new AsyncResponder(
				function onSuccess( result :Object, token :Object ) :void
				{
					setFeatureAttributes( result.result );
				},
				function onFault( error :Object, token :Object = null ) :void
				{
					// do nothing
				}, this
			) );
		}
		
		/**
		 * @private
		 * Makes the request to describe the WFS feature type and sets the feature attributes.
		 * @param responder The AsyncResponder to handle the result.
		 */
		protected function describeFeatureType( responder :AsyncResponder ) :void
		{
			var request :XML = WFSComm.DescribeFeatureTypeQuery(m_wfsQuery.featureNamespace,m_wfsQuery.featureName);
			var http :HTTPService = WFSUtil.createService( m_wfsQueryTask.url );
			var token :AsyncToken = http.send( request );
			token.addResponder( responder );
		}
		
		/** Saves the edits made to the currently selected feature. */ 
		public function saveEdit() :void
		{
			// event: transaction started
			dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_STARTED ) );
			
			// save updated feature attributes
			if( m_update )
			{
				for each( var attribute :Object in m_updatedAttributes )
					m_selectedFeature.attributes[attribute.Name] = attribute.Value;
			}
			
			// clean up
			m_selectedFeature.removeEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
			m_editing = false;
			m_usingCenter = false;
			m_startPoint = null;
			m_delta = NaN;
			m_offsetX = NaN;
			m_offsetY = NaN;
			m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
			
			// send the transaction
			sendTransaction();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.EDIT_SAVED ) );
		}
		
		/** Cancels the edits made to the currently selected feature. */
		public function cancelEdit() :void
		{
			m_updatedAttributes.removeAll();
			m_selectedFeature.removeEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
			
			// clone the backup geometry to avoid polluting our backup for future edits
			m_selectedFeature.geometry = copyGeometry( m_backupGeometry );
			m_selectedFeature.refresh();
			m_editing = false;
			m_updatedGeometry = false;
			m_usingCenter = false;
			m_startPoint = null;
			m_delta = NaN;
			m_offsetX = NaN;
			m_offsetY = NaN;
			m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
			
			// revert selected feature attributes to what exist in the selected feature
			m_selectedFeatureAttributes.removeAll();
			for( var attribute :String in m_selectedFeature.attributes )
			{
				if( attribute != "GML_FEATURE_ID" )
					m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );
			}
			m_selectedFeatureAttributes.refresh();
			
			for each( var attr :Object in m_updatedAttributes )
			{
				// set all attribute values that were changed back to their original values
				for each( var selectedAttribute :Object in m_selectedFeatureAttributes )
				{
					if( selectedAttribute.Name == attr.Name )
						selectedAttribute.Value = m_selectedFeature.attributes[attr.Name];
					continue;
				}
			}
			m_selectedFeatureAttributes.refresh();
			if( m_backupGeometry && m_selectedFeature != null )
			{
				m_selectedFeature.geometry = copyGeometry( m_backupGeometry );
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				//m_selectedFeature.symbol = symbolFunction( m_selectedFeature );
				m_selectedFeature.symbol = m_renderer.getSymbol( m_selectedFeature );
				m_selectedFeature.refresh();
			}
			
			// reset new feature
			if( m_new )
				remove( m_selectedFeature );
			
			// reset deleted feature
			if( m_delete )
				m_selectedFeature.visible = true;
			deselectFeature();
			
			m_updatedGeometry = false;
			m_updatedAttributes.removeAll();
			m_new = false;
			m_update = false;
			m_delete = false;
			
			cancelTransaction();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.EDIT_CANCELED ) );
		}
		
		/**
		 * Updates the attribute value for the currently selected feature, if it is currently being edited.
		 * @param attribute The attribute name.
		 * @param value The new attribute value.
		 */
		public function setAttributeValue( attribute :String, value :Object ) :void
		{
			if( m_editing )
			{
				if( m_selectedFeature.attributes.GML_FEATURE_ID.search( "NEW_FEATURE_" ) > -1 )
					m_selectedFeature.attributes[attribute] = value;
				else
					m_updatedAttributes.addItem( { Name: attribute, Value: value } );
				
				dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_UPDATED ) );
			}
		}
		
		/** Deletes the currently selected feature and adds it to the transaction. */
		public function deleteFeature() :void
		{
			m_selectedFeature.visible = false;
			m_delete = true;

			beginEdit();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_DELETED ) );
		}
		
		/**
		 * Inserts a new feature based on the initial geometry given.
		 * Once the feature is added it may be edited like any existing feature before
		 * commitment of the transaction.
		 * @param geometry The geometry defining the new feature.
		 */
		public function insertFeature( geometry :Geometry ) :void
		{
			if( m_featureAttributes != null )
				addFeature( getFeatureAttributes(), geometry ); 
			else
			{
				var request :XML = WFSComm.DescribeFeatureTypeQuery(m_wfsQuery.featureNamespace, m_wfsQuery.featureName);
				var http :HTTPService = WFSUtil.createService( m_wfsQueryTask.url );
				var token :AsyncToken = http.send( request );
				token.addResponder( new AsyncResponder(
					function onSuccess( result :Object, token :Object = null ) :void
					{
						setFeatureAttributes( result.result );
						addFeature( getFeatureAttributes(), geometry );
					},
					function onFault( error :Object, token :Object = null ) :void
					{
						// if we can't describe the feature type
						var attributes :Object = getEmptyAttributes();
						addFeature( getEmptyAttributes(), geometry );
					}, this
				) );
			}
		}
		
		/** Cancels the transaction. */
		public function cancelTransaction() :void
		{	
			var request :XML = WFSComm.cancelTransactionQuery();
			// set the lock ID if the transaction involves an update or delete
			if( m_lockID )
			{
				request.appendChild( <wfs:LockId xmlns:wfs={WFS}>{m_lockID}</wfs:LockId> );
				
				var http :HTTPService = WFSUtil.createService( m_wfsQueryTask.url );
				var token :AsyncToken = http.send( request );
				token.addResponder( new AsyncResponder(
					function onSuccess( result :Object, token :Object = null ) :void
					{
						m_lockID = null;
						// event: transaction canceled
						dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_CANCELED ) );
					},
					function onFailure( fault :FaultEvent, token :Object = null ) :void
					{
						handleStringError( "Unable to commit changes." );
					}, this
				) );
			}
			else
				dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_CANCELED ) );
			
		}
		
		/** Resets the layer state in the event. */
		override protected function resetLayerState() :void
		{
			deselectFeature();
			m_lockID = null;
			m_backupGeometry = null;
			m_editing = false;
			m_usingCenter = false;
			m_startPoint = null;
			m_editPoint = null;
			m_delta = NaN;
			m_offsetX = NaN;
			m_offsetY = NaN;
			m_featureAttributes = null;
			m_featureTypes.removeAll();
			m_new = false;
			m_update = false;
			m_delete = false;
			clear();
		}
		
		/**
		 * @private
		 * Retrieve the point coordinates string that represents the MapPoint.
		 * @param point The MapPoint.
		 * @return The point coordinates string.
		 */
		protected function getPointCoordinates( point :MapPoint ) :String
		{
			if( m_wfsQuery.swapCoordinates )
				return "" + point.y + " " + point.x;
			else
				return "" + point.x + " " + point.y;
		}
		
		/**
		 * @private
		 * Retrieve the point coordinates string that represents the Array of MapPoint objects.
		 * @param points The Array of MapPoint objects.
		 * @return The point coordinates string.
		 */
		protected function getPointsCoordinates( points :Array ) :String
		{
			var strings :Array = new Array();
			for each( var point :MapPoint in points )
			{
				if( m_wfsQuery.swapCoordinates )
					strings.push( "" + point.y + " " + point.x );
				else
					strings.push( "" + point.x + " " + point.y );						
			}
			return strings.join( " " );
		}
		
		/**
		 * @private
		 * Backs up the geometry of the selected feature to allow for rollback to geometry edits.
		 */
		protected function backupSelectedGeometry() :void
		{
			if( m_selectedFeature != null )
			{
				m_backupGeometry = copyGeometry( m_selectedFeature.geometry );
				m_intermediateBackupGeometry = copyGeometry( m_selectedFeature.geometry );
			}
		}
		
		/**
		 * @private
		 * Creates a deep copy of the given geometry.
		 * @return The copy of the given geometry.
		 */
		protected function copyGeometry( geometry :Geometry ) :Geometry
		{
			var copy :Geometry = null;
			if( geometry != null )
			{
				switch( geometry.type )
				{
					case Geometry.MAPPOINT:
					    var point :MapPoint = geometry as MapPoint;
						copy = new MapPoint( point.x, point.y, point.spatialReference );
						break;
					
					case Geometry.POLYGON:
						var polygon :Polygon = geometry as Polygon;
						var newRings :Array = new Array();
						for each( var ring :Array in polygon.rings )
						{
							var newRing :Array = new Array();
							for each( var ringPoint :MapPoint in ring )
								newRing.push( new MapPoint( ringPoint.x, ringPoint.y, ringPoint.spatialReference ) );
							newRings.push( newRing );
						}

						copy = new Polygon( newRings, polygon.spatialReference );
						break;

					case Geometry.POLYLINE:
						var polyline :Polyline = geometry as Polyline;
						var newPaths :Array = new Array();
						for each( var path :Array in polyline.paths )
						{
							var newPath :Array = new Array();
							for each( var pathPoint :MapPoint in path )
								newPath.push( new MapPoint( pathPoint.x, pathPoint.y, pathPoint.spatialReference ) );
							newPaths.push( newPath );
						}

						copy = new Polyline( newPaths, polyline.spatialReference );
						break;	
				}
			}
			
			return copy;
		}
		
		/**
		 * @private
		 * Finds the closest geometry vertex based on the tolerance (pixels).
		 * If none are within the tolerance, the center point is chosen.
		 * @param points The Array of MapPoint objects.
		 */
		protected function findGeometryEditPoint( points :Array ) :void
		{
			var tolerance :int = m_selectTolerance * m_selectTolerance;
			// if it's not within 20 pixels, skip it
			for each( var point :MapPoint in points )
			{
				var pointPixel :Point = map.toScreen( point );
				var startPixel :Point = map.toScreen( m_startPoint );
				var curDelta :Number = Math.pow( pointPixel.x - startPixel.x, 2 ) + Math.pow( pointPixel.y - startPixel.y, 2 );
				if( !isNaN( m_delta ) )
				{
					if( curDelta < m_delta && curDelta < tolerance )
					{
						m_delta = curDelta;
						m_editPoint = point;
						m_offsetX = m_editPoint.x - m_startPoint.x;
						m_offsetY = m_editPoint.y - m_startPoint.y;
					}
				}
				else if( curDelta < tolerance )
				{
					m_delta = Math.pow( pointPixel.x - startPixel.x, 2 ) + Math.pow( pointPixel.y - startPixel.y, 2 );
					m_editPoint = point;
					m_offsetX = m_editPoint.x - m_startPoint.x;
					m_offsetY = m_editPoint.y - m_startPoint.y;
				}
			}
		}
		
		/**
		 * @private
		 * Update the position of the geometry points based on the current point.
		 * @param curPoint The current MapPoint.
		 */
		protected function updatePointPositions( curPoint :MapPoint ) :void
		{
			var dX :Number = curPoint.x - m_startPoint.x;
			var dY :Number = curPoint.y - m_startPoint.y;
			var i :int = 0;
			var j :int = 0;
			switch( m_selectedFeature.geometry.type )
			{
				case Geometry.POLYGON:
					var polygon :Polygon = m_selectedFeature.geometry as Polygon;
				    for each( var ring :Array in Polygon( m_intermediateBackupGeometry ).rings )
				    {
				    	for each( var ringPoint :MapPoint in ring )
				    	{
				    		polygon.rings[i][j].x = ringPoint.x + dX;
							polygon.rings[i][j].y = ringPoint.y + dY;
				    		j += 1;
				    	}
				    	i += 1;
				    	j = 0;
				    }
					break;
				case Geometry.POLYLINE:
					var polyline :Polyline = m_selectedFeature.geometry as Polyline;
					for each( var path :Array in Polyline( m_intermediateBackupGeometry ).paths )
					{
						for each( var pathPoint :MapPoint in path )
						{
							polyline.paths[i][j].x = pathPoint.x + dX;
							polyline.paths[i][j].y = pathPoint.y + dY;
							j += 1;
						}
						i += 1;
					}
					break;
			}
		}
		
		/**
		 * @private
		 * Deselects the selected feature, if one is selected.
		 */
		protected function deselectFeature() :void
		{
			if( m_selectedFeature != null )
				m_selectedFeature.symbol = m_renderer.getSymbol( m_selectedFeature );

			m_selectedFeature = null;
			m_selectedFeatureID = null;
			m_selectedFeatureAttributes.removeAll();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_DESELECTED ) );
		}
		
		/**
		 * @private
		 * Retrieves the attributes in use on a feature, with null values for all.
		 * @return The attributes Object with no values set.
		 */
		protected function getEmptyAttributes() :Object
		{
			var attributes :Object = new Object();
			if( this.numChildren > 0 )
			{
				var graphic :Graphic = this.getChildAt( 0 ) as Graphic;
				for( var key :String in graphic.attributes )
				{
					attributes[key] = null;
				}
			}
			return attributes;
		}
		
		/**
		 * @private
		 * Parses and sets the feature attributes.
		 */
		protected function setFeatureAttributes( xml :XML ) :void
		{
			m_featureAttributes = new Object();
			for each( var element :XML in xml..XS::element )
			{
				var name :String = element.@name;
				if( name != m_wfsQuery.featureName && name.toLowerCase() != m_wfsQuery.shapeField.toLowerCase() )
					m_featureAttributes[name] = null;

				else if( name.toLowerCase() == m_wfsQuery.shapeField.toLowerCase() )
				{
					var shapeType :String = element.@type;
					shapeType = shapeType.substr( 4 ); // remove the 'gml:' characters
					if( shapeType == "PointPropertyType" )
						m_geometryType = Geometry.MAPPOINT;

					else if( shapeType == "MultiSurfacePropertyType" ||
							 shapeType == "PolygonPropertyType" ||
							 shapeType == "SurfacePropertyType" )
						m_geometryType = Geometry.POLYGON;

					else if( shapeType == "MultiCurvePropertyType" ||
							 shapeType == "LineStringPropertyType" ||
							 shapeType == "CurvePropertyType" ||
							 shapeType == "MultiLineStringPropertyType") //this one added... 
					    m_geometryType = Geometry.POLYLINE;
				}
			}
		}
		
		/**
		 * @private
		 * Get a copy of the feature attributes.
		 * @return The empty feature attributes.
		 */
		protected function getFeatureAttributes() :Object
		{
			var attributes :Object = new Object();
			for( var attribute :String in m_featureAttributes )
				attributes[attribute] = null;

			return attributes;
		}
		
		/**
		 * @private
		 * Add the available feature attributes that haven't been set in the feature to the selected feature attributes list.
		 */
		protected function balanceAttributes() :void
		{
			var attributes :Object;
			if( m_featureAttributes != null )
				attributes = m_featureAttributes;
			else
				attributes = getEmptyAttributes();
			
			var usedAttributes :ArrayCollection = new ArrayCollection();
			m_selectedFeatureAttributes.removeAll();
			
			// add existing attributes from the selected feature
			for( var attribute :String in m_selectedFeature.attributes )
			{
				if( attribute != "GML_FEATURE_ID" )
				{
					m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );
					usedAttributes.addItem( attribute );
				}
			}
			
			// add attributes that are available for the feature but aren't set yet
			for( attribute in attributes )
			{
				if( attribute != "GML_FEATURE_ID" && !WFSUtil.containsString( attribute, usedAttributes ) )
					m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );
			}
			// refresh the selected feature attributes list
			m_selectedFeatureAttributes.refresh();
		}
		
		/**
		 * @private
		 * Add the new feature to the map and the transaction.
		 * @param attributes The feature attributes with empty values.
		 * @param geometry The feature geometry.
		 */
		protected function addFeature( attributes :Object, geometry :Geometry ) :void
		{
			if( geometry != null )
				geometry.spatialReference = map.spatialReference;
			
			// describe feature type
			var aliases :Object = new Object();
			for( var key :String in attributes )
				aliases[key] = key;
					
			var newFeature :Graphic = new Graphic();
			newFeature.geometry = geometry;
			newFeature.attributes = attributes;
			
			// set as selected feature
			newFeature.attributes.GML_FEATURE_ID = "NEW_FEATURE_";
			// newFeature.attributes.GML_FEATURE_ID = "NEW_FEATURE_" + m_newFeatures.length;
			
			// add the mouse handlers and set the symbol
			newFeature.addEventListener( MouseEvent.CLICK, onClick );
			newFeature.symbol = m_renderer.selectSymbolFunction( newFeature );

			// add the feature to the list of graphics
			add( newFeature );
			
			// select item
			m_selectedFeature = newFeature;
			m_selectedFeatureID = newFeature.attributes.GML_FEATURE_ID;
			m_selectedFeatureAttributes.removeAll();
			for( var attribute :String in m_selectedFeature.attributes )
			{
				if( attribute != "GML_FEATURE_ID" )
					m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );
			}
			m_selectedFeatureAttributes.refresh();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_INSERTED ) );
			dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_SELECTED ) );
			
			m_new = true;
			beginEdit();
		}
		
		/**
		 * @private
		 * Send the transaction request.
		 */ 
		protected function sendTransaction() :void
		{
			var request :XML = WFSComm.sendTransactionQuery();
			
			// set the lock ID if the transaction involves an update or delete
			if( m_update || m_delete )
				request.appendChild( <wfs:LockId xmlns:wfs={WFS}>{m_lockID}</wfs:LockId> );
			
			// add inserted element
			if( m_new )
			{
				var newFeatureXML :XML =
					<wfs:Insert idGen="GenerateNew" xmlns:wfs={WFS} xmlns:ogc={OGC} xmlns:gml={GML}>
					</wfs:Insert>;
				
				// add attributes
				var newFeatureDefinitionXML :XML = new XML(
					"<ns:" + m_wfsQuery.featureName + " xmlns:ns=\"" + m_wfsQuery.featureNamespace + "\" xmlns:gml=\"" + GML + "\">" +
					"</ns:" + m_wfsQuery.featureName + ">"
				);
				for( var key :String in m_selectedFeature.attributes )
				{
					var value :Object = m_selectedFeature.attributes[key];
					if( key != "GML_FEATURE_ID" && key.search( m_wfsQuery.shapeField + "." ) == -1 && value )
					{
						var newPropertyXML :XML = new XML(
							"<ns:" + key + " xmlns:ns=\"" + m_wfsQuery.featureNamespace + "\" xmlns:wfs=\"" + WFS + "\">" +
							m_selectedFeature.attributes[key] +
							"</ns:" + key + ">"
						);
						newFeatureDefinitionXML.appendChild( newPropertyXML );
					}
				}
				// add geometry property
				var newShapeXML :XML = new XML(
					"<ns:" + m_wfsQuery.shapeField + " xmlns:ns=\"" + m_wfsQuery.featureNamespace + "\" xmlns:gml=\"" + GML + "\">" +
					"</ns:" + m_wfsQuery.shapeField + ">"
				);
				
				switch( m_selectedFeature.geometry.type )
				{
					case Geometry.MAPPOINT:
						var newValueXML :XML =
							<gml:Point srsName={m_wfsQuery.srsName} xmlns:gml={GML}>
								<gml:pos>{getPointCoordinates( m_selectedFeature.geometry as MapPoint )}</gml:pos>
							</gml:Point>;
						newShapeXML.appendChild( newValueXML );										
						break;
					case Geometry.POLYGON:
						// let's assume that the first ring is exterior and all others are interior
						var newPolygon :Polygon = m_selectedFeature.geometry as Polygon;
						var newPolygonValueXML :XML =
							<gml:MultiSurface srsName={m_wfsQuery.srsName} xmlns:gml={GML}>
								<gml:surfaceMember>
									<gml:Polygon srsName={m_wfsQuery.srsName} xmlns:gml={GML}></gml:Polygon>
								</gml:surfaceMember>
							</gml:MultiSurface>;
						if( newPolygon.rings.length > 0 )
						{
							var newExteriorXML :XML =
								<gml:exterior xmlns:gml={GML}>
									<gml:LinearRing srsName={m_wfsQuery.srsName}>
										<gml:posList>{getPointsCoordinates( newPolygon.rings[0] )}</gml:posList>
									</gml:LinearRing>
								</gml:exterior>;
							newPolygonValueXML.GML::surfaceMember.GML::Polygon.appendChild( newExteriorXML );
						}
						if( newPolygon.rings.length > 1 )
						{
							for( var newRingIndex :int = 1; ringIndex < newPolygon.rings.length; ringIndex++ )
							{
								var newInteriorXML :XML =
									<gml:interior xmlns:gml={GML}>
										<gml:LinearRing srsName={m_wfsQuery.srsName}>
											<gml:posList>{getPointsCoordinates( newPolygon.rings[newRingIndex] )}</gml:posList>
										</gml:LinearRing>
									</gml:interior>
								newPolygonValueXML.GML::surfaceMember.GML::Polygon.appendChild( newInteriorXML );
							}
						}
						newShapeXML.appendChild( newPolygonValueXML );
						break;
					case Geometry.POLYLINE:
						var newPolyline :Polyline = m_selectedFeature.geometry as Polyline;
						var newMultiCurveValueXML :XML =
								<gml:MultiCurve srsName={m_wfsQuery.srsName} xmlns:gml={GML}>
									<gml:curveMember></gml:curveMember>
								</gml:MultiCurve>;
						for each( var newPath :Array in newPolyline.paths )
						{
							var newLineStringXML :XML =
								<gml:LineString xmlns:gml={GML} srsName={m_wfsQuery.srsName}>
									<gml:posList>{getPointsCoordinates( newPath )}</gml:posList>
								</gml:LineString>;
							newMultiCurveValueXML.GML::curveMember.appendChild( newLineStringXML );
						}
						newShapeXML.appendChild( newMultiCurveValueXML );
						break;
				}
				
				newFeatureDefinitionXML.appendChild( newShapeXML );
				newFeatureXML.appendChild( newFeatureDefinitionXML );
				request.appendChild( newFeatureXML );
			}
			// add deleted element
			else if( m_delete )
			{
				var deletedFeatureID :String = m_selectedFeature.attributes.GML_FEATURE_ID; 
				var deleteFeatureXML :XML =
					<wfs:Delete typeName={"ns:" + m_wfsQuery.featureName} xmlns:wfs={WFS} xmlns:ogc={OGC} xmlns:gml={GML}>
						<ogc:Filter xmlns:ogc={OGC}>
							<ogc:FeatureId fid={deletedFeatureID}/>
						</ogc:Filter>
					</wfs:Delete>;
				request.appendChild( deleteFeatureXML );
			}
			// add updated element
			else if( m_update )
			{
				var updateFeatureXML :XML = <wfs:Update typeName={"ns:" + m_wfsQuery.featureName} xmlns:wfs={WFS}></wfs:Update>;
				// set updated attributes 
				if( m_selectedFeature.attributes )
				{
					for( key in m_selectedFeature.attributes )
					{
						if( key != "GML_FEATURE_ID" )
						{
							var propertyXML :XML =
								<wfs:Property xmlns:wfs={WFS}>
									<wfs:Name>{key}</wfs:Name>
									<wfs:Value>{m_selectedFeature.attributes[key]}</wfs:Value>
								</wfs:Property>;
							updateFeatureXML.appendChild( propertyXML );
						}
					}
				}
				// set updated geometry
				if( m_selectedFeature.geometry )
				{
					var shapeXML :XML =
						<wfs:Property xmlns:wfs={WFS} xmlns:gml={GML}>
							<wfs:Name>{m_wfsQuery.shapeField}</wfs:Name>
						</wfs:Property>;
					
					switch( m_selectedFeature.geometry.type )
					{
						case Geometry.MAPPOINT:
							var valueXML :XML =
								<wfs:Value xmlns:wfs={WFS} xmlns:gml={GML}>
									<gml:Point srsName={m_wfsQuery.srsName}>
										<gml:pos>{getPointCoordinates( m_selectedFeature.geometry as MapPoint )}</gml:pos>
									</gml:Point>
								</wfs:Value>;
							shapeXML.appendChild( valueXML );										
							break;
						case Geometry.POLYGON:
							// let's assume that the first ring is exterior and all others are interior
							var polygon :Polygon = m_selectedFeature.geometry as Polygon;
							var polygonValueXML :XML =
								<wfs:Value xmlns:wfs={WFS} xmlns:gml={GML}>
									<gml:Polygon srsName={m_wfsQuery.srsName}></gml:Polygon>
								</wfs:Value>;
							if( polygon.rings.length > 0 )
							{
								var exteriorXML :XML =
									<gml:exterior xmlns:gml={GML}>
										<gml:LinearRing srsName={m_wfsQuery.srsName}>
											<gml:posList>{getPointsCoordinates( polygon.rings[0] )}</gml:posList>
										</gml:LinearRing>
									</gml:exterior>;
								polygonValueXML.GML::Polygon.appendChild( exteriorXML );
							}
							if( polygon.rings.length > 1 )
							{
								for( var ringIndex :int = 1; ringIndex < polygon.rings.length; ringIndex++ )
								{
									var interiorXML :XML =
										<gml:interior xmlns:gml={GML}>
											<gml:LinearRing srsName={m_wfsQuery.srsName}>
												<gml:posList>{getPointsCoordinates( polygon.rings[ringIndex] )}</gml:posList>
											</gml:LinearRing>
										</gml:interior>
									polygonValueXML.GML::Polygon.appendChild( interiorXML );
								}
							}
							shapeXML.appendChild( polygonValueXML );
							break;
						case Geometry.POLYLINE:
							var polyline :Polyline = m_selectedFeature.geometry as Polyline;
							var multiCurveValueXML :XML =
								<wfs:Value xmlns:wfs={WFS} xmlns:gml={GML}>
									<gml:MultiCurve srsName={m_wfsQuery.srsName}>
										<gml:curveMember></gml:curveMember>
									</gml:MultiCurve>
								</wfs:Value>;
							for each( var path :Array in polyline.paths )
							{
								var lineStringXML :XML =
									<gml:LineString xmlns:gml={GML} srsName={m_wfsQuery.srsName}>
										<gml:posList>{getPointsCoordinates( path )}</gml:posList>
									</gml:LineString>;
								multiCurveValueXML.GML::MultiCurve.GML::curveMember.appendChild( lineStringXML );
							}
							shapeXML.appendChild( multiCurveValueXML );
							break;
					}
					updateFeatureXML.appendChild( shapeXML );
				}
				
				var filterXML :XML =
					<ogc:Filter xmlns:ogc={OGC}>
						<ogc:FeatureId fid={m_selectedFeature.attributes.GML_FEATURE_ID}/>
					</ogc:Filter>;
				updateFeatureXML.appendChild( filterXML );
				request.appendChild( updateFeatureXML );
			}
			
			var http :HTTPService = WFSUtil.createService( m_wfsQueryTask.url );
			var token :AsyncToken = http.send( request );
			token.addResponder( new AsyncResponder(
				function onSuccess( result :Object, token :Object = null ) :void
				{
					handleResponse( result.result, token, onTransactionComplete );
				},
				function onFailure( fault :FaultEvent, token :Object = null ) :void
				{
					// event: transaction failed
					dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_FAILED ) );
					
					cancelEdit();
					
					handleStringError( "Unable to commit changes." );
				}, this
			) );
		}
		
		/**
		 * @private
		 * Handles cleanup after the transaction is complete.
		 * @param xml The XML response.
		 */
		protected function onTransactionComplete( xml :XML ) :void
		{
			// clear lock
			m_lockID = null;
			
			// remove the graphic from the map if it was deleted
			if( m_delete || m_new )
				remove( m_selectedFeature );

			deselectFeature();
			
			// reset the transaction aggregators
			m_new = false;
			m_update = false;
			m_delete = false;
			
			// execute a new query to retrieve all the inserted and updated points
			executeQuery();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_COMMITTED ) );
		}
		
		/**
		 * @private
		 * Handles the response from the WFS endpoint.
		 * @param result The request result.
		 * @param token The token, if one is in use.
		 * @param operation The function to call in event of a successful response.
		 */
		protected function handleResponse( result :Object, token :Object = null, operation :Function = null ) :void
		{
			if( result.result == "" )
				handleStringError( "Empty result. Check parameters." );
			else
			{
				try
				{
					var response :XML = result as XML;
					if( response.name() == OWS + "::ExceptionReport" )
	                	handleError( response );
	                else
						operation.call( this, response );
	   			}
                catch( resultError :Error )
                {
                	handleStringError( resultError.toString() );
                }
			}
		}
		
		/**
		 * @private
		 * Handles a WFS ExceptionReport.
		 * @param xml the ExceptionReport XML object.
		 */
		private function handleError( xml :XML ) :void
		{
			var faultCode :String = xml.OWS::Exception.@exceptionCode;
			var faultString :String = xml..OWS::ExceptionText;
			var fault : Fault = new Fault( faultCode, faultString );
			fault.rootCause = xml;
			dispatchEvent( new FaultEvent( FaultEvent.FAULT, false, true, fault ));
		}
		
		// Mouse Handlers
		/**
		 * @private
		 * Handles the mouse over event.
		 * @param event The MouseEvent.
		 */
		protected function onMouseOver( event :MouseEvent ) :void
		{
			var graphic : Graphic = event.target as Graphic;
			graphic.symbol = m_renderer.selectSymbolFunction( graphic );
		}
		
		/**
		 * @private
		 * Handles the mouse out event.
		 * @param event The MouseEvent.
		 */	
		protected function onMouseOut( event :MouseEvent ) :void
		{
			var graphic :Graphic = event.target as Graphic;
			
			if( m_selectedFeature == graphic )
				graphic.symbol = m_renderer.selectSymbolFunction( graphic );
				
			else
				graphic.symbol = m_renderer.getSymbol ( graphic );
		}
		
		/**
		 * @private
		 * Handles the click event for selecting and/or deselecting the feature.
		 * @param event The MouseEvent.
		 */
		private function onClick( event :MouseEvent ) :void
		{
			if( !m_editing )
			{
				if( m_selectedFeature == event.target as Graphic )
				{
					m_selectedFeature.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
					m_selectedFeature.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
					m_selectedFeature.symbol = m_renderer.getSymbol( m_selectedFeature );
					deselectFeature();
				}
				else
				{
					if( m_selectedFeature != null )
					{
						m_selectedFeature.symbol = m_renderer.getSymbol( m_selectedFeature );
						m_selectedFeature.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
						m_selectedFeature.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
					}
					m_selectedFeature = event.target as Graphic;
					m_selectedFeature.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
					m_selectedFeature.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
					m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
					m_selectedFeatureID = m_selectedFeature.attributes.GML_FEATURE_ID;
					
					// add non-excluded feature attributes into the editor
					m_selectedFeatureAttributes.removeAll();
					for( var attribute :String in m_selectedFeature.attributes )
					{
						if( attribute != "GML_FEATURE_ID" )
							m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );
					}
					m_selectedFeatureAttributes.refresh();
					
					dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_SELECTED ) );
				}
			}
		}
		
		/**
		 * @private
		 * Setup the snapping information.
		 */
		private function setupSnapContext() :void
		{			
			var screenPoint :Point = map.toScreen( m_startPoint );
			var snapToShape :Shape = new Shape();
			snapToShape.name = "snapShape";
			snapToShape.x = screenPoint.x;
			snapToShape.y = screenPoint.y;
			snapToShape.graphics.clear();
			snapToShape.graphics.beginFill( m_snapContext.snapColor, m_snapContext.snapAlpha );
			snapToShape.graphics.drawCircle( 0, 0, m_snapContext.snapTolerance );
			snapToShape.graphics.endFill();
			
			m_snapContext.map = this.map;
			m_snapContext.graphicProvider = this.graphicProvider as ArrayCollection;
			m_snapContext.selectedGraphic = m_selectedFeature;
			m_snapContext.snapShape = snapToShape;
			
			//map.rawChildren.addChild( m_snapContext.snapShape );
			map.addChild(m_snapContext.snapShape);
		}
		
		/**
		 * @private
		 * Update the snapping information.
		 */
		private function updateSnapContext( point :MapPoint ) :void
		{
			var screenPoint :Point = map.toScreen( point );
			m_snapContext.snapShape.x = screenPoint.x;
			m_snapContext.snapShape.y = screenPoint.y;
			m_snapContext.snapShape.graphics.clear();
			m_snapContext.snapShape.graphics.beginFill( m_snapContext.snapColor, m_snapContext.snapAlpha );
			m_snapContext.snapShape.graphics.drawCircle( 0, 0, m_snapContext.snapTolerance );
			m_snapContext.snapShape.graphics.endFill();
			m_snapContext.origin = point;
		}
		
		/**
		 * @private
		 * Reset the snapping information.
		 */
		private function resetSnapContext() :void
		{
			//map.rawChildren.removeChild( m_snapContext.snapShape );
			map.removeChild( m_snapContext.snapShape );
			m_snapContext.map = null;
			m_snapContext.graphicProvider = null;
			m_snapContext.selectedGraphic = null;
			m_snapContext.snapShape = null;
			m_snapContext.origin = null;
		}
		
		/**
		 * @private
		 * Handles the mouse down during an edit.
		 * @param event The MouseEvent.
		 */
		protected function onEditMouseDown( event :MouseEvent ) :void
		{
			if( m_editing )
			{
				m_selectedFeature.removeEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
				
				// manage mouse event listeners
				m_startPoint = map.toMapFromStage( event.stageX, event.stageY );
				
				// handle snapping
				if( snappingEnabled() )
					setupSnapContext();
				
				// make sure the intermediate backup is updated
				m_intermediateBackupGeometry = copyGeometry( m_selectedFeature.geometry );
				
				// find closest point within a set pixel distance and select that point, otherwise move the entire geometry
				// then set the offset of the start point from the edit point
				switch( m_selectedFeature.geometry.type )
				{
					case Geometry.MAPPOINT:
						m_editPoint = m_selectedFeature.geometry as MapPoint;
						m_offsetX = m_editPoint.x - m_startPoint.x;
						m_offsetY = m_editPoint.y - m_startPoint.y;
						break;
					case Geometry.POLYGON:
						var polygon :Polygon = m_selectedFeature.geometry as Polygon;
						// search vertices for proximity to click
						// if none are close enough choose center
						for each( var ring :Array in polygon.rings )
						{
							findGeometryEditPoint( ring );
						}
						if( isNaN( m_delta ) )
						{
							m_editPoint = polygon.extent.center;
							m_offsetX = m_editPoint.x - m_startPoint.x;
							m_offsetY = m_editPoint.y - m_startPoint.y;
							m_usingCenter = true;
						}
						break;
					case Geometry.POLYLINE:
						var polyline :Polyline = m_selectedFeature.geometry as Polyline;
						// search vertices for proximity to click
						for each( var path :Array in polyline.paths )
						{
							findGeometryEditPoint( path );
						}
						if( isNaN( m_delta ) )
						{
							m_editPoint = polyline.extent.center;
							m_offsetX = m_editPoint.x - m_startPoint.x;
							m_offsetY = m_editPoint.y - m_startPoint.y;
							m_usingCenter = true;
						}
						break;
				}	
				
				map.addEventListener( MouseEvent.MOUSE_MOVE, onEditMouseMove );
				map.addEventListener( MouseEvent.MOUSE_UP, onEditMouseUp );
			}
		}
		
		/**
		 * @private
		 * Handles the mouse movement during an edit.
		 * @param event The MouseEvent.
		 */
		private function onEditMouseMove( event :MouseEvent ) :void
		{
			if( m_editing )
			{
				// flag that the geometry has been moved
				m_updatedGeometry = true;
				
				// update the geometry based on the movement
				var curPoint :MapPoint = map.toMapFromStage( event.stageX, event.stageY );
				
				// handle snapping
				var snap :Boolean = false;
				if( snappingEnabled() )
				{
					updateSnapContext( curPoint );
					
					// perform snapping calculation
					var newPoint :MapPoint = snapFunction( m_snapContext );
					
					// if the point is different from the current point, a snap point was found
					if( curPoint !== newPoint )
					{
						curPoint = newPoint;
						snap = true;
					}
				}
				
				// move edit point and refresh feature
				updateEditPoint( curPoint, snap );
				m_selectedFeature.refresh();
			}
		}
		
		/**
		 * @private
		 * Handles the mouse up during an edit.
		 * @param event The MouseEvent.
		 */
		private function onEditMouseUp( event :MouseEvent ) :void
		{
			if( m_editing )
			{
				map.removeEventListener( MouseEvent.MOUSE_MOVE, onEditMouseMove );
				map.removeEventListener( MouseEvent.MOUSE_UP, onEditMouseUp );
				
				var curPoint :MapPoint = map.toMapFromStage( event.stageX, event.stageY );
				
				// handle snapping
				var snap :Boolean = false;
				if( snappingEnabled() )
				{
					updateSnapContext( curPoint );
					
					// perform snapping calculation
					var newPoint :MapPoint = snapFunction( m_snapContext );
					
					// if the point is different from the current point, a snap point was found
					if( curPoint !== newPoint )
					{
						curPoint = newPoint;
						snap = true;
					}
					
					resetSnapContext();
				}
				
				// move edit point and refresh feature
				updateEditPoint( curPoint, snap );
				m_selectedFeature.refresh();
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
				
				// clean up editing attributes
				m_usingCenter = false;
				m_startPoint = null;
				m_delta = NaN;
				m_offsetX = NaN;
				m_offsetY = NaN;
				
				if( m_updatedGeometry )
					dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_UPDATED ) );
			}
		}
		
		/**
		 * @private
		 * Update the edit point, taking into account whether snapping is enabled
		 * and if we are moving the center point.
		 * @param point The new edit point value.
		 * @param snap True if snapping was used for this update, false otherwise.
		 */
		private function updateEditPoint( point :MapPoint, snap :Boolean ) :void
		{
			if( m_usingCenter )
				updatePointPositions( point );
			else
			{
				m_editPoint.x = snap ? point.x : point.x + m_offsetX;
				m_editPoint.y = snap ? point.y : point.y + m_offsetY;
			}
		}
		
		/**
		 * @private
		 * Prepares the layer for showing later.
		 */
		private function onHide( event :FlexEvent ) :void
		{
			if( editing )
				cancelEdit();

			deselectFeature();
			clear();
			m_featureIDs.removeAll();
		}
		
		/**
		 * @private
		 * Returns true if snapping is enabled by either setting the snap mode or having a symbol function, false otherwise.
		 */
		private function snappingEnabled() :Boolean
		{
			if( snapEnabledFunction != null && m_renderer.getSymbol != null )
				return snapEnabledFunction();
			return SnapUtil.snappingEnabled( m_snapContext.snapMode ) && m_renderer.getSymbol != null;
		}
	}
	
	
}