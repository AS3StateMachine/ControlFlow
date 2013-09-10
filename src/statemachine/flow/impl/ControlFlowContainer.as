package statemachine.flow.impl
{
import org.swiftsuspenders.Injector;

import statemachine.flow.core.Executable;
import statemachine.flow.dsl.ControlFlowMapping;
import statemachine.flow.dsl.OptionalControlFlowMapping;
import statemachine.flow.dsl.SimpleControlFlowMapping;

public class ControlFlowContainer implements ControlFlowMapping, Executable
{
    internal var injector:Injector;
    internal const blocks:Vector.<Executable> = new Vector.<Executable>();

    public function ControlFlowContainer( injector:Injector )
    {
        this.injector = injector.createChildInjector();
        this.injector.map( Injector ).toValue( this.injector );
        this.injector.map( ControlFlowMapping ).toValue( this );
    }

    public function get always():SimpleControlFlowMapping
    {
        const block:* = injector.getOrCreateNewInstance( SimpleControlFlow );
        blocks.push( block );
        return block;
    }

    public function get either():OptionalControlFlowMapping
    {
        const block:* = injector.getOrCreateNewInstance( OptionalControlFlow );
        blocks.push( block );
        return block;
    }

    public function fix():void
    {
        blocks.fixed = true;
    }

    public function execute():void
    {
        for each ( var block:Executable in blocks )
        {
            block.execute();
        }
    }
}
}
