package flow.impl.support.mappings
{
import flow.impl.ControlFlow;

public class MockFlowGroup extends ControlFlow
{
    public var executeCalled:int = 0;


    override public function execute():void
    {
        executeCalled++;
    }

    public function MockFlowGroup()
    {
        super( null );
    }
}
}
