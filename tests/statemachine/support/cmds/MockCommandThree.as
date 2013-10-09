package statemachine.support.cmds
{
import statemachine.support.TestRegistry;

public class MockCommandThree
{
    [Inject]
    public var commandRegistry:TestRegistry;


    public function execute():void
    {
        commandRegistry.register( MockCommandThree );
    }
}
}
