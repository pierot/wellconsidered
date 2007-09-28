/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice
{
	public class WebServiceMethodResponse
	{
		public var _name:String;
		public var _pars:Array;
		
		public function WebServiceMethodResponse(param_name:String)
		{
			trace("RESPONSE " + param_name);
			
			_name = param_name;
			
			_pars = new Array();
		}
			
		public function addPar(param_arg:WebServiceArgument):void
		{
			trace("\t\t" + param_arg.name + " - " + param_arg.type);
			
			_pars.push(param_arg);
		}
	}
}
