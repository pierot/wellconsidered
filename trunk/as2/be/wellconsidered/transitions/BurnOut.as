import flash.geom.ColorTransform;

class be.wellconsidered.transitions.BurnOut
{
	public function BurnOut(){}

	public static function burn(target:MovieClip, callback:Function, thisObject:Object):Void
	{
		var ra:Number = 100;
		var rb:Number = 255;
		var ga:Number = 100;
		var gb:Number = 255;
		var ba:Number = 100;
		var bb:Number = 255;
		var aa:Number = 100;
		var ab:Number = 1;
		
		target._parent.onEnterFrame = function()
		{
			var mc_color:Color = new Color(target);
			var ct:Object;
			
			if(rb > 5)
			{
				rb -= 15;
				gb -= 15;
				bb -= 15;

				ct = {ra: ra, rb: rb, ga: ga, gb: gb, ba: ba, bb: bb, aa: aa, ab: ab};

				mc_color.setTransform(ct);
			}
			else
			{
				rb = 1;
				gb = 1;
				bb = 1;
			
				ct = {ra: ra, rb: rb, ga: ga, gb: gb, ba: ba, bb: bb, aa: aa, ab: ab};
				
				mc_color.setTransform(ct);
				
				delete(this.onEnterFrame);
				
				callback.apply(thisObject);
			}
		}
	}

}