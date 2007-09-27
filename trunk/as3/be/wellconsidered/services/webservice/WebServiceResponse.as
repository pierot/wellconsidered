/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice
{
	public class WebServiceResponse
	{
		private var _resp_xml:XML;
		private var _data:Object;
		private var _method_name:String;
		
		public function WebServiceResponse(param_xml:XML)
		{
			_resp_xml = param_xml;
			
			createResponseObject();
		}
		
		private function createResponseObject():void
		{
			var soap_nms:Namespace = new Namespace("http://www.w3.org/2003/05/soap-envelope");
			var default_nms:Namespace = new Namespace("http://tempuri.org/");
			
			var body_resp_xml:XMLList = _resp_xml.soap_nms::Body.children();
			_method_name = body_resp_xml[0].localName().split("Response")[0];
			
			var result_xmllst:XMLList = body_resp_xml.default_nms::[_method_name + "Result"].children();
			
			if(result_xmllst.length() > 1)
			{
				// HET IS EEN ARRAY VAN ELEMENTEN
				_data = new Array();
				
				for(var i:Number = 0; i < result_xmllst.length(); i++)
				{
					_data.push(createResObject(result_xmllst[i].children()));
				}
			}
			else
			{
				// 1 ENKEL OBJECT			
				_data = createResObject(result_xmllst[0].children());				
			}
		}
		
		private function createResObject(param_xmllst:XMLList):Object
		{
			var res:Object = new Object();
			
			for each(var el:XML in param_xmllst)
			{
				res[el.localName()] = el.toString();
				
				// trace(el.localName() + " -> " + _data[el.localName()] + " (" + (typeof _data[el.localName()]) + ")");
			}	
			
			return res;
		}
	
		public function get data():Object
		{
			return _data;
		}
	}
}

/* VOORBEELD 1
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <getProdWeekResponse xmlns="http://tempuri.org/">
      <getProdWeekResult>
        <ProdWeek>
          <BON_BK>PS1</BON_BK>
          <BONTYPE>3</BONTYPE>
          <PRODUCT>LIT Tetra peach trio-pack tetra</PRODUCT>
          <BONNAAM>Happy Days punten bij aankoop van 2 3-packs Lipton Ice tea (tetra)</BONNAAM>
          <TEKST/>
          <BEELD>CQJV2_Offre_PS1.png</BEELD>
          <VALIDITY/>
          <EANCODE>0400444000008</EANCODE>
          <PROMO/>
          <BONKOST>20</BONKOST>
          <WEEK>1</WEEK>
          <ERROR/>
        </ProdWeek>
      </getProdWeekResult>
    </getProdWeekResponse>
  </soap:Body>
</soap:Envelope>
*/