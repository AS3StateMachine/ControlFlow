package flow.impl
{
import org.swiftsuspenders.Injector;

public class Executor
{
    private var _injector:Injector;


    public function Executor( injector:Injector )
    {
        _injector = injector;
    }

    public function execute( executionGroup:ExecutionData ):Boolean
    {
        if ( executionGroup.guards.length > 0 && !approveGuards( executionGroup.guards ) ) return false;

        const commands:Vector.<Class> = executionGroup.commands;

        for each( var cmdClass:Class in commands )
        {
            const cmd:* = _injector.instantiateUnmapped( cmdClass );

            try
            {
                cmd.execute();
            }

            catch ( error:Error )
            {
                handleError( error );
            }
        }

        return true;
    }

    private function approveGuards( guards:Vector.<Class> ):Boolean
    {
        for each( var guardClass:Class in guards )
        {
            const guard:* = _injector.instantiateUnmapped( guardClass );

            try
            {
                const result:Boolean = guard.approve();
                if ( !result ) return false;
            }

            catch ( error:Error )
            {
                handleError( error );
            }

        }
        return true;
    }

    private function handleError( error:Error ):void
    {
        throw new FlowError(error)
    }


}
}
