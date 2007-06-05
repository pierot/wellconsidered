/**
 * @author pieter michels
 */
 
class be.wellconsidered.utils.MathUtils extends Math
{
	/**
	 * Constructor
	 */
	private static function MathUtils(){}
	
	
	/**
	 * Round to specific decimal
	 * 
	 * @param	param_num				Number to be rounded 
	 * @param	param_count				Number of decimals
	 * 
	 * @return		returns rounded number (decimal)  
	 */
	public static function roundTo(param_num:Number, param_count:Number):Number
	{
		return int((param_num) * Math.pow(10, param_count)) / Math.pow(10, param_count);
	}
}