package br.com.silveiracamilo.mediaplayer {
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public interface IMediaPlayer extends IEventDispatcher {
		function get playing():Boolean;
		
		function init():void;
		function close():void;
		function play():void;
		function pause():void;
		function stop():void;
		function rewind():void;
		function set autoPlay(value:Boolean):void;
		function seek(time:Number):void;
		function volume(value:Number):void;
		function getTimeTotalFormatted():String;
		function getTimePositionFormatted():String;
		function getTime():Number;
		function getPercentage():Number;
	}	
}