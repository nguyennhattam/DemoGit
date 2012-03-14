    package {  
      
        import alternativa.engine3d.controllers.SimpleObjectController; //we need classes Alternativa3D 8  
        import alternativa.engine3d.core.Camera3D;  
        import alternativa.engine3d.core.Object3D;  
        import alternativa.engine3d.core.Resource;  
        import alternativa.engine3d.core.View;  
        import alternativa.engine3d.loaders.ParserA3D;  
        import alternativa.engine3d.materials.FillMaterial;  
        import alternativa.engine3d.objects.Mesh;  
        import alternativa.engine3d.resources.Geometry;  
      
        import flash.display.Sprite; //Flash classes  
        import flash.display.Stage3D;  
        import flash.display.StageAlign;  
        import flash.display.StageScaleMode;  
        import flash.events.Event;  
        import flash.net.URLLoader;  
        import flash.net.URLRequest;  
        import flash.net.URLLoaderDataFormat;  
      
        public class Main extends Sprite {  
      
            private var rootContainer:Object3D = new Object3D(); //everything is clear, if it is not clear read last lesson  
            private var camera:Camera3D;  
            private var stage3D:Stage3D;  
            private var car:Mesh; //container for our car  
            /* Mesh class inherits from Object3D and may contain a 3d model with arbitrary geometry 
             * Can also act as a container. 
             */  
            private var simpleController:SimpleObjectController;  
      
            public function Main(){  
                stage.align = StageAlign.TOP_LEFT; //align the content in the upper left corner  
                stage.scaleMode = StageScaleMode.NO_SCALE; //do not allow scaling content  
      
                camera = new Camera3D(0.1, 10000); //create a camera and position it  
                camera.view = new View(550, 400); //create a viewport  
                camera.rotationX = -120 * Math.PI / 180;  
                camera.y = -100;  
                camera.z = 50;  
                camera.view.hideLogo();  
                addChild(camera.view);  
                //addChild(camera.diagram); // add diagram  
                /* The diagram, which displays debug information. To display a diagram, it must be added to the screen. 
                 * FPS — The average number of frames per second for the gap in fpsUpdatePeriod frames. 
                 * MS — Average execution time measured using startTimer - stopTimer piece of code in milliseconds for the interval in timerUpdatePeriod frames. 
                 * MEM — Number of occupied memory in the player Mb 
                 * DRW — Amount drawing graphics in the current frame. 
                 * PLG — Amount visible polygons in the current frame. 
                 * TRI — Amount triangles are drawn in the current frame. 
     
                 * The camera also has methods to position diagram 
                 * 
                 * diagramAlign --> Using the class constants StageAlign indicate where a diagram would be located 
                 * Example: camera.diagramAlign = StageAlign.BOTTOM_LEFT; 
                 * 
                 * diagramHorizontalMargin  --> padding from the edge of the workspace in the horizontal 
                 * Example: camera.diagramHorizontalMargin = 50; 
                 * 
                 * diagramVerticalMargin  --> padding from the edge of the workspace in the vertical 
                 * Example: camera. diagramVerticalMargin = 50; 
                 */  
                rootContainer.addChild(camera);  
      
                stage3D = stage.stage3Ds[0]; //get stage3D  
                stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);  
                stage3D.requestContext3D(); //request context  
            }  
      
            private function onContextCreate(e:Event):void {  
                stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);  
      
                var loaderA3D:URLLoader = new URLLoader(); //create a URLLoader  
                loaderA3D.dataFormat = URLLoaderDataFormat.BINARY; //indicate that the content was loaded as a byte array, not as a text  
                loaderA3D.load(new URLRequest("test.A3D"));  
                loaderA3D.addEventListener(Event.COMPLETE, onA3DLoad); //end load  
            }  
      
            private function onA3DLoad(e:Event):void {  
      
                var parser:ParserA3D = new ParserA3D(); //create a parser  
                /* 
                 * ParserA3D - This class parses the format of the loaded model a3d 
                 * and scores array [objects] three-dimensional objects 
                 */  
      
    //  ---------------------->>>>>>>>>> HERE THE ERROR OCCURS !!!  <<<<<-----------------------  
      
                parser.parse((e.target as URLLoader).data); //parse model  
      
    // --- End of Error --  
      
                car = new Mesh(); //Create Mesh.     
                rootContainer.addChild(car); //add to the main container  
      
                for each (var object:Object3D in parser.objects){ //iterate through an array of [objects]  
                    if (object is Mesh){  
                        var mesh:Mesh = Mesh(object); //transform in Mesh  
                        //if (object.name == "glaslght" || object.name == "glass"){ //If the current 3D object glass or glaslght (so called lights and glass in my model)  
                            //mesh.setMaterialToAllSurfaces(new FillMaterial(Math.random() * 0xFFFFFF, 0.5)); //"Paint" and make clear (as detailed in Section 2.3)  
                        //} else {  
                            mesh.setMaterialToAllSurfaces(new FillMaterial(Math.random() * 0xFFFFFF)); //just "paint"  
                        //}  
                        car.addChild(mesh); //add to a container for a car  
                    }  
                }  
      
                for each (var resource:Resource in rootContainer.getResources(true)){  
                    resource.upload(stage3D.context3D);  
                } // all resources are loaded in context3D  
                //I do not remember I said or not but that we have anything we came all the resources necessary to download context3D and we must always remember this  
                simpleController = new SimpleObjectController(stage, car, 1000); // assign a controller for a container car (detail in another lesson)  
                stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);  
            }  
      
            private function onEnterFrame(e:Event):void {  
                simpleController.update(); //update the controller  
                camera.render(stage3D); //render the scene  
            }  
        }  
    }  