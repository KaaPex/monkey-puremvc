'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

Import puremvc.interfaces.imediator
Import puremvc.interfaces.inotification
Import puremvc.interfaces.inotifier
Import puremvc.patterns.observer.notifier

'/**
 '* A base <code>IMediator</code> implementation. 
 '* 
 '* @see org.puremvc.as3.core.view.View View
 '*/
Public Class Mediator Extends Notifier Implements IMediator, INotifier

	'/**
	 '* The name of the <code>Mediator</code>. 
	 '* 
	 '* <P>
	 '* Typically, a <code>Mediator</code> will be written to serve
	 '* one specific control or group controls and so,
	 '* will not have a need to be dynamically named.</P>
	 '*/
Public 
	Const NAME:String = "Mediator"
	
	'/**
	 '* Constructor.
	 '*/
	Method New( mediatorName:String="", viewComponent:Object=Null )
		If (mediatorName <> "") Then
			_mediatorName = mediatorName
		Else 
			_mediatorName = NAME
		Endif
		_viewComponent = viewComponent	
	End Method

	'/**
	 '* Get the name of the <code>Mediator</code>.
	 '* @return the Mediator name
	 '*/		
	Method GetMediatorName:String() 
		Return _mediatorName
	End Method

	'/**
	 '* Set the <code>IMediator</code>'s view component.
	 '* 
	 '* @param Object the view component
	 '*/
	Method SetViewComponent:Void( viewComponent:Object ) 
		_viewComponent = viewComponent
	End Method

	'/**
	 '* Get the <code>Mediator</code>'s view component.
	 '* 
	 '* <P>
	 '* Additionally, an implicit getter will usually
	 '* be defined in the subclass that casts the view 
	 '* object to a type, like this:</P>
	 '* 
	 '* <listing>
	 '*		private function get comboBox : mx.controls.ComboBox 
	 '*		{
	 '*			return viewComponent as mx.controls.ComboBox;
	 '*		}
	 '* </listing>
	 '* 
	 '* @return the view component
	 '*/		
	Method GetViewComponent:Object()
		Return viewComponent;
	End Method

	'/**
	 '* List the <code>INotification</code> names this
	 '* <code>Mediator</code> is interested in being notified of.
	 '* 
	 '* @return Array the list of <code>INotification</code> names 
	 '*/
	Method ListNotificationInterests:String[]() 
		Return []
	End Method

	'/**
	 '* Handle <code>INotification</code>s.
	 '* 
	 '* <P>
	 '* Typically this will be handled in a switch statement,
	 '* with one 'case' entry per <code>INotification</code>
	 '* the <code>Mediator</code> is interested in.
	 '*/ 
	Method HandleNotification:Void( notification:INotification )
	End Method
	
	'/**
	 '* Called by the View when the Mediator is registered
	 '*/ 
	Method OnRegister:Void( )
	End Method

	'/**
	 '* Called by the View when the Mediator is removed
	 '*/ 
	Method OnRemove:Void( )
	End Method
	
	'// The view component
	Field _viewComponent:Object
	
Private
	'// the mediator name
	Field _mediatorName:String


End Class