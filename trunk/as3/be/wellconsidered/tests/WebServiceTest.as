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
	import be.wellconsidered.services.Operation;
	import be.wellconsidered.events.OperationEvent;
	
	import flash.text.TextField;
	
	public class WebServiceTest
	{
		private var ws:WebService;
		private var output:TextField;
		
		public function WebServiceTest()
		{
			tracing("START TEST");
			
			ws = new WebService("http://webservices.microsite.be/mora/ws_mora.asmx?wsdl");
			// ws = new WebService("http://webservices.microsite.be/electrabel_wind/WSFestivalWind.asmx?WSDL");
			// ws = new WebService("http://webservices.microsite.be/wigw2/service.asmx?wsdl");

			init();
		}

		private function init():void
		{
			tracing("INIT");
			
			var o:Operation = new Operation(ws);
			
			o.addEventListener(OperationEvent.COMPLETE, onResult);
			o.addEventListener(OperationEvent.FAILED, onFault);
			
			o.getWinners();
			// ws.IsRegisteredFestival("00000000-0000-0000-0000-000000000000");
			// ws.doLogin("pieter.michels@proximity.bbdo.be", "test", 0);
		}		
		
		private function onResult(e:OperationEvent):void
		{
			tracing(e.data);
			
			for(var el:String in e.data)
			{
				tracing(el + "  -  " + e.data[el]); 
				
				if(typeof(e.data[el]) == "object")
				{
					for(var el2:String in e.data[el])
					{
						tracing("\t" + el2 + "  -  " + e.data[el][el2]); 
					}					
				}
			}
		}

		private function onFault(e:OperationEvent):void { tracing(e.data); }		
		
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
