package statemachine.flow.impl.support.guards
{
import statemachine.flow.impl.support.TestEvent;

public class OnlyIfGoodbye
{
    [Inject]
    public var event:TestEvent;

    public function approve():Boolean
    {
        return (event.message.toLowerCase() == "goodbye");
    }
}
}
