package flow.impl
{
import flow.dsl.CaseFlowMapping;
import flow.dsl.FlowGroupMapping;
import flow.dsl.SingleFlowMapping;

import org.swiftsuspenders.Injector;

public class ControlFlow implements FlowGroupMapping
{
    internal var injector:Injector;
    internal const blocks:Vector.<Executable> = new Vector.<Executable>();
    private var _errorHandler:*;

    public function ControlFlow( injector:Injector )
    {
        this.injector = injector;
    }

    public function get always():SingleFlowMapping
    {
        const block:* = injector.getOrCreateNewInstance( SimpleControlFlow );
        blocks.push( block );
        return block;
    }

    public function get either():CaseFlowMapping
    {
        const block:* = injector.getOrCreateNewInstance( OptionalControlFlow );
        blocks.push( block );
        return block;
    }

    public function handle( errorHandler:* ):void
    {
        _errorHandler = errorHandler;
        fix();
    }

    public function fix():void
    {
        blocks.fixed = true;
    }

    public function execute():void
    {
        for each ( var block:Executable in blocks )
        {
            try
            {
                block.execute();
            }

            catch ( error:Error )
            {
                if ( _errorHandler is Function )
                {
                    _errorHandler( error )
                }

                else if ( _errorHandler is Class )
                {

                }

            }

        }
    }
}
}
