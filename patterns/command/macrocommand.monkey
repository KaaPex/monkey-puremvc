'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict
Import reflection
Import monkey.stack
Import puremvc.interfaces.icommand
Import puremvc.interfaces.inotification
Import puremvc.patterns.observer.notifier

'/**
 '* A base <code>ICommand</code> implementation that executes other <code>ICommand</code>s.
 '*  
 '* <P>
 '* A <code>MacroCommand</code> maintains an list of
 '* <code>ICommand</code> Class references called <i>SubCommands</i>.</P>
 '* 
 '* <P>
 '* When <code>execute</code> is called, the <code>MacroCommand</code> 
 '* instantiates and calls <code>execute</code> on each of its <i>SubCommands</i> turn.
 '* Each <i>SubCommand</i> will be passed a reference to the original
 '* <code>INotification</code> that was passed to the <code>MacroCommand</code>'s 
 '* <code>execute</code> method.</P>
 '* 
 '* <P>
 '* Unlike <code>SimpleCommand</code>, your subclass
 '* should not override <code>execute</code>, but instead, should 
 '* override the <code>initializeMacroCommand</code> method, 
 '* calling <code>addSubCommand</code> once for each <i>SubCommand</i>
 '* to be executed.</P>
 '* 
 '* <P>
 '* 
 '* @see org.puremvc.as3.core.controller.Controller Controller
 '* @see org.puremvc.as3.patterns.observer.Notification Notification
 '* @see org.puremvc.as3.patterns.command.SimpleCommand SimpleCommand
 '*/
 
Public Class MacroCommand Extends Notifier Implements ICommand, INotifier
	
	'/**
	 '* Constructor. 
	 '* 
	 '* <P>
	 '* You should not need to define a constructor, 
	 '* instead, override the <code>initializeMacroCommand</code>
	 '* method.</P>
	 '* 
	 '* <P>
	 '* If your subclass does define a constructor, be 
	 '* sure to call <code>super()</code>.</P>
	 '*/
	Method New()
		_subCommands = New Stack<ICommand>()
		InitializeMacroCommand()		
	End Method
	
	'/**
	 '* Initialize the <code>MacroCommand</code>.
	 '* 
	 '* <P>
	 '* In your subclass, override this method to 
	 '* initialize the <code>MacroCommand</code>'s <i>SubCommand</i>  
	 '* list with <code>ICommand</code> class references like 
	 '* this:</P>
	 '* 
	 '* <listing>
	 '*		// Initialize MyMacroCommand
	 '*		override protected function initializeMacroCommand( ) : void
	 '*		{
	 '*			addSubCommand( com.me.myapp.controller.FirstCommand );
	 '*			addSubCommand( com.me.myapp.controller.SecondCommand );
	 '*			addSubCommand( com.me.myapp.controller.ThirdCommand );
	 '*		}
	 '* </listing>
	 '* 
	 '* <P>
	 '* Note that <i>SubCommand</i>s may be any <code>ICommand</code> implementor,
	 '* <code>MacroCommand</code>s or <code>SimpleCommands</code> are both acceptable.
	 '*/
	Method InitializeMacroCommand:Void()
	End Method
	
	'/**
	 '* Add a <i>SubCommand</i>.
	 '* 
	 '* <P>
	 '* The <i>SubCommands</i> will be called in First In/First Out (FIFO)
	 '* order.</P>
	 '* 
	 '* @param commandClassRef a reference to the <code>Class</code> of the <code>ICommand</code>.
	 '*/
	Method AddSubCommand: Void( commandClassRef:ICommand )
		_subCommands.Push(commandClassRef)
	End Method
	
	'/** 
	 '* Execute this <code>MacroCommand</code>'s <i>SubCommands</i>.
	 '* 
	 '* <P>
	 '* The <i>SubCommands</i> will be called in First In/First Out (FIFO)
	 '* order. 
	 '* 
	 '* @param notification the <code>INotification</code> object to be passsed to each <i>SubCommand</i>.
	 '*/
	Public Final Method Execute : Void( notification:INotification )
		While _subCommands.Length() > 0
			Local commandClassRef : ClassInfo = _subCommands.Pop()
			Local commandInstance : ICommand = New commandClassRef()
			commandInstance.Execute( notification )
		Wend
	End Method
		
Private 
	Field _subCommands:Stack<ICommand>
							
End Class