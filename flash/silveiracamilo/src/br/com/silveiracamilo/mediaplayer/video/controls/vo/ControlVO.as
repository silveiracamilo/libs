package br.com.silveiracamilo.mediaplayer.video.controls.vo 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Camilo da Silveira
	 */
	public class ControlVO
	{
		public var control:DisplayObject;
		public var classControl:Class;
		
		public function ControlVO(control:DisplayObject, classControl:Class) {
			this.control = control;
			this.classControl = classControl;
		}
		
	}

}