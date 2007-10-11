/**
* @author Pieter Michels
*/

package be.wellconsidered.services
{
	import flash.net.*;
	
    import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	
	import be.wellconsidered.services.webservice.*;
	
	import be.wellconsidered.events.WebServiceMethodCollectionEvent
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
			urllserv_desc.addEventListener(Event.COMPLETE, onDescrLoaded);
			urllserv_desc.addEventListener(IOErrorEvent.IO_ERROR, onDescrFailed);	
			urllserv_desc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			urllserv_desc.load(new URLRequest(url_ws));		
		}
		
		private function onDescrLoaded(e:Event):void
		{
			method_col = new WebServiceMethodCollection();
			
			method_col.addEventListener(WebServiceMethodCollectionEvent.COMPLETE, onDescrExtractComplete);
			method_col.extract(new XML(urllserv_desc.data));
		}
		
		private function onDescrExtractComplete(e:WebServiceMethodCollectionEvent):void
		{
			descr_loaded = true;
			
			executeQeuedOperations();
			
			// trace("DESCRIPTION LOADED!");
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITED));
		}	
		
		private function onDescrFailed(e:IOErrorEvent):void
		{
			// throw(new Error("WSDL file could not be loaded (" + url_ws + ")"));
			
			dispatchEvent(new WebServiceEvent(WebServiceEvent.INITFAILED, e));
		}	
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			// trace("WS ERROR :" + e);
			
			// throw(new Error("WSDL file security error (" + url_ws + ")"));
			
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
		
		/**
		* Add Operation object to Webservice qeue. 
		* 
		* @param	Operation instance
		* @return
		*/
		public function addOperationToQeue(param_o:Operation):void
		{
			// trace("ADD OPERATION TO QEUE");
			
			qeue_arr.push(param_o);
		}
		
		/**
		* Get collection of available Webservice methods.
		* 
		* @return	WebServiceMethodCollection instance
		*/
		public function getMethodCollection():WebServiceMethodCollection
		{
			return method_col;
		}
		
		/**
		* Is description file loaded.
		* 
		* @return	true if loaded
		*/
		public function get loaded():Boolean
		{
			return descr_loaded;
		}
		
		/**
		* Get Webservice URL
		* 
		* @return	String
		*/
		public function get url():String
		{
			return url_ws;
		}
	}
}