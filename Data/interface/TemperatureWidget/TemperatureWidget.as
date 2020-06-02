package {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import hudframework.IHUDWidget;
	
	public class TemperatureWidget extends MovieClip implements IHUDWidget{
		// HUDFramework Config
		private static const WIDGET_IDENTIFIER:String = "TemperatureWidget.swf";
		
		public var isWet:Boolean;
		public var isHeating:Boolean;
		
		// Command IDs
		private static const Command_UpdateTemp:int = 100;
		private static const Command_UpdateWetness:int = 200;
		private static const Command_UpdateHeat:int = 300;
		
		// Hello World Textfield
		public var AmbientTemp_tf:TextField;
		public var CoreTemp_tf:TextField;
		public var WindSpeed_tf:TextField;
		public var WetnessFader_MC:MovieClip;
		public var HeatSource_MC:MovieClip;
		
		public function TemperatureWidget() {
			// constructor code
		}
		
		public function processMessage(command:String, params:Array):void {
			switch(command) {
				case String(Command_UpdateTemp):
					AmbientTemp_tf.text = String(Number(params[0]).toFixed(2));
					WindSpeed_tf.text = String(Number(params[1]).toFixed(2));
					CoreTemp_tf.text = String(Number(params[2]).toFixed(2));
					trace("============== Core Stats ==============");
					trace("AmbTemp: " + params[0]);
					trace("WindSpeed: " + params[1]);
					trace("CoreTemp: " + params[2]);
					break;
				case String(Command_UpdateWetness):
					trace("============== Wetness ==============");
					//WetnessFader_MC.Wetness.Fill.gotoAndStop(params[0]);
					if ((Number(params[0]) <= 100.0 && Number(params[0]) >= 1.0) && isWet == true)
					{	//Wetness Fill to Value
						WetnessFader_MC.Wetness.gotoAndStop(Number(params[0]));
					}
					else if (Number(params[0]) >= 1.0 && isWet == false)
					{	//Wetness Fade In
						WetnessFader_MC.gotoAndPlay(2);
						isWet = true
					}
					else if (Number(params[0]) == 0.0 && isWet == true)
					{	//Wetness Fade Out
						WetnessFader_MC.gotoAndPlay(16);
						isWet = false
					}
					
					trace(params[0] + " | " + isWet);
					break;
				case String(Command_UpdateHeat):
					trace("================ Heat ================");
					if (isHeating == true && Number(params[0]) == 1.0)
					{
						HeatSource_MC.HeatSource.play()
					}
					else if(isHeating == false && Number(params[0]) == 1.0)
					{
						HeatSource_MC.gotoAndPlay(2)
						isHeating = true
					}
					else if(isHeating == true && Number(params[0]) == 0.0)
					{
						HeatSource_MC.HeatSource.stop()
						HeatSource_MC.gotoAndPlay(16)
						isHeating = false
					}
					trace("isHeating: " + params[0]);
					break;
					
			}
		}
	}
	
}
	