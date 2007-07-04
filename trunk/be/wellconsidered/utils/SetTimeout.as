/**
 * @author pieter michels
 */
 
class be.wellconsidered.utils.SetTimeout
{
	/**
	 * Vars
	 */
	public var _timerInterval:Number;
	public var _callBackArgs:Array;
	
	/**
	* Constructor
	*
	* @param	callBack		referentie naar een functie
	* @param	callBackRoot	referentie naar de plaats waar de functie zich bevindt
	* @param	callBackArgs	een argument
	* @param	delay			hoe lang moet hij wachten met uitvoeren
	*/
	function SetTimeout(callBack:Function, callBackRoot:Object, delay:Number)
	{
		_callBackArgs = (arguments[3] == "nextFrame") ? [(callBackRoot._currentframe + 1)] : arguments.slice(3);
		  
		var $self:Object = this;
		_timerInterval = setInterval(function ()
		{
			callBack.apply(callBackRoot, $self._callBackArgs);
			clearInterval($self._timerInterval);
		}, delay);
	}
	
	/**
	* Stop de huidige timeout.
	*/
	public function stop():Void
	{
		clearInterval(_timerInterval);
		
		delete this
		
		this = null
		this = undefined
	}
}
