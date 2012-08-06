'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 ' Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import INotification

'/**
 '* This interface must be implemented by all classes that want to be notified of
 '* a notification.
 '*/
Public Interface IFunction

	'/**
	 '* @param notification
	 '*/
	Method OnNotification( notification:INotification  )
	
End Interface
