package flow.dsl
{
public interface CaseFlowMapping extends ReturnMapping
{
    function get or():CaseFlowMapping;

    function executeAll( ...args ):CaseFlowMapping;

    function onApproval( ...args:Array ):CaseFlowMapping;
}
}
