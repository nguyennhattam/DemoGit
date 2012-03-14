package  
{
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.animation.AnimationController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.collada.DaeInstanceController;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;
	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sun
	 */
	public class ModelLoading extends MovieClip
	{
		
		public function ModelLoading() 
		{
			
		}
		
		protected var rootContainer:Object3D = new Object3D();
		protected var camera:Camera3D;
		protected var box:Box;

		protected static const DEGREES_TO_RADIANS:Number = Math.PI / 180.0;

        [Embed(source="../bin/beast.dae", mimeType="application/octet-stream")]
        protected var BeastModel:Class;
        [Embed(source="../bin/beast.jpg")]
        protected var BeastTexture:Class;

        protected var modelContainer:DaeInstanceController;
        protected var controllers:Vector.<AnimationController>;
		
		public function Main()
		{
			initEngine();
			initScene();
		}

		protected function initEngine():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			camera = new Camera3D(0.1, 10000);
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			addChild(camera.view);
			addChild(camera.diagram);

			camera.z = -1000;
			rootContainer.addChild(camera);

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

        protected function initScene():void
        {
            modelContainer = new DaeInstanceController();
            rootContainer.addChild(modelContainer);

            var xml:XML = new XML(new BeastModel());

            var parser:ParserCollada = new ParserCollada();
            parser.parse(xml);

            parser.textureMaterials[0].texture =  new BeastTexture().bitmapData;

            for each (var child:Object3D in parser.hierarchy)
                modelContainer.addChild(child);

            modelContainer.rotationX = 90 * DEGREES_TO_RADIANS;
            modelContainer.scaleX = modelContainer.scaleY = modelContainer.scaleZ = 500;

            controllers = new Vector.<AnimationController>();

            for each (var animation:AnimationClip in parser.animations)
            {
                var controller =  new AnimationController();
                controller.root = animation;
                controllers.push(controller);
            }
        }

        protected function onEnterFrame(e:Event):void
        {
            camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;

			camera.render();
            for each (var controller:AnimationController in controllers)
                controller.update();
        }
	}

}