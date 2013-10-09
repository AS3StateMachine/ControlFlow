package statemachine.support.cmds
{
import statemachine.support.TestRegistry;

public class MockCommandTwo
{
    [Inject]
    public var commandRegistry:TestRegistry;

    public function execute():void
    {
        commandRegistry.register( MockCommandTwo );
    }
}
}
