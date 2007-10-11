/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice.types
{
	public class WebServiceComplexType
	{
		public var _name:String;
		public var _pars:Array;
		
		public function WebServiceComplexType(param_name:String)
		{
			_name = param_name;
			
			_pars = new Array();
		}
			
		/**
		* Add WebServiceArgument property
		* 
		* @param	WebServiceArgument
		*/		
		public function addProp(param_arg:WebServiceArgument):void
		{
			_pars.push(param_arg);
		}
	}
}
