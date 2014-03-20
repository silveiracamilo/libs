package br.com.silveiracamilo.mediaplayer.video.controls 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import br.com.silveiracamilo.mediaplayer.IMediaPlayer;
	import br.com.silveiracamilo.mediaplayer.MediaPlayerEvent;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class PlayOrPauseControl extends ButtonControl
	{
		
		public function PlayOrPauseControl(button:DisplayObject, mediaPlayer:IMediaPlayer) {
			super(button, mediaPlayer);
		}
		
		override protected function setup():void {
			super.setup();
			
			this.mediaPlayer.addEventListener(MediaPlayerEvent.COMPLETE, mediaPlayerHandler, false, 0, true);
		}
		
		protected function mediaPlayerHandler(ev:MediaPlayerEvent):void {
			if (ev.type == MediaPlayerEvent.COMPLETE) {
				if (this.button is MovieClip) {
					(this.button as MovieClip).gotoAndStop(2);
				}
			}
		}
		
		override protected function mouseHandler(ev:MouseEvent):void {
			if (ev.type == MouseEvent.CLICK) {				
				if (this.mediaPlayer.playing) {
					this.mediaPlayer.pause();
					if (this.button is MovieClip) {
						(this.button as MovieClip).gotoAndStop(2);
					}
				} else {
					this.mediaPlayer.play();
					if (this.button is MovieClip) {
						(this.button as MovieClip).gotoAndStop(1);
					}
				}
			}
		}		
	}

}