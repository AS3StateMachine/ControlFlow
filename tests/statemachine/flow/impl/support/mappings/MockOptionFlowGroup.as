package statemachine.flow.impl.support.mappings
{
import statemachine.flow.dsl.ControlFlowMapping;
import statemachine.flow.impl.OptionalControlFlow;
import statemachine.flow.impl.support.ClassRegistry;

public class MockOptionFlowGroup extends OptionalControlFlow
{
    private var _registry:ClassRegistry;


    override public function execute():void
    {
        _registry.register( MockOptionFlowGroup )
    }

    public function MockOptionFlowGroup( parent:ControlFlowMapping, registry:ClassRegistry )
    {
        super( parent, null );
        _registry = registry;
    }
}
}
