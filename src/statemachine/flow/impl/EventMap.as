package statemachine.flow.impl
{
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import org.swiftsuspenders.Injector;

import statemachine.flow.api.EventFlowMap;
import statemachine.flow.builders.FlowMapping;

public class EventMap implements EventFlowMap
{
    internal var injector:Injector;

    private var _triggerMap:TriggerFlowMap;
    private var _dispatcher:IEventDispatcher;
    private const _triggers:Dictionary = new Dictionary( false );

    public function EventMap( injector:Injector )
    {
        this.injector = injector.createChildInjector();
        this.injector.map( Injector ).toValue( this.injector );
        this.injector.map( Executor );
        _dispatcher = this.injector.getInstance( IEventDispatcher );
        _triggerMap = this.injector.getOrCreateNewInstance( TriggerFlowMap );
    }

    public function on( type:String, eventClass:Class = null ):FlowMapping
    {
        _triggers[type] = new EventTrigger( type, eventClass ).setDispatcher( _dispatcher );
        return _triggerMap.map( _triggers[type] );
    }

    public function remove( type:String ):void
    {
        _triggerMap.unmap( _triggers[type] );
    }
}
}
