'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

Import puremvc.interfaces.IFunction

'/**
 '* A base <code>IObserver</code> implementation.
 '* 
 '* <P> 
 '* An <code>Observer</code> is an object that encapsulates information
 '* about an interested object with a method that should 
 '* be called when a particular <code>INotification</code> is broadcast. </P>
 '* 
 '* <P>
 '* In PureMVC, the <code>Observer</code> class assumes these responsibilities:
 '* <UL>
 '* <LI>Encapsulate the notification (callback) method of the interested object.</LI>
 '* <LI>Encapsulate the notification context (this) of the interested object.</LI>
 '* <LI>Provide methods for setting the notification method and context.</LI>
 '* <LI>Provide a method for notifying the interested object.</LI>
 '* </UL>
 '* 
 '* @see org.puremvc.as3.core.view.View View
 '* @see org.puremvc.as3.patterns.observer.Notification Notification
 '*/
 
Public Class Observer Implements IObserver

Private 
	Field _notify:IFunction
    Field _context:Object
	'/**
	 '* Get the notification method.
	 '* 
	 '* @return the notification (callback) method of the interested object.
	 '*/
	Method GetNotifyMethod:IFunction()
		Return _notify
	End Method
	
	'/**
	 '* Get the notification context.
	 '* 
	 '* @return the notification context (<code>this</code>) of the interested object.
	 '*/
	Method GetNotifyContext:Object()
		Return _context
	End Method

Public	
	'/**
	 '* Constructor. 
	 '* 
	 '* <P>
	 '* The notification method on the interested object should take 
	 '* one parameter of type <code>INotification</code></P>
	 '* 
	 '* @param notifyMethod the notification method of the interested object
	 '* @param notifyContext the notification context of the interested object
	 '*/
	Method New( notifyMethod:IFunction, notifyContext:Object ) 
		SetNotifyMethod( notifyMethod )
		SetNotifyContext( notifyContext )
	End Method
	
	'/**
	 '* Set the notification method.
	 '* 
	 '* <P>
	 '* The notification method should take one parameter of type <code>INotification</code>.</P>
	 '* 
	 '* @param notifyMethod the notification (callback) method of the interested object.
	 '*/
	Method SetNotifyMethod:Void( notifyMethod:IFunction )
		_notify = notifyMethod
	End Method
	
	'/**
	 '* Set the notification context.
	 '* 
	 '* @param notifyContext the notification context (this) of the interested object.
	 '*/
	Method SetNotifyContext:Void( notifyContext:Object )
		_context = notifyContext
	End Method
	
	
	'/**
	 '* Notify the interested Object.
	 '* 
	 '* @param notification the <code>INotification</code> to pass to the interested object's notification method.
	 '*/
	Method NotifyObserver:Void( notification:INotification )
		self.GetNotifyMethod().OnNotification( notification );
	End Method

	'/**
	 '* Compare an Object To the notification context. 
	 '* 
	 '* @param object the object to compare
	 '* @return boolean indicating if the object and the notification context are the same
	 '*/
	 Method CompareNotifyContext:Bool( obj:Object )
	 	Return obj = self._context
	 End Method	
	 	
End Class