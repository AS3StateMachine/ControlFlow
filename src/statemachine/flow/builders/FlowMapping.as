package statemachine.flow.builders
{
public interface FlowMapping
{
    function get only():SimpleFlowMapping;


    function get either():OptionalFlowMapping;

    function fix():void;
}
}
