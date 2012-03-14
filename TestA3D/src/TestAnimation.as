package  
{
			//imports////////////////////////////////////////////////////////////////////////////////////////////////////////////
import alternativa.engine3d.controllers.SimpleObjectController;
import alternativa.engine3d.core.Camera3D;
import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.core.Renderer;
import alternativa.engine3d.core.Resource;
import alternativa.engine3d.core.View;
import alternativa.engine3d.loaders.ParserCollada;
import alternativa.engine3d.loaders.ParserMaterial;
import alternativa.engine3d.loaders.TexturesLoader;
import alternativa.engine3d.resources.ExternalTextureResource;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.objects.Mesh;
import alternativa.engine3d.objects.Skin;
import alternativa.engine3d.objects.Joint;
import alternativa.engine3d.objects.Surface;
import alternativa.engine3d.resources.Geometry;
import alternativa.engine3d.resources.TextureResource;
import alternativa.engine3d.lights.*;
import alternativa.engine3d.materials.*;
import flash.display.Stage3D;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Vector3D;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
//import alternativa.engine3d.materials.VertexLightTextureMaterial
import alternativa.engine3d.resources.BitmapTextureResource;
import alternativa.engine3d.animation.AnimationClip;
import alternativa.engine3d.animation.AnimationController;
import alternativa.engine3d.animation.AnimationSwitcher;
import alternativa.engine3d.collisions.EllipsoidCollider;
import alternativa.engine3d.primitives.Box;
import alternativa.engine3d.primitives.GeoSphere;
import alternativa.engine3d.materials.FillMaterial;
	/**
	 * ...
	 * @author Sun
	 */
	public class TestAnimation 
	{
		
		public function TestAnimation() 
		{
			//camera///////////////////////////////////////////////////////////////////////////////////////////////////////////
				var scene:Object3D = new Object3D();
				var cont1 :Object3D = new Object3D()
				var cont2 :Object3D = new Object3D()
				scene.addChild(cont1)
				cont1.z =80
				cont1.addChild(cont2)
				 
				var global:Object3D = new Object3D();
				scene.addChild(global)
				 
				var camera:Camera3D = new Camera3D(1, 20000);
				camera.view = new View(1000, 600);
				addChild(camera.view);
				camera.rotationX = Math.PI*3/2;
				camera.y = -550
				camera.fov = Math.PI*1/3
				cont2.addChild(camera);
				camera.view.hideLogo();
				//addChild(camera.diagram);
				 
				//lights///////////////////////////////////////////////////
				var light1:OmniLight = new OmniLight(0xcccccc, 40000, 1000000);
				light1.z = 30000
				light1.y = 50000
				light1.x = -50000
				scene.addChild(light1);
				 
				var light2:OmniLight = new OmniLight(0xcccccc, 40000, 1000000);
				light2.z = 30000
				light2.y = 50000
				light2.x = 50000
				scene.addChild(light2);
				 
				var light3:OmniLight = new OmniLight(0xffffff, 40000, 1000000);
				light3.z = 30000
				light3.y = -50000
				light3.x = -50000
				scene.addChild(light3);
				 
				//btns
				var btn:butoane = new butoane()
				addChild(btn)
				btn.y = 400
				 
				//perdeaua
				var perdea:loadmc = new loadmc()
				var countdown:Number = new Number(600)
				var removeul:Number = new Number(0)
				addChild(perdea)
				perdea.barul.width = 0
				 
				//podeaua/////////////////////////////////////////////////////////////////////////////
				var meshPodeaua:Mesh
				 
				var loaderPodeaua:URLLoader = new URLLoader();
				loaderPodeaua.dataFormat = URLLoaderDataFormat.TEXT;
				loaderPodeaua.load(new URLRequest("base.DAE"));
				loaderPodeaua.addEventListener(Event.COMPLETE, onPodeauaLoad);
				 
				//actor///////////////////////////////////////////////////////////
				var meshActor1:Skin
				 
				var loaderActor1:URLLoader = new URLLoader();
				loaderActor1.dataFormat = URLLoaderDataFormat.TEXT;
				loaderActor1.load(new flash.net.URLRequest("spider.DAE"));
				loaderActor1.addEventListener(Event.COMPLETE, onActor1Load);
				
				//listeners////////////////////////////////////////////////////////////////////////////////////////////
				stage.addEventListener(MouseEvent.MOUSE_DOWN, incepi);
				stage.addEventListener(MouseEvent.MOUSE_UP, ridica)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyPressedUp); 
				
				//directionarea///////////////////////////////////////////////////////////////////////////////
				var directiaDeDeplasare:Vector3D = new Vector3D();
				var collider:EllipsoidCollider = new EllipsoidCollider(30, 30, 60);
				 
				addEventListener(Event.ENTER_FRAME, directionarea);
				
				//
				//rendering/////////////////////////////////////////////////////////////////////////
				var stage3D:Stage3D = stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
				stage3D.requestContext3D();
		}
 

		function onPodeauaLoad(event:Event):void {
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML(loaderPodeaua.data));
			meshPodeaua = parser.getObjectByName("level") as Mesh;
			global.addChild(meshPodeaua);
			for each (var resource:Resource in meshPodeaua.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
			var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
			for (var i:int = 0; i < meshPodeaua.numSurfaces; i++) {
				var surface:Surface = meshPodeaua.getSurface(i);
				var material:ParserMaterial = surface.material as ParserMaterial;
				var filling:ExternalTextureResource = material.textures["diffuse"];
				if (filling != null) {
					textures.push(filling);
					surface.material = new VertexLightTextureMaterial(filling, null);
				}
			}
			var texturesLoader:TexturesLoader = new TexturesLoader(stage3D.context3D);
			texturesLoader.loadResources(textures);
		}
		 
		
		 
		function onActor1Load(event:Event):void {
			var animationController1:AnimationController =  new AnimationController();
			var animationClip1:AnimationClip
			var animationSwitcher1:AnimationSwitcher = new AnimationSwitcher();
		 
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML(loaderActor1.data));
		 
			meshActor1 = parser.getObjectByName("spider") as Skin;
			scene.addChild(meshActor1);
			meshActor1.rotationZ =  Math.PI
			meshActor1.scaleX = 0.4
			meshActor1.scaleY = 0.4
			meshActor1.scaleZ = 0.4
		 
			for each (var resource1:Resource in meshActor1.getResources(true)) {
				resource1.upload(stage3D.context3D);
			}
		 
			var textures1:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
			for (var j:int = 0; j < meshActor1.numSurfaces; j++) {
				var surface1:Surface = meshActor1.getSurface(j);
				var material1:ParserMaterial = surface1.material as ParserMaterial;
				var filling1:ExternalTextureResource = material1.textures["diffuse"];
				if (filling1 != null) {
					textures1.push(filling1);
					surface1.material = new VertexLightTextureMaterial(filling1,null)
				}
			}
			var texturesLoader1:TexturesLoader = new TexturesLoader(stage3D.context3D);
			texturesLoader1.loadResources(textures1);
		 
			//actor base animation///////////////////////////////////////////////////////////////////////////////////////////////
			animationClip1 = parser.getAnimationByObject(meshActor1);
			animationController1.root = animationSwitcher1;
		 
			var danseaza1:AnimationClip;
			danseaza1 = animationClip1.slice(66/30, 100/30);
			animationSwitcher1.addAnimation(danseaza1);
			animationSwitcher1.activate(danseaza1,0.3);
			animationSwitcher1.speed = 0.6;
		 
			///////clones
			for (var i:Number=1; i<6;i++){
				for (var k:Number=1; k<6;k++){
					var actor1Clone:Object3D=meshActor1.clone();
					scene.addChild(actor1Clone);
					actor1Clone.x = 400*i
					actor1Clone.y = 400*k
		 
					actor1Clone.scaleX = 0.4
					actor1Clone.scaleY = 0.4
					actor1Clone.scaleZ = 0.4
		 
					//////clones animations
					var danseazach:AnimationClip=danseaza1.clone();
					danseazach.attach(actor1Clone,true);
		 
					animationSwitcher1.addAnimation(danseazach);
					animationSwitcher1.activate(danseazach,(Math.floor(Math.random())+2));
					animationSwitcher1.speed = 0.6;
				}
			}
		 
			addEventListener(Event.ENTER_FRAME, comportament);
			function comportament(event:Event):void {
				animationController1.update();
			}
		}
		 
		
		 
		//keys//////////////////////////////////////////////////////////////////////////////////////////////////
		var k:Number = new Number()
		var m:Number = new Number()
		var pdaX:Number = new Number(0)
		var pdaY:Number = new Number(0)
		 
		var speed:Number = new Number(0);
		var speedL:Number = new Number(0);
		var marja:Number = new Number(0);
		var dir:Number = new Number(0)
		var tst:Number = new Number(0)
		 
		function keyPressedDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 87) {speed = 4}
			if (evt.keyCode == 83) {speed = -4}
			if (evt.keyCode == 68) {speedL = 2}
			if (evt.keyCode == 65) {speedL = -2}
		}
		 
		function keyPressedUp(evt:KeyboardEvent):void {
			if (evt.keyCode == 87) {speed = 0}
			if (evt.keyCode == 83) {speed = 0}
			if (evt.keyCode == 68) {speedL = 0}
			if (evt.keyCode == 65) {speedL = 0}
		}   
		 
		function incepi(event:MouseEvent):void {
			k = pdaX - mouseX/4
			m = pdaY - mouseY/4
			addEventListener(Event.ENTER_FRAME, trage)
		 
		} 
		 
		function trage(event:Event):void{
			pdaX = (mouseX/4 + k)
			pdaY = (mouseY/4 + m)
		}           
		 
		function ridica(event:MouseEvent):void{
			removeEventListener(Event.ENTER_FRAME, trage)
		}
		 
	
		function directionarea(event:Event):void {
			if(removeul ==0){
				if(System.totalMemory/1024/1024 < 10){
					perdea.barul.width = (System.totalMemory/1024/1024)*300/10
					if(perdea.barul.width >= 300){
						perdea.barul.width = 300
					}
				}
				if(System.totalMemory/1024/1024 > 10){
					countdown = countdown -1
					perdea.barul.width = (600-countdown)/2
					if(countdown <= 0){
						countdown = 0
						perdea.alpha = perdea.alpha - 0.1
						if(perdea.alpha <=0){
							removeChild(perdea)
							removeul = 1
						}
					}
				}
			}
		 
			//rotatia mea///////////////////////////////////////////////////////////
			cont2.rotationX -= (cont2.rotationX + pdaY*0.01)*0.3
			cont1.rotationZ -= (cont1.rotationZ + pdaX*0.01)*0.3
			cont2.y -= (cont2.y - pdaY*2.0)*0.3;
		 
			//directia de deplasarea elipsoidului CORP/////////////////////////////
			directiaDeDeplasare.x = - speed*Math.sin(cont1.rotationZ) + speedL*Math.cos(cont1.rotationZ)
			directiaDeDeplasare.y = + speed*Math.cos(cont1.rotationZ) + speedL*Math.sin(cont1.rotationZ)
			directiaDeDeplasare.z = 0
		 
			var cont1Coords:Vector3D = new Vector3D(cont1.x, cont1.y, cont1.z)
			var destination:Vector3D = collider.calculateDestination(cont1Coords, directiaDeDeplasare, global);         
		 
			cont1.x = destination.x;
			cont1.y = destination.y;
			cont1.z = destination.z;
		}
		 
		
		 
		function onContextCreate(event:Event):void {
			addEventListener(Event.ENTER_FRAME, rendering);
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
		}
		 
		function rendering(event:Event):void {
			camera.render(stage3D);
		}
	}

}