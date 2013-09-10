package statemachine.flow.impl
{
import flash.utils.Dictionary;

import org.swiftsuspenders.Injector;

import statemachine.flow.core.Trigger;
import statemachine.flow.dsl.ControlFlowMapping;

public class TriggerMap
{
    internal var injector:Injector;

    private const _map:Dictionary = new Dictionary();

    public function TriggerMap( injector:Injector )
    {
        this.injector = injector;
    }

    public function map( trigger:Trigger ):ControlFlowMapping
    {
        const flowGroup:ControlFlowContainer = injector.getOrCreateNewInstance( ControlFlowContainer );

        trigger.add( flowGroup );

        _map[trigger] = flowGroup;

        return flowGroup;
    }

    public function unmap( trigger:Trigger ):void
    {
        if ( _map[trigger] == null ) return;
        trigger.remove();
        delete _map[trigger];
    }


}
}