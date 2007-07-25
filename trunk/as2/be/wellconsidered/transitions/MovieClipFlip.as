import be.wellconsidered.graphics.DistordImageAlt;

import mx.transitions.Tween;
import mx.transitions.easing.*;

import flash.filters.BlurFilter;
import flash.geom.ColorTransform;

class be.wellconsidered.transitions.MovieClipFlip extends MovieClip
{	
	private var _dia:DistordImageAlt;
	
	private var _mcSource:MovieClip;
	private var _mcCont:MovieClip;
		
	private var _vseg:Number = 2;
	private var _hseg:Number = 2;
	private var _nZoom:Number = 1;
	public var _nRotation:Number = 0;
	private var _nWidth:Number;
	private var _nHeight:Number;
	
	private var _tw:Tween;
	private var _twZoom:Tween;
	
	private var fl:Number = 250;
	private var vpX:Number =0;
	private var vpY:Number =0;
	private var points:Array = new Array();
	
	private var _bIsAnimating:Boolean = false;
	
	function BtnFlip()
	{
		init();
	}
	
	private function init():Void
	{	
		var $Ref:MovieClip = this;
		
		_mcSource = this["image_mc"];
		_mcCont = this.createEmptyMovieClip("holder_mc",this.getNextHighestDepth());
		
		_nWidth = _mcSource._width
		_nHeight = _mcSource._height
		
		vpX = _nWidth/2;
		vpY = _nHeight/2;
		
		points[0] = {x:-_nWidth/2, y:-_nHeight/2, z:0};
		points[1] = {x:_nWidth/2, y:-_nHeight/2, z:0};
		points[2] = {x:_nWidth/2, y:_nHeight/2, z:0};
		points[3] = {x:-_nWidth/2, y:_nHeight/2, z:0};
		
		_dia = new DistordImageAlt(_mcCont,_mcSource,_vseg,_hseg,_nWidth,_nHeight);
		
		var c:Color = new Color(_mcSource);
		var ct:Object = { ra: 0, rb: 0, ga: 0, gb: 0, ba: 0, bb: 0, aa: 33, ab: 1};
		
		c.setTransform(ct);
		
		_mcSource._alpha = 13;
		_mcSource.filters = [new BlurFilter(10,10,1)];
		
		this.onPress = doFlip;
		
		render();
	}
	
	private function doFlip():Void
	{
		var $Ref:MovieClip = this;
		
		if(!_bIsAnimating)
		{
			_bIsAnimating = true;
			
			_tw = new Tween(this,"_nRotation",Regular.easeInOut,_nRotation,_nRotation + 360,0.5,true);
			
			_tw.onMotionChanged = function():Void
			{
				$Ref.render();
			}
			
			_tw.onMotionFinished = function():Void
			{
				$Ref._bIsAnimating = false;
			}
			
			_twZoom = new Tween(this,"_nZoom",Strong.easeOut,1,1.5,0.25,true);
			
			_twZoom.onMotionChanged = function():Void
			{
				var xBlur = ($Ref._nZoom -1 ) * 20;
				
				$Ref._mcCont.filters = [new BlurFilter(xBlur,0,1)];
				$Ref._mcSource._alpha = 3 + (10 * (1 -(($Ref._nZoom - 1) / 0.5)))
			}
			
			_twZoom.onMotionFinished = function():Void
			{
				this.continueTo(1,0.25);
				this.onMotionFinished = null;
			}
		}
	}
	
	private function render():Void
	{		
		var newPoints:Array = transformPointsForYRotation((_nRotation/180) *  Math.PI);

		_dia.setTransform(	newPoints[0].xPos,newPoints[0].yPos,
							newPoints[1].xPos,newPoints[1].yPos,
							newPoints[2].xPos,newPoints[2].yPos,
							newPoints[3].xPos,newPoints[3].yPos);
	}

	private function transformPointsForYRotation(r:Number):Array
	{
		var angleY:Number = r;
		var angleX:Number = 0;
		
		var cosY:Number = Math.cos(angleY);
		var sinY:Number = Math.sin(angleY);
			
		var cosX:Number = Math.cos(angleX);
		var sinX:Number = Math.sin(angleX);
		
		var newPoints:Array = new Array();
		
		for(var i:Number = 0; i < points.length; i++)
		{
			var point:Object = points[i];
			
			var x1:Number = point.x * cosY - point.z * sinY;
			var z1:Number = point.z * cosY + point.x * sinY;
			
			var y1:Number = point.y * cosY - z1 * sinX;
			var z2:Number = z1 * cosX + point.y * sinX;
			
			var newPoint:Object = new Object();
			newPoint.x = x1;
			newPoint.z = z2;
			
			var scale:Number = fl/(fl + newPoint.z) *  _nZoom;
			
			newPoint.xPos = vpX + newPoint.x * scale;
			newPoint.yPos = vpY + point.y * scale;
			
			newPoints[i] = newPoint;
		}
		
		return newPoints;
	}
}