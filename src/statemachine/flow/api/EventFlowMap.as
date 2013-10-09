package statemachine.flow.api
{
import statemachine.flow.builders.FlowMapping;

public interface EventFlowMap
{
    function on( type:String, eventClass:Class=null ):FlowMapping

    function remove( type:String ):void
}
}
