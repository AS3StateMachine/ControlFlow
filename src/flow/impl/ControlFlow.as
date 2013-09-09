package flow.impl
{
import flow.dsl.ControlFlowMapping;
import flow.dsl.OptionalControlFlowMapping;
import flow.dsl.SimpleControlFlowMapping;

import org.swiftsuspenders.Injector;

public class ControlFlow implements ControlFlowMapping
{
    internal var injector:Injector;
    internal const blocks:Vector.<Executable> = new Vector.<Executable>();

    public function ControlFlow( injector:Injector )
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
