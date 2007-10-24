class be.wellconsidered.utils.ArrayUtils
{
	public function ArrayUtils() {}
	
	public static function shuffleArray(param_a:Array):Array
	{
		return param_a.sort(shuffle);
	}
	
	private static function shuffle(param_a, param_b):Number
	{
		return Math.round(Math.random() * 2) - 1;
	}
}