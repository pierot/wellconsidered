/**
* @author Pieter Michels
*/

package be.wellconsidered.services
{
	import flash.net.*;
	import flash.xml.XMLDocument;
    import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.errors.IOError;
	import flash.events.HTTPStatusEvent;
	import flash.events.EventDispatcher;
	
	import be.wellconsidered.services.webservice.*;
	
	public class WebService extends EventDispatcher
	{
		private var url_loader:URLLoader;
		private var url_request:URLRequest;
		
		private var urllserv_desc:URLLoader;
		
		private var method_col:WebServiceMethodCollection;
		
		public function WebService(param_ws_url:String)
		{
			// PREPARE METHOD CALLING
			url_request = new URLRequest(param_ws_url);
			url_request.method = URLRequestMethod.POST;
			url_request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/soap+xml"));
			
			url_loader = new URLLoader();
			url_loader.dataFormat = URLLoaderDataFormat.TEXT;
			url_loader.addEventListener("complete", onServiceLoaded);
			url_loader.addEventListener("ioError", onServiceFailed);
			
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
			method_col = new WebServiceMethodCollection();
			method_col.extract(new XML(urllserv_desc.data));
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITED));
		}	
		
		private function onDescrFailed(e:ErrorEvent):void
		{
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITFAILED, e));
		}		
		
		public function loadMethod(param_method_name:String, ... args):void
		{
			var new_call:WebServiceCall = new WebServiceCall(param_method_name, args, method_col.getMethodObject(param_method_name));
			
			url_request.data = new_call.call;
			
			url_loader.load(url_request);
		}
		
		private function onServiceLoaded(e:Event):void
		{
			var response:WebServiceResponse = new WebServiceResponse(new XML(url_loader.data));
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.COMPLETE, response.data));
			
			url_loader.data = null;
		}
		
		private function onServiceFailed(e:ErrorEvent):void
		{
			dispatchEvent(new WebServiceEvent(WebServiceEvent.FAILED, e));
		}
	}
}