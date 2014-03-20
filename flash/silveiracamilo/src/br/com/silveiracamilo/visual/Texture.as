package br.com.silveiracamilo.visual {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Texture {
		
		public function Texture() {
			
		}		
		public static function applyTexture(width:Number, height:Number, bitmapData:BitmapData, returnSprite:Sprite=null):Sprite {
			if (!returnSprite) returnSprite = new Sprite();
			
			returnSprite.graphics.clear();
			returnSprite.graphics.beginBitmapFill(bitmapData, null, true, true);
			returnSprite.graphics.drawRect(0, 0, width, height);
			returnSprite.graphics.endFill();
			
			return returnSprite;
		}
		
		public static function applyDisplayObjectContainerTexture(displayObjectContainer:DisplayObjectContainer, texture:BitmapData, alpha:Number = 1):Sprite {
			var backgroundTexture:Sprite = Texture.applyTexture(displayObjectContainer.width, displayObjectContainer.height, texture);
			backgroundTexture.alpha = alpha;
			displayObjectContainer.addChild(backgroundTexture);
			
			return backgroundTexture;
		}
		
		public static function applyMovieClipTexture(movieclip:MovieClip, texture:BitmapData, alpha:Number = 1):Sprite {
			var backgroundTexture:Sprite = Texture.applyTexture(movieclip.width, movieclip.height, texture);
			backgroundTexture.alpha = alpha;
			movieclip.addChild(backgroundTexture);
			
			return backgroundTexture;
		}

	}
	
}
