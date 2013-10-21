package statemachine.flow.builders
{
public interface SimpleFlowMapping extends ReturnMapping
{
    function execute( ...args ):SimpleFlowMapping;

    function onApproval( ...args ):SimpleFlowMapping;
}
}
