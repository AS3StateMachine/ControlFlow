package statemachine.flow.impl
{
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import statemachine.flow.api.EventFlowMap;
import statemachine.flow.builders.FlowMapping;

public class EventMap implements EventFlowMap
{
    private var _triggerMap:TriggerFlowMap;
    private var _dispatcher:IEventDispatcher;
    private const _triggers:Dictionary = new Dictionary( false );

    public function EventMap( triggerMap:TriggerFlowMap, dispatcher:IEventDispatcher )
    {
        _triggerMap = triggerMap;
        _dispatcher = dispatcher;
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
