/**
* @author Pieter Michels
*/

package be.wellconsidered.events
{
	import flash.events.Event;
	
	public class OperationEvent extends Event
	{	
		public static var COMPLETE:String = "complete";
		public static var FAILED:String = "failed";
		
		private var _data:Object;
		
		function OperationEvent(param_event:String, param_data:Object = null)
		{
			super(param_event);
			
			_data = param_data;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
