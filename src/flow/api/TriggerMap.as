package flow.api
{
import flow.dsl.FlowGroupMapping;

public interface TriggerMap
{
    function on( trigger:Class ):FlowGroupMapping

    function remove( trigger:Class ):void
}
}
