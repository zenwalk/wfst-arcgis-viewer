/***************************************************
 *** Update By : Raffaello Bertini                ***
 ***                                              *** 
 *** Date: 2012 - Oct                             ***
 ***----------------------------------------------***
 *** Note: Future Works need to implement more    ***
 *** outputs sub-type formats: KML, ShapeTipe     ***
 *** GML 3.3 -- WFS 2.0	-- etc...				  ***								
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
	import com.esri.wfs.renderers.WFSTLazyLockRenderer;
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
	 * Dispatched when a task call fails.
	 * @eventType mx.rpc.events.FaultEvent.FAULT
	 */
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
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
	 * Dispatched when editing of the selected feature begins.
	 * @eventType com.esri.wfs.events.WFSTEvent.EDIT_BEGUN
	 */
	[Event(name="editBegun", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when the edits made to the the selected feature are saved.
	 * @eventType com.esri.wfs.events.WFSTEvent.EDIT_SAVED
	 */
	[Event(name="editSaved", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when editing of the selected feature is canceled.
	 * @eventType com.esri.wfs.events.WFSTEvent.EDIT_CANCELED
	 */
	[Event(name="editCanceled", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is selected.
	 * @eventType com.esri.wfs.events.WFSTEvent.FEATURE_SELECTED
	 */
	[Event(name="featureSelected", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is deselected.
	 * @eventType com.esri.wfs.events.WFSTEvent.FEATURE_DESELECTED
	 */
	[Event(name="featureDeselected", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is inserted.
	 * @eventType com.esri.wfs.events.WFSTEvent.FEATURE_INSERTED
	 */
	[Event(name="featureInserted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is updated.
	 * @eventType com.esri.wfs.events.WFSTEvent.FEATURE_UPDATED
	 */
	[Event(name="featureUpdated", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched when a feature is deleted.
	 * @eventType com.esri.wfs.events.WFSTEvent.FEATURE_DELETED
	 */
	[Event(name="featureDeleted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after the transaction is started.
	 * @eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_STARTED
	 */
	[Event(name="transactionStarted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after the transaction is committed.
	 * @eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_COMMITTED
	 */
	[Event(name="transactionCommitted", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after the transaction is canceled.
	 * @eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_CANCELED
	 */
	[Event(name="transactionCanceled", type="com.esri.wfs.events.WFSTEvent")]
	
	/**
	 * Dispatched after a transaction fails.
	 * @eventType com.esri.wfs.events.WFSTransactionEvent.TRANSACTION_FAILED
	 */
	[Event(name="transactionFailed", type="com.esri.wfs.events.WFSTEvent")]
	
	[Bindable]
	/**
	 * Executes queries against a WFS endpoint and provides transactional commits to that same endpoint.
	 */
	public class WFSTLazyLockLayer extends WFSTLayer
	{
		// Updated features
		private var m_updatedFeatures :ArrayCollection = new ArrayCollection();
		
		// New features
		private var m_newFeatures :ArrayCollection = new ArrayCollection();
		
		// Deleted features
		private var m_deletedFeatures :ArrayCollection = new ArrayCollection();
		
		/** Alternate label for display purposes. */
		//public var label :String = null;
		
	
		/**
		 * Constructs a new WFSTransactionalLayer object.
		 * @param url the URL of the WFS endpoint.
		 */
		public function WFSTLazyLockLayer( url :String = null )
		{
			super(url);
			m_renderer = new WFSTLazyLockRenderer();
			/* all statements called by super() */
		}
		
		/** Returns true if there are changes currently set in the transaction for later committal, false otherwise.
		 * (lazy lock) [check] */
		override public function get hasChanges() :Boolean
		{
			return ( m_newFeatures.length > 0 ||
					 m_updatedFeatures.length > 0 ||
					 m_deletedFeatures.length > 0 );
		}
		
		
		/** Begins editing the currently selected feature. 
		 * (lazy lock) [check]*/
		override public function beginEdit() :void
		{
			// backup the geometry in case the user wishes to cancel the edit
			backupSelectedGeometry();
			
			// set editing flag and state
			m_editing = true;
			m_selectedFeature.addEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
			m_selectedFeature.symbol = m_renderer.editSymbolFunction( m_selectedFeature );
			
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
		
		/** Saves the edits made to the currently selected feature. 
		 *(lazy locks) [Check] */ 
		override public function saveEdit() :void
		{
			m_selectedFeature.removeEventListener( MouseEvent.MOUSE_DOWN, onEditMouseDown );
			m_editing = false;
			
			// if it's an updated feature
			if( String( m_selectedFeature.attributes.GML_FEATURE_ID ).search( "NEW_FEATURE_" ) == -1 &&
				!m_updatedFeatures.contains( m_selectedFeature ) )
			{
				var updatedFeature :Graphic = new Graphic();
				updatedFeature.attributes = new Object();
				if( m_updatedGeometry )
					updatedFeature.geometry = copyGeometry( m_selectedFeature.geometry );

				updatedFeature.attributes.GML_FEATURE_ID = m_selectedFeature.attributes.GML_FEATURE_ID;
				for each( var attribute :Object in m_updatedAttributes )
				{
					updatedFeature.attributes[attribute.Name] = attribute.Value;
					m_selectedFeature.attributes[attribute.Name] = attribute.Value;
				}
				saveUpdatedFeature( updatedFeature );
			}

			m_usingCenter = false;
			m_startPoint = null;
			m_delta = NaN;
			m_offsetX = NaN;
			m_offsetY = NaN;
			m_selectedFeature.symbol = m_renderer.selectSymbolFunction( m_selectedFeature );
			
			dispatchEvent( new WFSTEvent( WFSTEvent.EDIT_SAVED ) );
		}
		
		/** Cancels the edits made to the currently selected feature. 
		 * (lazy locks) [Check]*/
		override public function cancelEdit() :void
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
				if( attribute != "GML_FEATURE_ID" )
					m_selectedFeatureAttributes.addItem( { Name: attribute, Value: m_selectedFeature.attributes[attribute] } );

			m_selectedFeatureAttributes.refresh();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.EDIT_CANCELED ) );
		}
		
		/** Deletes the currently selected feature and adds it to the transaction. 
		 * (lazy locks) [Check]*/
		override public function deleteFeature() :void
		{
			// if editing, cancel edits that were not explicitly saved
			if( m_editing)
				cancelEdit();
			
			m_selectedFeature.visible = false;
			if( m_newFeatures.length > 0 &&
				m_selectedFeature.attributes.GML_FEATURE_ID.search( "NEW_FEATURE_" ) == -1 )
				m_newFeatures.removeItemAt( m_newFeatures.getItemIndex( m_selectedFeature ) );
			else
				m_deletedFeatures.addItem( m_selectedFeature );

			deselectFeature();
			dispatchEvent( new WFSTEvent( WFSTEvent.FEATURE_DELETED ) );
		}
		
		/**
		 * Inserts a new feature based on the initial geometry given.
		 * Once the feature is added it may be edited like any existing feature before
		 * commitment of the transaction.
		 * @param geometry The geometry defining the new feature.
		 * 
		 * (lazy locks) [Check]
		 */
		override public function insertFeature( geometry :Geometry ) :void
		{
			// if editing, cancel edits that were not explicitly saved
			if( m_editing )
				cancelEdit();
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
		
		/** Commits the transaction. */
		public function commitTransaction() :void
		{
			// event: transaction started
			dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_STARTED ) );
			
			// if editing, assume that commiting includes the current edits
			if( m_editing )
				saveEdit();
			
			// start the transaction by retrieving the lock
			var request :XML = 
				<wfs:GetFeatureWithLock xmlns:wfs={WFS} xmlns:gml={GML} xmlns:ogc={OGC} xmlns:ows={OWS} xmlns:xlink={XLINK}
					version={VERSION} service={SERVICE} outputFormat={OUTPUT_FORMAT} expiry={EXPIRY_TIME}>
					<wfs:Query typeName={m_wfsQuery.featureName} srsName={m_wfsQuery.srsName}>
						<ogc:Filter xmlns:ogc={OGC} xmlns:gml={GML}>
						</ogc:Filter>
					</wfs:Query>
				</wfs:GetFeatureWithLock>;
			
			for each( var updatedFeature :Graphic in m_updatedFeatures )
				request.WFS::Query.OGC::Filter.appendChild( <ogc:FeatureId fid={updatedFeature.attributes.GML_FEATURE_ID} xmlns:ogc={OGC}/> );
			for each( var deletedFeature :Graphic in m_deletedFeatures )
				request.WFS::Query.OGC::Filter.appendChild( <ogc:FeatureId fid={deletedFeature.attributes.GML_FEATURE_ID} xmlns:ogc={OGC}/> );
			
			var http :HTTPService = WFSUtil.createService( m_wfsQueryTask.url );
			var token :AsyncToken = http.send( request );
			token.addResponder( new AsyncResponder(
				function onSuccess( result :Object, token :Object = null ) :void
				{
					m_lockID = result.result.@lockId;
					sendTransaction();
				},
				function onFailure( fault :FaultEvent, token :Object = null ) :void
				{
					dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_FAILED ) );
					handleStringError( "Unable to retrieve a lock." );
				}, this
			) );
		}
		
		/** Cancels the transaction. 
		 * (lazy locks) [Check]*/
		override public function cancelTransaction() :void
		{
			// if editing, cancel edits that were not explicitly saved
			if( m_editing )
				cancelEdit();
			
			for each( var attribute :Object in m_updatedAttributes )
			{
				// set all attribute values that were changed back to their original values
				for each( var selectedAttribute :Object in m_selectedFeatureAttributes )
				{
					if( selectedAttribute.Name == attribute.Name )
						selectedAttribute.Value = m_selectedFeature.attributes[attribute.Name];
					continue;
				}
			}
			m_selectedFeatureAttributes.refresh();
			if( m_backupGeometry && m_selectedFeature != null )
			{
				m_selectedFeature.geometry = copyGeometry( m_backupGeometry );
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				m_selectedFeature.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				m_selectedFeature.symbol = m_renderer.getSymbol( m_selectedFeature );
				m_selectedFeature.refresh();
			}
			
			// reset new features
			for each( var newFeature :Graphic in m_newFeatures )
				remove( newFeature );
			
			// reset deleted features
			for each ( var deletedFeature :Graphic in m_deletedFeatures )
			{
				deletedFeature.visible = true;
				if( deletedFeature.attributes.GML_FEATURE_ID == m_selectedFeatureID )
					m_selectedFeature = deletedFeature;
			}
			deselectFeature();
			
			m_updatedGeometry = false;
			m_updatedAttributes.removeAll();
			m_newFeatures.removeAll();
			m_updatedFeatures.removeAll();
			m_deletedFeatures.removeAll();
			
			dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_CANCELED ) );
		}
		
		/** Resets the layer state in the event. 
		 * (lazy locks) [Check]*/
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
			m_newFeatures.removeAll();
			m_deletedFeatures.removeAll();
			m_updatedFeatures.removeAll();
			clear();
		}
		
		/**
		 * @private
		 * Send the transaction request.
		 * (lazy locks) [Check]
		 */ 
		override protected function sendTransaction() :void
		{
			var request :XML = WFSComm.sendTransactionQuery();
			//lock...
			request.appendChild(<wfs:LockId xmlns:wfs={WFS}>{m_lockID}</wfs:LockId>);
			// add inserted elements
			if( m_newFeatures.length > 0 )
			{
				for each( var newFeature :Graphic in m_newFeatures )
				{
					var newFeatureXML :XML =
						<wfs:Insert idGen="GenerateNew" xmlns:wfs={WFS} xmlns:ogc={OGC} xmlns:gml={GML}>
						</wfs:Insert>;
					
					// add attributes
					var newFeatureDefinitionXML :XML = new XML(
						"<ns:" + m_wfsQuery.featureName + " xmlns:ns=\"" + m_wfsQuery.featureNamespace + "\" xmlns:gml=\"" + GML + "\">" +
						"</ns:" + m_wfsQuery.featureName + ">"
					);
					for( var key :String in newFeature.attributes )
					{
						var value :Object = newFeature.attributes[key];
						if( key != "GML_FEATURE_ID" && key.search( m_wfsQuery.shapeField + "." ) == -1 && value )
						{
							var newPropertyXML :XML = new XML(
								"<ns:" + key + " xmlns:ns=\"" + m_wfsQuery.featureNamespace + "\" xmlns:wfs=\"" + WFS + "\">" +
								newFeature.attributes[key] +
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
					switch( newFeature.geometry.type )
					{
						case Geometry.MAPPOINT:
							var newValueXML :XML =
								<gml:Point srsName={m_wfsQuery.srsName} xmlns:gml={GML}>
									<gml:pos>{getPointCoordinates( newFeature.geometry as MapPoint )}</gml:pos>
								</gml:Point>;
							newShapeXML.appendChild( newValueXML );										
							break;
						case Geometry.POLYGON:
							// let's assume that the first ring is exterior and all others are interior
							var newPolygon :Polygon = newFeature.geometry as Polygon;
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
							var newPolyline :Polyline = newFeature.geometry as Polyline;
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
			}
			
			// add deleted elements
			if( m_deletedFeatures.length > 0 )
			{
				for each( var deletedFeature :Graphic in m_deletedFeatures )
				{
					var deletedFeatureID :String = deletedFeature.attributes.GML_FEATURE_ID; 
					var deleteFeatureXML :XML =
						<wfs:Delete typeName={"ns:" + m_wfsQuery.featureName} xmlns:wfs={WFS} xmlns:ogc={OGC} xmlns:gml={GML}>
							<ogc:Filter xmlns:ogc={OGC}>
								<ogc:FeatureId fid={deletedFeatureID}/>
							</ogc:Filter>
						</wfs:Delete>;
					request.appendChild( deleteFeatureXML );
				}
			}
			
			if( m_updatedFeatures.length > 0 )
			{
				for each( var updatedFeature :Graphic in m_updatedFeatures )
				{
					var updateFeatureXML :XML = <wfs:Update typeName={"ns:" + m_wfsQuery.featureName} xmlns:wfs={WFS}></wfs:Update>;
					// set updated attributes 
					if( updatedFeature.attributes )
					{
						for( key in updatedFeature.attributes )
						{
							if( key != "GML_FEATURE_ID" )
							{
								var propertyXML :XML =
									<wfs:Property xmlns:wfs={WFS}>
										<wfs:Name>{key}</wfs:Name>
										<wfs:Value>{updatedFeature.attributes[key]}</wfs:Value>
									</wfs:Property>;
								updateFeatureXML.appendChild( propertyXML );
							}
						}
					}
					// set updated geometry
					if( updatedFeature.geometry )
					{
						var shapeXML :XML =
							<wfs:Property xmlns:wfs={WFS} xmlns:gml={GML}>
								<wfs:Name>{m_wfsQuery.shapeField}</wfs:Name>
							</wfs:Property>;
						switch( updatedFeature.geometry.type )
						{
							case Geometry.MAPPOINT:
								var valueXML :XML =
									<wfs:Value xmlns:wfs={WFS} xmlns:gml={GML}>
										<gml:Point srsName={m_wfsQuery.srsName}>
											<gml:pos>{getPointCoordinates( updatedFeature.geometry as MapPoint )}</gml:pos>
										</gml:Point>
									</wfs:Value>;
								shapeXML.appendChild( valueXML );										
								break;
							case Geometry.POLYGON:
								// let's assume that the first ring is exterior and all others are interior
								var polygon :Polygon = updatedFeature.geometry as Polygon;
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
								var polyline :Polyline = updatedFeature.geometry as Polyline;
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
							<ogc:FeatureId fid={updatedFeature.attributes.GML_FEATURE_ID}/>
						</ogc:Filter>;
					updateFeatureXML.appendChild( filterXML );
					request.appendChild( updateFeatureXML );
				}
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
					dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_FAILED ) );
					handleStringError( "Unable to commit changes." );
				}, this
			) );
		}
		
		/**
		 * @private
		 * Handles cleanup after the transaction is complete.
		 * @param xml The XML response.
		 * (lazy locks) [Check]
		 */
		override protected function onTransactionComplete( xml :XML ) :void
		{
			// clear lock
			m_lockID = null;
			
			// remove all graphics that were involved in the transaction from the map
			for each( var graphic :Graphic in m_newFeatures )
				remove( graphic );
			for each( graphic in m_updatedFeatures )
				remove( graphic );
			for each( graphic in m_deletedFeatures )
				remove( graphic );
			
			deselectFeature();
			// reset the transaction aggregators
			m_newFeatures.removeAll();
			m_updatedFeatures.removeAll();
			m_deletedFeatures.removeAll();
			
			// execute a new query to retrieve all the inserted and updated points
			executeQuery();
			dispatchEvent( new WFSTEvent( WFSTEvent.TRANSACTION_COMMITTED ) );
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
		 * Saves the updated feature to the transaction.
		 * @param updatedFeature The updated feature.
		 */
		private function saveUpdatedFeature( updatedFeature :Graphic ) :void
		{
			var foundFeature :Boolean = false;
			for each( var feature :Graphic in m_updatedFeatures )
			{
				if( feature.attributes.GML_FEATURE_ID == updatedFeature.attributes.GML_FEATURE_ID )
				{
					// set new updated values
					for( var key :String in updatedFeature.attributes )
						feature.attributes[key] = updatedFeature.attributes[key];
					if( m_updatedGeometry )
						feature.geometry = updatedFeature.geometry;

					foundFeature = true;
				}
			}
			
			// if this is a newly updated feature, add it now
			if( !foundFeature )
				m_updatedFeatures.addItem( updatedFeature );
		}
	}
}