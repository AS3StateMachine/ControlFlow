package statemachine.flow.builders
{
import statemachine.flow.core.Trigger;

public interface Unmapper
{
    function unmap( trigger:Trigger ):void
}
}
