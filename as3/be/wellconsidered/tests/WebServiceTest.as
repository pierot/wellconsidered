/**
* @author Pieter Michels
* 
* Test Webservice:
* 
* 	new WebServiceTest();
* 
* 	eh voila;
*/

package be.wellconsidered.tests 
{
	import be.wellconsidered.services.WebService;
	import be.wellconsidered.events.WebServiceEvent;
	
	public class WebServiceTest
	{
		private var ws:WebService;
		
		public function WebServiceTest()
		{
			ws = new WebService("http://webservices.microsite.be/electrabel_wind/WSFestivalWind.asmx?WSDL");
			// ws = new WebService("http://webservices.microsite.be/wigw2/service.asmx?wsdl");

			ws.addEventListener(WebServiceEvent.INITED, onWSInit);
			ws.addEventListener(WebServiceEvent.INITFAILED, onWSInitFailed);			
		}
		
		private function onWSInitFailed(e:WebServiceEvent):void { trace(e.data); }	
		
		private function onWSInit(e:WebServiceEvent):void
		{
			ws.addEventListener(WebServiceEvent.COMPLETE, onResult);
			ws.addEventListener(WebServiceEvent.FAILED, onFault);
			
			ws.loadMethod("Init_SessionGuid");
			// ws.loadMethod("doLogin", "pieter.michels@proximity.bbdo.be", "test", 0);
		}		
		
		private function onResult(e:WebServiceEvent):void
		{
			trace(e.data);
			for(var el:String in e.data)
			{
				trace(el + " - " + e.data[el]);
				
				for(var el2:String in e.data[el])
				{
					trace(el2 + " - " + e.data[el][el2]);
				}				
			}
		}

		private function onFault(e:WebServiceEvent):void { trace(e.data); }		
	}
}
