/**
 * @author pieter michels
 */
 
class be.wellconsidered.utils.MathUtils extends Math
{
	/**
	 * Constructor
	 */
	function MathUtils(){}
	
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
	
	public static function createID(param_length:Number):String
	{
		var tmp:Number = Math.round(Math.random() * 999999);
		
		return ("" + tmp).length < 6 ? "0" + tmp : "" + tmp;
	}	
}