package flow.impl.support.mappings
{
import flow.dsl.FlowGroupMapping;
import flow.impl.SimpleControlFlow;
import flow.impl.support.ClassRegistry;

public class MockSingleFlowGroup extends SimpleControlFlow
{
    private var _registry:ClassRegistry;


    override public function execute():void
    {
        _registry.register( MockSingleFlowGroup )
    }

    public function MockSingleFlowGroup( parent:FlowGroupMapping, registry:ClassRegistry )
    {
        super( parent, null );
        _registry = registry;
    }
}
}
