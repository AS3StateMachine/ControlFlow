package flow.api
{
import flow.dsl.ControlFlowMapping;

public interface TriggerMap
{
    function on( trigger:Class ):ControlFlowMapping

    function remove( trigger:Class ):void
}
}
