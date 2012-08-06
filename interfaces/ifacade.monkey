'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import imodel
Import iview
Import icontroller
Import icommand
Import inotification

'/**
 '* The interface definition for a PureMVC Facade.
 '*
 '* <P>
 '* The Facade Pattern suggests providing a single
 '* class to act as a central point of communication 
 '* for a subsystem. </P>
 '* 
 '* <P>
 '* In PureMVC, the Facade acts as an interface between
 '* the core MVC actors (Model, View, Controller) and
 '* the rest of your application.</P>
 '* 
 '* @see puremvc.interfaces.IModel IModel
 '* @see puremvc.interfaces.IView IView
 '* @see puremvc.interfaces.IController IController
 '* @see puremvc.interfaces.ICommand ICommand
 '* @see puremvc.interfaces.INotification INotification
 '*/
Public Interface IFacade Extends INotifier

	'/**
	 '* Register an <code>IProxy</code> with the <code>Model</code> by name.
	 '* 
	 '* @param proxy the <code>IProxy</code> to be registered with the <code>Model</code>.
	 '*/
	Method RegisterProxy : void( proxy:IProxy )

	'/**
	 '* Retrieve a <code>IProxy</code> from the <code>Model</code> by name.
	 '* 
	 '* @param proxyName the name of the <code>IProxy</code> instance to be retrieved.
	 '* @return the <code>IProxy</code> previously regisetered by <code>proxyName</code> with the <code>Model</code>.
	 '*/
	Method RetrieveProxy : IProxy( proxyName:String )
	
	'/**
	 '* Remove an <code>IProxy</code> instance from the <code>Model</code> by name.
	 '*
	 '* @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
	 '* @return the <code>IProxy</code> that was removed from the <code>Model</code>
	 '*/
	Method RemoveProxy : IProxy( proxyName:String )

	'/**
	 '* Check if a Proxy is registered
	 '* 
	 '* @param proxyName
	 '* @return whether a Proxy is currently registered with the given <code>proxyName</code>.
	 '*/
	Method HasProxy : Bool( proxyName:String )

	'/**
	 '* Register an <code>ICommand</code> with the <code>Controller</code>.
	 '* 
	 '* @param noteName the name of the <code>INotification</code> to associate the <code>ICommand</code> with.
	 '* @param commandClassRef a reference to the <code>Class</code> of the <code>ICommand</code>.
	 '*/
	Method RegisterCommand : Void( noteName : String, commandClassRef : ICommand )
	
	'/**
	 '* Remove a previously registered <code>ICommand</code> To <code>INotification</code> mapping from the Controller.
	 '* 
	 '* @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
	 '*/
	Method RemoveCommand : Void( notificationName:String )

	'/**
	 '* Check if a Command is registered for a given Notification 
	 '* 
	 '* @param notificationName
	 '* @return whether a Command is currently registered for the given <code>notificationName</code>.
	 '*/
	Method HasComman : Boold( notificationName:String )
	
	'/**
	 '* Register an <code>IMediator</code> instance with the <code>View</code>.
	 '* 
	 '* @param mediator a reference to the <code>IMediator</code> instance
	 '*/
	Method RegisterMediator : Void( mediator:IMediator )

	'/**
	 '* Retrieve an <code>IMediator</code> instance from the <code>View</code>.
	 '* 
	 '* @param mediatorName the name of the <code>IMediator</code> instance to retrievve
	 '* @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
	 '*/
	Method RetrieveMediator : IMediator( mediatorName:String )

	'/**
	 '* Remove a <code>IMediator</code> instance from the <code>View</code>.
	 '* 
	 '* @param mediatorName name of the <code>IMediator</code> instance to be removed.
	 '* @return the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
	 '*/
	Method RemoveMediator : IMediator( mediatorName:String )
	
	'/**
	 '* Check if a Mediator is registered or not
	 '* 
	 '* @param mediatorName
	 '* @return whether a Mediator is registered with the given <code>mediatorName</code>.
	 '*/
	Method HasMediator : Bool( mediatorName:String )

	'/**
	 '* Notify the <code>IObservers</code> for a particular <code>INotification</code>.
	 '* 
	 '* <P>
	 '* All previously attached <code>IObservers</code> for this <code>INotification</code>'s
	 '* list are notified and are passed a reference to the <code>INotification</code> in 
	 '* the order in which they were registered.</P>
	 '* <P>
	 '* NOTE: Use this method only if you are sending custom Notifications. Otherwise
	 '* use the sendNotification method which does not require you to create the
	 '* Notification instance.</P> 
	 '* 
	 '* @param notification the <code>INotification</code> to notify <code>IObservers</code> of.
	 '*/
	Method NotifyObservers : Void( note:INotification )
	
End Interface