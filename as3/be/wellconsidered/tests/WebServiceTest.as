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
		private var ws2:WebService;
		private var ws3:WebService;
		
		private var output:TextField;
		
		public function WebServiceTest()
		{
			tracing("START TEST");
			
			 ws = new WebService("http://webservices.microsite.be/mora/ws_mora.asmx?wsdl");
			// ws2 = new WebService("http://webservices.microsite.be/wigw2/service.asmx?wsdl");
			//ws3 = new WebService("http://www.webservicex.net/WeatherForecast.asmx?wsdl");

			init();
		}

		private function init():void
		{
			tracing("INIT");
		
			var o1:Operation = new Operation(ws);
			
			o1.addEventListener(OperationEvent.COMPLETE, onResult);
			o1.addEventListener(OperationEvent.FAILED, onFault);
			
			o1.getWinners();
				/*
			var o2:Operation = new Operation(ws2);
			
			o2.addEventListener(OperationEvent.COMPLETE, onResult);
			o2.addEventListener(OperationEvent.FAILED, onFault);
			
			// o2.doLogin("pieter.michels@proximity.bbdo.be", "test", 0);
			// o2.getProfiel("7aa88918-462a-4590-9f86-5a748e0f9c7c");
			o2.updateProfiel2({Guid: "7aa88918-462a-4590-9f86-5a748e0f9c7c", vnaam: "Pieter" + Math.round(Math.random() * 9999)});
			
			
			var o3:Operation = new Operation(ws3);
			
			o3.addEventListener(OperationEvent.COMPLETE, onResult);
			o3.addEventListener(OperationEvent.FAILED, onFault);
			
			o3.GetWeatherByPlaceName("new york");	*/	
		}		
		
		private function onResult(e:OperationEvent):void
		{
			trace("ONRESULT ---------------------------------------------------");
			
			tracing(e.data);
			
			for(var el:String in e.data)
			{
				tracing(el + "  -  " + e.data[el] + "(" + (typeof e.data[el]) + ")"); 
				
				if(typeof(e.data[el]) == "object")
				{
					for(var el2:String in e.data[el])
					{
						tracing("\t" + el2 + "  -  " + e.data[el][el2] + "(" + (typeof e.data[el][el2]) + ")"); 
					}					
				}
			}
			
			trace("");
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
