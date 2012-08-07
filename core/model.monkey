'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
	
Strict
Import monkey.map
Import puremvc.interfaces.imodel
Import puremvc.interfaces.iproxy
	
'/**
 '* A Singleton <code>IModel</code> implementation.
 '* 
 '* <P>
 '* In PureMVC, the <code>Model</code> class provides
 '* access to model objects (Proxies) by named lookup. 
 '* 
 '* <P>
 '* The <code>Model</code> assumes these responsibilities:</P>
 '* 
 '* <UL>
 '* <LI>Maintain a cache of <code>IProxy</code> instances.</LI>
 '* <LI>Provide methods for registering, retrieving, and removing 
 '* <code>IProxy</code> instances.</LI>
 '* </UL>
 '* 
 '* <P>
 '* Your application must register <code>IProxy</code> instances 
 '* with the <code>Model</code>. Typically, you use an 
 '* <code>ICommand</code> to create and register <code>IProxy</code> 
 '* instances once the <code>Facade</code> has initialized the Core 
 '* actors.</p>
 '*
 '* @see org.puremvc.as3.patterns.proxy.Proxy Proxy
 '* @see org.puremvc.as3.interfaces.IProxy IProxy
 '*/
 
Public Class Model Implements IModel

Public
	'/**
	 '* Constructor. 
	 '* 
	 '* <P>
	 '* This <code>IModel</code> implementation is a Singleton, 
	 '* so you should not call the constructor 
	 '* directly, but instead call the static Singleton 
	 '* Factory method <code>Model.getInstance()</code>
	 '* 
	 '* @throws Error Error if Singleton instance has already been constructed
	 '* 
	 '*/
	Method New( )
		_instance = Self;
		_proxyMap = New StringMap<IProxy>()	
		InitializeModel();	
	End Method
	
	'/**
	 '* Initialize the Singleton <code>Model</code> instance.
	 '* 
	 '* <P>
	 '* Called automatically by the constructor, this
	 '* is your opportunity to initialize the Singleton
	 '* instance in your subclass without overriding the
	 '* constructor.</P>
	 '* 
	 '* @return void
	 '*/
	Method InitializeModel : Void(  ) 
	End Method
			
	'/**
	 '* <code>Model</code> Singleton Factory method.
	 '* 
	 '* @return the Singleton instance
	 '*/
	Function GetInstance : IModel() 
		If (_instance = Null) Then 
			_instance = New Model( )
		Endif	
		Return _instance
	End Function

	'/**
	 '* Register an <code>IProxy</code> with the <code>Model</code>.
	 '* 
	 '* @param proxy an <code>IProxy</code> to be held by the <code>Model</code>.
	 '*/
	Method RegisterProxy : Void( proxy:IProxy )
		Self._proxyMap.Add( proxy.getProxyName(), proxy )
		proxy.OnRegister()
	End Method

	'/**
	 '* Retrieve an <code>IProxy</code> from the <code>Model</code>.
	 '* 
	 '* @param proxyName
	 '* @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
	 '*/
	Method RetrieveProxy : IProxy( proxyName:String )
		Return Self._proxyMap.Get( proxyName )
	End Method

	'/**
	 '* Check if a Proxy is registered
	 '* 
	 '* @param proxyName
	 '* @return whether a Proxy is currently registered with the given <code>proxyName</code>.
	 '*/
	Method HasProxy : Bool( proxyName:String )
		Return _proxyMap.Get( proxyName ) <> Null
	End Method

	'/**
	 '* Remove an <code>IProxy</code> from the <code>Model</code>.
	 '* 
	 '* @param proxyName name of the <code>IProxy</code> instance to be removed.
	 '* @return the <code>IProxy</code> that was removed from the <code>Model</code>
	 '*/
	Method RemoveProxy : IProxy( proxyName:String )
		Local proxy:IProxy = IProxy ( _proxyMap.Get( proxyName ) )
		If ( proxy ) Then
			_proxyMap.Remove( proxyName)
			proxy.OnRemove()
		Endif
		Return proxy
	End Method
	
	'// Singleton instance
	Global _instance : IModel
	
Private
	'// Mapping of proxyNames to IProxy instances
	Field _proxyMap : StringMap<IProxy>
	
End Class