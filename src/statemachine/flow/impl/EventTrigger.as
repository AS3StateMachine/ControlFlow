package statemachine.flow.impl
{
import flash.events.Event;
import flash.events.IEventDispatcher;

import org.swiftsuspenders.Injector;

import statemachine.flow.core.Executable;
import statemachine.flow.core.Trigger;

public class EventTrigger implements Trigger
{
    internal var injector:Injector;
    internal var preExecute:Function
    private var _dispatcher:IEventDispatcher;
    private var _client:Executable;
    private var _type:String;
    private var _eventClass:Class;

    public function EventTrigger( type:String, eventClass:Class = null )
    {
        _type = type;
        _eventClass = eventClass;
    }

    public function setInjector( value:Injector ):EventTrigger
    {
        injector = value;
        _dispatcher = injector.getInstance( IEventDispatcher );
        _dispatcher.addEventListener( _type, handleEvent );
        return this;
    }

    private function handleEvent( event:Event ):void
    {
        if ( _client == null )return;

        const eventClass:Class = (_eventClass == null) ? Event : _eventClass;
        injector.map( eventClass ).toValue( event );
        (preExecute != null) && preExecute();
        _client.execute();

        injector.unmap( eventClass );
    }


    public function add( client:Executable ):void
    {
        _client = client;
    }

    public function remove():void
    {
        _client = null;
    }
}
}
