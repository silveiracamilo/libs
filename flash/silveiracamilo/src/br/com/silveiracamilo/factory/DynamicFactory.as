package br.com.silveiracamilo.factory 
{
	import flash.utils.getDefinitionByName;
	
	public class DynamicFactory
	{
		
		public function DynamicFactory() {
			throw new Error("This method can't be executed.");
		}
		
		public static function getClass(className:String):Class {
			return getDefinitionByName(className) as Class;
		}

		public static function create(className:String):Object {
			
			var klass:Class = getClass(className);
			if (!klass) throw new Error("Invalid parameter.");
			
			return new klass();
		}
			

	}

}