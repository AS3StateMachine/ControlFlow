package flow.impl.support
{
import flow.core.Trigger;
import flow.core.Executable;

public class MockTrigger implements Trigger
{
    private var _client:Executable;

    public function add( client:Executable ):void
    {
        _client = client;
    }

    public function remove():void
    {
        _client = null;
    }

    public function execute():void
    {
        (_client != null) && _client.execute();
    }
}
}
