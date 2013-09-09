package flow.impl.support.cmds
{
import flow.impl.support.*;

public class MockCommandOne
{
    [Inject]
    public var commandRegistry:ClassRegistry;

    public function execute():void
    {
        commandRegistry.register( MockCommandOne );
    }
}
}
