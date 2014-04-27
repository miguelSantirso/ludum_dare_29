package utils 
{
	import spark.formatters.NumberFormatter;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Text 
	{
		private static var fmt:NumberFormatter = new NumberFormatter();
		
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
		
		public static function setAndtruncateFormattedNumber(tf:TextField, value:Number, maxValue:Number, thousandSeparator:Boolean = true, prefixOrSuffix:Boolean = false):void
		{	
			fmt.useGrouping = thousandSeparator;
			fmt.fractionalDigits = 0;
			fmt.groupingPattern = "3;*";
			fmt.groupingSeparator = ",";
			
			if(value <= maxValue) tf.text = fmt.format(value);
			//else tf.text = prefixOrSuffix ? "+" + fmt.format(maxValue) : fmt.format(maxValue) + "+";
		}
	}

}