package flow.impl.support.mappings
{
import flow.impl.ControlFlow;

import org.swiftsuspenders.Injector;

public class MockControlFlow extends ControlFlow
{
    public var executeCalled:int = 0;


    override public function execute():void
    {
        executeCalled++;
    }

    public function MockControlFlow(injector:Injector)
    {
        super( injector );
    }
}
}
