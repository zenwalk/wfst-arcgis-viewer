/****************************************************
 *** Created By : Raffaello Bertini               ***
 *** GML 3.1 can only Support                     *** 
 *** Date: 2012 - Oct                             ***
 ***----------------------------------------------***
 *** Note: Future Works need to implement more    ***
 *** outputs sub-type formats: KML, ShapeTipe     ***
 ***************************************************/
package com.esri.wfs
{
	public class WFSComm
	{
		public static const SERVICE :String       = "WFS";
		public static const VERSION :String       = "1.1.0"; //Geoserver support WFS 2.0.0
		//public static const VERSION :String       = "2.0.0"; 
		//GML 3.1
		public static const OUTPUT_FORMAT :String = "text/xml; subtype=gml/3.1.1";
		//GML 3.2  //NOT Supported by flexviewer(?)
		//public static const OUTPUT_FORMAT :String = "GML2";
		//GML 3.3 
		//public static const OUTPUT_FORMAT :String = ""; (?)
		//GML 3.3 sono più namespace(?)
		
		public static const EXPIRY_TIME :String    = "5";
		public static const RELEASE_ACTION :String = "ALL";
		//public static const ESRI :Namespace = new Namespace( "http://www.esri.com" );
		//public static const ESRI :Namespace = new Namespace( "http://www.tinyows.org" ); 
		//public static const ESRI :Namespace   = new Namespace( "http://www.opengis.net/ows" );
		public static const WFS :Namespace    = new Namespace( "http://www.opengis.net/wfs" );
		//public static const WFS :Namespace    = new Namespace( "http://www.opengis.net/wfs/2.0" );
		public static const GML :Namespace    = new Namespace( "http://www.opengis.net/gml" );
		//public static const GML :Namespace    = new Namespace( "http://www.opengis.net/gml/3.2" );
		//public static const OGC :Namespace    = new Namespace( "http://www.opengis.net/ogc" );
		public static const OGC :Namespace    = new Namespace( "http://www.opengis.net/ogc/1.1" );
		//public static const OWS :Namespace    = new Namespace( "http://www.opengis.net/ows" );
		public static const OWS :Namespace    = new Namespace( "http://www.opengis.net/ows/1.1" );
		public static const XS :Namespace     = new Namespace( "http://www.w3.org/2001/XMLSchema" );
		public static const XLINK :Namespace  = new Namespace( "http://www.w3.org/1999/xlink" );
		
		public static const FILTER :Namespace = new Namespace( "http://www.opengis.net/fes" );
		//public static const FILTER :Namespace = new Namespace( "http://www.opengis.net/fes/2.0" );
		public static const XSI    :Namespace = new Namespace( "http://www.w3.org/2001/XMLSchema-instance" );
		
		
		/*
		public function WFSComm()
		{
			
		}
		*/
		
		
		/**
		 * COMPLETARE LE QUERY DI TRANS E QUANTALTRO USATE DA WFS!!!
		 * */
		// start the transaction by retrieving the lock
		public static function lockRequestQuery(featureName :String, srsName :String, GML_FEATURE_ID :Object) :XML
		{
			var lockRequest :XML = 
				<wfs:GetFeatureWithLock xmlns:wfs={WFS} xmlns:gml={GML} xmlns:ogc={OGC} xmlns:ows={OWS} xmlns:xlink={XLINK}
					version={VERSION} service={SERVICE} outputFormat={OUTPUT_FORMAT} expiry={EXPIRY_TIME}>
				<wfs:Query typeName={featureName} srsName={srsName}>
					<ogc:Filter xmlns:ogc={OGC} xmlns:gml={GML}>
					<ogc:FeatureId fid={GML_FEATURE_ID} xmlns:ogc={OGC}/>
					</ogc:Filter>
				</wfs:Query>
				</wfs:GetFeatureWithLock>;
		
			return lockRequest;
		}
	
		public static function GetCapabilitiesQuery() :XML
		{
			var capabilities :XML;

			{
				capabilities =  
					<wfs:GetCapabilities 
					service={SERVICE}
				    version={VERSION}
				    xmlns:wfs={WFS} 
					xmlns:ns={OWS} 
					xmlns:xsi={XSI} 
				    xsi:schemaLocation={WFS + " " + "http://schemas.opengis.net/wfs/"+VERSION+"/wfs.xsd"}/>;
			}
			return capabilities;
		}
		
		public static function cancelTransactionQuery() :XML
		{
			var request :XML =
				<wfs:Transaction 
				xmlns:wfs={WFS} 
				xmlns:ns={OWS} 
				version={VERSION} 
				service={SERVICE} 
				releaseAction={RELEASE_ACTION}>
				</wfs:Transaction>;
			
			return request;
		}
		
		public static function sendTransactionQuery() :XML
		{
			var request :XML;
			{
			    request =
				<wfs:Transaction 
                xmlns:wfs={WFS} 
			    xmlns:ns={OWS} 
			    version={VERSION} 
			    service={SERVICE} 
			    releaseAction={RELEASE_ACTION}>
				</wfs:Transaction>;
			}
			//if(lock)
			//	request.appendChild( <wfs:LockId xmlns:wfs={WFS}>{lockID}</wfs:LockId> );
			
			return request;
		}
			
		//Get Request Query
		public static function GetFeatureRequestQuery(featureNamespace :String , featureName :String , srsName :String) :XML
		{
			var xml :XML;
			/*
			if(OUTPUT_FORMAT != "")
			{
				xml = 
				<wfs:GetFeature xmlns:wfs={WFS} xmlns:gml={GML} xmlns:ogc={OGC} xmlns:ows={OWS} xmlns:xlink={XLINK}
					xmlns:ns={featureNamespace}
					version={VERSION} service={SERVICE} outputFormat={OUTPUT_FORMAT}>
					<wfs:Query typeName={"ns:" + featureName} srsName={srsName}> 
					</wfs:Query>
				</wfs:GetFeature>;
			}
			else
			*/
			{
				xml =			
				<wfs:GetFeature xmlns:wfs={WFS} xmlns:gml={GML} xmlns:ogc={OGC} xmlns:ows={OWS} xmlns:xlink={XLINK}
					xmlns:ns={featureNamespace}
					version={VERSION} service={SERVICE}
				    xmlns:fes={OGC}>
					<wfs:Query typeName={"ns:" + featureName} srsName={srsName}> 
					</wfs:Query>
				</wfs:GetFeature>;
			}
			
			return xml;
		}
		
		public static function DescribeFeatureTypeQuery(featureNamespace :String, featureName :String) :XML
		{
			{
				var request :XML =
				<wfs:DescribeFeatureType xmlns:wfs={WFS} xmlns:ns={featureNamespace}
					service={SERVICE} version={VERSION} outputFormat={OUTPUT_FORMAT}>
					<wfs:TypeName>ns:{featureName}</wfs:TypeName>
				</wfs:DescribeFeatureType>;
			}

			return request;
		}
	}
}