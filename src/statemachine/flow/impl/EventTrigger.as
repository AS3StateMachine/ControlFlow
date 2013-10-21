package statemachine.flow.impl
{
import flash.events.Event;
import flash.events.IEventDispatcher;

import statemachine.flow.api.Payload;
import statemachine.flow.builders.Unmapper;
import statemachine.flow.core.ExecutableBlock;
import statemachine.flow.core.Trigger;

public class EventTrigger implements Trigger
{
    public function EventTrigger( type:String, eventClass:Class = null )
    {
        _type = type;
        _eventClass = eventClass;
    }

    private var _dispatcher:IEventDispatcher;
    private var _client:ExecutableBlock;
    private var _type:String;
    private var _eventClass:Class;
    private var _unmapper:Unmapper;
    private var _once:Boolean;

    public function setDispatcher( value:IEventDispatcher, once:Boolean = false ):EventTrigger
    {
        _dispatcher = value;
        _once = once;
        _dispatcher.addEventListener( _type, handleEvent );
        return this;
    }

    public function setUnmapper( value:Unmapper ):EventTrigger
    {
        _unmapper = value;
        return this;
    }

    public function add( client:ExecutableBlock ):void
    {
        _client = client;
    }

    public function remove():void
    {
        _dispatcher.removeEventListener( _type, handleEvent );
        _client = null;
    }

    private function handleEvent( event:Event ):void
    {
        if ( _client == null )return;
        const eventClass:Class = (_eventClass == null) ? Event : _eventClass;
        _client.executeBlock( new Payload().add( event, eventClass ) );

        if ( _once )
        {
            _unmapper.unmap( this );
        }
    }
}
}
