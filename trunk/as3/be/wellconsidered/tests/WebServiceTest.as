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
	import flash.text.TextField;
	
	public class WebServiceTest
	{
		private var ws:WebService;
		private var output:TextField;
		
		public function WebServiceTest()
		{
			ws = new WebService("http://webservices.microsite.be/mora/ws_mora.asmx?wsdl");
			// ws = new WebService("http://webservices.microsite.be/electrabel_wind/WSFestivalWind.asmx?WSDL");
			// ws = new WebService("http://webservices.microsite.be/wigw2/service.asmx?wsdl");

			ws.addEventListener(WebServiceEvent.INITED, onWSInit);
			ws.addEventListener(WebServiceEvent.INITFAILED, onWSInitFailed);			
		}
		
		private function onWSInitFailed(e:WebServiceEvent):void { tracing(e.data); }	
		
		private function onWSInit(e:WebServiceEvent):void
		{
			ws.addEventListener(WebServiceEvent.COMPLETE, onResult);
			ws.addEventListener(WebServiceEvent.FAILED, onFault);
			
			ws.loadMethod("getWinners");
			// ws.loadMethod("IsRegisteredFestival", "00000000-0000-0000-0000-000000000000");
			// ws.loadMethod("doLogin", "pieter.michels@proximity.bbdo.be", "test", 0);
		}		
		
		private function onResult(e:WebServiceEvent):void
		{
			tracing(e.data);
			
			for(var el:String in e.data)
			{
				tracing(el + "  -  " + e.data[el]); 
			}
		}

		private function onFault(e:WebServiceEvent):void { tracing(e.data); }		
		
		public function addTracer(param_txt:TextField):void
		{
			output = param_txt;
		}
		
		private function tracing(... args):void
		{
			trace(args);
			
			if(output != null)
			{
				output.appendText(args.toString() + "\n");
			}
		}
	}
}
