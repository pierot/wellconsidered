/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice 
{
	public class WebServiceCall
	{
		private var _call:XML;
		
		private var _method:String;
		private var _args:Array;
		private var _wsmethod:WebServiceMethod;
		
		public function WebServiceCall(param_method:String, param_wsmethod:WebServiceMethod, ... args)
		{
			_method = param_method;
			_args = args;
			_wsmethod = param_wsmethod;
			
			createSoapCall();
		}
	
		private function createSoapCall():void
		{
			var add_node:XML = <{_method} xmlns="http://tempuri.org/" />
			trace(_wsmethod);
			for(var j:int = 0; j < _wsmethod._args.length; j++)
			{
				var ws_arg:WebServiceArgument = _wsmethod._args[j];
				
				add_node.appendChild(
					<{ws_arg.name}>
						{_args[j]}
					</{ws_arg.name}>
					);
			}
			
			_call = 
				<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
					<soap12:Body>
						{add_node}
					</soap12:Body>
				</soap12:Envelope>
				;
		}
		
		public function get call():XML
		{
			return _call;
		}
	}
}
