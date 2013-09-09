package flow.impl.support.cmds
{
import flow.impl.support.PretendError;

public class ErrorCommandTwo
{

    public function execute():void
    {
        trace("");
        throw new PretendError(  );
    }
}
}
