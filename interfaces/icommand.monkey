'/*
' PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
' Your reuse is governed by the Creative Commons Attribution 3.0 United States License
' Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import inotification

'/**
 '* The Interface definition For a PureMVC Command.
 '*
 '* @see puremvc.interfaces INotification
 '*/
Public Interface ICommand
	'/**
	' * Execute the <code>ICommand</code>'s logic to handle a given <code>INotification</code>.
	' * 
	' * @param note an <code>INotification</code> To handle.
	' */
	Method Execute : Void( notification : INotification ) 
	
End Interface
