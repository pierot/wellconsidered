/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice 
{
	import be.wellconsidered.services.webservice.types.*;
	
	public class WebServiceCall
	{
		private var _call:XML;
		
		private var _method:String;
		private var _args:Array;
		private var _wsmethod:WebServiceMethod;
		private var _method_col:WebServiceMethodCollection;
		private var _tgtnms:String;
		
		public function WebServiceCall(param_method:String, param_wsmethodcol:WebServiceMethodCollection, param_tgtnms:String = "http://tempuri.org/", param_arr:Array = null)
		{
			_method_col = param_wsmethodcol;
			_method = param_method;
			_args = param_arr;
			_wsmethod = _method_col.getMethodObject(_method);
			_tgtnms = param_tgtnms;
			
			createSoapCall();
		}
	
		private function createSoapCall():void
		{
			var add_node:XML = <{_method} xmlns={_tgtnms} />
			
			if(_args.length > 1 || typeof(_args[0]) != "object")
			{
				for(var j:int = 0; j < _wsmethod._args.length; j++)
				{
					var ws_arg:WebServiceArgument = _wsmethod._args[j];
					
					add_node.appendChild(
						<{ws_arg.name}>
							{_args[j]}
						</{ws_arg.name}>
						);
				}
			}
			else
			{
				
				/*
				for(var k:String in _args[0])
				{
					var ws_lookup_arg:WebServiceArgument = _method_col.getMethodObjectArgument(_wsmethod._args, k);
					
					add_node.appendChild(
						<{ws_lookup_arg.name}>
							{_args[0][ws_lookup_arg.name]}
						</{ws_lookup_arg.name}>
						);
				}
				*/
				
				for(var i:int = 0; i < _wsmethod._args.length; i++)
				{
					var wsa_arg:WebServiceArgument = _wsmethod._args[i];
					
					if(!_args[0][wsa_arg.name])
					{
						add_node.appendChild(
							<{wsa_arg.name} />
							);								
					}
					else
					{
						add_node.appendChild(
							<{wsa_arg.name}>
								{_args[0][wsa_arg.name]}
							</{wsa_arg.name}>
							);
					}
				}	
			}
			
			_call = 
				<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
					<soap12:Body>
						{add_node}
					</soap12:Body>
				</soap12:Envelope>
				;
				
			trace(_call);
		}
		
		public function get call():XML
		{
			return _call;
		}
	}
}
