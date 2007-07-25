import mx.transitions.Tween;
import mx.transitions.easing.*;

import flash.filters.BlurFilter;

class be.wellconsidered.transitions.BlurTween
{
	private var _bf:BlurFilter;
	private var _mc:Object;
	private var _value:Number = 0;
	private var _blurTween:Tween;
	private var _quality:Number;
	
	/**
	* @param        mc
	* @param        quality;
	*/
	public function BlurTween(mc:Object, quality:Number)
	{
		_mc = mc;
		_quality = quality;
		
		_value = typeof(_mc.filters[0].blurX) == "number" ? _mc.filters[0].blurX : 0;
	}
   
	public function setQuality(value:Number):Void
	{
	   _quality = value;
	}

	/**
	* @param        target
	* @param        speed
	* @param        ease
	*/
	public function blurTo(target:Number, speed:Number, ease:Function):Void
	{
		clearTween();
		
		_blurTween = new Tween(this, "blur", Strong.easeOut, _value, target, speed, true);               
	}

	/**
	* @param        Void
	*/
	private function clearTween(Void):Void
	{
		_blurTween.stop();
		
		delete _blurTween;
	}       

	/**
	* @param        value
	*/
	public function set blur(value:Number):Void
	{
		_value = Math.floor(value);
	   
		_bf = new BlurFilter();
		_bf.blurX = _value;
		_bf.blurY = _value;
		_bf.quality = _quality;
	   
		_mc.filters = [_bf];
	}   
}