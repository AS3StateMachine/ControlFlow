package flow.core
{
import flow.core.Executable;

public interface Trigger
{
    function add( client:Executable ):void;

    function remove():void;
}
}
