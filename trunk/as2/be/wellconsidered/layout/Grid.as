class be.wellconsidered.layout.Grid
{
	public var max_cols:Number = 0;
	public var x_offset:Number = 0;
	public var y_offset:Number = 0;
	
	public var mc_arr:Array;
	
	public static var VERTICAL:Number = 2;
	public static var HORIZONTAL:Number = 1;

	public function Grid(a:Array, c:Number, xO:Number, yO:Number, method:Number)
	{
		mc_arr = a;
		
		max_cols = c;
		x_offset = xO;
		y_offset = yO;
		
		switch(method)
		{
			case 2:
			
					sortDataVertical();
					break;
				
			default:
			
					sortData();
		}
	}

	public function sortData():Void
	{
		for(var i:Number = 0; i < mc_arr.length; i ++)
		{
			var mc:MovieClip = mc_arr[i];
			
			mc._x = i % max_cols * x_offset;
			mc._y = Math.floor(i / max_cols) * y_offset;
		}
	}
	
	public function sortDataVertical():Void
	{
		for(var i:Number = 0; i < max_cols; i++)
		{
			var start_idx:Number = i * Math.round(mc_arr.length / max_cols);
			var end_idx:Number = ((i + 1) * Math.round(mc_arr.length / max_cols));
			
			var sub_arr:Array = mc_arr.slice(start_idx, end_idx + 1);
			
			for(var j:Number = 0; j < sub_arr.length; j++)
			{
				var mc:MovieClip = sub_arr[j];
				
				mc._x = i * x_offset;
				mc._y = j * y_offset;
			}
		}
	}
	
}