package statemachine.flow.impl
{
import org.swiftsuspenders.Injector;

import statemachine.flow.api.Payload;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.OptionalFlowMapping;
import statemachine.flow.builders.SimpleFlowMapping;
import statemachine.flow.core.ExecutableBlock;

public class ControlFlowContainer implements FlowMapping, ExecutableBlock
{
    internal var injector:Injector;
    internal const blocks:Vector.<ExecutableBlock> = new Vector.<ExecutableBlock>();

    public function ControlFlowContainer( injector:Injector )
    {
        this.injector = injector.createChildInjector();
        this.injector.map( Injector ).toValue( this.injector );
        this.injector.map( FlowMapping ).toValue( this );
    }

    public function get always():SimpleFlowMapping
    {
        const block:* = injector.getOrCreateNewInstance( SimpleControlFlow );
        blocks.push( block );
        return block;
    }

    public function get either():OptionalFlowMapping
    {
        const block:* = injector.getOrCreateNewInstance( OptionalControlFlow );
        blocks.push( block );
        return block;
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
