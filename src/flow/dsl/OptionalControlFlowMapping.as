package flow.dsl
{
public interface OptionalControlFlowMapping extends ReturnMapping
{
    function get or():OptionalControlFlowMapping;

    function executeAll( ...args ):OptionalControlFlowMapping;

    function onApproval( ...args:Array ):OptionalControlFlowMapping;
}
}
