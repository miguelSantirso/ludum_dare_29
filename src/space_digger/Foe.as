package space_digger 
{
	import citrus.objects.platformer.box2d.Enemy;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Foe extends Enemy 
	{
		public var justHurt:Signal = new Signal();
		
		public function Foe(name:String, params:Object=null) 
		{
			super(name, params);
			
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			justHurt.removeAll();
		}
		
		override public function  hurt():void {

			super.hurt();
			
			justHurt.dispatch();
		}
		
		override public function update(timeDelta:Number):void {

			super.update(timeDelta);

			if (this._hurt)
			{
				this.body.SetActive(false);
			}
		}
	}

}