package flow.impl
{
import flash.utils.Dictionary;

import flow.api.EventControlFlowMap;
import flow.dsl.ControlFlowMapping;

import org.swiftsuspenders.Injector;

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


    public function on( type:String, eventClass:Class ):ControlFlowMapping
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
