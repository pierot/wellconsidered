/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice 
{
	import be.wellconsidered.services.webservice.WebServiceMethod;
	
	public class WebServiceMethodCollection
	{
		private var _methods_arr:Array;
		private var _response_arr:Array;
		
		public function WebServiceMethodCollection()
		{
			_methods_arr = new Array();
			_response_arr = new Array();
		}
		
		public function extract(param_xml:XML):void
		{
			trace(param_xml);
			var types_nms:Namespace = param_xml.namespace("wsdl");
			
			var types_xml:XML = param_xml.types_nms::types[0];
			var s_nms:Namespace = types_xml.namespace("s");
			
			var els_xml:XML = types_xml.s_nms::schema[0];
			
			for each(var i:XML in els_xml.s_nms::element)
			{
				try
				{
					var tmp:XML = i.s_nms::complexType[0].s_nms::sequence[0];
					var tmp_lst:XMLList = tmp.s_nms::element;
						
					// METHODS
					if(i.@name.indexOf("Response") <= 0)
					{
						var method:WebServiceMethod = new WebServiceMethod(i.@name);
						
						for each(var j:XML in tmp_lst)
						{				
							method.addArg(new WebServiceArgument(j.@name, j.@type));
						}
						
						_methods_arr.push(method);
					}
					else
					{
						// RESPONSES
						var response:WebServiceMethodResponse = new WebServiceMethodResponse(i.@name);
						
						for each(var k:XML in tmp_lst)
						{				
							response.addPar(new WebServiceArgument(k.@name, k.@type));
						}
						
						_response_arr.push(response);						
					}
				}
				catch(e:Error)
				{/*trace(e.message);*/}
			}			
		}
		
		public function getMethodObject(param_name:String):WebServiceMethod
		{
			for(var i:int = 0; i < _methods_arr.length; i++)
			{
				if(_methods_arr[i]._name == param_name){ return _methods_arr[i]; break; }
			}
			
			return null;
		}		
	}
}
