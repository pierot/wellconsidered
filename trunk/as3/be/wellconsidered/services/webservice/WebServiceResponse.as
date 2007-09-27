/**
* @author Pieter Michels
*/

package be.wellconsidered.services.webservice
{
	public class WebServiceResponse
	{
		private var _resp_xml:XML;
		private var _data:Object;
		
		public function WebServiceResponse(param_xml:XML)
		{
			_resp_xml = param_xml;
			
			createResponseObject();
		}
		
		private function createResponseObject():void
		{
			var soap_nms:Namespace = new Namespace("http://www.w3.org/2003/05/soap-envelope");
			var body_resp_xml:XML = _resp_xml.soap_nms::Body[0].children()[0];
			var body_res_xml:XML = body_resp_xml.children()[0];
			var body_res_axml:Number = body_res_xml.children().length();
			var body_res_xmllst:XMLList;
			
			if(body_res_axml > 1)
			{
				// HET IS EEN ARRAY VAN ELEMENTEN
				_data = new Array();
				
				for(var i:Number = 0; i < body_res_axml; i++)
				{
					body_res_xmllst = body_res_xml.children()[i].children();
						
					_data.push(createResObject(body_res_xmllst));
				}
			}
			else
			{
				// 1 ENKEL OBJECT
				body_res_xmllst = body_res_xml.children()[0].children();
				
				_data = createResObject(body_res_xmllst);				
			}
		}
		
		private function createResObject(param_xmllst:XMLList):Object
		{
			var tmp_res:Object = new Object();
			
			for each(var el:XML in param_xmllst)
			{
				tmp_res[el.localName()] = el.toString();
				
				// trace(el.localName() + " -> " + _data[el.localName()] + " (" + (typeof _data[el.localName()]) + ")");
			}	
			
			return tmp_res;
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