package br.com.silveiracamilo.sound 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author camilo
	 */
	public class SoundMediator extends EventDispatcher
	{
		public var autoPlay:Boolean = true;
		public var ratioProgress:Number = 0;
		public var playing:Boolean = false;
		public var positionPaused:Number = 0;
		
		protected var channel:SoundChannel;
		protected var sound:Sound;
		protected var addedListeners:Boolean = false;
		protected var volume:Number = 1;
		
		public function SoundMediator() {}
		
		public function load(url:String):void
		{
			if (this.addedListeners && this.sound && this.channel) 
			{
				this.removeListerners();
				this.clear();				
			}
			
			try
			{	
				this.sound = new Sound();
				this.channel = new SoundChannel();
				this.sound.load(new URLRequest(url));
				if (this.autoPlay) this.play();
				if (!this.addedListeners) this.addListerners();
				this.setVolume(volume);
			}
			catch (e:Error)
			{
				//Logger.error("ERROR SoundMediator.load(): " + e.message);
			}
		}
		
		public function play():void 
		{
			this.playing = true;
			this.removeListenersChannel();
			this.channel = this.sound.play(this.positionPaused);
			this.addListenersChannel();
			this.setVolume(this.volume);
		}
		
		public function pause():void 
		{
			this.playing = false;
			this.positionPaused = this.channel.position;
			this.channel.stop();
		}
		
		public function seek(position:Number):void 
		{ 
			this.pause();
			this.positionPaused = position;
			this.play();
		}
		
		public function getSound():Sound
		{ 
			return this.sound;
		}
		
		public function getSoundChannel():SoundChannel
		{
			return this.channel;
		}
		
		public function getLength():Number 
		{ 
			return this.sound.length;
		}
		
		public function getPercent():Number
		{
			return this.channel.position / this.sound.length;
		}
		
		public function getTimeFormatted():String
		{
			var secs:Number = this.channel.position / 1000;
			var mins:Number = Math.floor(secs / 60);
			secs = Math.floor(secs % 60);
			return mins + ":" + (secs < 10 ? "0" : "") + secs;
		}
		
		public function getTimeTotalFormatted():String 
		{
			var secs:Number = this.sound.length / 1000;
			var mins:Number = Math.floor(secs / 60);
			secs = Math.floor(secs % 60);
			return mins + ":" + (secs < 10 ? "0" : "") + secs;
		}
		
		public function setVolume(value:Number):void 
		{
			this.volume = value;
			
			var soundTransform:SoundTransform = this.channel.soundTransform;
			soundTransform.volume = value;
			this.channel.soundTransform = soundTransform;
		}
		
		public function close():void
		{ 
			this.removeListerners();
			this.clear();
		}
		
		protected function clear():void
		{
			this.channel.stop();
			
			this.sound = null;
			this.channel = null;
			this.positionPaused = 0;
		}
		
		protected function addListerners():void
		{
			this.addedListeners = true;
			
			this.sound.addEventListener(Event.ID3, soundHandler, false, 0, true);
			this.sound.addEventListener(ProgressEvent.PROGRESS, soundHandler, false, 0, true);
			this.addListenersChannel();
		}
		
		protected function addListenersChannel():void
		{
			this.channel.addEventListener(Event.SOUND_COMPLETE, channelHandler, false, 0, true);
		}
		
		protected function removeListerners():void
		{
			this.addedListeners = false;
			
			this.sound.removeEventListener(Event.ID3, soundHandler);
			this.sound.removeEventListener(ProgressEvent.PROGRESS, soundHandler);
			this.removeListenersChannel();
		}
		
		protected function removeListenersChannel():void
		{
			this.channel.removeEventListener(Event.SOUND_COMPLETE, channelHandler);
		}
		
		protected function channelHandler(e:Event):void 
		{
			if (e.type == Event.SOUND_COMPLETE)
			{
				if (this.addedListeners) this.removeListerners();
				
				this.positionPaused = 0;
			}
			
			this.dispatchEvent(e);
		}
		
		protected function soundHandler(e:Event):void
		{
			if (e.type == ProgressEvent.PROGRESS)
			{
				var p:ProgressEvent = ProgressEvent(e);
				this.ratioProgress = p.bytesLoaded / p.bytesTotal;
			}
			else if (e.type == Event.ID3)
			{
				/*Logger.info(StringUtils.join("Event.ID3"));
				for (var propName:String in this.sound.id3) 
				{
					Logger.info(StringUtils.join(propName , " = " , this.sound.id3[propName] , "\n"));
				}*/
			}
			
			this.dispatchEvent(e);
		}
	}
	
}