package statemachine.flow.dsl
{
public interface ControlFlowMapping
{
    function get always():SimpleControlFlowMapping;

    function get either():OptionalControlFlowMapping;

    function fix():void;
}
}
