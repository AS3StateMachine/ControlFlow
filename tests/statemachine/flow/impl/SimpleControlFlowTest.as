package statemachine.flow.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.flow.api.Payload;
import statemachine.flow.impl.support.mappings.MockExecutor;
import statemachine.support.TestEvent;
import statemachine.support.cmds.CommandWithTestEvent;
import statemachine.support.cmds.MockCommandOne;
import statemachine.support.cmds.MockCommandThree;
import statemachine.support.cmds.MockCommandTwo;
import statemachine.support.guards.GrumpyGuard;
import statemachine.support.guards.HappyGuard;
import statemachine.support.guards.JoyfulGuard;

public class SimpleControlFlowTest
{
    private var _classUnderTest:SimpleControlFlow;
    private var _parent:ControlFlowContainer;
    private var _executor:MockExecutor;

    [Before]
    public function before():void
    {
        _executor = new MockExecutor( null );
        _parent = new ControlFlowContainer( _executor );
        _classUnderTest = new SimpleControlFlow( _executor );
        _classUnderTest.parent = _parent;
    }

    [Test]
    public function and_property_returns_parent_mapping():void
    {
        assertThat( _classUnderTest.and, strictlyEqualTo( _parent ) );
    }

    [Test]
    public function execute_returns_self():void
    {
        assertThat( _classUnderTest.executeAll(), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function execute_maps_command_classes_to_CommandMap_and_retains_order():void
    {
        _classUnderTest.executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
        assertThat( _classUnderTest._commandGroup.commands,
                array(
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                ) );
    }

    [Test]
    public function onApproval_returns_self():void
    {
        assertThat( _classUnderTest.onApproval(), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function onApproval_maps_guard_classes_to_CommandMap_and_retains_order():void
    {
        _classUnderTest.onApproval( GrumpyGuard, HappyGuard, JoyfulGuard )
        assertThat( _classUnderTest._commandGroup.guards,
                array(
                        strictlyEqualTo( GrumpyGuard ),
                        strictlyEqualTo( HappyGuard ),
                        strictlyEqualTo( JoyfulGuard )
                ) );
    }

    [Test]
    public function execute_executes_commandGroup():void
    {
        _classUnderTest.executeAll( MockCommandOne, MockCommandThree );
        _classUnderTest.executeBlock( null );
        assertThat(
                _executor.recievedData[0].commands,
                array(
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandThree )
                ) );
    }

    [Test] // will throw error if fails
    public function execute_passes_payload_to_Executor():void
    {
        _classUnderTest.executeAll( CommandWithTestEvent );
        _classUnderTest.executeBlock( new Payload().add( new TestEvent( "hello" ), TestEvent ) );
    }


}
}
