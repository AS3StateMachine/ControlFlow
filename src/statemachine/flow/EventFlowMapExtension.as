package statemachine.flow
{
import flash.events.IEventDispatcher;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

import statemachine.flow.api.EventFlowMap;
import statemachine.flow.impl.EventMap;
import statemachine.flow.impl.TriggerFlowMap;

public class EventFlowMapExtension implements IExtension
{
    public function extend( context:IContext ):void
    {
        const injector:IInjector = context.injector;
        const dispatcher:IEventDispatcher = injector.getInstance( IEventDispatcher );
        const triggerMap:TriggerFlowMap = injector.getInstance( TriggerFlowMap );
        const map:EventMap = new EventMap( triggerMap, dispatcher );
        context.injector.map( EventFlowMap ).toValue( map );

    }

}
}
