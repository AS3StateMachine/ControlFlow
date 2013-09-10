package flow.impl
{
import flash.utils.Dictionary;

import flow.core.Trigger;
import flow.core.TriggerMap;
import flow.dsl.ControlFlowMapping;

import org.swiftsuspenders.Injector;

public class TriggerMap implements TriggerMap
{
    internal var injector:Injector;

    private const _map:Dictionary = new Dictionary();

    public function TriggerMap( injector:Injector )
    {
        this.injector = injector;
    }

    public function map( trigger:Trigger ):ControlFlowMapping
    {
        const flowGroup:ControlFlow = injector.getOrCreateNewInstance( ControlFlow );

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
