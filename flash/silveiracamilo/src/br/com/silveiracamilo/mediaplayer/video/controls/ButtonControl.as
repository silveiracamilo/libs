package br.com.silveiracamilo.mediaplayer.video.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import br.com.silveiracamilo.mediaplayer.IMediaPlayer;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class ButtonControl
	{
		protected var button:DisplayObject;
		protected var mediaPlayer:IMediaPlayer;
		
		public function ButtonControl(button:DisplayObject, mediaPlayer:IMediaPlayer) {
			this.button = button;
			this.mediaPlayer = mediaPlayer;
			
			this.setup();
		}
		
		protected function setup():void{
			(this.button as Sprite).buttonMode = true;
			this.button.addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
		}
		
		protected function mouseHandler(ev:MouseEvent):void {
			
		}		
	}
}