package flow.impl.support
{
import flow.api.Trigger;

public class MockTrigger  implements Trigger
{
    public var listener:Function;

    public function add( listener:Function ):void
    {
        this.listener = listener;
    }

    public function remove():void
    {
        this.listener = null;
    }
}
}
