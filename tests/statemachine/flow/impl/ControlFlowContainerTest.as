package statemachine.flow.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.flow.api.Payload;
import statemachine.flow.builders.OptionalFlowMapping;
import statemachine.flow.builders.SimpleFlowMapping;
import statemachine.flow.impl.support.mappings.MockExecutor;
import statemachine.support.cmds.MockCommandOne;
import statemachine.support.cmds.MockCommandThree;
import statemachine.support.cmds.MockCommandTwo;

public class ControlFlowContainerTest
{
    private var _classUnderTest:ControlFlowContainer;
    private var _executor:MockExecutor;

    [Before]
    public function before():void
    {
        _executor = new MockExecutor( null );
        _classUnderTest = new ControlFlowContainer( _executor );
    }

    [Test]
    public function always_property_returns_instanceOf_SingleFlowMapping():void
    {
        assertThat( _classUnderTest.always, instanceOf( SimpleFlowMapping ) )
    }

    [Test]
    public function always_property_returns_unique_instanceOf_SingleFlowMapping():void
    {
        assertThat( _classUnderTest.always, not( _classUnderTest.always ) )
    }

    [Test]
    public function SingleFlowMapping_instance_added_to_groups():void
    {
        assertThat( _classUnderTest.always, strictlyEqualTo( _classUnderTest.blocks[0] ) )
    }

    [Test]
    public function either_property_returns_instanceOf_CaseFlowMapping():void
    {
        assertThat( _classUnderTest.either, instanceOf( OptionalFlowMapping ) )
    }

    [Test]
    public function either_property_returns_unique_instanceOf_CaseFlowMapping():void
    {
        assertThat( _classUnderTest.either, not( _classUnderTest.either ) )
    }

    [Test]
    public function CaseFlowMapping_instance_added_to_groups():void
    {
        assertThat( _classUnderTest.either, strictlyEqualTo( _classUnderTest.blocks[0] ) )
    }

    [Test]
    public function execute_iterates_through_executables():void
    {
        _classUnderTest
                .either.executeAll( MockCommandOne )
                .and.always.executeAll( MockCommandTwo )
                .and.either.executeAll( MockCommandThree );

        _classUnderTest.executeBlock( null );

        assertThat( _executor.recievedPayload.length, equalTo( 3 ) );
    }

    [Test]
    public function execute_passes_payload_to_executables():void
    {
        _classUnderTest
                .either.executeAll( MockCommandOne )
                .and.always.executeAll( MockCommandTwo )
                .and.either.executeAll( MockCommandThree );

        const payload:Payload = new Payload()
        _classUnderTest.executeBlock( payload );

        assertThat( _executor.recievedPayload.length, equalTo( 3 ) )
        assertThat(
                _executor.recievedPayload
                , array(
                        strictlyEqualTo( payload ),
                        strictlyEqualTo( payload ),
                        strictlyEqualTo( payload )
                )
        );
    }
}
}
