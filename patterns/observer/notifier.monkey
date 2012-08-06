'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

Import puremvc.patterns.facade.facade
	
'/**
 '* A Base <code>INotifier</code> implementation.
 '* 
 '* <P>
 '* <code>MacroCommand, Command, Mediator</code> and <code>Proxy</code> 
 '* all have a need to send <code>Notifications</code>. <P>
 '* <P>
 '* The <code>INotifier</code> interface provides a common method called
 '* <code>sendNotification</code> that relieves implementation code of 
 '* the necessity to actually construct <code>Notifications</code>.</P>
 '* 
 '* <P>
 '* The <code>Notifier</code> class, which all of the above mentioned classes
 '* extend, provides an initialized reference to the <code>Facade</code>
 '* Singleton, which is required for the convienience method
 '* for sending <code>Notifications</code>, but also eases implementation as these
 '* classes have frequent <code>Facade</code> interactions and usually require
 '* access to the facade anyway.</P>
 '* 
 '* @see org.puremvc.as3.patterns.facade.Facade Facade
 '* @see org.puremvc.as3.patterns.mediator.Mediator Mediator
 '* @see org.puremvc.as3.patterns.proxy.Proxy Proxy
 '* @see org.puremvc.as3.patterns.command.SimpleCommand SimpleCommand
 '* @see org.puremvc.as3.patterns.command.MacroCommand MacroCommand
 '*/
 
Public Class Notifier Implements INotifier

	'/**
	 '* Send an <code>INotification</code>s.
	 '* 
	 '* <P>
	 '* Keeps us from having to construct new notification instances in our
	 '* implementation code.
	 '* 
	 '* @param notificationName
	 '*            the name of the notiification to send
	 '* @param body
	 '*            the body of the notification (optional)
	 '* @param type
	 '*            the type of the notification (optional)
	 '*/

	Method SendNotification:Void(  notificationName:String,  body:Object, type:String )
		_facade.SendNotification( notificationName, body, type )
	End Method
	
	'/**
	 '* Send an <code>INotification</code>s.
	 '* 
	 '* <P>
	 '* Keeps us from having to construct new notification instances in our
	 '* implementation code.
	 '* 
	 '* @param notificationName
	 '*            the name of the notiification to send
	 '* @param body
	 '*            the body of the notification (optional)
	 '*/

	Method SendNotification:Void( notificationName:String, Object body)
		_facade.sendNotification( notificationName, body)
	End Method
	
	'/**
	 '* Send an <code>INotification</code>s.
	 '* 
	 '* <P>
	 '* Keeps us from having to construct new notification instances in our
	 '* implementation code.
	 '* 
	 '* @param notificationName
	 '*            the name of the notiification to send
	 '*/

	Method SendNotification:Void( notificationName:String)
		_facade.sendNotification( notificationName)
	End Method
	
	'// The Multiton Key for this app
	'/**
	 '* Local reference to the Facade Singleton
	 '*/
	Private _facade:Facade = Facade.GetInstance()
		
End Class