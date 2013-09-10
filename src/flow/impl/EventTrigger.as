package flow.impl
{
import flash.events.Event;
import flash.events.IEventDispatcher;

import flow.core.Executable;
import flow.core.Trigger;

import org.swiftsuspenders.Injector;

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

    public function setInjector( value:Injector ):void
    {
        injector = value;
        _dispatcher = injector.getInstance( IEventDispatcher );
        _dispatcher.addEventListener( _type, handleEvent )
    }

    private function handleEvent( event:Event ):void
    {
        const eventClass:Class = (_eventClass == null) ? Event : _eventClass ;
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
    }
}
}
