/**
 * @author pieter michels
 */
class be.wellconsidered.utils.StringUtils
{
	/**
	 * Constructor	 */
	private static function StringUtils(){}
	
	
	/**
	 * Remove specified characters
	 * 
	 * @param	trimmed				String to be processed  
	 * @param	chars				Array of chars to be removed from string 
	 * 
	 * @return		returns the string with the chars 	 */
	public static function removeChars(trimmed:String, chars:Array):String
	{
		for (var i:Number = 0; i < chars.length; i++)
		{
			// VERWIJDER CUSTOM CHARS
			if (trimmed.indexOf(chars[i]) >= 0)
			{
				while (trimmed.indexOf(chars[i]) != -1){ trimmed = replace(chars[i], "", trimmed); }
			}
			
			// START
			if (trimmed.indexOf(chars[i]) == 0)
			{
				while (trimmed.indexOf(chars[i]) == 0){ trimmed = replace(chars[i], "", trimmed); }
			}
			// END   
			if (trimmed.indexOf(chars[i]) == trimmed.length - 2)
			{
				while (trimmed.indexOf(chars[i]) == trimmed.length - 2){ trimmed = trimmed.substring(0, trimmed.length - 2); }
			}
		}
		
		return trimmed;
	}
	
	
	/**
	 * Trim whitespaces : left and right
	 * 
	 * @param	trimmed				String to be trimmed 
	 * 
	 * @return		returns trimmed string (both sides) 	 */
	public static function trimSpace(trimmed:String):String
	{
		trimmed = trimRight(trimmed);
		trimmed = trimLeft(trimmed);
		
		return trimmed;
	}
	
	
	/**
	 * Trim whitespaces from the right
	 * 
	 * @param	trimmed				String to be trimmed 
	 * 
	 * @return		returns right trimmed string 	 */
	public static function trimRight(trimmed:String):String
	{
        for (var i:Number = trimmed.length; i > 0; i--) {
                if (trimmed.charCodeAt (i) > 32) {
                        return trimmed.substring (0, i + 1);
                }
        }
        		
		return trimmed
	}	
	
	
	/**
	 * Trim whitespaces from the left
	 * 
	 * @param	trimmed				String to be trimmed 
	 * 
	 * @return		returns left trimmed string 
	 */	
	public static function trimLeft(trimmed:String):String
	{
        for (var i:Number = 0; i < trimmed.length; i++) {
                if (trimmed.charCodeAt (i) > 32) {
                        return trimmed.substr (i, trimmed.length);
                }
        }
        		
		return trimmed
	}
	
	
	/**
	 * Trim specific character(s) with another character(s)
	 * 
	 * @param	param_search			String where to search for
	 * @param	param_replace			String for replacement 
	 * @param	param_str				String where to search in  
	 * 
	 * @return		returns string with replaced chars 	 */
	public static function replace(param_search:String, param_replace:String, param_str:String):String
	{
		var str:String = param_str;
		var endText:String, preText:String, newText:String;
		
		var arg_search:String = param_search;
		var arg_replace:String = param_replace;
		
		if (arg_search.length == 1){ return str.split(arg_search).join(arg_replace); }
		
		var position:Number = str.indexOf(arg_search);
		
		if (position == -1){ return str; }
		
		do
		{
			position = str.indexOf(arg_search);
			preText = str.substring(0, position);
			endText = str.substring(position + arg_search.length);
			newText += preText + arg_replace;
		} while (str.indexOf(arg_search) != -1);
		
		return (newText + str);
	}	
}