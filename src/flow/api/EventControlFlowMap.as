package flow.api
{
import flow.dsl.ControlFlowMapping;

public interface EventControlFlowMap
{
    function on( type:String, eventClass:Class ):ControlFlowMapping

    function remove( type:String ):void
}
}
