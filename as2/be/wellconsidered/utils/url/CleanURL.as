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
		_letter['œ'] = "oe";
		_letter['ß'] = "ss";
		_letter['à'] = "a";
		_letter['á'] = "a";
		_letter['â'] = "a";
		_letter['ã'] = "a";
		_letter['ä'] = "a";
		_letter['å'] = "a";
		_letter['æ'] = "ae";
		_letter['ç'] = "c";
		_letter['è'] = "e";
		_letter['é'] = "e";
		_letter['ê'] = "e";
		_letter['ë'] = "e";
		_letter['ì'] = "i";
		_letter['í'] = "i";
		_letter['î'] = "i";
		_letter['ï'] = "i";
		_letter['ð'] = "o";
		_letter['ñ'] = "n";
		_letter['ò'] = "o";
		_letter['ó'] = "o";
		_letter['ô'] = "o";
		_letter['õ'] = "o";
		_letter['ö'] = "o";
		_letter['ù'] = "u";
		_letter['ú'] = "u";
		_letter['û'] = "u";
		_letter['ü'] = "u";
		_letter['ý'] = "y";
		_letter['ÿ'] = "y";
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