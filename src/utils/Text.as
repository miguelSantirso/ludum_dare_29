package utils 
{
	import flash.text.TextField;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Text 
	{
		public static function truncateText(tf:TextField, tooltip:String = "."):void
		{
			var margin:Number = 4; // Flash adds this to all textfields;
			
			if(tf.textWidth > tf.width - margin)
			{
				while(tf.textWidth > tf.width - margin)
				{
					tf.text = tf.text.substr(0, (tf.text.charAt(tf.text.length - 10) != " ") ? -9 : -10) + tooltip;
				}
			}
		}
	}

}