'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import reflection
Import puremvc.core.controller
Import puremvc.core.model
Import puremvc.core.view
Import puremvc.interfaces.icommand
Import puremvc.interfaces.ifacade
Import puremvc.interfaces.imediator
Import puremvc.interfaces.inotification
Import puremvc.interfaces.iproxy
Import puremvc.patterns.observer.notification

'/**
 '* A base Singleton <code>IFacade</code> implementation.
 '* 
 '* <P>
 '* In PureMVC, the <code>Facade</code> class assumes these 
 '* responsibilities:
 '* <UL>
 '* <LI>Initializing the <code>Model</code>, <code>View</code>
 '* and <code>Controller</code> Singletons.</LI> 
 '* <LI>Providing all the methods defined by the <code>IModel, 
 '* IView, & IController</code> interfaces.</LI>
 '* <LI>Providing the ability to override the specific <code>Model</code>,
 '* <code>View</code> and <code>Controller</code> Singletons created.</LI> 
 '* <LI>Providing a single point of contact to the application for 
 '* registering <code>Commands</code> and notifying <code>Observers</code></LI>
 '* </UL>
 '* <P>
 	 '* 
 '* @see org.puremvc.as3.core.model.Model Model
 '* @see org.puremvc.as3.core.view.View View
 '* @see org.puremvc.as3.core.controller.Controller Controller
 '* @see org.puremvc.as3.patterns.observer.Notification Notification
 '* @see org.puremvc.as3.patterns.mediator.Mediator Mediator
 '* @see org.puremvc.as3.patterns.proxy.Proxy Proxy
 '* @see org.puremvc.as3.patterns.command.SimpleCommand SimpleCommand
 '* @see org.puremvc.as3.patterns.command.MacroCommand MacroCommand
 '*/
Public Class Facade Implements IFacade

	'/**
	 '* Constructor. 
	 '* 
	 '* <P>
	 '* This <code>IFacade</code> implementation is a Singleton, 
	 '* so you should not call the constructor 
	 '* directly, but instead call the static Singleton 
	 '* Factory method <code>Facade.getInstance()</code>
	 '* 
	 '* @throws Error Error if Singleton instance has already been constructed
	 '* 
	 '*/
	Method New( )
		instance = self
		InitializeFacade()
	End Method

Public
	'/**
	 '* Initialize the Singleton <code>Facade</code> instance.
	 '* 
	 '* <P>
	 '* Called automatically by the constructor. Override in your
	 '* subclass to do any subclass specific initializations. Be
	 '* sure to call <code>super.initializeFacade()</code>, though.</P>
	 '*/
	Method InitializeFacade:Void(  ) 
		InitializeModel()
		InitializeController()
		InitializeView()
	End Method

	'/**
	 '* Facade Singleton Factory method
	 '* 
	 '* @return the Singleton instance of the Facade
	 '*/
	Function GetInstance:IFacade()
		If (instance = Null) Then
			instance = New Facade( )
		Endif	 
		Return instance
	End Function

	'/**
	 '* Initialize the <code>Controller</code>.
	 '* 
	 '* <P>
	 '* Called by the <code>initializeFacade</code> method.
	 '* Override this method in your subclass of <code>Facade</code> 
	 '* if one or both of the following are true:
	 '* <UL>
	 '* <LI> You wish to initialize a different <code>IController</code>.</LI>
	 '* <LI> You have <code>Commands</code> to register with the <code>Controller</code> at startup.</code>. </LI>		  
	 '* </UL>
	 '* If you don't want to initialize a different <code>IController</code>, 
	 '* call <code>super.initializeController()</code> at the beginning of your
	 '* method, then register <code>Command</code>s.
	 '* </P>
	 '*/
	Method InitializeController:Void( )
		If ( _controller <> Null ) Then
			Return
		Endif	
		_controller = Controller.GetInstance()
	End Method

	'/**
	 '* Initialize the <code>Model</code>.
	 '* 
	 '* <P>
	 '* Called by the <code>initializeFacade</code> method.
	 '* Override this method in your subclass of <code>Facade</code> 
	 '* if one or both of the following are true:
	 '* <UL>
	 '* <LI> You wish to initialize a different <code>IModel</code>.</LI>
	 '* <LI> You have <code>Proxy</code>s to register with the Model that do not 
	 '* retrieve a reference to the Facade at construction time.</code></LI> 
	 '* </UL>
	 '* If you don't want to initialize a different <code>IModel</code>, 
	 '* call <code>super.initializeModel()</code> at the beginning of your
	 '* method, then register <code>Proxy</code>s.
	 '* <P>
	 '* Note: This method is <i>rarely</i> overridden; in practice you are more
	 '* likely to use a <code>Command</code> to create and register <code>Proxy</code>s
	 '* with the <code>Model</code>, since <code>Proxy</code>s with mutable data will likely
	 '* need to send <code>INotification</code>s and thus will likely want to fetch a reference to 
	 '* the <code>Facade</code> during their construction. 
	 '* </P>
	 '*/
	Method InitializeModel:Void( )
		If ( _model <> Null ) Then
			Return
		Endif	
		_model = Model.GetInstance()
	End Method
	
	'/**
	 '* Initialize the <code>View</code>.
	 '* 
	 '* <P>
	 '* Called by the <code>initializeFacade</code> method.
	 '* Override this method in your subclass of <code>Facade</code> 
	 '* if one or both of the following are true:
	 '* <UL>
	 '* <LI> You wish to initialize a different <code>IView</code>.</LI>
	 '* <LI> You have <code>Observers</code> to register with the <code>View</code></LI>
	 '* </UL>
	 '* If you don't want to initialize a different <code>IView</code>, 
	 '* call <code>super.initializeView()</code> at the beginning of your
	 '* method, then register <code>IMediator</code> instances.
	 '* <P>
	 '* Note: This method is <i>rarely</i> overridden; in practice you are more
	 '* likely to use a <code>Command</code> to create and register <code>Mediator</code>s
	 '* with the <code>View</code>, since <code>IMediator</code> instances will need to send 
	 '* <code>INotification</code>s and thus will likely want to fetch a reference 
	 '* to the <code>Facade</code> during their construction. 
	 '* </P>
	 '*/
	Method InitializeView:Void( )
		If ( _view <> Null ) Then
			Return
		Endif	
		_view = View.GetInstance()
	End Method

Public
	'/**
	 '* Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
	 '* 
	 '* @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with
	 '* @param commandClassRef a reference to the Class of the <code>ICommand</code>
	 '*/
	Method RegisterCommand:Void( notificationName:String, commandClassRef:ClassInfo ) 
		_controller.RegisterCommand( notificationName, commandClassRef )
	End Method

	'/**
	 '* Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
	 '* 
	 '* @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
	 '*/
	Method RemoveCommand:Void( notificationName:String ) 
		_controller.RemoveCommand( notificationName )
	End Method

	'/**
	 '* Check if a Command is registered for a given Notification 
	 '* 
	 '* @param notificationName
	 '* @return whether a Command is currently registered for the given <code>notificationName</code>.
	 '*/
	Method HasCommand : Bool( notificationName:String )
		Return _controller.HasCommand(notificationName)
	End Method

	'/**
	 '* Register an <code>IProxy</code> with the <code>Model</code> by name.
	 '* 
	 '* @param proxyName the name of the <code>IProxy</code>.
	 '* @param proxy the <code>IProxy</code> instance to be registered with the <code>Model</code>.
	 '*/
	Method RegisterProxy:Void ( proxy:IProxy )	
		_model.RegisterProxy ( proxy )
	End Method
			
	'/**
	 '* Retrieve an <code>IProxy</code> from the <code>Model</code> by name.
	 '* 
	 '* @param proxyName the name of the proxy to be retrieved.
	 '* @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
	 '*/
	Method RetrieveProxy:IProxy ( proxyName:String ) 
		Return _model.RetrieveProxy ( proxyName )	
	End Method

	'/**
	 '* Remove an <code>IProxy</code> from the <code>Model</code> by name.
	 '*
	 '* @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
	 '* @return the <code>IProxy</code> that was removed from the <code>Model</code>
	 '*/
	Method RemoveProxy:IProxy ( proxyName:String ) 
		Local proxy:IProxy
		If ( _model <> Null ) Then
			Return _model.RemoveProxy ( proxyName )
		Endif	
		Return Null
	End Method

	'/**
	 '* Check if a Proxy is registered
	 '* 
	 '* @param proxyName
	 '* @return whether a Proxy is currently registered with the given <code>proxyName</code>.
	 '*/
	Method HasProxy : Bool( proxyName:String )
		Return _model.HasProxy( proxyName )
	End Method

	'/**
	 '* Register a <code>IMediator</code> with the <code>View</code>.
	 '* 
	 '* @param mediatorName the name to associate with this <code>IMediator</code>
	 '* @param mediator a reference to the <code>IMediator</code>
	 '*/
	Method RegisterMediator:Void( mediator:IMediator ) 
		If ( _view <> Null ) Then
			_view.RegisterMediator( mediator )
		Endif	
	End Method

	'/**
	 '* Retrieve an <code>IMediator</code> from the <code>View</code>.
	 '* 
	 '* @param mediatorName
	 '* @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
	 '*/
	Method RetrieveMediator:IMediator( mediatorName:String ) 
		Return IMediator (_view.RetrieveMediator( mediatorName ))
	End Method

	'/**
	 '* Remove an <code>IMediator</code> from the <code>View</code>.
	 '* 
	 '* @param mediatorName name of the <code>IMediator</code> to be removed.
	 '* @return the <code>IMediator</code> that was removed from the <code>View</code>
	 '*/
	Method RemoveMediator : IMediator( mediatorName:String ) 
		If ( _view <> Null ) Then
			Return _view.RemoveMediator( mediatorName )
		Endif	
		Return Null
	End Method

	'/**
	 '* Check if a Mediator is registered or not
	 '* 
	 '* @param mediatorName
	 '* @return whether a Mediator is registered with the given <code>mediatorName</code>.
	 '*/
	Method HasMediator : Bool( mediatorName:String )
		Return _view.HasMediator( mediatorName )
	End Method

	'/**
	 '* Create and send an <code>INotification</code>.
	 '* 
	 '* <P>
	 '* Keeps us from having to construct new notification 
	 '* instances in our implementation code.
	 '* @param notificationName the name of the notiification to send
	 '* @param body the body of the notification (optional)
	 '* @param type the type of the notification (optional)
	 '*/ 
	Method SendNotification:Void ( notificationName:String, body:Object=Null, type:String="" )
		NotifyObservers( New Notification( notificationName, body, type ) )
	End Method
	
	'/**
	 '* Create and send an <code>INotification</code>.
	 '* 
	 '* <P>
	 '* Keeps us from having to construct new notification 
	 '* instances in our implementation code.
	 '* @param notificationName the name of the notification to send
	 '* @param body the body of the notification (optional)
	 '*/ 
	Method SendNotification:Void( notificationName:String, body:Object=Null ) 
		SendNotification( notificationName, body, "" )
	End Method
	
	'/**
	 '* Create and send an <code>INotification</code>.
	 '* 
	 '* <P>
	 '* Keeps us from having to construct new notification 
	 '* instances in our implementation code.
	 '* @param notificationName the name of the notification to send
	 '*/ 
	Method SendNotification:Void( notificationName:String ) 
		SendNotification( notificationName, Null, "" )
	End Method
	
	'/**
	 '* Notify <code>Observer</code>s.
	 '* <P>
	 '* This method is left public mostly for backward 
	 '* compatibility, and to allow you to send custom 
	 '* notification classes using the facade.</P>
	 '*<P> 
	 '* Usually you should just call sendNotification
	 '* and pass the parameters, never having to 
	 '* construct the notification yourself.</P>
	 '* 
	 '* @param notification the <code>INotification</code> to have the <code>View</code> notify <code>Observers</code> of.
	 '*/
	Method NotifyObservers:Void ( notification:INotification )
		If ( _view <> Null ) Then
			_view.NotifyObservers( notification )
		Endif	
	End Method
	
	'// The Singleton Facade instance.
	Global instance : Facade = Null
	
Private 
	'// Private references to Model, View and Controller
	Field _controller : IController = Null
	Field _model	  : IModel = Null
	Field _view		  : IView = Null

End Class