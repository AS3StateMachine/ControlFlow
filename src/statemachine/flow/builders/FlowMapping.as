package statemachine.flow.builders
{
public interface FlowMapping
{
    function get always():SimpleFlowMapping;

    function get either():OptionalFlowMapping;

    function fix():void;
}
}
