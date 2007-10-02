/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice.types
{
	public class WebServiceMethodResponse
	{
		public var _name:String;
		public var _pars:Array;
		
		public function WebServiceMethodResponse(param_name:String)
		{
			_name = param_name;
			
			_pars = new Array();
		}
			
		public function addPar(param_arg:WebServiceArgument):void
		{	
			_pars.push(param_arg);
		}
	}
}
