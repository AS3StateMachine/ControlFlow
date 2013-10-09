package statemachine.flow.builders
{
public interface OptionalFlowMapping extends ReturnMapping
{
    function get or():OptionalFlowMapping;

    function executeAll( ...args ):OptionalFlowMapping;

    function onApproval( ...args:Array ):OptionalFlowMapping;
}
}
