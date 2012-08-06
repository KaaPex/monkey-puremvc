'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 ' Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import reflection
Import monkey.map
Import View
Import puremvc.interfaces.ICommand
Import puremvc.interfaces.IController
Import puremvc.interfaces.IFunction
Import puremvc.interfaces.INotification
Import puremvc.patterns.observer.Observer
	
'/**
 '* A Singleton <code>IController</code> implementation.
 '* 
 '* <P>
 '* In PureMVC, the <code>Controller</code> class follows the
 '* 'Command and Controller' strategy, and assumes these 
 '* responsibilities:
 '* <UL>
 '* <LI> Remembering which <code>ICommand</code>s 
 '* are intended to handle which <code>INotifications</code>.</LI>
 '* <LI> Registering itself as an <code>IObserver</code> with
 '* the <code>View</code> for each <code>INotification</code> 
 '* that it has an <code>ICommand</code> mapping for.</LI>
 '* <LI> Creating a new instance of the proper <code>ICommand</code>
 '* to handle a given <code>INotification</code> when notified by the <code>View</code>.</LI>
 '* <LI> Calling the <code>ICommand</code>'s <code>execute</code>
 '* method, passing in the <code>INotification</code>.</LI> 
 '* </UL>
 '* 
 '* <P>
 '* Your application must register <code>ICommands</code> with the 
 '* Controller.
 '* <P>
 	 '* The simplest way is to subclass </code>Facade</code>, 
 '* and use its <code>initializeController</code> method to add your 
 '* registrations. 
 '* 
 '* @see org.puremvc.as3.core.view.View View
 '* @see org.puremvc.as3.patterns.observer.Observer Observer
 '* @see org.puremvc.as3.patterns.observer.Notification Notification
 '* @see org.puremvc.as3.patterns.command.SimpleCommand SimpleCommand
 '* @see org.puremvc.as3.patterns.command.MacroCommand MacroCommand
'*/
Public Class Controller Implements IController
	
	'/**
	 '* Constructor. 
	 '* 
	 '* <P>
	 '* This <code>IController</code> implementation is a Singleton, 
	 '* so you should not call the constructor 
	 '* directly, but instead call the static Singleton 
	 '* Factory method <code>Controller.getInstance()</code>
	 '* 
	 '* @throws Error Error if Singleton instance has already been constructed
	 '* 
	 '*/
	Method New( )
		'If (instance <> Null) Throw Error(SINGLETON_MSG);
		_instance = Self
		_commandMap = New StringMap<ICommand>()
		InitializeController()
	End Method
	
	'/**
	 '* <code>Controller</code> Singleton Factory method.
	 '* 
	 '* @return the Singleton instance of <code>Controller</code>
	 '*/
	Method GetInstance : IController()
		If ( _instance = Null ) Then
			_instance = New Controller( )
		Endif	
		Return _instance
	End Method

	'/**
	 '* If an <code>ICommand</code> has previously been registered 
	 '* to handle a the given <code>INotification</code>, then it is executed.
	 '* 
	 '* @param note an <code>INotification</code>
	 '*/
	Method ExecuteCommand( note : INotification ) : void
		Local commandInstance : ICommand = ICommand(New  _commandMap.Get( note.GetName() ))
		If ( commandInstance <> Null ) Then
			commandInstance.Execute( note )
		Endif	
	End Method

	'/**
	 '* Register a particular <code>ICommand</code> class as the handler 
	 '* for a particular <code>INotification</code>.
	 '* 
	 '* <P>
	 '* If an <code>ICommand</code> has already been registered to 
	 '* handle <code>INotification</code>s with this name, it is no longer
	 '* used, the new <code>ICommand</code> is used instead.</P>
	 '* 
	 '* The Observer for the new ICommand is only created if this the 
	 '* first time an ICommand has been regisered for this Notification name.
	 '* 
	 '* @param notificationName the name of the <code>INotification</code>
	 '* @param commandClassRef the <code>Class</code> of the <code>ICommand</code>
	 '*/
	Method RegisterCommand : Void( notificationName : String, commandClassRef : ICommand )
		If( Null <> _commandMap.Add( notificationName, commandClassRef ) ) Then
			Return
		Endif

		_view.RegisterObserver( 
			notificationName, 
			New Observer( 
				new IFunction()
				{
					Method  onNotification:Void( notification:INotification  )
						ExecuteCommand( notification )
					End Method
				}, 
				Self 
			)
		)
	
	End Method
	
	'/**
	 '* Check if a Command is registered for a given Notification 
	 '* 
	 '* @param notificationName
	 '* @return whether a Command is currently registered for the given <code>notificationName</code>.
	 '*/
	Method HasCommand : Bool( notificationName:String )
		Return _commandMap.Get( notificationName ) <> Null
	End Method

	'/**
	 '* Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping.
	 '* 
	 '* @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
	 '*/
	Method RemoveCommand( notificationName : String ) : void
		'// if the Command is registered...
		If ( HasCommand( notificationName ) ) Then
			'// remove the observer
			_view.RemoveObserver( notificationName, Self )
						
			'// remove the command
			_commandMap.Remove( notificationName )
		Endif
	End Method
	
Private	
	'/**
	 '* Initialize the Singleton <code>Controller</code> instance.
	 '* 
	 '* <P>Called automatically by the constructor.</P> 
	 '* 
	 '* <P>Note that if you are using a subclass of <code>View</code>
	 '* in your application, you should <i>also</i> subclass <code>Controller</code>
	 '* and override the <code>initializeController</code> method in the 
	 '* following way:</P>
	 '* 
	 '* <listing>
	 '*		// ensure that the Controller is talking to my IView implementation
	 '*		override public function initializeController(  ) : void 
	 '*		{
	 '*			view = MyView.getInstance();
	 '*		}
	 '* </listing>
	 '* 
	 '* @return void
	 '*/
	Method InitializeController : Void(  ) 
		_view = View.GetInstance()
	End Method
	
	'// Local reference To View 
	Field _view : IView
	
	'// Mapping of Notification names to Command Class references
	Field _commandMap : StringMap<ICommand>

	'// Singleton instance
	Field _instance : IController

End Class