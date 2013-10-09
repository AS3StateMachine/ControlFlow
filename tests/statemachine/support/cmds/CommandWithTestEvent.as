package statemachine.support.cmds
{
import statemachine.support.TestRegistry;
import statemachine.support.TestEvent;

public class CommandWithTestEvent
{
    [Inject]
    public var commandRegistry:TestRegistry;

    [Inject]
    public var event:TestEvent;


    public function execute():void
    {
        commandRegistry.register( MockCommandTwo );
    }
}
}
