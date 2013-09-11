package statemachine.flow.impl.support.guards
{
import statemachine.flow.impl.support.TestEvent;

public class OnlyIfHello
{
    [Inject]
    public var event:TestEvent;

    public function approve():Boolean
    {
        return (event.message.toLowerCase() == "hello");
    }
}
}
