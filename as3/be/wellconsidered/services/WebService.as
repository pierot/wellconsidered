package
{
	import flash.net.*;
	import flash.xml.XMLDocument;
    import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.errors.IOError;
	import flash.events.HTTPStatusEvent;
	import flash.events.EventDispatcher;
	
	public class WebService extends EventDispatcher
	{
		private var urlLoaderService:URLLoader;
		private var urlRequest:URLRequest;
		
		private var urllserv_desc:URLLoader;
		
		private var methods_arr:Array;
		
		public function WebService(param_ws_url:String)
		{
			// PREPARE METHOD CALLING
			urlRequest = new URLRequest(param_ws_url);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/soap+xml"));
			
			urlLoaderService = new URLLoader();
			urlLoaderService.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoaderService.addEventListener("complete", onServiceLoaded);
			urlLoaderService.addEventListener("ioError", onServiceFailed);
			
			// LOAD WS DESCRIPTION
			loadWSDescr(param_ws_url);
		}
		
		private function loadWSDescr(param_ws_url:String):void
		{
			urllserv_desc = new URLLoader();
			
			urllserv_desc.dataFormat = URLLoaderDataFormat.TEXT;
			urllserv_desc.addEventListener("complete", onDescrLoaded);
			urllserv_desc.addEventListener("ioError", onDescrFailed);		
			
			urllserv_desc.load(new URLRequest(param_ws_url));		
		}
		
		private function onDescrLoaded(e:Event):void
		{
			methods_arr = new Array();
			
			var descr_xml:XML = new XML(urllserv_desc.data);
			var types_nms:Namespace = descr_xml.namespace("wsdl");
			
			var types_xml:XML = descr_xml.types_nms::types[0];
			var s_nms:Namespace = types_xml.namespace("s");
			
			var els_xml:XML = types_xml.s_nms::schema[0];
			
			for each(var i:XML in els_xml.s_nms::element)
			{
				try
				{
					var method:WebServiceMethod = new WebServiceMethod(i.@name);
					
					var tmp:XML = i.s_nms::complexType[0].s_nms::sequence[0];
					
					for each(var j:XML in tmp.s_nms::element)
					{				
						method.addArg(j.@name);
					}
					
					methods_arr.push(method);
				}
				catch(e:Error)
				{/*trace(e.message);*/}
			}
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITED));
		}	
		
		private function onDescrFailed(e:ErrorEvent):void
		{
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITFAILED, e));
		}		
		
		public function loadMethod(param_method:String, ... args):void
		{
			urlRequest.data = createSoapCall(param_method, args);
			
			urlLoaderService.load(urlRequest);
		}
		
		private function onServiceLoaded(e:Event):void
		{
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.COMPLETE, new XML(urlLoaderService.data)));
			
			urlLoaderService.data = null;
		}
		
		private function onServiceFailed(e:ErrorEvent):void
		{
			dispatchEvent(new WebServiceEvent(WebServiceEvent.FAILED, e));
		}
		
		private function createSoapCall(method:String, args:Array):XML
		{
			var method_obj:WebServiceMethod = getServiceMethods(method);
			var add_node:XML = <{method} xmlns="http://tempuri.org/" />
			
			for(var j:int = 0; j < method_obj._args.length; j++)
			{
				add_node.appendChild(
					<{method_obj._args[j]}>
						{args[j]}
					</{method_obj._args[j]}>
					);
			}
			
			var r_xml:XML = 
				<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
					<soap12:Body>
						{add_node}
					</soap12:Body>
				</soap12:Envelope>
				;

			return r_xml;
		}
		
		private function getServiceMethods(param_name:String):WebServiceMethod
		{
			for(var i:int = 0; i < methods_arr.length; i++)
			{
				if(methods_arr[i]._name == param_name){ return methods_arr[i]; break; }
			}
			
			return null;
		}
	}
}