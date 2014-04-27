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
					tf.text = tf.text.substr(0, (tf.text.charAt(tf.text.length - 5) != " ") ? -4 : -5) + tooltip;
				}
			}
		}
		
		public static function truncateMultilineText(textfield:TextField, maxLines:int, tooltip:String = "."):TextField
		{
			if (textfield.numLines > maxLines)
			{
				var char:int = textfield.getLineOffset(maxLines);
				char -= tooltip.length;
				char = textfield.text.substring(0, char + 1).search(/\S\s*$/);
				
				textfield.text = textfield.text.substring(0, char) + tooltip;
			}
			
			return textfield;
		}
	}
}