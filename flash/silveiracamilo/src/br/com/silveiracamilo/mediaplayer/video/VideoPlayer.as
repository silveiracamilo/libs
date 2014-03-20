package br.com.silveiracamilo.mediaplayer.video 
{
	import br.com.silveiracamilo.mediaplayer.IMediaPlayer;
	import br.com.silveiracamilo.mediaplayer.MediaPlayerEvent;
	import br.com.silveiracamilo.mediaplayer.video.controls.vo.ControlVO;
	import flash.display.DisplayObject;
	import flash.media.Video;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class VideoPlayer
	{
		public var autoPlay:Boolean = false;
		protected var mediaPlayer:IMediaPlayer;
		protected var iconBuffer:DisplayObject;
		protected var controls:Array = [];
		
		public function VideoPlayer(video:Video, netStream:NetStream, videoURL:String = "") {
			this.mediaPlayer = new VideoMediaPlayer(video, netStream, videoURL);
			
			//this.addControls([new ControlVO(this.iPlay, PlayControl),
							  //new ControlVO(this.iPause, PauseControl),
							  //new ControlVO(this.iStop, StopControl),]
		}
		
		public function init():void { 
			this.mediaPlayer.addEventListener(MediaPlayerEvent.BUFFERING_STATE_ENTERED, mediaPlayerHandler, false, 0, true);
			this.mediaPlayer.addEventListener(MediaPlayerEvent.PLAYING_STATE_ENTERED, mediaPlayerHandler, false, 0, true);
			this.mediaPlayer.addEventListener(MediaPlayerEvent.COMPLETE, mediaPlayerHandler, false, 0, true);			
			
			this.mediaPlayer.autoPlay = this.autoPlay;
			this.mediaPlayer.init();
		}
		
		public function close():void { 
			this.mediaPlayer.removeEventListener(MediaPlayerEvent.BUFFERING_STATE_ENTERED, mediaPlayerHandler);
			this.mediaPlayer.removeEventListener(MediaPlayerEvent.PLAYING_STATE_ENTERED, mediaPlayerHandler);
			this.mediaPlayer.removeEventListener(MediaPlayerEvent.COMPLETE, mediaPlayerHandler);
			
			this.mediaPlayer.close();
		}
		
		public function addControls(controls:Array):void { 
			controls.forEach(function(controlVO:ControlVO, i:int, a:Array):void {
				var control:DisplayObject = controlVO.control;
				this.controls.push(new controlVO.classControl(control, this.mediaPlayer));
			}, this);
		}
		
		public function addIconBuffer(icon:DisplayObject):void { 
			this.iconBuffer = icon;
		}
		
		protected function mediaPlayerHandler(ev:MediaPlayerEvent):void {
			if (ev.type == MediaPlayerEvent.BUFFERING_STATE_ENTERED) {
				if (this.iconBuffer) {
					this.iconBuffer.visible = true;
				}
			} else if (ev.type == MediaPlayerEvent.PLAYING_STATE_ENTERED) {
				if (this.iconBuffer) {
					this.iconBuffer.visible = false;
				}
			} else if (ev.type == MediaPlayerEvent.COMPLETE) {
				this.mediaPlayer.rewind();
			}
		}
	}
}