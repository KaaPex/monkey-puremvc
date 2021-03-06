'/*
 'PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 'Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 'Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
'*/
Strict

Import monkey.map
Import monkey.list
Import puremvc.interfaces.imediator
Import puremvc.interfaces.inotification
Import puremvc.interfaces.iobserver
Import puremvc.interfaces.iview
Import puremvc.patterns.observer.observer

'/**
 '* A Singleton <code>IView</code> implementation.
 '* 
 '* <P>
 '* In PureMVC, the <code>View</code> class assumes these responsibilities:
 '* <UL>
 '* <LI>Maintain a cache of <code>IMediator</code> instances.</LI>
 '* <LI>Provide methods for registering, retrieving, and removing <code>IMediators</code>.</LI>
 '* <LI>Notifiying <code>IMediators</code> when they are registered or removed.</LI>
 '* <LI>Managing the observer lists for each <code>INotification</code> in the application.</LI>
 '* <LI>Providing a method for attaching <code>IObservers</code> to an <code>INotification</code>'s observer list.</LI>
 '* <LI>Providing a method for broadcasting an <code>INotification</code>.</LI>
 '* <LI>Notifying the <code>IObservers</code> of a given <code>INotification</code> when it broadcast.</LI>
 '* </UL>
 '* 
 '* @see org.puremvc.as3.patterns.mediator.Mediator Mediator
 '* @see org.puremvc.as3.patterns.observer.Observer Observer
 '* @see org.puremvc.as3.patterns.observer.Notification Notification
 '*/
Class View Implements IView

	'/**
	 '* Constructor. 
	 '* 
	 '* <P>
	 '* This <code>IView</code> implementation is a Singleton, 
	 '* so you should not call the constructor 
	 '* directly, but instead call the static Singleton 
	 '* Factory method <code>View.getInstance()</code>
	 '* 
	 '* @throws Error Error if Singleton instance has already been constructed
	 '* 
	 '*/
	Method New( )
		instance = Self
		_mediatorMap = New StringMap<IMediator>()
		_observerMap = New StringMap<List<IObserver>>()	
		InitializeView()
	End Method
	
	'/**
	 '* Initialize the Singleton View instance.
	 '* 
	 '* <P>
	 '* Called automatically by the constructor, this
	 '* is your opportunity to initialize the Singleton
	 '* instance in your subclass without overriding the
	 '* constructor.</P>
	 '* 
	 '* @return void
	 '*/
	Method InitializeView:Void()
	End Method

	'/**
	 '* View Singleton Factory method.
	 '* 
	 '* @return the Singleton instance of <code>View</code>
	 '*/
	Function GetInstance : IView() 
		If ( instance = Null ) Then
			instance = New View( )
		Endif	
		Return instance
	End Function
			
	'/**
	 '* Register an <code>IObserver</code> to be notified
	 '* of <code>INotifications</code> with a given name.
	 '* 
	 '* @param notificationName the name of the <code>INotifications</code> to notify this <code>IObserver</code> of
	 '* @param observer the <code>IObserver</code> to register
	 '*/
	Method RegisterObserver:Void ( notificationName:String, observer:IObserver )
		If ( _observerMap.Get( notificationName ) = Null ) Then
			_observerMap.Add( notificationName, New List<IObserver>() )
		Endif	
		Local observers:List<IObserver> = List<IObserver> (_observerMap.Get(notificationName))
		observers.AddLast(observer)	
		_observerMap.Set(notificationName, observers)
	End Method

	'/**
	 '* Notify the <code>IObservers</code> for a particular <code>INotification</code>.
	 '* 
	 '* <P>
	 '* All previously attached <code>IObservers</code> for this <code>INotification</code>'s
	 '* list are notified and are passed a reference to the <code>INotification</code> in 
	 '* the order in which they were registered.</P>
	 '* 
	 '* @param notification the <code>INotification</code> to notify <code>IObservers</code> of.
	 '*/
	Method NotifyObservers : Void( notification:INotification )
		'// Get a reference to the observers list for this notification name
		Local observers_ref:List<IObserver> = List<IObserver> ( _observerMap.Get(notification.GetName()) )
		
		If( observers_ref <> Null ) Then
					
			'// Copy observers from reference array to working array, 
			'// since the reference array may change during the notification loop
			Local observers:IObserver[] = observers_ref.ToArray()
			
			'// Notify Observers from the working array				
			For Local i:Int = 0 Until observers.Length()
				Local observer:IObserver = IObserver (observers[i])
				observer.NotifyObserver(notification)
			Next
		Endif
	End Method

	'/**
	 '* Remove the observer for a given notifyContext from an observer list for a given Notification name.
	 '* <P>
	 '* @param notificationName which observer list to remove from 
	 '* @param notifyContext remove the observer with this object as its notifyContext
	 '*/
	Method RemoveObserver:Void( notificationName:String, notifyContext:Object )
		'// the observer list for the notification under inspection
		Local observers:List<IObserver> = _observerMap.Get(notificationName)

		If ( observers <> Null ) Then
			'// find the observer for the notifyContext
			For Local obs:IObserver = Eachin observers
				Local observer:Observer = Observer(obs)
				If ( observer.CompareNotifyContext( notifyContext ) = True ) Then
					'// there can only be one Observer for a given notifyContext 
					'// in any given Observer list, so remove it and break
					observers.RemoveEach(observer)
					Exit
				Endif
			Next
	
			'// Also, when a Notification's Observer list length falls to 
			'// zero, delete the notification key from the observer map
			If ( observers.Count() = 0 ) Then
				_observerMap.Remove( notificationName )		
			Endif
		Endif
	End Method

	'/**
	 '* Register an <code>IMediator</code> instance with the <code>View</code>.
	 '* 
	 '* <P>
	 '* Registers the <code>IMediator</code> so that it can be retrieved by name,
	 '* and further interrogates the <code>IMediator</code> for its 
	 '* <code>INotification</code> interests.</P>
	 '* <P>
	 '* If the <code>IMediator</code> returns any <code>INotification</code> 
	 '* names to be notified about, an <code>Observer</code> is created encapsulating 
	 '* the <code>IMediator</code> instance's <code>handleNotification</code> method 
	 '* and registering it as an <code>Observer</code> for all <code>INotifications</code> the 
	 '* <code>IMediator</code> is interested in.</p>
	 '* 
	 '* @param mediatorName the name to associate with this <code>IMediator</code> instance
	 '* @param mediator a reference to the <code>IMediator</code> instance
	 '*/
	Method RegisterMediator : void( mediator:IMediator )
		'// do not allow re-registration (you must to removeMediator fist)
		If( _mediatorMap.Contains(mediator.GetMediatorName()) ) Then
			Return
		Endif	
		
		'// Register the Mediator for retrieval by name
		_mediatorMap.Add(mediator.GetMediatorName(), mediator)
		
		'// Get Notification interests, if any.
		Local noteInterests:String[] = mediator.ListNotificationInterests()

		'// Register Mediator as an observer for each of its notification interests
		If ( noteInterests.Length() > 0 ) Then

			'// Create Observer referencing this mediator's handlNotification method
			Local observer:Observer = New Observer( GetClass(mediator).GetMethod("HandleNotification",[GetClass("INotification")]), mediator )

			'// Register Mediator as Observer for its list of Notification interests
			For Local i:Int=0 Until noteInterests.Length()
				RegisterObserver( noteInterests[i],  observer )
			Next
		Endif
		
		'// alert the mediator that it has been registered
		mediator.OnRegister()
		
	End Method

	'/**
	 '* Retrieve an <code>IMediator</code> from the <code>View</code>.
	 '* 
	 '* @param mediatorName the name of the <code>IMediator</code> instance to retrieve.
	 '* @return the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
	 '*/
	Method RetrieveMediator : IMediator( mediatorName:String )
		Return IMediator(_mediatorMap.Get( mediatorName ))
	End Method

	'/**
	 '* Remove an <code>IMediator</code> from the <code>View</code>.
	 '* 
	 '* @param mediatorName name of the <code>IMediator</code> instance to be removed.
	 '* @return the <code>IMediator</code> that was removed from the <code>View</code>
	 '*/
	Method RemoveMediator : IMediator( mediatorName:String )
		'// Retrieve the named mediator
		Local mediator:IMediator = _mediatorMap.Get( mediatorName )
		
		If ( mediator <> Null ) 
			'// for every notification this mediator is interested in...
			Local interests:String[] = mediator.ListNotificationInterests()
			For Local i:Int=0 Until interests.Length() 
				'// remove the observer linking the mediator 
				'// to the notification interest
				RemoveObserver( interests[i], mediator )
			Next	
			
			'// remove the mediator from the map		
			_mediatorMap.Remove( mediatorName )

			'// alert the mediator that it has been removed
			mediator.OnRemove()
		Endif
		
		Return mediator
	End Method
	
	'/**
	 '* Check if a Mediator is registered or not
	 '* 
	 '* @param mediatorName
	 '* @return whether a Mediator is registered with the given <code>mediatorName</code>.
	 '*/
	Method HasMediator : Bool( mediatorName:String )
		Return _mediatorMap.Get( mediatorName ) <> Null
	End Method
	
	'// Singleton instance
	Global instance	: IView
	
Private
	'// Mapping of Mediator names to Mediator instances
	Field _mediatorMap : StringMap<IMediator>

	'// Mapping of Notification names to Observer lists
	Field _observerMap	: StringMap<List<IObserver>>
	
End Class
