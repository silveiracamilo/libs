package br.com.silveiracamilo.mediaplayer.video 
{
	import br.com.silveiracamilo.mediaplayer.IMediaPlayer;
	import br.com.silveiracamilo.mediaplayer.MediaPlayerEvent;
	import br.com.silveiracamilo.mediaplayer.video.vo.CuePointVO;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class VideoMediaPlayer extends EventDispatcher implements IMediaPlayer
	{
		public var duration:Number = 0;
		public var bytesTotal:Number = 0;
		public var bytesLoaded:Number = 0;
		public var ratio:Number = 0;
		public var bufferTime:Number = 10;
			
		public var progressLoad:Boolean = false;
		private var _autoPlay:Boolean = false;
		public var loaded:Boolean = false;
		
		protected var videoURL:String;
		protected var video:Video;		
		protected var netStream:NetStream;
		protected var objClient:Object;
		protected var _playing:Boolean = false;
		
		
		public function VideoMediaPlayer(video:Video, netStream:NetStream, videoURL:String = "") {
			this.videoURL = videoURL;
			this.netStream = netStream;
			this.setVideo(video);
		}
		
		protected function setVideo(video:Video):void {
			this.video = video;
			this.video.attachNetStream(this.netStream);
		}
		
		protected function setNetStream(netStream:NetStream):void {
			this.objClient = new Object();
			this.objClient.onMetaData = this.onMetaData;
			this.objClient.onCuePoint = this.onCuePoint;
			this.netStream.client = this.objClient;
		}
		
		public function init():void {
			this.setNetStream(this.netStream);
			this.netStream.play(this.videoURL);
			this.addEvents();
		}
		
		public function close():void { 
			if (this.video.hasEventListener(Event.ENTER_FRAME)) this.removeEventVideo();
			
			this.rewind();
			
			this.netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStreamHandler);
			
			this.loaded = false;
		}
		
		public function play():void {
			if (!this.video.hasEventListener(Event.ENTER_FRAME)) this.addEventVideo();		
			
			this.playing = true;
			
			this.netStream.resume();
		}
		
		public function pause():void {
			if(this.video.hasEventListener(Event.ENTER_FRAME)) this.removeEventVideo();
			
			this.playing = false;
			
			this.netStream.pause();
		}
		
		public function stop():void {
			if(this.video.hasEventListener(Event.ENTER_FRAME)) this.removeEventVideo();
			
			this.pause();
			this.netStream.seek(0);
		}
		
		public function seek(time:Number):void {
			this.netStream.seek(time);
		}
		
		public function rewind():void {
			if(this.video.hasEventListener(Event.ENTER_FRAME)) this.removeEventVideo();
			
			this.stop();
		}
		
		public function volume(value:Number):void {
			var sound:SoundTransform = new SoundTransform();
			sound.volume = value;
			this.netStream.soundTransform = sound;
		}
		
		public function getTimeTotalFormatted():String {
			var secs:Number = this.duration;
			var mins:Number = Math.floor(secs / 60);
			secs = Math.floor(secs % 60);
			return (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs;
		}
		
		public function getTimePositionFormatted():String {
			var secs:Number = this.netStream.time;
			var mins:Number = Math.floor(secs / 60);
			secs = Math.floor(secs % 60);
			
			return (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs;
		}
		
		public function getTime():Number {
			return this.netStream.time;
		}
		
		public function getPercentage():Number { 			
			return this.getTime() / this.duration;
		}
		
		protected function addEvents():void { 
			this.netStream.addEventListener(NetStatusEvent.NET_STATUS, netStreamHandler);
			
			this.addEventVideo();
		}
		
		protected function addEventVideo():void { 
			this.video.addEventListener(Event.ENTER_FRAME, videoHandler, false, 0, true);
		}
		
		protected function removeEventVideo():void { 
			this.video.removeEventListener(Event.ENTER_FRAME, videoHandler);
		}
		
		protected function videoHandler(e:Event):void {
			var pcto:Number = (this.netStream.time / this.duration);
			if (isNaN(pcto)) pcto = 0;
			
			this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYHEAD_UPDATE_PROGRESS, true));
			
			if (this.netStream.bytesLoaded != this.netStream.bytesTotal) {
				var pct:Number = this.netStream.bytesLoaded / this.netStream.bytesTotal;
				this.ratio = pct;
			} else if (this.netStream.bytesLoaded > 0 && this.netStream.bytesLoaded == this.netStream.bytesTotal && !this.loaded) {
				this.ratio = 1;
				this.loaded = true;
			} else return;
			
			this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.LOAD_PROGRESS, true, true, 0, this.ratio));
		}
		
		protected function netStreamHandler(e:NetStatusEvent):void {
			//trace("e.info.code: " + e.info.code);
			
			switch (e.info.code)
			{
				case "NetStream.Play.Stop":
					//this.removeEventVideo();
					this.playing = false;
					this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.COMPLETE));
					break;
				case "NetStream.Seek.Notify":
					this.addEventVideo();
					break;
				case "NetStream.Play.Failed":
					throw new Error("FLV not found!");
					break;
				case "NetStream.Buffer.Empty":
					if (!this.loaded) {
						this.playing = false;
						this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BUFFERING_STATE_ENTERED));
					}
					break;
				case "NetStream.Play.Start":
				case "NetStream.Buffer.Full":
				case "NetStream.Buffer.Flush":
					//this.playing = true;
					this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYING_STATE_ENTERED));
					break;
			}
		}
		protected function onMetaData(info:Object):void {
			this.duration = info.duration;
			
			if (!this.autoPlay) {
				this.autoPlay = true;
				this.stop();
			} 
			
			this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.DURATION, true, true, this.duration));
		}
		protected function onCuePoint(info:Object):void {
			var cuePointVO:CuePointVO = new CuePointVO(info.name, info.type, info.time);
			
			this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.CUE_POINT, true, true, 0, 0, cuePointVO));
		}		
		
		public function get playing():Boolean {
			return this._playing;
		}
		
		public function set playing(value:Boolean):void{
			this._playing = value;
		}
		
		public function get autoPlay():Boolean {
			return this._autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void{
			this._autoPlay = value;
		}
	}
}