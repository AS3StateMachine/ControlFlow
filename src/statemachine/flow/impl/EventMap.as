package statemachine.flow.impl
{
import flash.utils.Dictionary;

import org.swiftsuspenders.Injector;

import statemachine.flow.api.EventControlFlowMap;
import statemachine.flow.dsl.ControlFlowMapping;

public class EventMap implements EventControlFlowMap
{
    internal var injector:Injector;

    private var _triggerMap:TriggerMap;
    private const _triggers:Dictionary = new Dictionary( false );

    public function EventMap( injector:Injector )
    {
        this.injector = injector.createChildInjector();
        this.injector.map( Injector ).toValue( this.injector );
        this.injector.map( Executor );
        _triggerMap = this.injector.getOrCreateNewInstance( TriggerMap );
    }


    public function on( type:String, eventClass:Class = null ):ControlFlowMapping
    {
        _triggers[type] = new EventTrigger( type, eventClass ).setInjector( injector );
        return _triggerMap.map( _triggers[type] );
    }

    public function remove( type:String ):void
    {
        _triggerMap.unmap( _triggers[type] );
    }
}
}
