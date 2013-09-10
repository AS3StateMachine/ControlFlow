package statemachine.flow.impl.support.cmds
{
import statemachine.flow.impl.support.ClassRegistry;

public class MockCommandThree
{
    [Inject]
    public var commandRegistry:ClassRegistry;

    public function execute():void
    {
        commandRegistry.register( MockCommandThree );
    }
}
}
