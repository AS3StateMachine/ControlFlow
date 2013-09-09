package flow.impl.support.cmds
{
import flow.impl.support.PretendError;

public class ErrorCommandOne
{

    public function execute():void
    {
        throw new PretendError(  );
    }
}
}
