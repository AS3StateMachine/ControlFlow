package statemachine.support.cmds
{
import statemachine.support.TestRegistry;

public class MockCommandOne
{
    [Inject]
    public var commandRegistry:TestRegistry;

    public function execute():void
    {
        commandRegistry.register( MockCommandOne );
    }
}
}
