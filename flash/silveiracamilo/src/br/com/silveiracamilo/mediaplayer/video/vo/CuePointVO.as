package br.com.silveiracamilo.mediaplayer.video.vo 
{
	
	/**
	 * 
	 * @author camilo
	 */
	public class CuePointVO 
	{
		public var name:String;
		public var type:String;
		public var time:Number;
		
		public function CuePointVO(name:String, type:String, time:Number) {
			this.name = name;
			this.type = type;
			this.time = time;
		}
		
	}
	
}