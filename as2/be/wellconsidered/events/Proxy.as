
class be.wellconsidered.events.Proxy
{
	public static function create(oTarget:Object, fFunction:Function):Function
	{
	// jhallo
		var aParameters:Array = new Array();
		
		for(var i:Number = 2; i < arguments.length; i++)
		{
			aParameters[i - 2] = arguments[i];
		}

		var fProxy:Function = 	function():Void
								{
									var aActualParameters:Array = arguments.concat(aParameters); 
									aActualParameters.push(arguments.callee); 
									fFunction.apply(oTarget, aActualParameters);
								}

		return fProxy;
	}
}
