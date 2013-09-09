package flow.dsl
{
public interface SimpleControlFlowMapping extends ReturnMapping
{
    function executeAll( ...args ):SimpleControlFlowMapping;

    function onApproval( ...args ):SimpleControlFlowMapping;
}
}
