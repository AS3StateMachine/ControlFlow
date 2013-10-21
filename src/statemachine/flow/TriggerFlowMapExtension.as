package statemachine.flow
{
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

import statemachine.flow.impl.Executor;
import statemachine.flow.impl.TriggerFlowMap;

public class TriggerFlowMapExtension implements IExtension
{
    public function extend( context:IContext ):void
    {
        const executor:Executor = new Executor( context.injector );
        const triggerMap:TriggerFlowMap = new TriggerFlowMap( executor );
        context.injector.map( TriggerFlowMap ).toValue( triggerMap );
    }
}
}
