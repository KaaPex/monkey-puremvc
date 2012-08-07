'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

Import puremvc.interfaces.inotification
	
'/**
 '* A base <code>INotification</code> implementation.
 '* 
 '* <P>
 '* PureMVC does not rely upon underlying event models such 
 '* as the one provided with Flash, and ActionScript 3 does 
 '* not have an inherent event model.</P>
 '* 
 '* <P>
 '* The Observer Pattern as implemented within PureMVC exists 
 '* to support event-driven communication between the 
 '* application and the actors of the MVC triad.</P>
 '* 
 '* <P>
 '* Notifications are not meant to be a replacement for Events
 '* in Flex/Flash/Apollo. Generally, <code>IMediator</code> implementors
 '* place event listeners on their view components, which they
 '* then handle in the usual way. This may lead to the broadcast of <code>Notification</code>s to 
 '* trigger <code>ICommand</code>s or to communicate with other <code>IMediators</code>. <code>IProxy</code> and <code>ICommand</code>
 '* instances communicate with each other and <code>IMediator</code>s 
 '* by broadcasting <code>INotification</code>s.</P>
 '* 
 '* <P>
 '* A key difference between Flash <code>Event</code>s and PureMVC 
 '* <code>Notification</code>s is that <code>Event</code>s follow the 
 '* 'Chain of Responsibility' pattern, 'bubbling' up the display hierarchy 
 '* until some parent component handles the <code>Event</code>, while
 '* PureMVC <code>Notification</code>s follow a 'Publish/Subscribe'
 '* pattern. PureMVC classes need not be related to each other in a 
 '* parent/child relationship in order to communicate with one another
 '* using <code>Notification</code>s.
 '* 
 '* @see org.puremvc.as3.patterns.observer.Observer Observer
 '* 
 '*/
Public Class Notification Implements INotification

	'/**
	 '* Constructor. 
	 '* 
	 '* @param name name of the <code>Notification</code> instance. (required)
	 '* @param body the <code>Notification</code> body. (optional)
	 '* @param type the type of the <code>Notification</code> (optional)
	 '*/
	Method New( name:String, body:Object=Null, type:String="")
		_name = name
		_body = body
		_type = type
	End Method
	
	'/**
	 '* Get the name of the <code>Notification</code> instance.
	 '* 
	 '* @return the name of the <code>Notification</code> instance.
	 '*/
	Method GetName:String()
		Return _name
	End Method
	
	'/**
	 '* Set the body of the <code>Notification</code> instance.
	 '*/
	Method SetBody:Void( body:Object )
		_body = body
	End Method
	
	'/**
	 '* Get the body of the <code>Notification</code> instance.
	 '* 
	 '* @return the body object. 
	 '*/
	Method GetBody:Object()
		Return _body
	End Method
	
	'/**
	 '* Set the type of the <code>Notification</code> instance.
	 '*/
	Method SetType:Void( type:String )
		_type = type
	End Method
	
	'/**
	 '* Get the type of the <code>Notification</code> instance.
	 '* 
	 '* @return the type  
	 '*/
	Method GetType:String()
		Return _type
	End Method

	'/**
	 '* Get the string representation of the <code>Notification</code> instance.
	 '* 
	 '* @return the string representation of the <code>Notification</code> instance.
	 '*/
	Method ToString:String()
		String result = "Notification Name: " + GetName() + " Body:"
		If( body <> Null ) Then
		'	result += _body.ToString() + " Type:"
		Else
			result += "null Type:"
		Endif	
		
		If( type <> Null ) Then
			result += _type
		Else
			result += "null "
		Endif	
		
		Return result
	End Method
	
Private	
	'// the name of the notification instance
	Field _name			: String
	'// the type of the notification instance
	Field _type			: String
	'// the body of the notification instance
	Field _body			: Object
	
End Class