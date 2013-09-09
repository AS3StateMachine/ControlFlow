package flow.dsl
{
public interface FlowGroupMapping
{
    function get always():SingleFlowMapping;

    function get either():CaseFlowMapping;

    function handle( errorHandler:* ):void;
    function fix():void;
}
}
