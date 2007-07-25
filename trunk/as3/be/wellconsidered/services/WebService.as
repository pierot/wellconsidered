package be.wellconsidered.services
{
	import flash.net.*;
	import flash.xml.XMLDocument;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.HTTPStatusEvent;
	
	public class WebService
	{
		public var soap12:Namespace = new Namespace("http://www.w3.org/2003/05/soap-envelope");
		public var xsi:Namespace = new Namespace("http://www.w3.org/2001/XMLSchema-instance");
		public var xsd:Namespace = new Namespace("http://www.w3.org/2001/XMLSchema");
		public var returnFunction:Function;
		
		private var urlLoaderService:URLLoader;

		public function WebService($parent:DepthMonitor){}

		public function loadWebService($feedURL:String, $returnFunction:Function, $identifier:String, $identifier2:String = null):void
		{
			var feedType:String = $feedURL.split("=")[1];
			var urlRequest:URLRequest = new URLRequest($feedURL);
			
			returnFunction = $returnFunction;
			
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/soap+xml"));
			urlRequest.data = returnCorrectXML(feedType, $identifier, $identifier2 );
			
			urlLoaderService = new URLLoader();
			urlLoaderService.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoaderService.addEventListener("complete", onServiceLoaded);
			urlLoaderService.addEventListener("ioerror", ifServiceFailed);
			urlLoaderService.load(urlRequest);
		}

		public function onServiceLoaded(e:Event):void
		{
			var d:XML = new XML(urlLoaderService.data);
			
			returnFunction(d);
			
			urlLoaderService.data = null;
		}

		public function ifServiceFailed(e:ErrorEvent):void
		{
			trace("Couldn't load "+ returnFunction +" because ::: " + e);
		}

		public function returnCorrectXML(feedType:String, feedIdentifier:String, feedIdentifier2:String):XML
		{
			var rXML:XML = <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"><soap12:Body/></soap12:Envelope>;
			
			switch (feedType)
			{
				case "feed1":
							
							rXML.soap12::Body.appendChild(<feed1 xmlns="http://www.wellconsidered.be/"><feed1Data>{feedIdentifier}</feed1Data></feed1>);
							
							break;
							
				case "feed2":
							
							rXML.soap12::Body.appendChild(<feed2 xmlns="http://www.wellconsidered.be/"><feedData>{feedIdentifier}</feedData><feedData2>{feedIdentifier2}</feedData2></feed2>);
			
							break;
			
				default:
				
							trace("can't find a SOAP request document conforming to this parameter : " + feedType);
						
							break;
			}
			
			return rXML;
		}		
	}
}
