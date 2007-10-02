/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice
{
	import be.wellconsidered.services.webservice.types.*;
	
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
			
			/*
			for each(var it:WebServiceArgument in resp_obj._pars)
			{
				 trace("args : " + it.name + " -" + it.type + " -" + it.isReference());
			}
			*/
			
			if(result_xmllst.length() > 1)
			{
				trace("-> ARRAY");
				
				// ARRAY
				_data = new Array();
				
				var par_arr:Array = resp_obj._pars;
				
				if(par_arr.length == 1 && par_arr[0].isReference())
				{
					par_arr = _method_col.getComplexObject(par_arr[0].type)._pars;
				}
				
				for(var i:Number = 0; i < result_xmllst.length(); i++)
				{
					_data.push(createResObject(result_xmllst[i].children(), par_arr));
				}
			}
			else if(result_xmllst[0].children().length() > 0)
			{
				trace("-> 1 OBJECT + PROPS");
				
				var wsa_single:WebServiceArgument = resp_obj._pars[0];
				var obj_single_args:Array = resp_obj._pars;
				
				if(wsa_single.isReference())
				{	
					obj_single_args = _method_col.getComplexObject(wsa_single.type)._pars;
					
					if(obj_single_args.length == 1 && obj_single_args[0].isReference())
					{
						obj_single_args = _method_col.getComplexObject(obj_single_args[0].type)._pars;
					}
				}
				
				// 1 OBJECT AND MULTIPLE PROPERTIES
				_data = createResObject(result_xmllst[0].children(), obj_single_args);			
			}
			else
			{
				// trace("-> 1 VALUE");
				
				// 1 OBJECT AND 1 ARGUMENT
				_data = castType(result_xmllst[0].toXMLString(), resp_obj._pars[0].type);
			}
		}
		
		private function createResObject(param_xmllst:XMLList, param_wsa:*):Object
		{
			if(param_xmllst.length() > 1)
			{
				var res:Object = new Object();
				
				for(var i:int = 0; i < param_xmllst.length(); i++)
				{
					var el:XML = param_xmllst[i];
					var wsa:WebServiceArgument = _method_col.getComplexObjectArgument(param_wsa, el.localName()); // LOOKUP
					
					res[el.localName()] = castType(el[0], wsa.type);
				}
				
				return res;
			}
			else
			{				
				return castType(param_xmllst[0], param_wsa[0].type);
			}
		}
		
		private function castType(param_o:Object, param_t:String):*
		{
			switch(param_t.toLowerCase())
			{
				case "int":
					
					return int(param_o);
						
					break;
					
				case "float":
				case "double":
				
					return Number(param_o);
						
					break;					
				
				case "string":
				default:
				
					return String(param_o);
			}
		}		
	
		public function get data():Object
		{
			return _data;
		}
	}
}