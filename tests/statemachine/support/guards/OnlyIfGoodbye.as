package statemachine.support.guards
{
import statemachine.support.TestEvent;

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
