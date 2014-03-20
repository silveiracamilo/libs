package br.com.silveiracamilo.mediaplayer.video.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import br.com.silveiracamilo.mediaplayer.IMediaPlayer;
	import br.com.silveiracamilo.mediaplayer.MediaPlayerEvent;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class BarControl
	{
		protected var bar:Object;
		protected var mediaPlayer:IMediaPlayer;		
		protected var barProgress:Object;
		protected var barLoader:Object;
		protected var thumbPosition:Object;
		protected var duration:Number;
		protected var isDraggingThumb:Boolean = false;
		protected var areaThumb:Rectangle;
		protected var thumbInitX:Number;
		protected var thumbEndX:Number;
		
		public function BarControl(bar:Object, mediaPlayer:IMediaPlayer) 
		{
			this.bar = bar;
			this.mediaPlayer = mediaPlayer;
			
			this.setup();
		}
		
		protected function setup():void{
			this.mediaPlayer.addEventListener(MediaPlayerEvent.DURATION, mediaPlayerHandler, false, 0, true);
			this.mediaPlayer.addEventListener(MediaPlayerEvent.LOAD_PROGRESS, mediaPlayerHandler, false, 0, true);
			this.mediaPlayer.addEventListener(MediaPlayerEvent.PLAYHEAD_UPDATE_PROGRESS, mediaPlayerHandler, false, 0, true);
			this.mediaPlayer.addEventListener(MediaPlayerEvent.COMPLETE, mediaPlayerHandler, false, 0, true);
			
			this.barProgress = this.bar.barProgress as DisplayObject;
			this.barLoader = this.bar.barLoader as DisplayObject;
			this.thumbPosition = this.bar.thumbPosition as Sprite;
			
			if (this.barLoader) {
				this.barLoader.addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
				this.barLoader.buttonMode = true;
			}
			
			if (this.thumbPosition) {
				this.thumbPosition.buttonMode = true;
				this.thumbPosition.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler, false, 0, true);
				if (this.thumbPosition.stage) this.thumbPosition.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
				else this.thumbPosition.addEventListener(Event.ADDED_TO_STAGE, stageHandler, false, 0, true);
			}
			
			if (this.barProgress) {
				this.barProgress.mouseEnabled = false;
			}
			
			this.thumbInitX = this.barLoader.x;
			this.thumbEndX = this.thumbInitX + this.barLoader.width - this.thumbPosition.width;
			
			this.areaThumb = new Rectangle(0, 0, this.thumbEndX, 0);
			
			(this.barProgress as DisplayObject).scaleX = 0;
			(this.barLoader as DisplayObject).scaleX = 0;
		}
		
		protected function updateBarProgress(pct:Number, updateDragging:Boolean = false):void { 
			if (pct < 0) pct = 0;
			else if (pct > 1) pct = 1;
			
			if (!this.isDraggingThumb || updateDragging) this.barProgress.scaleX = pct;
		}
		
		protected function updateBarLoader(pct:Number):void { 
			this.barLoader.scaleX = pct;
		}
		
		protected function updatePositionThumb(pct:Number):void { 
			if (!this.isDraggingThumb) {
				var percDist:Number = (this.thumbEndX - this.thumbInitX);
				var newX:Number = Math.round(percDist * pct);
				
				this.thumbPosition.x = newX;
			}
		}
		
		protected function getPercentageToPosition(value:Number):Number{
			return value / this.thumbEndX;
		}
		
		protected function update():void{
			var percentage:Number = this.getPercentageToPosition(this.thumbPosition.x);
			this.updateBarProgress(percentage, true);
			this.mediaPlayer.seek(percentage * duration);
		}
		
		protected function mediaPlayerHandler(ev:MediaPlayerEvent):void {
			if (ev.type == MediaPlayerEvent.DURATION) {
				this.duration = ev.duration;
			} else if (ev.type == MediaPlayerEvent.LOAD_PROGRESS) {
				this.updateBarLoader(ev.ratio);
			} else if (ev.type == MediaPlayerEvent.PLAYHEAD_UPDATE_PROGRESS) {
				this.updateBarProgress(this.mediaPlayer.getPercentage());
				this.updatePositionThumb(this.mediaPlayer.getPercentage());
			} else if (ev.type == MediaPlayerEvent.COMPLETE) {
				this.updateBarProgress(0);
				this.updatePositionThumb(0);
			}			
		}
		
		protected function mouseHandler(ev:MouseEvent):void {
			if (ev.type == MouseEvent.CLICK) {
				if (ev.currentTarget == this.barLoader) {
					this.thumbPosition.x = ev.localX;
					this.update();
				}
			} else if (ev.type == MouseEvent.MOUSE_DOWN) {
				if (ev.currentTarget == this.thumbPosition) {
					this.isDraggingThumb = true;
					this.thumbPosition.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
					this.thumbPosition.startDrag(false, this.areaThumb);
				}
			} else if (ev.type == MouseEvent.MOUSE_UP) {
				if (ev.currentTarget == this.thumbPosition.stage) {
					this.isDraggingThumb = false;
					this.thumbPosition.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					this.thumbPosition.stopDrag();
				}
			}
		}
		
		protected function mouseMoveHandler(ev:MouseEvent):void {
			this.update();
		}
		
		protected function stageHandler(ev:Event):void {
			this.thumbPosition.removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			this.thumbPosition.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
		}
	}
}