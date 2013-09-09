package flow.impl.support.cmds
{
import flow.impl.support.*;

public class MockCommandTwo
{
    [Inject]
    public var commandRegistry:ClassRegistry;

    public function execute():void
    {
        commandRegistry.register( MockCommandTwo );
    }
}
}
