/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice 
{
	import be.wellconsidered.services.webservice.types.*;
	
	import be.wellconsidered.events.WebServiceMethodCollectionEvent;
	
	import flash.events.EventDispatcher;
	
	public class WebServiceMethodCollection extends EventDispatcher
	{
		private var _methods_arr:Array;
		private var _complex_arr:Array;
		private var _response_arr:Array;
		
		private var _tgtnms:String;
		
		public function WebServiceMethodCollection()
		{
			_methods_arr = new Array();
			_response_arr = new Array();
			_complex_arr = new Array();
		}
		
		public function extract(param_xml:XML):void
		{
			// trace(param_xml);
			
			var types_nms:Namespace = param_xml.namespace("wsdl");
			
			try
			{
				_tgtnms = param_xml.@targetNamespace;
			}
			catch(e:Error)
			{/* trace(e.message); */}
			
			var types_xml:XML = param_xml.types_nms::types[0];
			var s_nms:Namespace = types_xml.namespace("s");
			
			var els_xml:XML = types_xml.s_nms::schema[0];
			
			extractMethods(els_xml, s_nms);
			extractComplexType(els_xml, s_nms);
			
			dispatchEvent(new WebServiceMethodCollectionEvent(WebServiceMethodCollectionEvent.COMPLETE));
		}
		
		private function extractMethods(param_schema_xml:XML, param_nms:Namespace):void
		{
			for each(var i:XML in param_schema_xml.param_nms::element)
			{
				try
				{
					var tmp_complex:XML = i.param_nms::complexType[0];
					
					// ARGUMENTEN XML
					var tmp_sequence:XML = tmp_complex.param_nms::sequence.length() > 0 ? tmp_complex.param_nms::sequence[0] : null;
					var tmp_lst:XMLList = tmp_sequence == null ? new XMLList() : tmp_sequence.param_nms::element;
				
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
		
		private function extractComplexType(param_schema_xml:XML, param_nms:Namespace):void
		{
			for each(var i:XML in param_schema_xml.param_nms::complexType)
			{
				try
				{
					var tmp_sequence:XML = i.param_nms::sequence[0];
					
					var complex:WebServiceComplexType = new WebServiceComplexType(i.@name);
					
					var tmp_lst:XMLList = tmp_sequence == null ? new XMLList() : tmp_sequence.param_nms::element;
					
					for each(var m:XML in tmp_lst)
					{				
						complex.addProp(new WebServiceArgument(m.@name, m.@type));
					}	
					
					_complex_arr.push(complex);
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
		
		public function getMethodObjectArgument(param_a:Array, param_name:String):WebServiceArgument
		{
			for(var i:int = 0; i < param_a.length; i++)
			{
				if(param_a[i].name == param_name){ return param_a[i]; break; }
			}
			
			return null;
		}		
		
		public function getResponseObject(param_name:String):WebServiceMethodResponse
		{
			for(var i:int = 0; i < _response_arr.length; i++)
			{
				if(_response_arr[i]._name == param_name){ return _response_arr[i]; break; }
			}
			
			return null;
		}
		
		public function getComplexObject(param_name:String):WebServiceComplexType
		{
			for(var i:int = 0; i < _complex_arr.length; i++)
			{
				if(_complex_arr[i]._name == param_name){ return _complex_arr[i]; break; }
			}
			
			return null;
		}	
		
		public function getComplexObjectArgument(param_a:Array, param_name:String):WebServiceArgument
		{
			for(var i:int = 0; i < param_a.length; i++)
			{
				if(param_a[i].name == param_name){ return param_a[i]; break; }
			}
			
			return null;
		}		
		
		public function methodExists(param_name:String):Boolean
		{
			for(var i:int = 0; i < _methods_arr.length; i++)
			{
				if(_methods_arr[i]._name == param_name){ return true; break; }
			}
			
			return false;			
		}
		
		public function get targetNameSpace():String
		{
			return _tgtnms;
		}
	}
}
