package  
{
	public class WebServiceMethod
	{
		public var _name:String;
		public var _args:Array;
		
		public function WebServiceMethod(param_name:String)
		{
			_name = param_name;
			
			_args = new Array();
		}
			
		public function addArg(param_name:String):void
		{
			_args.push(param_name);
		}
	}
}
