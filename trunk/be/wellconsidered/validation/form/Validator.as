import be.wellconsidered.validation.form.*;

class be.wellconsidered.validation.form.Validator
{
	private var _onError:Function;
	private var _onValidated:Function;
	
	private var _onRoot:MovieClip;
	
	private var _val_arr:Array;
	
	// DEFAULT VALIDATION REGEXP STRINGS
	public static var VALID_EMAIL:String = "^[a-zA-Z0-9_.-]{1,,30}[@]{1}[a-zA-Z0-9_.-]{1,,50}$";
	public static var VALID_STRING:String = "^[a-zA-Z0-9_.-]{1,,256}$";
	
	function Validator(param_root:MovieClip)
	{
		trace("NEW VALIDATOR INSTANTIATED");
		
		_onRoot = param_root;
		_val_arr = new Array();
	}
	
	public function setHandlers(param_err:Function, param_val:Function):Void
	{
		_onError = param_err;
		_onValidated = param_val;
	}
	
	public function addItem(param_field:TextField, param_regexp:String):Void
	{
		_val_arr.push(new ValidateItem(param_field, param_regexp, "gim"));
	}
	
	public function validate():Void
	{
		trace("VALIDATE FORM");
		
		var bValid:Boolean = true;
		var bErrorField_arr:Array = new Array();
		
		for(var i:Number = 0; i < _val_arr.length; i++)
		{
			if(!_val_arr[i].validate())
			{
				bValid = false;
				
				bErrorField_arr.push(_val_arr[i].getField());
			}
		}
		
		if(bValid) { _onValidated(_onRoot); }else{ _onError(bErrorField_arr, _onRoot); }
	}
}
