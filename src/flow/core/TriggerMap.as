package flow.core
{
import flow.dsl.ControlFlowMapping;

public interface TriggerMap
{
    function map( trigger:Trigger ):ControlFlowMapping

    function unmap( trigger:Trigger ):void
}
}
