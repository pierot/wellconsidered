package be.wellconsidered.utils
{
	import flash.external.ExternalInterface;
	import flash.utils.*;
	import flash.net.URLVariables;
	
	public class HostURL
	{
		private var _all:String;
		private var _base:String;
		private var _query_string:String;
		private var _params:URLVariables;
		
		private const _LOCAL:String = "local";
		
		public function HostURL()
		{
			extractURL();
		}
		
		private function extractURL():void
		{
			try 
			{
				_all =  ExternalInterface.call("window.location.href.toString");
				_query_string = ExternalInterface.call("window.location.search.substring", 1);
				_params = new URLVariables(_query_string);
				_base = _all.split("?")[0].substring(0, _all.split("?")[0].lastIndexOf("/"));				
			}
			catch(e:Error)
			{
				_all = _LOCAL;
				
				trace("Some error occured. ExternalInterface doesn't work in Standalone player.");
			}  			
		}
		
		public function get parameters():URLVariables
		{
			return _params;
		}		
		
		public function get longURL():String
		{
			return _all;
		}
		
		public function get baseURL():String
		{
			return _base;
		}		
		
		public function isLocal():Boolean
		{
			return _all == _LOCAL;
		}
	}
}