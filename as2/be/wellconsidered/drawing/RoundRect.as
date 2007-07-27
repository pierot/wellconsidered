class be.wellconsidered.drawing.RoundRect
{
	function RoundRect(param_obj:Object)
	{
		var tmp_tgt:MovieClip = param_obj.target;

		tmp_tgt.clear();
		
		tmp_tgt.beginFill(param_obj.fillColor, param_obj.fillAlpha);
		tmp_tgt.lineStyle(param_obj.lineThickness, param_obj.lineColor, param_obj.lineAlpha);
		tmp_tgt.moveTo(param_obj.cornerRadius, 0);
		
		tmp_tgt.lineTo(param_obj.width - param_obj.cornerRadius, 0);
		tmp_tgt.curveTo(param_obj.width, 0, param_obj.width, param_obj.cornerRadius);
		tmp_tgt.lineTo(param_obj.width, param_obj.cornerRadius);
		tmp_tgt.lineTo(param_obj.width, param_obj.height - param_obj.cornerRadius);
		tmp_tgt.curveTo(param_obj.width, param_obj.height, param_obj.width - param_obj.cornerRadius, param_obj.height);
		tmp_tgt.lineTo(param_obj.width - param_obj.cornerRadius, param_obj.height);
		
		tmp_tgt.lineTo(param_obj.cornerRadius, param_obj.height);
		tmp_tgt.curveTo(0, param_obj.height, 0, param_obj.height - param_obj.cornerRadius);
		tmp_tgt.lineTo(0, param_obj.height - param_obj.cornerRadius);
	
		tmp_tgt.lineTo(0, param_obj.cornerRadius);
		tmp_tgt.curveTo(0, 0, param_obj.cornerRadius, 0);
		
		tmp_tgt.lineTo(param_obj.cornerRadius, 0);
		
		tmp_tgt.endFill();		
	}
}
