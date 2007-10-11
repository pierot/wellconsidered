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
			
			var soap_nms:Namespace = new Namespace("http://schemas.xmlsoap.org/soap/envelope/");
			var default_nms:Namespace = new Namespace(_method_col.targetNameSpace);
			
			var body_resp_xml:XMLList = _resp_xml.soap_nms::Body.children();
			
			_response_name = body_resp_xml[0].localName();
			_method_name = _response_name.split("Response")[0];
			
			var result_xmllst:XMLList = body_resp_xml.default_nms::[_method_name + "Result"].children();
		
			var resp_obj:WebServiceMethodResponse = _method_col.getResponseObject(_response_name);
			
			trace(result_xmllst);
			trace("--------------------------------------------------------------------------------------------------------");
			
			_data = parseXMLList(result_xmllst, resp_obj);
		}
		
		private function parseXMLList(result_xmllst:XMLList, resp_obj:*):*
		{	
			if(resp_obj._pars.length == 1)
			{
				var resp_wsa:WebServiceArgument = resp_obj._pars[0];
				
				// OR 1 ITEM OR REFERENCE
				if(resp_wsa.isReference())
				{
					// TNS
					if(resp_wsa.isArray())
					{
						// ARRAY OF TNS OBJECT
						resp_obj = _method_col.getComplexObject(resp_wsa.type);
						
						var tmp:Array = new Array();
						
						for(var i:int = 0; i < result_xmllst.length(); i++)
						{
							tmp.push(parseXMLList(result_xmllst[i].children(), resp_obj));
						}
						
						return tmp;
					}
					else
					{
						resp_obj = _method_col.getComplexObject(resp_wsa.type);
						
						return parseXMLList(result_xmllst, resp_obj);
					}
				}
				else
				{
					// 1 ITEM
					return castType(result_xmllst[0], resp_wsa.type);
				}
			}
			else
			{
				var obj:Object = new Object();
				var arr:Array = new Array();
				
				// MEERDERE PROPS
				for(var j:int = 0; j < result_xmllst.length(); j++)
				{
					if(result_xmllst[j].children().length() > 1)
					{
						var tmp_a_wsa:WebServiceArgument = _method_col.getComplexObjectArgument(resp_obj._pars, result_xmllst[j].localName());
						
						if(tmp_a_wsa == null)
						{
							// ARRAY					
							arr.push(parseXMLList(result_xmllst[j].children(), resp_obj));
						}
						else
						{
							var tmp_a_resp_obj:WebServiceComplexType = _method_col.getComplexObject(tmp_a_wsa.type);
							
							obj[tmp_a_wsa.name] = new Array();
							obj[tmp_a_wsa.name] = parseXMLList(result_xmllst[j].children(), tmp_a_resp_obj);
						}
					}
					else
					{
						var tmp_wsa:WebServiceArgument = _method_col.getComplexObjectArgument(resp_obj._pars, result_xmllst[j].localName());
						
						if(tmp_wsa.isReference())
						{
							resp_obj = _method_col.getComplexObject(tmp_wsa.type);
							
							// obj[tmp_wsa.name] = parseXMLList(result_xmllst[j].children(), resp_obj);			
						}
						else
						{
							obj[tmp_wsa.name] = castType(result_xmllst[j], tmp_wsa.type);	
						}
					}
				}
				
				return arr.length> 0 ? arr : obj;
			}
		}
		
		private function createResObject(param_xmllst:XMLList, param_wsa:WebServiceArgument):Object
		{
			if(param_wsa.isReference())
			{
				return parseXMLList(param_xmllst, _method_col.getComplexObject(param_wsa.type));	
			}
			else
			{
				return castType(param_xmllst[0], param_wsa.type);
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