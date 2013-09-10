package statemachine.flow.impl.support.mappings
{
import org.swiftsuspenders.Injector;

import statemachine.flow.impl.ControlFlowContainer;

public class MockControlFlowContainer extends ControlFlowContainer
{
    public var executeCalled:int = 0;


    override public function execute():void
    {
        executeCalled++;
    }

    public function MockControlFlowContainer( injector:Injector )
    {
        super( injector );
    }
}
}
