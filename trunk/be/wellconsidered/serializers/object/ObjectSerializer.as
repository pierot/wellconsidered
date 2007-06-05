
class be.wellconsidered.serializers.object.ObjectSerializer
{
	function ObjectSerializer(){}
	
	public static function visualize(param_obj):String
	{
		var looped:Boolean = false;
		var t:String = (t == undefined) ? "\t" : t + "\t";
		var s:String = (s == undefined) ? "Object: {" : s + "{";
		
		for (var p in param_obj)
		{
			s += "\n" + t;
			
			var looped:Boolean = (!looped) ? true : looped;
			
			if (param_obj[p] instanceof Array)
			{
				s += p + ": [" + param_obj[p] + "]";
			}
			else if (typeof param_obj[p] == "object")
			{
				s += param_obj[p].toString (p + ": ", t);
			}
			else if (typeof param_obj[p] == "function")
			{
				s += p + ": (function)";
			}
			else
			{
				s += p + ": " + param_obj[p];
			}
		}
		
		return s + "\n" + t.slice (0, -1) + "}";		
	}
}
