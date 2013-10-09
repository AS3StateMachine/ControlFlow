package statemachine.flow.builders
{
public interface SimpleFlowMapping extends ReturnMapping
{
    function executeAll( ...args ):SimpleFlowMapping;

    function onApproval( ...args ):SimpleFlowMapping;
}
}
