/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice.types
{
	public class WebServiceArgument
	{	
		private var _name:String;
		private var _type:String;
		
		public function WebServiceArgument(param_name:String, param_type:String = "")
		{
			_name = param_name
			_type = param_type
		}	
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type.split(":")[1];
		}
		
		public function isReference():Boolean
		{
			return _type.split(":")[0] == "tns";
		}
		
		public function isArray():Boolean
		{
			return isReference() && _type.split(":")[1].indexOf("Array") == 0;
		}		
	}
}
