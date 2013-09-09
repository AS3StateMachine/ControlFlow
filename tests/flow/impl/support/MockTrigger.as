package flow.impl.support
{
import flow.api.Trigger;

public class MockTrigger implements Trigger
{
    private var _listener:Function;

    public function add( listener:Function ):void
    {
        _listener = listener;
    }

    public function remove():void
    {
        _listener = null;
    }

    public function execute():void
    {
        (_listener != null) && _listener();
    }
}
}
