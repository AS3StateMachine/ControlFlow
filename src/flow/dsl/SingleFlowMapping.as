package flow.dsl
{
public interface SingleFlowMapping extends ReturnMapping
{
    function executeAll( ...args ):SingleFlowMapping;

    function onApproval( ...args ):SingleFlowMapping;
}
}
