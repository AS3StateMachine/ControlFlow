package statemachine.flow.impl.support.mappings
{
import statemachine.flow.api.Payload;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.impl.OptionalControlFlow;
import statemachine.support.TestRegistry;

public class MockOptionFlowGroup extends OptionalControlFlow
{
    private var _registry:TestRegistry;
    public var receivedPayload:Payload;


    override public function executeBlock( payload:Payload ):void
    {
        receivedPayload = payload;
        _registry.register( this )
    }

    public function MockOptionFlowGroup( parent:FlowMapping, registry:TestRegistry )
    {
        super( parent, null );
        _registry = registry;
    }
}
}
