package statemachine.flow.impl
{
import statemachine.flow.api.Payload;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.OptionalFlowMapping;
import statemachine.flow.builders.SimpleFlowMapping;
import statemachine.flow.core.ExecutableBlock;

public class ControlFlowContainer implements FlowMapping, ExecutableBlock
{
    internal const blocks:Vector.<ExecutableBlock> = new Vector.<ExecutableBlock>();

    public function ControlFlowContainer( executor:Executor )
    {
        _executor = executor;
    }

    private var _executor:Executor;

    public function get only():SimpleFlowMapping
    {
        const block:SimpleControlFlow = new SimpleControlFlow( _executor );
        block.parent = this;
        blocks.push( block );
        return block as SimpleFlowMapping;
    }

    public function get either():OptionalFlowMapping
    {
        const block:OptionalControlFlow = new OptionalControlFlow( _executor );
        block.parent = this;
        blocks.push( block );
        return block as OptionalFlowMapping;
    }

    public function fix():void
    {
        blocks.fixed = true;
    }

    public function executeBlock( payload:Payload ):void
    {
        for each ( var block:ExecutableBlock in blocks )
        {
            block.executeBlock( payload );
        }
    }
}
}
