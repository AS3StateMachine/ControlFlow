package statemachine.support.guards
{
import statemachine.support.TestEvent;

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
