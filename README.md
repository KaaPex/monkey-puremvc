PureMVC for Monkey
=================

This is a port of PureMVC to the [Monkey](http://www.monkeycoder.co.nz/) language.
The port is translated from [PureMVC](http://http://puremvc.org)

PureMVC is a lightweight framework for creating applications based upon the classic Model, View and Controller concept.
 
Based upon proven design patterns, this free, open source framework which was originally implemented in the ActionScript 3 language for use with Adobe Flex, Flash and AIR, is now being ported to all major development platforms.
The Model, View and Controller application tiers are represented by three Singletons (a class where only one instance may be created).
 
The MVC Singletons maintain named caches of Proxies, Mediators and Commands, respectively. The Facade, also a Singleton, provides a single interface for communications throughout the application. These four Singletons are referred to as the Core Actors.
 
Data objects, be they local or remote, are managed by Proxies.
The View Components that make up the User Interface are managed by Mediators.
Commands may interact with Proxies, Mediators, as well as trigger or execute other Commands.
 
All actors discover and communicate with each other via the Facade, rather than work directly with Model, View and Controller.
 
PureMVC also introduces a Publish/subscribe-style Observer notification scheme. This allows asynchronous, event-driven communications between the actors of the system, and also promotes a loose coupling between those actors, since the subscriber never needs to have direct knowledge of the publisher.

Requirements
------------

Monkey v53 or higher

