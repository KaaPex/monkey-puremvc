Strict
Import puremvc.interfaces.ifacade
Import puremvc.patterns.facade.facade
import puremvc.interfaces.icommand
import puremvc.interfaces.inotification
Import puremvc.patterns.command.simplecommand
    
Import mojo

Function Main()

	Print("Starting game!");

	New Hello()
End

Class MainGame Extends App
	
	Method OnCreate:Int()

		
		Return Super.OnCreate();		 
	End
	
	Method OnRender:Int()

		Return Super.OnRender();
	End
	
	Method OnUpdate:Int()
		 	

		Return Super.OnUpdate();
	End Method
		
End

