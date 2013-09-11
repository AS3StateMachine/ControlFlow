package statemachine.flow.api
{
import statemachine.flow.dsl.ControlFlowMapping;

public interface EventControlFlowMap
{
    function on( type:String, eventClass:Class=null ):ControlFlowMapping

    function remove( type:String ):void
}
}
