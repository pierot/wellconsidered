 
class be.wellconsidered.da.CookieManager
{
	/**
	 * Vars	 */
	private static var _ckie_name:String = "";
	private static var _ckie_so:SharedObject;
	
	
	/**
	 * Constructor	 */
	private function CookieManager(){}
	
	
	/**
	 * Create Cookie
	 */
	public static function getCookie(param_cookie_name:String):Void
	{
		trace("GET COOKIE (" + param_cookie_name + ")");
		
		_ckie_name = param_cookie_name;
		
		_ckie_so = SharedObject.getLocal(_ckie_name, "/");
		
		_ckie_so.onStatus = function(param_ifo:Object)
		{
		    for (var i in param_ifo)
		    {
		        trace(param_ifo[i], LogWrapper.WARN);
		    }
		};
	}	
	
	
	/**
	 * Read Cookie	 */
	public static function read(param_var:String):String
	{
		trace("READ COOKIE (" + param_var + ")");
		
		return _ckie_so.data[param_var];
	}
	
	
	/**
	 * Write to cookie	 */
	public static function write(param_var:String, param_content:String):Void
	{
		trace("WRITE TO COOKIE (" + param_var + "->" + param_content + ")");
		
		if(_ckie_so == null)
		{
			getCookie(_ckie_name);
		}
		
		_ckie_so.data[param_var] = param_content;
		
		_ckie_so.flush();
		
		if(_ckie_so.data[param_var] == param_content)
		{
			trace("WRITE TO COOKIE WAS SUCCESSFUL");
		}
	}
	
	
	/**
	 * Clear Cookie	 */
	public static function clear():Void
	{
		trace("CLEAR COOKIE");
		
		_ckie_so.clear();
		
		_ckie_so = undefined;
		_ckie_so = null;
	}
}