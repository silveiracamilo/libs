package br.com.silveiracamilo.data.paging {
	import flash.events.Event;

	public class PagingEvent extends Event {
		
		public static const PREVIOUS:String = "utils.PagingEvent.PREVIOUS";
		public static const NEXT:String = "utils.PagingEvent.NEXT";
		public static const NO_MORE_ELEMENTS:String = "utils.PagingEvent.NO_MORE_ELEMENTS";
		
		public function PagingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
	
}