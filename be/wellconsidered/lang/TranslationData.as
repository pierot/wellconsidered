import com.xfactorstudio.xml.xpath.XPath;

/*
*	how to use :
*
*	ACTIONSCRIPT:
*					import be.bbdo.atmosphere.xml.TranslationData;
*					var trans_obj:TranslationData = new TranslationData("lang/lang_NL.xml");
*					trans_obj.onLoad = function(succes)
*					{
*						trace("load is: " + succes);	
*						trace("myKey Translation is: " + trans_obj.getTranslation("myKey"));
*					}
*	lang_NL.xml:
*					<?xml version="1.0" encoding="UTF-8"?>				
*					<translations>		
*						<translation key="myKey"><![CDATA[This is a translationTekst]]></translation>		
*					</translations>
*/

class class be.wellconsidered.lang.TranslationData
{
	//VARS
	public var $root;
	private var td_translation_keys:Object;
	
	//**************************************************************************//
	//CONSTRUCTOR
	public function TranslationData(p_xml_path:String)
	{
		var $ref = this;
		var temp_xml:XML = new XML();
		td_translation_keys = new Object();
		
		temp_xml.ignoreWhite = true;
		temp_xml.load(p_xml_path);
		temp_xml.onLoad = function(success:Boolean):Void 
		{
			if (success)
			{
				var tmp_keys_arr:Array = XPath.selectNodes(this, "//translations/*");
				
				for (var i:Number = 0, a:Number = tmp_keys_arr.length; i < a; i++)
				{
					var tmp_trans_name:String = XPath.selectNodes(tmp_keys_arr[i], "//translation/@key")[0].toString();
					var tmp_trans_content:XMLNode = XPath.selectSingleNode(tmp_keys_arr[i], "//translation/node()");
					$ref.td_translation_keys[tmp_trans_name] = tmp_trans_content.nodeValue;
				}
				
				$ref.onLoad(true);
			}
			else
			{
				trace("TranslationData: Failed To Load XML: " + p_xml_path);
				
				$ref.onLoad(false);
			}
		};
	}
	
	public function onLoad(succes:Boolean):Void{}
	
	public function getTranslation(p_key:String):String
	{
		return td_translation_keys[p_key];
	}
}
