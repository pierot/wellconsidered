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
			var soap_nms:Namespace = new Namespace("http://www.w3.org/2003/05/soap-envelope");
			var default_nms:Namespace = new Namespace("http://tempuri.org/");
			
			var body_resp_xml:XMLList = _resp_xml.soap_nms::Body.children();
			
			_response_name = body_resp_xml[0].localName();
			_method_name = _response_name.split("Response")[0];
			
			var result_xmllst:XMLList = body_resp_xml.default_nms::[_method_name + "Result"].children();
			
			var resp_obj:WebServiceMethodResponse = _method_col.getResponseObject(_response_name);
			
			for each(var it:WebServiceArgument in resp_obj._pars)
			{
				trace("args : " + it.name + " -" + it.type);
			}

			if(result_xmllst.length() > 1)
			{
				// HET IS EEN ARRAY VAN ELEMENTEN
				_data = new Array();
				
				for(var i:Number = 0; i < result_xmllst.length(); i++)
				{
					_data.push(createResObject(result_xmllst[i].children()));
				}
			}
			else if(result_xmllst[0].children().length() > 0)
			{
				// 1 ENKEL OBJECT MET MEERDERE PROPERTIES
				_data = createResObject(result_xmllst[0].children());				
			}
			else
			{
				// 1 ENKEL OBJECT MET 1 ARGUMENT
				_data = result_xmllst[0].toXMLString();
			}
		}
		
		private function createResObject(param_xmllst:XMLList):Object
		{
			var res:Object = new Object();
			
			for each(var el:XML in param_xmllst)
			{
				res[el.localName()] = el.toString();
				
				// trace(el.localName() + " -> " + _data[el.localName()] + " (" + (typeof _data[el.localName()]) + ")");
			}	
			
			return res;
		}
	
		public function get data():Object
		{
			return _data;
		}
	}
}