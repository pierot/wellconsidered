class be.wellconsidered.utils.url.CleanURL
{
	private static var _inst:URLRewriter;
	private var _letter:Array;
	private var START_ALPHA:Number = 96;
	private var END_ALPHA:Number = 123;
	private var START_NUM:Number = 47;
	private var END_NUM:Number = 58;
	
	private function URLRewriter()
	{
		_letter = [];
		_letter['�'] = "oe";
		_letter['�'] = "ss";
		_letter['�'] = "a";
		_letter['�'] = "a";
		_letter['�'] = "a";
		_letter['�'] = "a";
		_letter['�'] = "a";
		_letter['�'] = "a";
		_letter['�'] = "ae";
		_letter['�'] = "c";
		_letter['�'] = "e";
		_letter['�'] = "e";
		_letter['�'] = "e";
		_letter['�'] = "e";
		_letter['�'] = "i";
		_letter['�'] = "i";
		_letter['�'] = "i";
		_letter['�'] = "i";
		_letter['�'] = "o";
		_letter['�'] = "n";
		_letter['�'] = "o";
		_letter['�'] = "o";
		_letter['�'] = "o";
		_letter['�'] = "o";
		_letter['�'] = "o";
		_letter['�'] = "u";
		_letter['�'] = "u";
		_letter['�'] = "u";
		_letter['�'] = "u";
		_letter['�'] = "y";
		_letter['�'] = "y";
		_letter["'"] = "-";
	}
	
	public static function getInstance():URLRewriter
	{
		if (_inst == undefined)
		{
			_inst = new URLRewriter();
		}
		
		return _inst;
	}
	
	public function cleanURL(url:String):String
	{
		url = url.split(" ").join("-");
		url = url.toLowerCase();
		
		var a = url.split("");
		var b = a.length;
		var url = "";
		
		for(var i = 0; i < b; i++)
		{
			var l = a[i];
			var n = l.charCodeAt();
			
			if((n > START_NUM && n < END_NUM) || (n > START_ALPHA && n < END_ALPHA) || (l == "-"))
			{
				url += l;
			}
			else
			{
				var u = _letter[l];
				url += (u != undefined) ? u : "";
			}
		}
		
		return url;
	}	
}