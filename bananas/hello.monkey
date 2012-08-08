
Import puremvc.interfaces.ifacade
Import puremvc.patterns.facade.facade
Import puremvc.interfaces.icommand
Import puremvc.interfaces.inotification
Import puremvc.patterns.command.simplecommand
import puremvc.interfaces.iproxy
Import puremvc.patterns.proxy.proxy
Import puremvc.interfaces.imediator
Import puremvc.patterns.mediator.mediator
    
Import mojo
Import reflection

Class Game Extends App
Public 
	Global hello:HelloSprite
	
    Method OnCreate()
        Print "hello"
        Print "Grab a square and drag."
		Print "Use Mousewheel to scale all squares up."
		Print "(No wheel on Safari or Mac, sorry)"
		hello = New HelloSprite("haha") 
 		ApplicationFacade.GetInstance().Startup( self )
        SetUpdateRate 60   
    End
    
    Method OnRender()
     	Cls(255,255,255)
	    hello.Draw()
    End
    
    Method OnUpdate()

    	hello.Update()
    End     

End

Function Main()
	New Game()
End

'****************************************************************
    
' Controller
Class StartupCommand Extends SimpleCommand Implements ICommand
	'/**
	'* Register the Proxies and Mediators.
	'* 
	'* Get the View Components for the Mediators from the app,
	'* which passed a reference to itself on the notification.
	'*/
	Method Execute : Void( note:INotification )    
		facade.RegisterProxy(New SpriteDataProxy())
		Local game:Game = Game(note.GetBody())
		facade.RegisterMediator( New AppMediator( game ) )
		SendNotification( ApplicationFacade.STAGE_ADD_SPRITE )
		Print ApplicationFacade.STAGE_ADD_SPRITE
	End Method
End Class

Class ApplicationFacade Extends Facade 
	'// Notification name constants
	Const STARTUP:String          = "startup"
	Const STAGE_ADD_SPRITE:String = "helloAddSprite"
	Const SPRITE_SCALE:String     = "spriteScale"
	Const SPRITE_DROP:String      = "spriteDrop"
	
	'/**
	'* Singleton ApplicationFacade Factory Method
	'*/
	Function GetInstance:ApplicationFacade()
		If ( instance = Null ) Then
			instance = New ApplicationFacade( )
		Endif	
		Return ApplicationFacade(instance)
	End Function
	
	'/**
	'* Register Commands with the Controller 
	'*/
	Method InitializeController : Void( ) 
		Super.InitializeController()         
		RegisterCommand( STARTUP, GetClass("StartupCommand"))
		Print STARTUP
	End Method
	        
	Method Startup:Void( obj:Object )
		SendNotification( STARTUP, obj )
	End Method
        
End Class

'Model
Class SpriteDataProxy Extends Proxy 'Implements IProxy

	Const NAME:String = "SpriteDataProxy"
	
	Method New( )
		Super.New( NAME, BoxFloat(0))
		palette = [ blue, red, yellow, green, cyan ]
    End Method

Private 
	Global palette:Int[]
	Field red:Int 	= $FF0000
	Field green:Int  = $00FF00
	Field blue:Int   = $0000FF
	Field yellow:Int = $FFFF00
	Field cyan:Int	= $00FFFF

Public 
	Function NextSpriteColor:Int( startColor:Int )
		'// identify color index
		Local index:Int
		Local found:Bool = False
		For Local j:Int=0 Until palette.Length()
			index = j
			If (startColor = palette[index]) Exit
		Next
		
		'// select the next color in the palette
		If (index = palette.Length()-1) Then
			index = 0
		Else
			index += 1
		Endif	
		'//return startColor;
		Return palette[index]		
	End Function
	
    '/**
	 '* Get the next Sprite ID
	 '*/
	Method GetNextSpriteID:String()
		spriteCount += 1
		Return "sprite"+spriteCount
	End Method
	
	'/**
	 '* Get the next Sprite ID
	 '*/
	Method spriteCount:Float() Property
		Return UnboxFloat(GetData())
	End Method
	
	Method spriteCount:Void(count:Float) Property
		SetData(BoxFloat(count))
	End Method
		
End Class

Class HelloSprite
		
Public
	'// Event name to tell Mediator to create a new sprite
	Const SPRITE_DIVIDE:String = "spriteDivide"
	
	'position	
	Field _x:Int = 175
	Field _y:Int = 30	
	'// id, size and color 
	Field _id:String
	Field size:Int = 75
    Field color:Int = $0000FF
		
	'// boundaries
	Field xBound:Int = 400
	Field yBound:Int = 400
		
	'// xy Location
	Field xLoc:Int = 175
	Field yLoc:Int = 30
	
	'// xy Vector 		
	Field xVec:Int = +3
	Field yVec:int = -2


	'/**
	 '* Constructor
	 '* 
	 '* Accepts the unique ID for this sprite, as well as its 
	 '* other parameters xy location, vector, size and color
	 '*/
	Method New( id:String, params:Int[] = [] ) 
		_id = id
		If (params.Length() > 0) Then
			xLoc=params[0]
			yLoc=params[1]
			xVec=params[2]
			yVec=params[3]
			size=params[4]
			color=params[5]
		Endif
		'Draw()
	End Method
#rem
	'// User has pressed the mouse
        private function handleMouseDown(event:MouseEvent):void {
		timer.reset();
		child.startDrag();
		child.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }

	// User has released the mouse
        private function handleMouseUp(event:MouseEvent=null):void {
		dropSprite();
        }

	// drop the sprite 
	public function dropSprite():void
	{
		child.stopDrag();
		child.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		timer.start();
	}
#End
	Method Update()
		If (MouseDown(MOUSE_LEFT) = 1 And MouseX >= _x And MouseX <= _x+size And MouseY >= _y And MouseY <= _y+size ) Then
			'Print "drag"
			MouseMove()
		Endif
		UpdatePosition()
	End Method

	'// Called only when dragging
	Method MouseMove:Void()
		If(_x < xLoc) Then
			xVec=-(Abs(xVec))
		Else If (_x > xLoc) Then
			xVec=Abs(xVec)
		Endif
		
		If(_y < yLoc) Then
			yVec=-(Abs(yVec))
		Else If (_y > yLoc) Then
			yVec=Abs(yVec)
		Endif
		
		xLoc=_x
		yLoc=_y
	End Method

	'// Update position based on vector and bounds
	Method UpdatePosition:Void()
		'// update the x and y location based on x and vectors
		'// then bounds check. Scale down when hitting a wall.
		'// finally, update the actual position of the sprite
		'// with the newly calculated values.
		xLoc = xLoc + xVec
		If ((xLoc + size) >= xBound) Then
			xVec = -(xVec)
			ScaleSprite(-5)
		Else If (xLoc <= 0) Then
			xVec = -(xVec)
			xLoc = 0
			ScaleSprite(-5)
		Endif
		yLoc = yLoc + yVec
		If ((yLoc + size) >= yBound) Then
			yVec = -(yVec)
			ScaleSprite(-5)
		Else If (yLoc <= 0) Then
			yVec = -(yVec)
			yLoc = 0
			ScaleSprite(-5)
		Endif
		_x = xLoc
		_y = yLoc
	End Method
		
	'// scale the sprite 
	Method ScaleSprite:Void(delta:Float)
		size += delta
		If (size <= 5) Then 
			size = 5
		Endif	
		If (size >= 150) Then
			size = 5
		Endif	
	End Method
	
	Method GetNewSpriteState:Int[]()
		Return [xLoc, yLoc, -(xVec), -(yVec), size, color]
	End Method
	
	'// Create the actual sprite to display
    Method Draw:void()
        Local r:Float = (color Shr 16) & $FF
		Local g:Float = (color Shr 8) & $FF
		Local b:Float = color & $FF	
        SetColor(r,g,b)
        SetAlpha(0.25)        
        DrawRect( xLoc, yLoc, size, size ) 
	End Method
End Class

'Mediators
Class HelloSpriteMediator Extends Mediator 'Implements IMediator
       
'/**
'* Constructor. 
'*/
	Method New( viewComponent:Object ) 
		'// pass the viewComponent to the superclass where 
		'// it will be stored in the inherited viewComponent property
		'//
		'// *** Note that the name of the mediator is the same as the
		'// *** id of the HelloSprite it stewards. It does not use a
		'// *** fixed 'NAME' constant as most single-use mediators do
        Super.New( HelloSprite(viewComponent)._id, viewComponent )
    
		'// Retrieve reference to frequently consulted Proxies
		_spriteDataProxy = SpriteDataProxy(facade.RetrieveProxy( SpriteDataProxy.NAME ))
		
		'// Listen for events from the view component 
		'helloSprite.addEventListener( HelloSprite.SPRITE_DIVIDE, onSpriteDivide );
            
	End Method

	'/**
	'* List all notifications this Mediator is interested in.
	'* <P>
	'* Automatically called by the framework when the mediator
	'* is registered with the view.</P>
	'* 
	'* @return Array the list of Nofitication names
	'*/
	Method ListNotificationInterests:String[]() 
		Return [ ApplicationFacade.SPRITE_SCALE, ApplicationFacade.SPRITE_DROP ]
	End Method
	
	'/**
	'* Handle all notifications this Mediator is interested in.
	'* <P>
	'* Called by the framework when a notification is sent that
	'* this mediator expressed an interest in when registered
	'* (see <code>listNotificationInterests</code>.</P>
	'* 
	'* @param INotification a notification 
	'*/
	Method HandleNotification:Void ( note:INotification )
		Select ( note.GetName() )
			Case ApplicationFacade.SPRITE_DROP
				'hello.DropSprite()
			Case ApplicationFacade.SPRITE_SCALE
				Local delta:Float = UnboxFloat(note.GetBody())
				hello.ScaleSprite(delta)
			End
	End Method
		
	'/**
	'* Sprite divide.
	'* <P>
	'* User is dragging the sprite, send a notification to create a new sprite
	'* and pass the state the new sprite should inherit.
	'*/
	Method OnSpriteDivide:void()
		Game.hello.color = SpriteDataProxy.NextSpriteColor( Game.hello.color )
		SendNotification( ApplicationFacade.STAGE_ADD_SPRITE, ArrayBoxer<Int>.Box(Game.hello.GetNewSpriteState()) )				
	End Method

	'/**
	'* Cast the viewComponent to its actual type.
	'* 
	'* <P>
	'* This is a useful idiom for mediators. The
	'* PureMVC Mediator class defines a viewComponent
	'* property of type Object. </P>
	'* 
	'* <P>
	'* Here, we cast the generic viewComponent to 
	'* its actual type in a protected mode. This 
	'* retains encapsulation, while allowing the instance
	'* (and subclassed instance) access to a 
	'* strongly typed reference with a meaningful
	'* name.</P>
	'* 
	'* @return stage the viewComponent cast to HelloSprite
	'*/
	Method hello:HelloSprite() Property
		Return HelloSprite(GetViewComponent())
	End Method

Private 
	Field _spriteDataProxy:SpriteDataProxy
End Class

'/**
'* A Mediator for interacting with the App.
'*/
Public Class AppMediator Extends Mediator 'Implements IMediator

	'// Cannonical name of the Mediator
	Const NAME:String = "AppMediator"

	'/**
	' * Constructor. 
	' */
	Method New( viewComponent:Object ) 
		'// pass the viewComponent to the superclass where 
		'// it will be stored in the inherited viewComponent property
		Super.New( NAME, viewComponent )
    
		'// Retrieve reference to frequently consulted Proxies
		_spriteDataProxy = SpriteDataProxy( facade.RetrieveProxy( SpriteDataProxy.NAME ) )
	
		'// Listen for events from the view component 
		'stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
		'stage.addEventListener( MouseEvent.MOUSE_WHEEL, handleMouseWheel );
		            
	End Method


	'/**
	'* List all notifications this Mediator is interested in.
	'* <P>
	'* Automatically called by the framework when the mediator
	'* is registered with the view.</P>
	'* 
	'* @return Array the list of Nofitication names
	'*/
	Method ListNotificationInterests:String[]() 
		Return [ ApplicationFacade.STAGE_ADD_SPRITE ]
	End Method

	'/**
	'* Handle all notifications this Mediator is interested in.
	'* <P>
	'* Called by the framework when a notification is sent that
	'* this mediator expressed an interest in when registered
	'* (see <code>listNotificationInterests</code>.</P>
	'* 
	'* @param INotification a notification 
	'*/
	Method HandleNotification:void( note:INotification ) 

		Select ( note.GetName() ) 
                
			'// Create a new HelloSprite, 
			'// Create and register its HelloSpriteMediator
			'// and finally add the HelloSprite to the stage
			case ApplicationFacade.STAGE_ADD_SPRITE
				Local params:Int[] = ArrayBoxer<Int>.Unbox(note.GetBody())
				Local helloSprite:HelloSprite = New HelloSprite( _spriteDataProxy.GetNextSpriteID(), params )
				facade.RegisterMediator(new HelloSpriteMediator( helloSprite ))
				'stage.addChild( helloSprite )
		End					
	End Method

	'// The user has released the mouse over the stage
	Method HandleMouseLeft:Void()
		SendNotification( ApplicationFacade.SPRITE_DROP );
	End Method
                    
	'// The user has released the mouse over the stage
	Method HandleMouseRight:Void()	
		If ( MouseHit(MOUSE_RIGHT) = 1 ) Then
			SendNotification( ApplicationFacade.SPRITE_SCALE, BoxFloat(Float(2)) )
		Endif
	End Method
	
	'/**
	'* Cast the viewComponent to its actual type.
	'* 
	'* <P>
	'* This is a useful idiom for mediators. The
	'* PureMVC Mediator class defines a viewComponent
	'* property of type Object. </P>
	'* 
	'* <P>
	'* Here, we cast the generic viewComponent to 
	'* its actual type in a protected mode. This 
	'* retains encapsulation, while allowing the instance
	'* (and subclassed instance) access to a 
	'* strongly typed reference with a meaningful
	'* name.</P>
	'* 
	'* @return Game the viewComponent cast to App
	'*/
	Method game:Game() Property
		Return Game(GetViewComponent())
	End method
		
Private 
	Field _spriteDataProxy:SpriteDataProxy
End Class