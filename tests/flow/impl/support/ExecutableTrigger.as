package flow.impl.support
{
import flow.core.Trigger;
import flow.core.Executable;

public class ExecutableTrigger implements Trigger, Executable
{
    public var numbExecutions:int = 0;
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
        numbExecutions++;
        (_client != null) && _client.execute();
    }
}
}
