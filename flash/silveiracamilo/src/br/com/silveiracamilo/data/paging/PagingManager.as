package br.com.silveiracamilo.data.paging {
	import flash.events.EventDispatcher;
	
	public class PagingManager extends EventDispatcher {
		
		protected var collection:Array;
		
		protected var _pageSize:int;
		public function get pageSize():int {
			return this._pageSize;
		}
		public function set pageSize(value:int):void {
			this._pageSize = value;
		}
		
		public function get pageIndex():int {
			return int(this._index / this._pageSize);
		}
		
		public function get totalPages():int {
			return Math.ceil(this.collection.length / this._pageSize);
		}
		
		protected var _index:int;
		public function get index():int {
			return this._index;
		}
		
		public function PagingManager(collection:Array, pageSize:int) {
			this.collection = collection;
			this.pageSize = pageSize;
			
			this.init();
		}
		
		protected function init():void {
			this._index = 0;
		}
		
		public function previous():Array {
			this._index = Math.max(0, this._index - this._pageSize);
			
			this.dispatchEvent(new PagingEvent(PagingEvent.PREVIOUS));
			
			return this.getCurrentPage();
		}
		
		public function next():Array {
			if (this._index + this._pageSize >= this.collection.length) {
				this.dispatchEvent(new PagingEvent(PagingEvent.NO_MORE_ELEMENTS));
			}
			else {
				this._index += this._pageSize;
				this.dispatchEvent(new PagingEvent(PagingEvent.NEXT));
			}
			
			return this.getCurrentPage();
		}
		
		public function getCurrentPage():Array {
			return this.collection.slice(this._index, this._index + this._pageSize);
		}
		
		public function getPage(page:int):Array {
			if (page < 0) return [];
			
			var index:int = page * this._pageSize;
			if (index <this.collection.length)
				return this.collection.slice(index, index + this._pageSize);
			
			return [];
		}
		
		public function isFirstPage():Boolean {
			return this._index == 0;
		}
		
		public function isLastPage():Boolean {
			return this._index + this._pageSize >= this.collection.length;
		}
		
	}
	
}