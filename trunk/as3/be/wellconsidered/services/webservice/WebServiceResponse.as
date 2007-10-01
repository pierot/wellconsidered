/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice
{
	public class WebServiceResponse
	{
		private var _resp_xml:XML;
		private var _data:Object;
		
		private var _method_name:String;
		private var _response_name:String;
		
		private var _method_col:WebServiceMethodCollection;
		
		public function WebServiceResponse(param_xml:XML, param_method_col:WebServiceMethodCollection)
		{
			_method_col = param_method_col;
			_resp_xml = param_xml;
			
			createResponseObject();
		}
		
		private function createResponseObject():void
		{
			// trace(_resp_xml);
			
			var soap_nms:Namespace = new Namespace("http://www.w3.org/2003/05/soap-envelope");
			var default_nms:Namespace = new Namespace(_method_col.targetNameSpace);
			
			var body_resp_xml:XMLList = _resp_xml.soap_nms::Body.children();
			
			_response_name = body_resp_xml[0].localName();
			_method_name = _response_name.split("Response")[0];
			
			var result_xmllst:XMLList = body_resp_xml.default_nms::[_method_name + "Result"].children();
			
			var resp_obj:WebServiceMethodResponse = _method_col.getResponseObject(_response_name);
			
			for each(var it:WebServiceArgument in resp_obj._pars)
			{
				// trace("args : " + it.name + " -" + it.type);
			}
			
			if(result_xmllst.length() > 1)
			{
				trace("-> ARRAY");
				
				// ARRAY
				_data = new Array();
				
				for(var i:Number = 0; i < result_xmllst.length(); i++)
				{
					_data.push(createResObject(result_xmllst[i].children(), resp_obj._pars));
				}
			}
			else if(result_xmllst[0].children().length() > 0)
			{
				trace("-> 1 OBJECT + PROPS");
				
				// 1 OBJECT AND MULTIPLE PROPERTIES
				_data = createResObject(result_xmllst[0].children(), resp_obj._pars);			
			}
			else
			{
				trace("-> 1 VALUE");
				
				var wsa:WebServiceArgument = resp_obj._pars[0];
				
				// 1 OBJECT AND 1 ARGUMENT
				_data = castType(result_xmllst[0].toXMLString(), wsa.type);
			}
		}
		
		private function createResObject(param_xmllst:XMLList, param_types:Array):Object
		{
			if(param_xmllst.length() > 1)
			{
				// FULL OBJECT
				var res:Object = new Object();
				
				for(var i:int = 0; i < param_xmllst.length(); i++)
				{
					var el:XML = param_xmllst[i];
					
					res[el.localName()] = el.toString();
				}
				
				return res;
			}
			else
			{
				var type:String = param_types[0].type;
				var res_single:*;
				
				switch(type)
				{
					case "ArrayOfString":
					
						res_single = new String(param_xmllst[0]);
						
						break;
						
					default:
					
						res_single = param_xmllst[0];
				}
				
				return res_single;
			}
		}
		
		private function castType(param_o:Object, param_t:String):*
		{
			switch(param_t.toLowerCase())
			{
				case "int":
				
					return param_o as int;
						
					break;
					
				case "float":
				case "double":
				
					return param_o as Number;
						
					break;					
				
				case "string":
				default:
				
					return param_o;
			}
		}		
	
		public function get data():Object
		{
			return _data;
		}
	}
}