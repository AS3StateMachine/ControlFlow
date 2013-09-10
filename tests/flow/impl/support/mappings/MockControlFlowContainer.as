package flow.impl.support.mappings
{
import flow.impl.ControlFlowContainer;

import org.swiftsuspenders.Injector;

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
