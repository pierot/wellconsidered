import be.wellconsidered.validation.RegExp;

class be.wellconsidered.validation.form.ValidateItem
{
	private var _field:TextField;
	private var _regexp:String;
	private var _regexp_flags:String
	
	function ValidateItem(param_field:TextField, param_regexp:String, param_flags:String)
	{
		_field = param_field;
		_regexp = param_regexp;
		_regexp_flags = param_flags;
	}
	
	public function validate():Boolean
	{
		// trace("VALIDATE " + _field._name + " TEGEN " + _regexp);
		
		var tmp_re:RegExp = new RegExp(_regexp, _regexp_flags);
						
		return tmp_re.test(_field.text);
	}
	
	public function getField():TextField
	{
		return _field;
	}
}
