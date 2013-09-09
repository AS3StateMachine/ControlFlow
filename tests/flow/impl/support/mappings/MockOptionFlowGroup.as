package flow.impl.support.mappings
{
import flow.dsl.FlowGroupMapping;
import flow.impl.OptionalControlFlow;
import flow.impl.support.ClassRegistry;

public class MockOptionFlowGroup extends OptionalControlFlow
{
    private var _registry:ClassRegistry;


    override public function execute():void
    {
        _registry.register( MockOptionFlowGroup )
    }

    public function MockOptionFlowGroup( parent:FlowGroupMapping, registry:ClassRegistry )
    {
        super( parent, null );
        _registry = registry;
    }
}
}
