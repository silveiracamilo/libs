package br.com.silveiracamilo.loading {
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class GenericPreloader extends Sprite {
		
		public var dispatcher:EventDispatcher;
		
		public var bytesLoaded:Number;
		public var bytesTotal:Number;
		public var ratio:Number;
		public var pct:Number;
		
		public function GenericPreloader(dispatcher:EventDispatcher=null) {
			this.dispatcher = dispatcher;
		}
		
		public function beginPrealoder():void {
			this.reset();
			this.addListeners();
		}
		
		protected function reset():void {
			this.bytesLoaded = 0;
			this.bytesTotal = 0;
			this.ratio = 0;
			this.pct = 0;
		}
		
		protected function addListeners():void {
			this.dispatcher.addEventListener(Event.OPEN, openHandler, false, 0, true);
			this.dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			this.dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			this.dispatcher.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
			this.dispatcher.addEventListener(ErrorEvent.ERROR, errorHandler, false, 0, true);
		}
		
		protected function removeListeners():void {			
			this.dispatcher.removeEventListener(Event.OPEN, openHandler);
			this.dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			this.dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			this.dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			this.dispatcher.removeEventListener(ErrorEvent.ERROR, errorHandler);
		}
		
		protected function openHandler(ev:Event):void {
			this.dispatchEvent(ev);
		}
		
		protected function progressHandler(ev:ProgressEvent):void {
			if (ev.bytesLoaded > this.bytesLoaded) this.bytesLoaded = ev.bytesLoaded;
			if (ev.bytesTotal > this.bytesTotal) this.bytesTotal = ev.bytesTotal;
			
			if (this.bytesLoaded == 0) {
				this.ratio = this.pct = 0;
			}
			
			if (this.bytesTotal == 0) {
				this.ratio = this.pct = 0;
			}
			
			if (this.bytesLoaded > 0 && this.bytesTotal > 0) {
				this.ratio = this.bytesLoaded / this.bytesTotal;
				this.pct = Math.floor(this.ratio * 100);
			}
			
			this.dispatchEvent(ev);
		}
		
		protected function completeHandler(ev:Event):void {
			this.removeListeners();
			
			this.ratio = 1;
			this.pct = 100;
			
			this.dispatchEvent(ev);
		}
		
		protected function errorHandler(ev:Event):void {
			this.dispatchEvent(ev);
		}		
	}
}