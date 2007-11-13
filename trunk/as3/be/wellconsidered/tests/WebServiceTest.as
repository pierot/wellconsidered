/**
* @author Pieter Michels
* 
* 	new WebServiceTest();
*/

package be.wellconsidered.tests 
{
	import be.wellconsidered.events.OperationEvent;
	import be.wellconsidered.services.Operation;
	import be.wellconsidered.services.WebService;
	
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
			tracing("INIT WEBSERVICE TEST");
		}
		
		public function testConcentra():void
		{
			var w:WebService = new WebService("http://webservices.microsite.be/concentra/ws/service.asmx?wsdl");
			var o:Operation = new Operation(w);
			
			o.addEventListener(OperationEvent.COMPLETE, onResult);
			o.addEventListener(OperationEvent.FAILED, onFault);
			
			o.getNaw("6581df8b-1c1b-495b-8a5e-814e46ae66ae");
		}		
		
		public function testMXR():void
		{
			var w:WebService = new WebService("http://musicmixer.rmxr.com/zine-eu/Mixer/Portal?wsdl");
			var o:Operation = new Operation(w);
			
			o.addEventListener(OperationEvent.COMPLETE, onResult);
			o.addEventListener(OperationEvent.FAILED, onFault);
			
			// o.getMostRecentRemixesCount();
			o.getTopRatedRemixes(0, 10);
		}		

		public function testMora():void
		{
			var ws:WebService = new WebService("http://webservices.microsite.be/mora/ws_mora.asmx?wsdl");
			var o:Operation = new Operation(ws);
			
			o.addEventListener(OperationEvent.COMPLETE, onResult);
			o.addEventListener(OperationEvent.FAILED, onFault);
			
			o.getWinners();
		}
		
		public function testWeather():void
		{
			var ws:WebService = new WebService("http://www.webservicex.net/WeatherForecast.asmx?wsdl");
			var o:Operation = new Operation(ws);
			
			o.addEventListener(OperationEvent.COMPLETE, onResult);
			o.addEventListener(OperationEvent.FAILED, onFault);
			
			o.GetWeatherByPlaceName("new york");
			
			var o2:Operation = new Operation(ws);
			
			o2.addEventListener(OperationEvent.COMPLETE, onResult);
			o2.addEventListener(OperationEvent.FAILED, onFault);
			
			o2.GetWeatherByPlaceName("las vegas");
		}		
		
		protected function onResult(e:OperationEvent):void
		{
			trace("---- ONRESULT ----");
			
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
