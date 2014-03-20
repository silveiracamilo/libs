package br.com.silveiracamilo.animation.marquee {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author camilo
	 */
	public class Marquee extends Sprite {
		
		public static const ORIENTATION_HORIZONTAL:String = "ORIENTATION_HORIZONTAL";
		public static const ORIENTATION_VERTICAL:String = "ORIENTATION_VERTICAL";
		
		public var speed:Number;
		public var pauseTime:Number;
		
		protected var content:DisplayObject;
		protected var maskDisplay:DisplayObject;
		protected var contentMask:Sprite;
		protected var maskRect:Rectangle;
		protected var orientation:String;
		protected var inheritPosition:Boolean;
		protected var endPosition:Number;
		protected var idTimeout:uint;
		
		public function Marquee(content:DisplayObject, speed:Number = 500, pauseTime:Number = 1000, orientation:String = ORIENTATION_HORIZONTAL, inheritPosition:Boolean = true) { 
			this.content = content;
			this.speed = speed;
			this.pauseTime = pauseTime;
			this.orientation = orientation;
			this.inheritPosition = inheritPosition;
			
			super();
			
			this.construct();
		}
		
		protected function construct():void {			
			this.contentMask = new Sprite();
			
			if (this.inheritPosition) {
				this.x = this.content.x;
				this.y = this.content.y;
				
				this.content.x = 0;
				this.content.y = 0;
			}
			
			this.addChild(this.contentMask);
			this.addContent();
		}
		
		protected function addContent():void{
			this.addChild(this.content);
		}
		
		/*
			@ set Rectangle, create mask
		*/
		public function setMaskRect(rect:Rectangle):void { 
			this.maskRect = rect;
			
			this.createMaskToRect();
		}
		
		public function setMaskDisplay(mask:DisplayObject):void { 
			this.maskDisplay = maskDisplay;
			
			this.contentMaskRemoveChild();
			
			maskDisplay.cacheAsBitmap = true;
			this.content.cacheAsBitmap = true;
			
			this.contentMask.addChild(maskDisplay);
		}
		
		protected function createMaskToRect():void{
			var mask:Sprite = new Sprite();
			
			mask.graphics.beginFill(0x000000, 0);
			mask.graphics.drawRect(this.maskRect.x, this.maskRect.y, this.maskRect.width, this.maskRect.height);
			mask.graphics.endFill();
			
			this.contentMaskRemoveChild();
			
			this.contentMask.addChild(mask);
		}
		
		protected function contentMaskRemoveChild():void{
			if (this.contentMask.numChildren > 0) {
				this.contentMask.removeChild(this.contentMask.getChildAt(0));
			}
		}
		
		public function init():void {
			if (!this.maskRect && !this.maskDisplay) {
				throw new Error("not mask, setMaskRect(rect:Rectangle) or setMaskDisplay(mask:DisplayObject)");
			}
			
			if (this.createMarquee()) {
				
				this.content.mask = this.contentMask;
				this.content.x = this.content.y = 0;
				this.update();
				this.addLoop();
				
			} else {
				trace("content less than the mask!");
			}
		}
		
		public function update():void { 
			
			if (this.orientation == ORIENTATION_HORIZONTAL) {
				this.endPosition = Math.round((this.contentMask.x +  this.contentMask.width) - this.content.width);
			} else if (this.orientation == ORIENTATION_VERTICAL) { 
				this.endPosition = Math.round((this.contentMask.y +  this.contentMask.height) - this.content.height);
			}			
		}
		
		public function pause():void {
			this.removeLoop();
		}
		
		public function unpause():void {
			this.addLoop();
		}
		
		public function goToTheBeginning():void { 
			if (this.orientation == ORIENTATION_HORIZONTAL) {
				this.content.x = this.contentMask.x;
			} else if (this.orientation == ORIENTATION_VERTICAL) {
				this.content.y = this.contentMask.y;
			}
		}
		
		protected function createMarquee():Boolean {
			
			if (this.orientation == ORIENTATION_HORIZONTAL) {
				if (this.content.width > this.contentMask.width) return true;				
			} else if (this.orientation == ORIENTATION_VERTICAL) {
				if (this.content.height > this.contentMask.height) return true;
			}
			
			return false;
		}
		
		protected function addLoop():void { 
			this.content.addEventListener(Event.ENTER_FRAME, loopHandler, false, 0, true);
		}
		
		public function close():void {
			
			this.removeLoop();			
			
			clearTimeout(this.idTimeout);
		}
		
		protected function removeLoop():void {
			clearTimeout(this.idTimeout);
			this.content.removeEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		public function finalize():void {
			super.finalize();
		}
		
		protected function reset():void{
			
			this.goToTheBeginning();
			
			this.idTimeout = setTimeout(this.start, this.pauseTime);
		}
		
		protected function start():void{
			this.addLoop();
		}
		
		protected function loopHandler(ev:Event):void {
			
			if (this.orientation == ORIENTATION_HORIZONTAL) {
				
				if (Math.round(this.content.x + 5) >= this.endPosition) {
					this.content.x += this.endPosition / this.speed;
				} else {
					this.removeLoop();
					this.idTimeout = setTimeout(this.reset, this.pauseTime);
				}
				
			} else if (this.orientation == ORIENTATION_VERTICAL) {
				
				if (Math.round(this.content.y + 5) >= this.endPosition) {
					this.content.y += this.endPosition / this.speed;
				} else {
					this.removeLoop();
					this.idTimeout = setTimeout(this.reset, this.pauseTime);
				}			
			}			
		}
	}	
}