﻿package br.com.silveiracamilo.mediaplayer.video.controls 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import br.com.silveiracamilo.mediaplayer.IMediaPlayer;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class PlayControl extends ButtonControl
	{
		public function PlayControl(button:DisplayObject, mediaPlayer:IMediaPlayer) {
			super(button, mediaPlayer);
		}
		
		override protected function mouseHandler(ev:MouseEvent):void {
			if (ev.type == MouseEvent.CLICK) {
				this.mediaPlayer.play();
			}
		}	
	}
}