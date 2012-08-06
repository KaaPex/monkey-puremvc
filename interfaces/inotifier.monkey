'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 ' Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

'/**
 '* The interface definition for a PureMVC Notifier.
 '* 
 '* <P>
 '* <code>MacroCommand, Command, Mediator</code> and <code>Proxy</code>
 '* all have a need to send <code>Notifications</code>. </P>
 '* 
 '* <P>
 '* The <code>INotifier</code> interface provides a common method called
 '* <code>sendNotification</code> that relieves implementation code of 
 '* the necessity to actually construct <code>Notifications</code>.</P>
 '* 
 '* <P>
 '* The <code>Notifier</code> class, which all of the above mentioned classes
 '* extend, also provides an initialized reference to the <code>Facade</code>
 '* Singleton, which is required for the convienience method
 '* for sending <code>Notifications</code>, but also eases implementation as these
 '* classes have frequent <code>Facade</code> interactions and usually require
 '* access to the facade anyway.</P>
 '* 
 '* @see puremvc.interfaces.IFacade IFacade
 '* @see puremvc.interfaces.INotification INotification
 '*/
 
Public Interface INotifier

	'/**
	 '* Send a <code>INotification</code>.
	 '* 
	 '* <P>
	 '* Convenience method to prevent having to construct new 
	 '* notification instances in our implementation code.</P>
	 '* 
	 '* @param notificationName the name of the notification to send
	 '* @param body the body of the notification (optional)
	 '* @param type the type of the notification (optional)
	 '*/ 
	Method SendNotification:Void( notificationName:String, body:Object=Null, type:String=Null )
	'/**
	 '* Send a <code>INotification</code>.
	 '* 
	 '* <P>
	 '* Convenience method to prevent having to construct new notification
	 '* instances in our implementation code.
	 '* </P>
	 '* 
	 '* @param notificationName the name of the notification to send
	 '* @param body the body of the notification (optional)
	 '*/
	Method SendNotification:Void( notificationName:String, body:Object )	
	'/**
	 '* Send a <code>INotification</code>.
	 '* 
	 '* <P>
	 '* Convenience method to prevent having to construct new notification
	 '* instances in our implementation code.
	 '* </P>
	 '* 
	 '* @param notificationName the name of the notification to send
	 '*/
	Method SendNotification:Void( notificationName:String )
	
End Interface