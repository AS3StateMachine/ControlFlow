package flow.impl
{
import flash.utils.Dictionary;

import flow.api.EventControlFlowMap;
import flow.dsl.ControlFlowMapping;

import org.swiftsuspenders.Injector;

public class EventMap implements EventControlFlowMap
{
    internal var injector:Injector;

    private const _map:Dictionary = new Dictionary();

    public function EventMap( injector:Injector )
    {
        this.injector = injector;
    }


    public function on( type:String, eventClass:Class ):ControlFlowMapping
    {
        return null;
    }

    public function remove( type:String ):void
    {
    }
}
}
