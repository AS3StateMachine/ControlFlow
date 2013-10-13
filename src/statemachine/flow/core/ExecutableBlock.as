package statemachine.flow.core
{
import statemachine.flow.api.Payload;

public interface ExecutableBlock
{
    function executeBlock( payload:Payload ):void;
}
}
