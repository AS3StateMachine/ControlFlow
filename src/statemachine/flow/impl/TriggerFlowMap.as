package statemachine.flow.impl
{
import flash.utils.Dictionary;

import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.Unmapper;
import statemachine.flow.core.Trigger;

public class TriggerFlowMap implements Unmapper
{
    private const _map:Dictionary = new Dictionary();

    public function TriggerFlowMap( executor:Executor )
    {
        _executor = executor;
    }

    private var _executor:Executor;

    public function map( trigger:Trigger ):FlowMapping
    {
        const flowGroup:ControlFlowContainer = new ControlFlowContainer( _executor );
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

    public function has( trigger:Trigger ):Boolean
    {
        return (_map[trigger] != null);
    }


}
}
