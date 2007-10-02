/**
* @author Pieter Michels
*/

package be.wellconsidered.services
{
	import flash.net.*;
	
    import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	
	import flash.errors.IOError;
	
	import be.wellconsidered.services.webservice.*;
	import be.wellconsidered.events.WebServiceEvent;
	
	dynamic public class WebService extends EventDispatcher
	{
		private var url_ws:String;
		private var urllserv_desc:URLLoader;
		
		private var descr_loaded:Boolean = false;
		private var qeue_arr:Array;
		
		public var method_col:WebServiceMethodCollection;
		
		public function WebService(param_ws_url:String)
		{
			qeue_arr = new Array();
			url_ws = param_ws_url;
			
			loadWSDescr();
		}
		
		private function loadWSDescr():void
		{
			urllserv_desc = new URLLoader();
			
			urllserv_desc.dataFormat = URLLoaderDataFormat.TEXT;
			urllserv_desc.addEventListener("complete", onDescrLoaded);
			urllserv_desc.addEventListener("ioError", onDescrFailed);		
			
			urllserv_desc.load(new URLRequest(url_ws));		
		}
		
		private function onDescrLoaded(e:Event):void
		{
			method_col = new WebServiceMethodCollection();
			method_col.extract(new XML(urllserv_desc.data));
			
			loaded = true;
			
			executeQeuedOperations();
			
			trace("DESCRIPTION LOADED!");
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITED));
		}	
		
		private function onDescrFailed(e:ErrorEvent):void
		{
			trace("DESCRIPTION COULD NOT BE LOADED!");
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITFAILED, e));
		}	
		
		private function executeQeuedOperations():void
		{
			// trace("EXECUTE QEUED OPS (" + qeue_arr.length + ")");
			
			if(qeue_arr.length > 0)
			{
				for(var i:int = 0; i < qeue_arr.length; i++)
				{
					if(method_col.methodExists(qeue_arr[i].method))
					{
						qeue_arr[i].loadMethod();
					}
					
					qeue_arr.splice(i, 1);
				}
			}
		}
		
		public function addOperationToQeue(param_o:Operation):void
		{
			// trace("ADD OPERATION TO QEUE");
			
			qeue_arr.push(param_o);
		}
		
		public function getMethodCollection():WebServiceMethodCollection
		{
			return method_col;
		}
		
		private function set loaded(param_t:Boolean):void
		{
			descr_loaded = param_t;
		}
		
		public function get loaded():Boolean
		{
			return descr_loaded;
		}
		
		public function get url():String
		{
			return url_ws;
		}
	}
}