import be.wellconsidered.lang.TranslationData;

/*
 * feed array ["NL","FR","EN"] and a path that point to the xml files "xml/"
 * xml files should be named like this: "trans_nl.xml" "trans_fr.xml" "trans_en.xml"
 */
 
class be.wellconsidered.lang.Translator
{
	private static var currentLanguage:String;
	private static var aLanguages:Array;
	private static var path:String;
	private static var languages:Object = new Object();
	private static var loadCount:Number;
	private static var listenerObjects:Array = new Array();
	private static var filenameFormatStart:String = "trans_";
	private static var filenameFormatEnd:String = ".xml";

	function Translator(){}
	
	public static function load(a:Array, s:String):Void
	{
		aLanguages = a;
		path = s;
		currentLanguage = aLanguages[0].toUpperCase();
		loadCount = 0;
		
		loadNextLang();
	}		
	
	public static function translate(k:String):String
	{
		return languages[currentLanguage].getTranslation(k);
	}
	
	public static function set language(s:String):Void
	{
		if (currentLanguage != s.toUpperCase())
		{
			currentLanguage = s.toUpperCase();
			
			for (var i:Number = 0, a:Number = listenerObjects.length; i < a; i++)
			{
				listenerObjects[i].onLanguageChange();
			}
		}
		else
		{
			trace("Translator: IGNORE setting same language");
		}
	}
	
	public static function get language():String
	{
		return currentLanguage;
	}

	private static function loadNextLang():Void
	{
		if (loadCount < aLanguages.length)
		{
			var td:TranslationData = new TranslationData(path + filenameFormatStart + aLanguages[loadCount].toLowerCase() + filenameFormatEnd);
			
			languages[aLanguages[loadCount]] = td;
			
			td.onLoad = function(s:Boolean):Void 
			{
				if (s)
				{
					Translator.loadNextLang();
				}
				else
				{
					for (var i:Number = 0, a:Number = Translator.listenerObjects.length; i < a; i++)
					{
						Translator.listenerObjects[i].onLoad(false);
					}
				}
			};
		}
		else
		{
			for (var i:Number = 0, a:Number = listenerObjects.length; i < a; i++)
			{
				listenerObjects[i].onLoad(true);
			}
		}
		
		loadCount++;
	}
	
	public static function addListener(o:Object):Void
	{
		listenerObjects.push(o);
	}

	public static function removeListener(o:Object):Void
	{
		for (var i:Number = 0, a:Number = listenerObjects.length; i < a; i++)
		{
			if (listenerObjects[i] == o)
			{
				listenerObjects = listenerObjects.splice(i, 1);
			}
		}
	}
}
