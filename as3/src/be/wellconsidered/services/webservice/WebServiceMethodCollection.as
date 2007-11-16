/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice 
{
	import be.wellconsidered.events.WebServiceMethodCollectionEvent;
	import be.wellconsidered.services.webservice.types.*;
	
	import flash.events.EventDispatcher;
	
	public class WebServiceMethodCollection extends EventDispatcher
	{
		private var _methods_arr:Array;
		private var _complex_arr:Array;
		private var _response_arr:Array;
		private var _bindings_arr:Array;
		
		private var _tgtnms:String;
		
		private var _porttype:Boolean = false;
		
		public function WebServiceMethodCollection()
		{
			_methods_arr = new Array();
			_response_arr = new Array();
			_complex_arr = new Array();
			_bindings_arr = new Array();
		}
		
		/**
		* Extract data from resulting XML
		* 
		* @param	XML object
		*/
		public function extract(param_xml:XML):void
		{
			// trace(param_xml);
			
			var p_nms:Namespace = param_xml.namespace();
			var types_xml:XML = param_xml.p_nms::types[0];
			var porttypes_xml:XML = param_xml.p_nms::portType[0];
			var bindings_xml:XML = param_xml.p_nms::binding[0];
			var messages_xmllst:XMLList = param_xml.p_nms::message;
			
			try
			{
				_tgtnms = param_xml.@targetNamespace;
			}
			catch(e:Error)
			{ /*trace(e.message);*/ }
			
			if(types_xml.children().length() > 0)
			{
				// METHODS / COMPLEX TYPES
				var s_nms:Namespace = types_xml.children()[0].namespace();
			
				extractMethods(types_xml.s_nms::schema[0], s_nms);
				extractComplexType(types_xml.s_nms::schema[0], s_nms);
			}
			else
			{
				// PORTMETHODS
				_porttype = true;
				
				extractPortMethods(porttypes_xml[0], porttypes_xml.children()[0].namespace(), porttypes_xml.@name, messages_xmllst);
			}
			
			// BINDINGS
			extractBindings(bindings_xml[0], bindings_xml.namespace());
			
			dispatchEvent(new WebServiceMethodCollectionEvent(WebServiceMethodCollectionEvent.COMPLETE));
		}
		
		private function extractBindings(param_schema_xml:XML, param_nms:Namespace):void
		{		
			var op_nms:Namespace = param_schema_xml.namespace("soap");

			for each(var i:XML in param_schema_xml.param_nms::operation)
			{
				try
				{
					var binding:WebServiceBinding = new WebServiceBinding(i.@name);
					
					var input_xml:XML = i.param_nms::input[0];
					var output_xml:XML = i.param_nms::output[0];
					
					binding.addInputNamespace(input_xml.op_nms::body[0].attribute("namespace"));
					binding.addInputUse(input_xml.op_nms::body[0].attribute("use"));
					
					binding.addOutputNamespace(output_xml.op_nms::body[0].attribute("namespace"));
					binding.addOutputUse(output_xml.op_nms::body[0].attribute("use"));
					
					_bindings_arr.push(binding);
				}
				catch(e:Error)
				{trace(e.message, e.getStackTrace());}
			}
		}
		
		private function extractPortMethods(param_schema_xml:XML, param_nms:Namespace, param_s_name:String, param_mes_xmllst:XMLList):void
		{
			for each(var i:XML in param_schema_xml.param_nms::operation)
			{
				try
				{
					// var par_order:Array = i.@parameterOrder.split(" ");
					
					// METHODS
					var method:WebServiceMethod = new WebServiceMethod(i.@name);
					var m_message:XML = param_mes_xmllst.(attribute("name") == (param_s_name + "_" + method._name))[0];

					for each(var j:XML in m_message.param_nms::part)
					{				
						method.addArg(new WebServiceArgument(j.@name, j.@type));
					}
					
					_methods_arr.push(method);					
					
					// RESPONSES
					var response:WebServiceMethodResponse = new WebServiceMethodResponse(i.param_nms::output.@message.split(":")[1].split("_")[1]);
					var r_message:XML = param_mes_xmllst.(attribute("name") == (param_s_name + "_" + response._name))[0];
					
					for each(var k:XML in r_message.param_nms::part)
					{				
						response.addPar(new WebServiceArgument(k.@name, k.@type));
					}
					
					_response_arr.push(response);					
				}
				catch(e:Error)
				{trace(e.message, e.getStackTrace());}
			}		
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
		
		/**
		* Get Method object
		* 
		* @param	Name of object
		* 
		* @return	WebServiceMethod
		*/		
		public function getMethodObject(param_name:String):WebServiceMethod
		{
			for(var i:int = 0; i < _methods_arr.length; i++)
			{
				if(_methods_arr[i]._name == param_name){ return _methods_arr[i]; break; }
			}
			
			return null;
		}

		/**
		* Get WebServiceArgument from a MethodObject
		* 
		* @param	Array of WebServiceArguments
		* @param	Argument name
		* 
		* @return	WebServiceArgument or null
		*/
		public function getMethodObjectArgument(param_a:Array, param_name:String):WebServiceArgument
		{
			for(var i:int = 0; i < param_a.length; i++)
			{
				if(param_a[i].name == param_name){ return param_a[i]; break; }
			}
			
			return null;
		}		
		
		/**
		* Get Response object
		* 
		* @param	Name of object
		* 
		* @return	WebServiceMethodResponse
		*/		
		public function getResponseObject(param_name:String):WebServiceMethodResponse
		{
			for(var i:int = 0; i < _response_arr.length; i++)
			{
				// trace(_response_arr[i]._name + " == " + param_name);
				if(_response_arr[i]._name == param_name){ return _response_arr[i]; break; }
			}
			
			return null;
		}
		
		/**
		* Get Complex object
		* 
		* @param	Name of object
		* 
		* @return	WebServiceComplexType
		*/
		public function getComplexObject(param_name:String):WebServiceComplexType
		{
			for(var i:int = 0; i < _complex_arr.length; i++)
			{
				if(_complex_arr[i]._name == param_name){ return _complex_arr[i]; break; }
			}
			
			return null;
		}
		
		/**
		* Get Binding object
		* 
		* @param	Name of method
		* 
		* @return	WebServiceBinding
		*/
		public function getBindingObject(param_name:String):WebServiceBinding
		{
			for(var i:int = 0; i < _bindings_arr.length; i++)
			{
				if(_bindings_arr[i]._name == param_name){ return _bindings_arr[i]; break; }
			}
			
			return null;
		}
		
		/**
		* Get WebServiceArgument from a ComplexObject
		* 
		* @param	Array of WebServiceArguments
		* @param	Argument name
		* 
		* @return	WebServiceArgument or null
		*/
		public function getComplexObjectArgument(param_a:Array, param_name:String):WebServiceArgument
		{
			for(var i:int = 0; i < param_a.length; i++)
			{
				if(param_a[i].name == param_name){ return param_a[i]; break; }
			}
			
			return null;
		}		
		
		/**
		* Check if method exists
		* 
		* @param	Method name
		* 
		* @return	True if method exists
		*/
		public function methodExists(param_name:String):Boolean
		{
			for(var i:int = 0; i < _methods_arr.length; i++)
			{
				if(_methods_arr[i]._name == param_name){ return true; break; }
			}
			
			return false;			
		}
		
		/**
		* Get target namespace
		* 
		* @return	Namespace as a String
		*/
		public function get targetNameSpace():String
		{
			return _tgtnms;
		}
		
		/**
		* Is port type?
		* 
		* @return	Boolean
		*/
		public function isPortType():Boolean
		{
			return _porttype;
		}		
	}
}
