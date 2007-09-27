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
	import be.wellconsidered.services.webservice.*;
	
	public class WebServiceTest
	{
		private var ws:WebService;
		
		public function WebServiceTest()
		{
			ws = new WebService("http://webservices.microsite.be/wigw2/service.asmx?wsdl");

			ws.addEventListener(WebServiceEvent.INITED, onWSInit);
			ws.addEventListener(WebServiceEvent.INITFAILED, onWSInitFailed);			
		}
		
		private function onWSInitFailed(e:WebServiceEvent):void { trace(e.data); }	
		
		private function onWSInit(e:WebServiceEvent):void
		{
			ws.addEventListener(WebServiceEvent.COMPLETE, onResult);
			ws.addEventListener(WebServiceEvent.FAILED, onFault);
			
			ws.loadMethod("getVragen", "1", "NL");
		}		
		
		private function onResult(e:WebServiceEvent):void
		{
			for(var el:String in e.data)
			{
				trace(el + " - " + e.data[el]);
			}
		}

		private function onFault(e:WebServiceEvent):void { trace(e.data); }		
	}
}
