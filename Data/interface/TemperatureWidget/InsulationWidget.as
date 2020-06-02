package {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import hudframework.IHUDWidget;
	
	public class InsulationWidget extends MovieClip implements IHUDWidget{
		// HUDFramework Config
		private static const WIDGET_IDENTIFIER:String = "InsulationWidget.swf";
		
		// Command IDs
		private static const Command_UpdateInsulation1:int = 100;
		private static const Command_UpdateInsulation2:int = 150;
		private static const Command_UpdateShow:int = 200;
		private static const Command_UpdateNames1:int = 300;
		private static const Command_UpdateNames2:int = 400;
		private static const Command_UpdateNames3:int = 500;
		private static const Command_UpdateNames4:int = 600;
		private static const Command_UpdateNames5:int = 700;
		private static const Command_UpdateNames6:int = 800;
		private static const Command_UpdateNames7:int = 900;
		
		public var isShowing:Boolean;
		
		// Hello World Textfield
		public var Head_tf:TextField;
		public var HeadVal_tf:TextField;
		public var LeftArm_tf:TextField;
		public var LeftArmVal_tf:TextField;
		public var LeftLeg_tf:TextField;
		public var LeftLegVal_tf:TextField;
		public var RightArm_tf:TextField;
		public var RightArmVal_tf:TextField;
		public var RightLeg_tf:TextField;
		public var RightLegVal_tf:TextField;
		public var Chest_tf:TextField;
		public var ChestVal_tf:TextField;
		public var Body_tf:TextField;
		public var BodyVal_tf:TextField;
		public var OtherVal_tf:TextField;
		public var Total_tf:TextField;
		public var Insulation_MC:MovieClip;
		public var All_MC:MovieClip;
		public var All_Inner_MC:MovieClip;
		
		public function InsulationWidget() {
			// constructor code
			isShowing = false;
			All_MC.All_Inner_MC.HeadVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.LeftArmVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.LeftLegVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.RightArmVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.RightLegVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.ChestVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.BodyVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.OtherVal_tf.text = String(Number(0));
			All_MC.All_Inner_MC.Total_tf.text = String(Number(0));
			All_MC.All_Inner_MC.Insulation_MC.Insulation.gotoAndStop(Number(2));
		}
		
		public function processMessage(command:String, params:Array):void {
			switch(command) {
				case String(Command_UpdateInsulation1):
					All_MC.All_Inner_MC.HeadVal_tf.text = String(Number(params[0]).toFixed(0));
					All_MC.All_Inner_MC.LeftArmVal_tf.text = String(Number(params[1]).toFixed(0));
					All_MC.All_Inner_MC.LeftLegVal_tf.text = String(Number(params[2]).toFixed(0));
					All_MC.All_Inner_MC.RightArmVal_tf.text = String(Number(params[3]).toFixed(0));
					All_MC.All_Inner_MC.RightLegVal_tf.text = String(Number(params[4]).toFixed(0));
					trace("============== Insulation Stats ==============");
					trace("Head: " + params[0]);
					trace("LeftArm: " + params[1]);
					trace("LeftLeg: " + params[2]);
					trace("RightArm: " + params[3]);
					trace("RightLeg: " + params[4]);
					break;
				case String(Command_UpdateInsulation2):
					All_MC.All_Inner_MC.ChestVal_tf.text = String(Number(params[0]).toFixed(0));
					All_MC.All_Inner_MC.BodyVal_tf.text = String(Number(params[1]).toFixed(0));
					All_MC.All_Inner_MC.OtherVal_tf.text = String(Number(params[2]).toFixed(0));
					All_MC.All_Inner_MC.Total_tf.text = String(Number(params[3]).toFixed(0));
					All_MC.All_Inner_MC.Insulation_MC.Insulation.gotoAndStop(Number(params[4]));
					trace("Chest: " + params[0]);
					trace("Body: " + params[1]);
					trace("Other: " + params[2]);
					trace("Total: " + params[3]);
					break;
				case String(Command_UpdateShow):
					if(isShowing == true && Number(params[0]) == 0.0)
					{
						All_MC.gotoAndStop(2);
						isShowing = false;
					}
					else if(isShowing == false && Number(params[0]) == 1.0)
					{
						All_MC.gotoAndStop(1);
						isShowing = true;
					}
					break;
				case String(Command_UpdateNames1):
					All_MC.All_Inner_MC.Head_tf.text = String(params[0]);
					break;
				case String(Command_UpdateNames2):
					All_MC.All_Inner_MC.LeftArm_tf.text = String(params[0]);
					break;
				case String(Command_UpdateNames3):
					All_MC.All_Inner_MC.LeftLeg_tf.text = String(params[0]);
					break;
				case String(Command_UpdateNames4):
					All_MC.All_Inner_MC.RightArm_tf.text = String(params[0]);
					break;
				case String(Command_UpdateNames5):
					All_MC.All_Inner_MC.RightLeg_tf.text = String(params[0]);
					break;
				case String(Command_UpdateNames6):
					All_MC.All_Inner_MC.Chest_tf.text = String(params[0]);
					break;
				case String(Command_UpdateNames7):
					All_MC.All_Inner_MC.Body_tf.text = String(params[0]);
					break;
			}
		}
	}
	
}
	