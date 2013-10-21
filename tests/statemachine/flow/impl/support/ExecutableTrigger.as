package statemachine.flow.impl.support
{
import statemachine.flow.api.Payload;
import statemachine.flow.core.ExecutableBlock;
import statemachine.flow.core.Trigger;

public class ExecutableTrigger implements Trigger, ExecutableBlock
{
    public var numbExecutions:int = 0;
    public var receivedPayload:Payload;
    private var _client:ExecutableBlock;

    public function add( client:ExecutableBlock ):void
    {
        _client = client;
    }

    public function remove():void
    {
        _client = null;
    }

    public function executeBlock( payload:Payload ):void
    {
        receivedPayload = payload;
        numbExecutions++;
        (_client != null) && _client.executeBlock(payload);
    }
}
}
