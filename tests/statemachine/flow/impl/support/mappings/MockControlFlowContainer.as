package statemachine.flow.impl.support.mappings
{
import org.swiftsuspenders.Injector;

import statemachine.flow.api.Payload;
import statemachine.flow.impl.ControlFlowContainer;

public class MockControlFlowContainer extends ControlFlowContainer
{
    public var executeCalled:int = 0;


    override public function executeBlock( payload:Payload ):void
    {
        executeCalled++;
    }

    public function MockControlFlowContainer( injector:Injector )
    {
        super( injector );
    }
}
}
