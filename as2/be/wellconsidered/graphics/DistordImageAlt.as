import be.wellconsidered.graphics.DistordImage;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.ColorTransform;

/**
* 
* does the same as DistordImage but get's it's Bitmapdata from another mc;
* 
*/

class be.wellconsidered.graphics.DistordImageAlt extends DistordImage {

	public function DistordImageAlt(mc:MovieClip, mcSource:MovieClip, vseg:Number, hseg:Number,w:Number,h:Number)
	{
		var bd:BitmapData = new BitmapData(w,h,true,0x00FF00);
		bd.draw(mcSource, new Matrix(), new ColorTransform(), "normal", null, true)
		
		_mc = mc;
		_texture = bd; //BitmapData.loadBitmap(symbolId);
		_vseg = vseg;
		_hseg = hseg;
		_w = _texture.width;
		_h = _texture.height;
		__init();
	}
}