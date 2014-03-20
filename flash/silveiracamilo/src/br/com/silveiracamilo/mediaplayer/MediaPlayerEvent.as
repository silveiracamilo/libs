package br.com.silveiracamilo.mediaplayer {
	import br.com.silveiracamilo.mediaplayer.video.vo.CuePointVO;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class MediaPlayerEvent extends Event {
		
		public static const PLAYHEAD_UPDATE_PROGRESS:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.PLAYHEAD_UPDATE_PROGRESS";
		public static const LOAD_PROGRESS:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.LOAD_PROGRESS";
		public static const COMPLETE:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.COMPLETE";		
		public static const BUFFERING_STATE_ENTERED:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.BUFFERING_STATE_ENTERED";		
		public static const PLAYING_STATE_ENTERED:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.PLAYING_STATE_ENTERED";		
		public static const DURATION:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.DURATION";
		public static const CUE_POINT:String = "br.com.silveiracamilo.mediaplayer.VideoEvent.CUE_POINT";
		
		public var duration:Number;
		public var ratio:Number;
		public var cuePoint:CuePointVO;
		
		public function MediaPlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true, duration:Number = 0, ratio:Number = 0, cuePoint:CuePointVO = null) { 
			super(type, bubbles, cancelable);
			
			this.duration = duration;
			this.ratio = ratio;
			this.cuePoint = cuePoint;
		} 
		
		public override function clone():Event {
			var ev:MediaPlayerEvent = new MediaPlayerEvent(this.type, this.bubbles, this.cancelable);
			
			return ev;
		} 
		
		public override function toString():String { 
			return this.formatToString("VideoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}