'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 ' Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import inotifier

'/**
 '* The interface definition for a PureMVC Proxy.
 '*
 '* <P>
 '* In PureMVC, <code>IProxy</code> implementors assume these responsibilities:</P>
 '* <UL>
 '* <LI>Implement a common method which returns the name of the Proxy.</LI>
 '* <LI>Provide methods for setting and getting the data object.</LI>
 '* </UL>
 '* <P>
 '* Additionally, <code>IProxy</code>s typically:</P>
 '* <UL>
 '* <LI>Maintain references to one or more pieces of model data.</LI>
 '* <LI>Provide methods for manipulating that data.</LI>
 '* <LI>Generate <code>INotifications</code> when their model data changes.</LI>
 '* <LI>Expose their name as a <code>public static const</code> called <code>NAME</code>, if they are not instantiated multiple times.</LI>
 '* <LI>Encapsulate interaction with local or remote services used to fetch and persist model data.</LI>
 '* </UL>
 '*/
Public Interface IProxy Extends INotifier
	
	'/**
	 '* Get the Proxy name
	 '* 
	 '* @return the Proxy instance name
	 '*/
	Method GetProxyName:String()
	
	'/**
	 '* Set the data object
	 '* 
	 '* @param data the data object
	 '*/
	Method SetData:Void( data:Object )
	
	'/**
	 '* Get the data object
	 '* 
	 '* @return the data as type Object
	 '*/
	Method GetData:Object()
	
	'/**
	 '* Called by the Model when the Proxy is registered
	 '*/ 
	Method OnRegister:Void( )

	'/**
	 '* Called by the Model when the Proxy is removed
	 '*/ 
	Method OnRemove:Void( )
	
End Interface