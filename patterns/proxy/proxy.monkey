'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

Import puremvc.interfaces.iproxy
Import puremvc.patterns.observer.notifier
	
'/**
 '* A base <code>IProxy</code> implementation. 
 '* 
 '* <P>
 '* In PureMVC, <code>Proxy</code> classes are used to manage parts of the 
 '* application's data model. </P>
 '* 
 '* <P>
 '* A <code>Proxy</code> might simply manage a reference to a local data object, 
 '* in which case interacting with it might involve setting and 
 '* getting of its data in synchronous fashion.</P>
 '* 
 '* <P>
 '* <code>Proxy</code> classes are also used to encapsulate the application's 
 '* interaction with remote services to save or retrieve data, in which case, 
 '* we adopt an asyncronous idiom; setting data (or calling a method) on the 
 '* <code>Proxy</code> and listening for a <code>Notification</code> to be sent 
 '* when the <code>Proxy</code> has retrieved the data from the service. </P>
 '* 
 '* @see org.puremvc.as3.core.model.Model Model
 '*/
Public Class Proxy Extends Notifier Implements IProxy, INotifier

	'/**
	 '* Constructor
	 '*/
	Method New( proxyName:String="", data:Object=Null ) 
		If (proxyName <> "") Then
			_proxyName = proxyName
		Endif	 
		If (data <> Null) Then
			SetData(data)
		Endif	
	End Method

	'/**
	 '* Get the proxy name
	 '*/
	Method GetProxyName:String() 
		Return proxyName
	End Method		
	
	'/**
	 '* Set the data object
	 '*/
	Method SetData:Void( data:Object ) 
		_data = data
	End Method
	
	'/**
	 '* Get the data object
	 '*/
	Method GetData:Object() 
		Return _data
	End Method		

	'/**
	 '* Called by the Model when the Proxy is registered
	 '*/ 
	Method OnRegister:Void( ) 
	End Method

	'/**
	 '* Called by the Model when the Proxy is removed
	 '*/ 
	Method OnRemove:Void( ) 
	End Method
	
	'// the data object
	Field _data:Object
		
Private	
	'// the proxy name
	Field _proxyName:String = "Proxy"
	
End Class