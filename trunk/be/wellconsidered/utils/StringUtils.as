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
	
	/**
	 * Correct HTML
	 *
	 * @return		returns string with correct html
	 */
	public static function corrHTML(param_txt:String):String
	{
		param_txt = replace("&deg;", "°", param_txt);
		param_txt = replace("&uacute;", "ú", param_txt);
		param_txt = replace("&ntilde;", "ñ", param_txt);
		param_txt = replace("&aacute;", "á", param_txt);
		param_txt = replace("&oacute;", "ó", param_txt);
		param_txt = replace("&iacute;", "í", param_txt);
		param_txt = replace("&agrave;", "à", param_txt);
		param_txt = replace("&egrave;", "è", param_txt);
		param_txt = replace("é&iexcl;", "a", param_txt);
		param_txt = replace("&rsquo;", "'", param_txt);
		param_txt = replace("&ldquo;", "'", param_txt);
		param_txt = replace("&rdquo;", "'", param_txt);
		param_txt = replace("&euro;", "€", param_txt);
		param_txt = replace("&hellip;", "...", param_txt);
		param_txt = replace("$egrave;", "è", param_txt);
		param_txt = replace("$reg;", "®", param_txt);
		param_txt = replace("&iuml;", "ï", param_txt);
		param_txt = replace("&euml;", "ë", param_txt);
		param_txt = replace("&eacute;", "é", param_txt);
		param_txt = replace("&amp;", "&", param_txt);
		param_txt = replace("&lt;", "<", param_txt);
		param_txt = replace("&gt;", ">", param_txt);
		param_txt = replace("&#039;", "'", param_txt);
		
		param_txt = replace("&quot;", "'", param_txt);
		param_txt = replace("&nbsp;", " ", param_txt);
		param_txt = replace("strong", "b", param_txt);
		param_txt = replace("&copy;", "", param_txt);
		param_txt = replace("&laquo;", "\"", param_txt);
		param_txt = replace("&raquo;", "\"", param_txt);
		param_txt = replace("&Atilde;", "é", param_txt);
		param_txt = replace("&acirc;", "'", param_txt);
		
		param_txt = replace("<p>", "", param_txt);
		param_txt = replace("</p>", "<br />", param_txt);
		param_txt = replace("\n", "", param_txt);
		param_txt = replace("\r", "", param_txt);
		param_txt = replace("<b>", "<span class=\"vet\">", param_txt);
		param_txt = replace("</b>", "</span>", param_txt);
		
		return param_txt;
	}	
}