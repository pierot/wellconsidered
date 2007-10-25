/**
* @author Pieter Michels
* 
* 	new WebServiceTest();
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
		private var ws2:WebService;
		private var ws3:WebService;
		private var ws4:WebService;
		
		private var output:TextField;
		
		public function WebServiceTest()
		{
			tracing("START WEBSERVICE TEST");
			
			ws = new WebService("http://webservices.microsite.be/mora/ws_mora.asmx?wsdl");
			ws2 = new WebService("http://webservices.microsite.be/wigw2/service.asmx?wsdl");
			ws3 = new WebService("http://www.webservicex.net/WeatherForecast.asmx?wsdl");
			ws4 = new WebService("http://webservices.microsite.be/fristi_droom/service.asmx?WSDL");

			init();
		}

		private function init():void
		{
			tracing("INIT");
			
			var o1:Operation = new Operation(ws);
			
			o1.addEventListener(OperationEvent.COMPLETE, onResult);
			o1.addEventListener(OperationEvent.FAILED, onFault);
			
			// o1.getWinners();
			
			var o2:Operation = new Operation(ws2);
			
			o2.addEventListener(OperationEvent.COMPLETE, onResult);
			o2.addEventListener(OperationEvent.FAILED, onFault);
			
			// o2.doLogin("pieter.michels@proximity.bbdo.be", "test", 0);
			// o2.getProfiel("7aa88918-462a-4590-9f86-5a748e0f9c7c");
			// o2.updateProfiel2({Guid: "7aa88918-462a-4590-9f86-5a748e0f9c7c", vnaam: "Pieter" + Math.round(Math.random() * 9999)});
			
			var o3:Operation = new Operation(ws3);
			
			o3.addEventListener(OperationEvent.COMPLETE, onResult);
			o3.addEventListener(OperationEvent.FAILED, onFault);
			
			o3.GetWeatherByPlaceName("new york");		
			
			var o4:Operation = new Operation(ws4);
			
			o4.addEventListener(OperationEvent.COMPLETE, onResult);
			o4.addEventListener(OperationEvent.FAILED, onFault);
			
			// o4.PageLoadGallery("", "", 0);				
		}		
		
		protected function onResult(e:OperationEvent):void
		{
			trace("---------------------- ONRESULT ----------------------");
			
			tracing("DATA : " + e.data);
			
			traceObject(e.data);
		}
		
		protected function traceObject(data:*, tabs:String = ""):void
		{
			for(var el:String in data)
			{
				tracing(tabs + "" + el + "  -  " + data[el] + " (" + (typeof data[el]) + ")"); 
				
				traceObject(data[el], tabs + "\t");
			}
		}

		protected function onFault(e:OperationEvent):void { tracing(e.data); }		
		
		public function addTracer(param_txt:TextField):void { output = param_txt; }
		
		protected function tracing(... args):void
		{
			trace(args);
			
			if(output != null)
			{
				output.appendText(args.toString() + "\n");
			}
		}
	}
}
